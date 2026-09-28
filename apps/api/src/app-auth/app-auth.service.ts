import { ConflictException, Inject, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { compare, hash } from 'bcryptjs';
import { randomInt } from 'node:crypto';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../database/prisma.service.js';
import { PHONE_VERIFICATION_GATEWAY, type PhoneVerificationGateway } from './phone-verification.gateway.js';

type AppProfile = { id: string; email: string; phone: string };
type ChallengeResponse = { challengeId: string; expiresAt: Date };
type ChallengePurpose = 'REGISTRATION' | 'SESSION';
type IdentityForProfile = AppProfile & { status: 'PENDING_PHONE_VERIFICATION' | 'ACTIVE' | 'SUSPENDED' };

@Injectable()
export class AppAuthService {
  private static readonly codeLifetimeMs = 10 * 60 * 1000;
  private static readonly maxAttempts = 5;

  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
    @Inject(PHONE_VERIFICATION_GATEWAY) private readonly phoneVerification: PhoneVerificationGateway,
  ) {}

  async beginRegistration(input: { email: string; password: string; phone: string }): Promise<ChallengeResponse> {
    const email = this.normalizeEmail(input.email);
    const phone = this.normalizePhone(input.phone);
    const existing = await this.prisma.appIdentity.findUnique({ where: { email } });
    if (existing) {
      if (existing.status !== 'PENDING_PHONE_VERIFICATION' || existing.phone !== phone) {
        throw new ConflictException('No se puede iniciar el registro');
      }
      // Un reenvío solo renueva el desafío: nunca reemplaza la contraseña original sin autenticar.
      return this.createChallenge(existing.id, existing.phone, 'REGISTRATION');
    }

    let identity;
    try {
      identity = await this.prisma.appIdentity.create({
        data: { email, phone, passwordHash: await hash(input.password, 12), status: 'PENDING_PHONE_VERIFICATION' },
      });
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2002') {
        throw new ConflictException('No se puede iniciar el registro');
      }
      throw error;
    }
    try {
      return await this.createChallenge(identity.id, identity.phone, 'REGISTRATION');
    } catch (error) {
      await this.prisma.appIdentity.delete({ where: { id: identity.id } });
      throw error;
    }
  }

  async beginSession(emailInput: string, password: string): Promise<ChallengeResponse> {
    const email = this.normalizeEmail(emailInput);
    const identity = await this.prisma.appIdentity.findUnique({ where: { email } });
    const accepted = identity?.status === 'ACTIVE' && await compare(password, identity.passwordHash);
    if (!identity || !accepted) throw new UnauthorizedException('Credenciales inválidas');
    return this.createChallenge(identity.id, identity.phone, 'SESSION');
  }

  async verifyRegistration(challengeId: string, code: string): Promise<{ accessToken: string; profile: AppProfile }> {
    const identity = await this.validateChallenge(challengeId, code, 'REGISTRATION');
    const activeIdentity = await this.prisma.$transaction(async (transaction) => {
      await this.consumeChallenge(challengeId, 'REGISTRATION', transaction);
      const updated = await transaction.appIdentity.updateMany({
        where: { id: identity.id, status: 'PENDING_PHONE_VERIFICATION' },
        data: { status: 'ACTIVE', phoneVerifiedAt: new Date() },
      });
      if (updated.count !== 1) throw new UnauthorizedException('Código inválido o vencido');
      return { ...identity, status: 'ACTIVE' as const };
    });
    return this.createSession(activeIdentity);
  }

  async verifySession(challengeId: string, code: string): Promise<{ accessToken: string; profile: AppProfile }> {
    const identity = await this.validateChallenge(challengeId, code, 'SESSION');
    await this.consumeChallenge(challengeId, 'SESSION', this.prisma);
    return this.createSession(identity);
  }

  private async createChallenge(identityId: string, phone: string, purpose: ChallengePurpose): Promise<ChallengeResponse> {
    const code = randomInt(0, 1_000_000).toString().padStart(6, '0');
    const expiresAt = new Date(Date.now() + AppAuthService.codeLifetimeMs);
    const challenge = await this.prisma.phoneVerificationChallenge.create({
      data: { identityId, purpose, codeHash: await hash(code, 12), expiresAt },
    });
    await this.phoneVerification.deliver({ phone, code, purpose, expiresAt });
    return { challengeId: challenge.id, expiresAt: challenge.expiresAt };
  }

  private async validateChallenge(challengeId: string, code: string, expectedPurpose: ChallengePurpose): Promise<IdentityForProfile> {
    const challenge = await this.prisma.phoneVerificationChallenge.findUnique({
      where: { id: challengeId },
      include: { identity: true },
    });
    const expired = !challenge || challenge.expiresAt <= new Date();
    if (expired || challenge.consumedAt || challenge.purpose !== expectedPurpose || challenge.attempts >= AppAuthService.maxAttempts) {
      throw new UnauthorizedException('Código inválido o vencido');
    }
    const accepted = await compare(code, challenge.codeHash);
    if (!accepted) {
      await this.prisma.phoneVerificationChallenge.updateMany({
        where: { id: challenge.id, purpose: expectedPurpose, consumedAt: null, expiresAt: { gt: new Date() }, attempts: { lt: AppAuthService.maxAttempts } },
        data: { attempts: { increment: 1 } },
      });
      throw new UnauthorizedException('Código inválido o vencido');
    }
    if (challenge.identity.status !== (expectedPurpose === 'REGISTRATION' ? 'PENDING_PHONE_VERIFICATION' : 'ACTIVE')) {
      throw new UnauthorizedException('Código inválido o vencido');
    }
    return challenge.identity;
  }

  private async consumeChallenge(
    challengeId: string, expectedPurpose: ChallengePurpose,
    transaction: Prisma.TransactionClient | PrismaService,
  ): Promise<void> {
    const consumed = await transaction.phoneVerificationChallenge.updateMany({
      where: { id: challengeId, purpose: expectedPurpose, consumedAt: null, expiresAt: { gt: new Date() }, attempts: { lt: AppAuthService.maxAttempts } },
      data: { consumedAt: new Date() },
    });
    if (consumed.count !== 1) throw new UnauthorizedException('Código inválido o vencido');
  }

  private async createSession(identity: AppProfile): Promise<{ accessToken: string; profile: AppProfile }> {
    const accessToken = await this.jwt.signAsync({ sub: identity.id, email: identity.email, role: 'APP' });
    return { accessToken, profile: this.toProfile(identity) };
  }

  private normalizeEmail(input: string): string {
    return input.trim().toLowerCase();
  }

  private normalizePhone(input: string): string {
    const phone = input.trim().replace(/[\s()-]/g, '');
    if (!/^\+[1-9]\d{7,14}$/.test(phone)) throw new UnauthorizedException('Teléfono inválido');
    return phone;
  }

  private toProfile(identity: AppProfile): AppProfile {
    return { id: identity.id, email: identity.email, phone: identity.phone };
  }
}

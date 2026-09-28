import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { compare } from 'bcryptjs';
import { PrismaService } from '../database/prisma.service.js';
import type { AdminTokenPayload, SafeAdminProfile } from './auth.types.js';

@Injectable()
export class AuthService {
  constructor(private readonly prisma: PrismaService, private readonly jwt: JwtService) {}

  async login(emailInput: string, password: string): Promise<{ accessToken: string; profile: SafeAdminProfile }> {
    const email = emailInput.trim().toLowerCase();
    const account = await this.prisma.adminAccount.findUnique({ where: { email } });
    const accepted = account?.status === 'ACTIVE' && await compare(password, account.passwordHash);
    if (!account || !accepted) throw new UnauthorizedException('Credenciales inválidas');

    const payload: AdminTokenPayload = { sub: account.id, email: account.email, role: 'ADMIN' };
    return { accessToken: await this.jwt.signAsync(payload), profile: this.toProfile(account) };
  }

  async profile(id: string): Promise<SafeAdminProfile> {
    const account = await this.prisma.adminAccount.findUnique({ where: { id } });
    if (!account || account.status !== 'ACTIVE') throw new UnauthorizedException('Sesión inválida');
    return this.toProfile(account);
  }

  private toProfile(account: { id: string; email: string; displayName: string; status: 'ACTIVE' | 'SUSPENDED' }): SafeAdminProfile {
    return { id: account.id, email: account.email, displayName: account.displayName, role: 'ADMIN', status: account.status };
  }
}

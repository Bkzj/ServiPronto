import { ConflictException, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { compare, hash } from 'bcryptjs';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import { PrismaService } from '../database/prisma.service.js';
import { AppAuthService } from './app-auth.service.js';
import type { PhoneVerificationGateway } from './phone-verification.gateway.js';

describe('AppAuthService', () => {
  const appIdentity = {
    findUnique: vi.fn(),
    create: vi.fn(),
    update: vi.fn(),
    delete: vi.fn(),
    updateMany: vi.fn(),
  };
  const phoneVerificationChallenge = {
    create: vi.fn(),
    findUnique: vi.fn(),
    update: vi.fn(),
    updateMany: vi.fn(),
  };
  const prisma = { appIdentity, phoneVerificationChallenge, $transaction: vi.fn(async (operation: (client: unknown) => Promise<unknown>) => operation({ appIdentity, phoneVerificationChallenge })) } as unknown as PrismaService;
  const signAsync = vi.fn().mockResolvedValue('app-session-token');
  const jwt = { signAsync } as unknown as JwtService;
  const deliver = vi.fn();
  const delivery = { deliver } as unknown as PhoneVerificationGateway;
  const service = new AppAuthService(prisma, jwt, delivery);

  beforeEach(() => vi.clearAllMocks());

  it('inicia un registro pendiente, normaliza el correo y entrega un código sin exponerlo en la respuesta', async () => {
    appIdentity.findUnique.mockResolvedValue(null);
    appIdentity.create.mockResolvedValue({ id: 'identity-1', email: 'cliente@example.com', phone: '+5492494000000' });
    phoneVerificationChallenge.create.mockResolvedValue({ id: 'challenge-1', expiresAt: new Date('2026-09-15T12:10:00.000Z') });

    const result = await service.beginRegistration({
      email: ' CLIENTE@example.com ',
      password: 'una-clave-segura',
      phone: '+54 9 249 400-0000',
    });

    expect(appIdentity.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ email: 'cliente@example.com', phone: '+5492494000000', status: 'PENDING_PHONE_VERIFICATION' }),
    }));
    expect(deliver).toHaveBeenCalledWith(expect.objectContaining({ phone: '+5492494000000', purpose: 'REGISTRATION', code: expect.stringMatching(/^\d{6}$/) }));
    expect(result).toEqual({ challengeId: 'challenge-1', expiresAt: new Date('2026-09-15T12:10:00.000Z') });
    expect(result).not.toHaveProperty('code');
  });

  it('rechaza registrar un correo que ya pertenece a una identidad de aplicación', async () => {
    appIdentity.findUnique.mockResolvedValue({ id: 'identity-1' });

    await expect(service.beginRegistration({ email: 'cliente@example.com', password: 'una-clave-segura', phone: '+5492494000000' }))
      .rejects.toEqual(new ConflictException('No se puede iniciar el registro'));
    expect(appIdentity.create).not.toHaveBeenCalled();
  });

  it('reenvía un código al mismo correo y teléfono pendientes sin crear identidad nueva', async () => {
    appIdentity.findUnique.mockResolvedValue({ id: 'identity-1', email: 'cliente@example.com', phone: '+5492494000000', status: 'PENDING_PHONE_VERIFICATION' });
    phoneVerificationChallenge.create.mockResolvedValue({ id: 'challenge-new', expiresAt: new Date('2026-09-15T12:10:00.000Z') });

    const result = await service.beginRegistration({ email: ' CLIENTE@example.com ', password: 'una-clave-segura', phone: '+54 9 249 400-0000' });

    expect(result.challengeId).toBe('challenge-new');
    expect(appIdentity.create).not.toHaveBeenCalled();
    expect(deliver).toHaveBeenCalledWith(expect.objectContaining({ phone: '+5492494000000', purpose: 'REGISTRATION' }));
  });

  it('no entrega sesión cuando otro consumo ganó la carrera del desafío', async () => {
    phoneVerificationChallenge.findUnique.mockResolvedValue({
      id: 'challenge-2', purpose: 'SESSION', codeHash: await hash('123456', 4),
      expiresAt: new Date(Date.now() + 60_000), consumedAt: null, attempts: 0,
      identity: { id: 'identity-1', email: 'cliente@example.com', phone: '+5492494000000', status: 'ACTIVE' },
    });
    phoneVerificationChallenge.updateMany.mockResolvedValue({ count: 0 });

    await expect(service.verifySession('challenge-2', '123456')).rejects.toBeInstanceOf(UnauthorizedException);
    expect(signAsync).not.toHaveBeenCalled();
  });

  it('no deja una identidad pendiente bloqueada si la entrega local del código falla', async () => {
    appIdentity.findUnique.mockResolvedValue(null);
    appIdentity.create.mockResolvedValue({ id: 'identity-1', email: 'cliente@example.com', phone: '+5492494000000' });
    phoneVerificationChallenge.create.mockResolvedValue({ id: 'challenge-1', expiresAt: new Date('2026-09-15T12:10:00.000Z') });
    deliver.mockRejectedValueOnce(new Error('Entrega local no disponible'));

    await expect(service.beginRegistration({ email: 'cliente@example.com', password: 'una-clave-segura', phone: '+5492494000000' }))
      .rejects.toThrow('Entrega local no disponible');

    expect(appIdentity.delete).toHaveBeenCalledWith({ where: { id: 'identity-1' } });
  });

  it('inicia una confirmación de sesión únicamente después de validar correo y contraseña', async () => {
    appIdentity.findUnique.mockResolvedValue({
      id: 'identity-1',
      email: 'cliente@example.com',
      phone: '+5492494000000',
      status: 'ACTIVE',
      passwordHash: await hash('una-clave-segura', 4),
    });
    phoneVerificationChallenge.create.mockResolvedValue({ id: 'challenge-2', expiresAt: new Date('2026-09-15T12:10:00.000Z') });

    const result = await service.beginSession('cliente@example.com', 'una-clave-segura');

    expect(deliver).toHaveBeenCalledWith(expect.objectContaining({ purpose: 'SESSION', phone: '+5492494000000' }));
    expect(result).toEqual({ challengeId: 'challenge-2', expiresAt: new Date('2026-09-15T12:10:00.000Z') });
  });

  it('responde de manera genérica y no entrega un código cuando la contraseña no coincide', async () => {
    appIdentity.findUnique.mockResolvedValue({
      id: 'identity-1',
      email: 'cliente@example.com',
      phone: '+5492494000000',
      status: 'ACTIVE',
      passwordHash: await hash('otra-clave', 4),
    });

    await expect(service.beginSession('cliente@example.com', 'una-clave-segura'))
      .rejects.toEqual(new UnauthorizedException('Credenciales inválidas'));
    expect(deliver).not.toHaveBeenCalled();
  });

  it('confirma una sesión con un desafío vigente de una sola utilización', async () => {
    const codeHash = await hash('123456', 4);
    phoneVerificationChallenge.findUnique.mockResolvedValue({
      id: 'challenge-2',
      purpose: 'SESSION',
      codeHash,
      expiresAt: new Date(Date.now() + 60_000),
      consumedAt: null,
      attempts: 0,
      identity: { id: 'identity-1', email: 'cliente@example.com', phone: '+5492494000000', status: 'ACTIVE' },
    });
    phoneVerificationChallenge.updateMany.mockResolvedValue({ count: 1 });

    const result = await service.verifySession('challenge-2', '123456');

    await expect(compare('123456', codeHash)).resolves.toBe(true);
    expect(phoneVerificationChallenge.updateMany).toHaveBeenCalledWith({
      where: expect.objectContaining({ id: 'challenge-2', consumedAt: null, attempts: { lt: 5 } }),
      data: expect.objectContaining({ consumedAt: expect.any(Date) }),
    });
    expect(signAsync).toHaveBeenCalledWith({ sub: 'identity-1', email: 'cliente@example.com', role: 'APP' });
    expect(result).toEqual({ accessToken: 'app-session-token', profile: { id: 'identity-1', email: 'cliente@example.com', phone: '+5492494000000' } });
  });

  it('activa una identidad solamente después de confirmar el código de registro', async () => {
    const codeHash = await hash('123456', 4);
    phoneVerificationChallenge.findUnique.mockResolvedValue({
      id: 'challenge-1',
      purpose: 'REGISTRATION',
      codeHash,
      expiresAt: new Date(Date.now() + 60_000),
      consumedAt: null,
      attempts: 0,
      identity: { id: 'identity-1', email: 'cliente@example.com', phone: '+5492494000000', status: 'PENDING_PHONE_VERIFICATION' },
    });
    appIdentity.updateMany.mockResolvedValue({ count: 1 });
    phoneVerificationChallenge.updateMany.mockResolvedValue({ count: 1 });

    const result = await service.verifyRegistration('challenge-1', '123456');

    expect(appIdentity.updateMany).toHaveBeenCalledWith({
      where: { id: 'identity-1', status: 'PENDING_PHONE_VERIFICATION' },
      data: expect.objectContaining({ status: 'ACTIVE', phoneVerifiedAt: expect.any(Date) }),
    });
    expect(result.accessToken).toBe('app-session-token');
    expect(result.profile).toEqual({ id: 'identity-1', email: 'cliente@example.com', phone: '+5492494000000' });
  });
});

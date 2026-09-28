import { hash } from 'bcryptjs';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import { UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../database/prisma.service.js';
import { AuthService } from './auth.service.js';

describe('AuthService', () => {
  const findUnique = vi.fn();
  const jwt = { signAsync: vi.fn().mockResolvedValue('signed-token') } as unknown as JwtService;
  const service = new AuthService({ adminAccount: { findUnique } } as unknown as PrismaService, jwt);

  beforeEach(() => vi.clearAllMocks());

  it('normalizes email and never returns the password hash', async () => {
    findUnique.mockResolvedValue({ id: 'admin-1', email: 'admin@example.com', displayName: 'Admin', status: 'ACTIVE', passwordHash: await hash('correct-pass', 4) });
    const result = await service.login(' ADMIN@example.com ', 'correct-pass');
    expect(findUnique).toHaveBeenCalledWith({ where: { email: 'admin@example.com' } });
    expect(result).toMatchObject({ accessToken: 'signed-token', profile: { email: 'admin@example.com', role: 'ADMIN' } });
    expect(result.profile).not.toHaveProperty('passwordHash');
  });

  it('uses a generic error for an invalid password', async () => {
    findUnique.mockResolvedValue({ id: 'admin-1', email: 'admin@example.com', displayName: 'Admin', status: 'ACTIVE', passwordHash: await hash('correct-pass', 4) });
    await expect(service.login('admin@example.com', 'wrong-pass')).rejects.toEqual(new UnauthorizedException('Credenciales inválidas'));
  });

  it('rejects suspended accounts', async () => {
    findUnique.mockResolvedValue({ id: 'admin-1', email: 'admin@example.com', displayName: 'Admin', status: 'SUSPENDED', passwordHash: await hash('correct-pass', 4) });
    await expect(service.login('admin@example.com', 'correct-pass')).rejects.toBeInstanceOf(UnauthorizedException);
  });
});

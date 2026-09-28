import { UnauthorizedException, type ExecutionContext } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import { AdminAuthGuard, type AdminRequest } from './admin-auth.guard.js';
import { AuthService } from './auth.service.js';

describe('AdminAuthGuard', () => {
  const verifyAsync = vi.fn();
  const profile = vi.fn();
  const request = { headers: {} } as AdminRequest;
  const context = {
    switchToHttp: () => ({ getRequest: () => request }),
  } as unknown as ExecutionContext;
  const guard = new AdminAuthGuard(
    { verifyAsync } as unknown as JwtService,
    { profile } as unknown as AuthService,
  );

  beforeEach(() => {
    vi.clearAllMocks();
    request.headers = {};
  });

  it('rejects requests without a bearer token', async () => {
    await expect(guard.canActivate(context)).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('attaches the verified active administrator', async () => {
    request.headers.authorization = 'Bearer valid-token';
    verifyAsync.mockResolvedValue({ sub: 'admin-1', email: 'admin@example.com', role: 'ADMIN' });
    profile.mockResolvedValue({ id: 'admin-1', email: 'admin@example.com', displayName: 'Admin', role: 'ADMIN', status: 'ACTIVE' });
    await expect(guard.canActivate(context)).resolves.toBe(true);
    expect(request.admin).toMatchObject({ id: 'admin-1', role: 'ADMIN' });
  });
});

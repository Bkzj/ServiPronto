import { UnauthorizedException, type ExecutionContext } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { describe, expect, it } from 'vitest';
import { AppAuthGuard, type AppRequest } from './app-auth.guard.js';

describe('AppAuthGuard', () => {
  const secret = 'a-test-secret-with-at-least-32-characters';
  const jwt = new JwtService({ secret });
  const guard = new AppAuthGuard(jwt);

  function contextFor(authorization?: string): { context: ExecutionContext; request: AppRequest } {
    const request = { headers: authorization ? { authorization } : {} } as AppRequest;
    const context = { switchToHttp: () => ({ getRequest: () => request }) } as unknown as ExecutionContext;
    return { context, request };
  }

  it('acepta un JWT APP firmado y adjunta solamente la identidad de aplicación', async () => {
    const token = await jwt.signAsync({ sub: 'identity-1', email: 'persona@example.com', role: 'APP' }, { expiresIn: '30m' });
    const { context, request } = contextFor(`Bearer ${token}`);

    await expect(guard.canActivate(context)).resolves.toBe(true);
    expect(request.appSession).toEqual({ identityId: 'identity-1', email: 'persona@example.com' });
  });

  it('rechaza un JWT administrativo aunque comparta secreto de firma', async () => {
    const token = await jwt.signAsync({ sub: 'admin-1', email: 'admin@example.com', role: 'ADMIN' }, { expiresIn: '30m' });
    const { context, request } = contextFor(`Bearer ${token}`);

    await expect(guard.canActivate(context)).rejects.toEqual(new UnauthorizedException('Sesión inválida'));
    expect(request.appSession).toBeUndefined();
  });

  it('rechaza un JWT sin rol', async () => {
    const token = await jwt.signAsync({ sub: 'identity-1', email: 'persona@example.com' }, { expiresIn: '30m' });
    const { context } = contextFor(`Bearer ${token}`);

    await expect(guard.canActivate(context)).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('rechaza un JWT APP con firma inválida sin mostrar el token en el error', async () => {
    const token = await new JwtService({ secret: 'another-test-secret-with-at-least-32-characters' })
      .signAsync({ sub: 'identity-1', email: 'persona@example.com', role: 'APP' }, { expiresIn: '30m' });
    const { context } = contextFor(`Bearer ${token}`);

    await expect(guard.canActivate(context)).rejects.toEqual(new UnauthorizedException('Sesión inválida'));
  });

  it('rechaza cabecera ausente o incompleta', async () => {
    for (const authorization of [undefined, 'Bearer', 'Basic abc', 'Bearer token extra']) {
      const { context } = contextFor(authorization);
      await expect(guard.canActivate(context)).rejects.toBeInstanceOf(UnauthorizedException);
    }
  });

  it('rechaza sesiones APP vencidas', async () => {
    const token = await jwt.signAsync({ sub: 'identity-1', email: 'persona@example.com', role: 'APP' }, { expiresIn: -1 });
    const { context } = contextFor(`Bearer ${token}`);

    await expect(guard.canActivate(context)).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('rechaza un JWT APP firmado que no tiene vencimiento', async () => {
    const token = await jwt.signAsync({ sub: 'identity-1', email: 'persona@example.com', role: 'APP' });
    const { context, request } = contextFor(`Bearer ${token}`);

    await expect(guard.canActivate(context)).rejects.toEqual(new UnauthorizedException('Sesión inválida'));
    expect(request.appSession).toBeUndefined();
  });

  it.each([
    { sub: '', email: 'persona@example.com', role: 'APP' },
    { email: 'persona@example.com', role: 'APP' },
    { sub: 'identity-1', email: '', role: 'APP' },
    { sub: 'identity-1', role: 'APP' },
  ])('rechaza un JWT APP con identidad incompleta: %j', async (payload) => {
    const token = await jwt.signAsync(payload, { expiresIn: '30m' });
    const { context } = contextFor(`Bearer ${token}`);

    await expect(guard.canActivate(context)).rejects.toBeInstanceOf(UnauthorizedException);
  });
});

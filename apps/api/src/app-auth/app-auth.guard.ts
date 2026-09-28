import { CanActivate, ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import type { Request } from 'express';

export type AppSession = { identityId: string; email: string };
export type AppRequest = Request & { appSession: AppSession };

@Injectable()
export class AppAuthGuard implements CanActivate {
  constructor(private readonly jwt: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<AppRequest>();
    const token = /^Bearer ([^\s]+)$/.exec(request.headers.authorization ?? '')?.[1];
    if (!token) throw new UnauthorizedException('Sesión inválida');

    try {
      const payload = await this.jwt.verifyAsync<Record<string, unknown>>(token);
      if (!isAppTokenPayload(payload)) throw new UnauthorizedException('Sesión inválida');
      request.appSession = { identityId: payload.sub, email: payload.email };
      return true;
    } catch {
      throw new UnauthorizedException('Sesión inválida');
    }
  }
}

function isAppTokenPayload(value: unknown): value is { sub: string; email: string; role: 'APP'; exp: number } {
  if (typeof value !== 'object' || value === null || Array.isArray(value)) return false;
  const payload = value as Record<string, unknown>;
  return payload.role === 'APP'
    && typeof payload.sub === 'string'
    && payload.sub.trim().length > 0
    && typeof payload.email === 'string'
    && payload.email.trim().length > 0
    && typeof payload.exp === 'number'
    && Number.isFinite(payload.exp)
    && payload.exp > Date.now() / 1000;
}

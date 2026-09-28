import { CanActivate, ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import type { Request } from 'express';
import { AuthService } from './auth.service.js';
import type { AdminTokenPayload, SafeAdminProfile } from './auth.types.js';

export type AdminRequest = Request & { admin: SafeAdminProfile };

@Injectable()
export class AdminAuthGuard implements CanActivate {
  constructor(private readonly jwt: JwtService, private readonly auth: AuthService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<AdminRequest>();
    const [scheme, token] = request.headers.authorization?.split(' ') ?? [];
    if (scheme !== 'Bearer' || !token) throw new UnauthorizedException('Sesión inválida');
    try {
      const payload = await this.jwt.verifyAsync<AdminTokenPayload>(token);
      if (payload.role !== 'ADMIN') throw new UnauthorizedException('Sesión inválida');
      request.admin = await this.auth.profile(payload.sub);
      return true;
    } catch {
      throw new UnauthorizedException('Sesión inválida');
    }
  }
}

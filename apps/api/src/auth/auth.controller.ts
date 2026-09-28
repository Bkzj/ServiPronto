import { Body, Controller, Get, HttpCode, HttpStatus, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags, ApiUnauthorizedResponse } from '@nestjs/swagger';
import { AdminAuthGuard } from './admin-auth.guard.js';
import { AuthService } from './auth.service.js';
import type { SafeAdminProfile } from './auth.types.js';
import { CurrentAdmin } from './current-admin.decorator.js';
import { LoginDto } from './login.dto.js';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({ description: 'Sesión administrativa iniciada' })
  @ApiUnauthorizedResponse({ description: 'Credenciales inválidas' })
  login(@Body() input: LoginDto) {
    return this.auth.login(input.email, input.password);
  }

  @Get('me')
  @UseGuards(AdminAuthGuard)
  @ApiBearerAuth()
  @ApiOkResponse({ description: 'Perfil administrador actual' })
  me(@CurrentAdmin() admin: SafeAdminProfile): SafeAdminProfile {
    return admin;
  }
}

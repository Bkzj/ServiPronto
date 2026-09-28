import { Body, Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { ApiBadRequestResponse, ApiConflictResponse, ApiCreatedResponse, ApiOkResponse, ApiOperation, ApiTags, ApiUnauthorizedResponse } from '@nestjs/swagger';
import { AppAuthService } from './app-auth.service.js';
import { AppChallengeResponseDto, AppErrorResponseDto, AppLoginDto, AppRegistrationDto, AppSessionResponseDto, AppVerificationDto } from './app-auth.dto.js';

@ApiTags('app-auth')
@Controller('app-auth')
export class AppAuthController {
  constructor(private readonly auth: AppAuthService) {}

  @Post('register')
  @ApiOperation({
    summary: 'Inicia un registro o reenvía su código pendiente',
    description: 'Si el mismo correo y teléfono ya tienen un registro pendiente, se envía un código nuevo y se conserva la contraseña original. El segundo intento no cambia la contraseña. Texto sugerido para la app: "Te enviamos un código. Si ya habías empezado el registro, seguí usando tu contraseña original".',
  })
  @ApiCreatedResponse({ description: 'Desafío creado; si el registro estaba pendiente, se reenvía el código y se conserva la contraseña original', type: AppChallengeResponseDto })
  @ApiBadRequestResponse({ description: 'Datos inválidos', type: AppErrorResponseDto })
  @ApiConflictResponse({ description: 'No se puede iniciar el registro', type: AppErrorResponseDto })
  register(@Body() input: AppRegistrationDto) {
    return this.auth.beginRegistration(input);
  }

  @Post('verify-registration')
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({ description: 'Sesión de aplicación creada', type: AppSessionResponseDto })
  @ApiBadRequestResponse({ description: 'Datos inválidos', type: AppErrorResponseDto })
  @ApiUnauthorizedResponse({ description: 'Código inválido o vencido', type: AppErrorResponseDto })
  verifyRegistration(@Body() input: AppVerificationDto) {
    return this.auth.verifyRegistration(input.challengeId, input.code);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({ description: 'Desafío telefónico creado', type: AppChallengeResponseDto })
  @ApiBadRequestResponse({ description: 'Datos inválidos', type: AppErrorResponseDto })
  @ApiUnauthorizedResponse({ description: 'Credenciales inválidas', type: AppErrorResponseDto })
  login(@Body() input: AppLoginDto) {
    return this.auth.beginSession(input.email, input.password);
  }

  @Post('verify-login')
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({ description: 'Sesión de aplicación creada', type: AppSessionResponseDto })
  @ApiBadRequestResponse({ description: 'Datos inválidos', type: AppErrorResponseDto })
  @ApiUnauthorizedResponse({ description: 'Código inválido o vencido', type: AppErrorResponseDto })
  verifyLogin(@Body() input: AppVerificationDto) {
    return this.auth.verifySession(input.challengeId, input.code);
  }
}

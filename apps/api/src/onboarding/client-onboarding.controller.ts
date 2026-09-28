import { Body, Controller, Get, HttpCode, HttpStatus, Put, UseGuards, ValidationPipe } from '@nestjs/common';
import { ApiBadRequestResponse, ApiBearerAuth, ApiBody, ApiOkResponse, ApiOperation, ApiTags, ApiUnauthorizedResponse } from '@nestjs/swagger';
import { AppAuthGuard, type AppSession } from '../app-auth/app-auth.guard.js';
import { CurrentApp } from '../app-auth/current-app.decorator.js';
import { AppErrorResponseDto } from '../app-auth/app-auth.dto.js';
import { ClientDraftDto, ClientProfileDto } from './client-onboarding.dto.js';
import { ClientOnboardingService, type ClientDraft, type ClientProfile } from './client-onboarding.service.js';

@ApiTags('onboarding')
@ApiBearerAuth('AppBearer')
@UseGuards(AppAuthGuard)
@Controller('onboarding/client')
export class ClientOnboardingController {
  constructor(private readonly onboarding: ClientOnboardingService) {}

  @Get()
  @ApiOperation({ summary: 'Lee el borrador o perfil Cliente del titular de la sesión APP' })
  @ApiOkResponse({ description: 'Borrador vacío o perfil guardado; correo y teléfono proceden de la identidad verificada', type: ClientProfileDto })
  @ApiUnauthorizedResponse({ description: 'Sesión APP ausente o inválida', type: AppErrorResponseDto })
  get(@CurrentApp() session: AppSession): Promise<ClientProfile> {
    return this.onboarding.get(session.identityId);
  }

  @Put()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Crea o actualiza un paso del borrador Cliente', description: 'Requiere al menos un campo editable. No admite correo, teléfono, identidad ni completitud enviados por el cliente.' })
  @ApiBody({ type: ClientDraftDto, description: 'Al menos un campo editable; los campos no enviados se conservan' })
  @ApiOkResponse({ description: 'Perfil Cliente creado o actualizado', type: ClientProfileDto })
  @ApiBadRequestResponse({ description: 'Borrador vacío, inválido o con campos reservados', type: AppErrorResponseDto })
  @ApiUnauthorizedResponse({ description: 'Sesión APP ausente o inválida', type: AppErrorResponseDto })
  save(
    @CurrentApp() session: AppSession,
    @Body(new ValidationPipe({ expectedType: ClientDraftDto, whitelist: true, forbidNonWhitelisted: true, transform: true })) input: ClientDraft,
  ): Promise<ClientProfile> {
    return this.onboarding.save(session.identityId, input);
  }
}

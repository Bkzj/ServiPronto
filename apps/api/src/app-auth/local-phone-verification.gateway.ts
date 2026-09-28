import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { PhoneVerificationDelivery, PhoneVerificationGateway } from './phone-verification.gateway.js';

@Injectable()
export class LocalPhoneVerificationGateway implements PhoneVerificationGateway {
  private readonly logger = new Logger(LocalPhoneVerificationGateway.name);

  constructor(config: ConfigService) {
    const environment = config.getOrThrow<string>('NODE_ENV');
    if (environment !== 'development' && environment !== 'test') {
      throw new Error('El adaptador local de verificación telefónica solo puede usarse en desarrollo o pruebas');
    }
    if (config.getOrThrow<boolean>('PHONE_VERIFICATION_LOCAL_ENABLED') !== true) {
      throw new Error('El adaptador local de verificación telefónica no está habilitado');
    }
  }

  async deliver(delivery: PhoneVerificationDelivery): Promise<void> {
    this.logger.debug({ phone: delivery.phone, purpose: delivery.purpose, expiresAt: delivery.expiresAt.toISOString(), code: delivery.code }, 'Código local de verificación');
  }
}

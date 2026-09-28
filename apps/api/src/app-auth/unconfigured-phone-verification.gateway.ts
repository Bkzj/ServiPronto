import { ServiceUnavailableException } from '@nestjs/common';
import type { PhoneVerificationDelivery, PhoneVerificationGateway } from './phone-verification.gateway.js';

export class UnconfiguredPhoneVerificationGateway implements PhoneVerificationGateway {
  async deliver(_delivery: PhoneVerificationDelivery): Promise<void> {
    throw new ServiceUnavailableException('La verificación telefónica no está configurada');
  }
}

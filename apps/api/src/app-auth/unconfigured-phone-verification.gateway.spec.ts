import { ServiceUnavailableException } from '@nestjs/common';
import { describe, expect, it } from 'vitest';
import { UnconfiguredPhoneVerificationGateway } from './unconfigured-phone-verification.gateway.js';

describe('UnconfiguredPhoneVerificationGateway', () => {
  it('no finge una entrega cuando todavía no existe un proveedor de mensajería configurado', async () => {
    const gateway = new UnconfiguredPhoneVerificationGateway();
    await expect(gateway.deliver({ phone: '+5492494000000', code: '123456', purpose: 'SESSION', expiresAt: new Date() }))
      .rejects.toEqual(new ServiceUnavailableException('La verificación telefónica no está configurada'));
  });
});

import { ConfigService } from '@nestjs/config';
import { describe, expect, it } from 'vitest';
import { LocalPhoneVerificationGateway } from './local-phone-verification.gateway.js';

describe('LocalPhoneVerificationGateway', () => {
  it.each(['development', 'test'])('rechaza el adaptador local en %s cuando la bandera está deshabilitada', (environment) => {
    const config = { getOrThrow: (key: string) => key === 'NODE_ENV' ? environment : false } as unknown as ConfigService;
    expect(() => new LocalPhoneVerificationGateway(config)).toThrow('no está habilitado');
  });

  it('solo se habilita para desarrollo y pruebas', () => {
    const config = { getOrThrow: (key: string) => key === 'NODE_ENV' ? 'production' : true } as unknown as ConfigService;
    expect(() => new LocalPhoneVerificationGateway(config)).toThrow('solo puede usarse en desarrollo o pruebas');
  });
});

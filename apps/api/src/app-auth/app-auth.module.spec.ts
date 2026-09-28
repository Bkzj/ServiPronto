import { Injectable } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { describe, expect, it } from 'vitest';
import { AppAuthModule } from './app-auth.module.js';
import { AppAuthGuard } from './app-auth.guard.js';
import { AppAuthService } from './app-auth.service.js';
import { LocalPhoneVerificationGateway } from './local-phone-verification.gateway.js';
import { PHONE_VERIFICATION_GATEWAY } from './phone-verification.gateway.js';
import { UnconfiguredPhoneVerificationGateway } from './unconfigured-phone-verification.gateway.js';

describe('AppAuthModule', () => {
  it('expone AppAuthGuard para controladores de aplicación futuros', async () => {
    @Injectable()
    class GuardConsumer {
      constructor(readonly guard: AppAuthGuard) {}
    }

    const module = await Test.createTestingModule({
      imports: [ConfigModule.forRoot({ isGlobal: true, ignoreEnvFile: true }), AppAuthModule],
      providers: [GuardConsumer],
    })
      .overrideProvider(ConfigService)
      .useValue({ getOrThrow: (key: string) => key === 'NODE_ENV' ? 'test' : key === 'PHONE_VERIFICATION_LOCAL_ENABLED' ? false : 'a-local-secret-with-at-least-32-characters' })
      .overrideProvider(AppAuthService)
      .useValue({})
      .compile();

    expect(module.get(GuardConsumer).guard).toBeInstanceOf(AppAuthGuard);
    await module.close();
  });

  it.each([
    { environment: 'development', enabled: false, gateway: UnconfiguredPhoneVerificationGateway },
    { environment: 'development', enabled: true, gateway: LocalPhoneVerificationGateway },
    { environment: 'test', enabled: true, gateway: LocalPhoneVerificationGateway },
    { environment: 'production', enabled: false, gateway: UnconfiguredPhoneVerificationGateway },
    { environment: 'production', enabled: true, gateway: UnconfiguredPhoneVerificationGateway },
  ])('selecciona $gateway.name en $environment cuando enabled=$enabled', async ({ environment, enabled, gateway }) => {
    const module = await Test.createTestingModule({ imports: [ConfigModule.forRoot({ isGlobal: true, ignoreEnvFile: true }), AppAuthModule] })
      .overrideProvider(ConfigService)
      .useValue({ getOrThrow: (key: string) => key === 'NODE_ENV' ? environment : key === 'PHONE_VERIFICATION_LOCAL_ENABLED' ? enabled : 'a-local-secret-with-at-least-32-characters' })
      .overrideProvider(AppAuthService)
      .useValue({})
      .compile();

    expect(module.get(PHONE_VERIFICATION_GATEWAY)).toBeInstanceOf(gateway);
    await module.close();
  });
});

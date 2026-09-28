import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { AppAuthGuard } from './app-auth.guard.js';
import { AppAuthService } from './app-auth.service.js';
import { AppAuthController } from './app-auth.controller.js';
import { LocalPhoneVerificationGateway } from './local-phone-verification.gateway.js';
import { PHONE_VERIFICATION_GATEWAY } from './phone-verification.gateway.js';
import { UnconfiguredPhoneVerificationGateway } from './unconfigured-phone-verification.gateway.js';

@Module({
  controllers: [AppAuthController],
  imports: [JwtModule.registerAsync({
    inject: [ConfigService],
    useFactory: (config: ConfigService) => ({ secret: config.getOrThrow<string>('JWT_SECRET'), signOptions: { expiresIn: '30m' } }),
  })],
  providers: [
    AppAuthService,
    AppAuthGuard,
    {
      provide: PHONE_VERIFICATION_GATEWAY,
      inject: [ConfigService],
      useFactory: (config: ConfigService) => {
        const environment = config.getOrThrow<string>('NODE_ENV');
        const localEnabled = config.getOrThrow<boolean>('PHONE_VERIFICATION_LOCAL_ENABLED');
        return localEnabled && (environment === 'development' || environment === 'test')
          ? new LocalPhoneVerificationGateway(config)
          : new UnconfiguredPhoneVerificationGateway();
      },
    },
  ],
  exports: [AppAuthService, AppAuthGuard, JwtModule],
})
export class AppAuthModule {}

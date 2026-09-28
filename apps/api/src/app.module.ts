import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { LoggerModule } from 'nestjs-pino';
import { validateEnvironment } from './config/environment.js';
import { DatabaseModule } from './database/database.module.js';
import { HealthModule } from './health/health.module.js';
import { AdminModule } from './admin/admin.module.js';
import { AuthModule } from './auth/auth.module.js';
import { BusinessModulesModule } from './modules/business-modules.module.js';
import { AppAuthModule } from './app-auth/app-auth.module.js';
import { ClientOnboardingModule } from './onboarding/client-onboarding.module.js';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, envFilePath: ['../../.env', '.env'], validate: validateEnvironment }),
    LoggerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        pinoHttp: {
          level: config.get('LOG_LEVEL', 'info'),
          redact: ['req.headers.authorization', 'req.headers.cookie', 'res.headers.set-cookie'],
        },
      }),
    }),
    DatabaseModule,
    HealthModule,
    AuthModule,
    AppAuthModule,
    ClientOnboardingModule,
    AdminModule,
    BusinessModulesModule,
  ],
})
export class AppModule {}

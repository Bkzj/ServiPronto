import { Module } from '@nestjs/common';
import { AppAuthModule } from '../app-auth/app-auth.module.js';
import { ClientOnboardingController } from './client-onboarding.controller.js';
import { ClientOnboardingService } from './client-onboarding.service.js';

@Module({ imports: [AppAuthModule], controllers: [ClientOnboardingController], providers: [ClientOnboardingService] })
export class ClientOnboardingModule {}

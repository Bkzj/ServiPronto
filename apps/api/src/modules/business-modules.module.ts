import { Module } from '@nestjs/common';
import { JorgeModule } from '../jorge/jorge.module.js';
import { AccountsModule } from './accounts/accounts.module.js';
import { CatalogModule } from './catalog/catalog.module.js';
import { ContentModule } from './content/content.module.js';
import { IncidentsModule } from './incidents/incidents.module.js';
import { JobsModule } from './jobs/jobs.module.js';
import { MessagingModule } from './messaging/messaging.module.js';
import { NotificationsModule } from './notifications/notifications.module.js';
import { PaymentsModule } from './payments/payments.module.js';
import { ProvidersModule } from './providers/providers.module.js';
import { QuotesModule } from './quotes/quotes.module.js';
import { ReputationModule } from './reputation/reputation.module.js';
import { RequestsModule } from './requests/requests.module.js';
import { SchedulingModule } from './scheduling/scheduling.module.js';
import { VisitsModule } from './visits/visits.module.js';

@Module({ imports: [AccountsModule, ProvidersModule, CatalogModule, RequestsModule, VisitsModule, QuotesModule, JobsModule, SchedulingModule, MessagingModule, PaymentsModule, ReputationModule, IncidentsModule, ContentModule, NotificationsModule, JorgeModule] })
export class BusinessModulesModule {}

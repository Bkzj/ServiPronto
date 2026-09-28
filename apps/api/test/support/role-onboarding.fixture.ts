import { ValidationPipe } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { Prisma } from '@prisma/client';
import { hash } from 'bcryptjs';
import { randomUUID } from 'node:crypto';
import type { INestApplication } from '@nestjs/common';
import { PHONE_VERIFICATION_GATEWAY, type PhoneVerificationDelivery } from '../../src/app-auth/phone-verification.gateway.js';
import { PrismaService } from '../../src/database/prisma.service.js';

export const secret = 'role-onboarding-contract-test-secret-123456';
export const clientPhone = '+5492494000001';
export const registrationPhone = '+5492494000002';
export const adminId = 'feff9549-d9b4-476a-a0a0-d03ccaa7536e';
export const providerId = '582680d3-1e34-4d8c-8d9a-0becc537306a';

type Identity = {
  id: string;
  email: string;
  phone: string;
  passwordHash: string;
  status: 'PENDING_PHONE_VERIFICATION' | 'ACTIVE';
  phoneVerifiedAt?: Date;
};
type Challenge = {
  id: string;
  identityId: string;
  purpose: 'REGISTRATION' | 'SESSION';
  codeHash: string;
  expiresAt: Date;
  consumedAt: Date | null;
  attempts: number;
};
type ClientAccount = {
  id: string;
  identityId: string;
  firstName: string | null;
  lastName: string | null;
  birthDate: Date | null;
  address: { street: string; number: string; city: string } | null;
  isComplete: boolean;
};
type ClientAccountCreate = Pick<ClientAccount, 'identityId'> & Partial<Omit<ClientAccount, 'id' | 'identityId'>>;
type ClientAccountQuery = { where: { identityId?: string; id?: string }; include?: { identity?: boolean } };

// Solo reemplaza la persistencia; el contrato HTTP usa módulos, controladores y guards reales.
export class IsolatedDatabase {
  private identities = new Map<string, Identity>();
  private challenges = new Map<string, Challenge>();
  private clientAccounts = new Map<string, ClientAccount>();
  private existingProvider: { id: string; identityId: string; status: 'INCOMPLETE' } | null = null;
  private adminPasswordHash = '';

  async prepare(): Promise<void> {
    this.adminPasswordHash = await hash('Admin-contract-2026!', 4);
  }

  reset(): void {
    this.identities.clear();
    this.challenges.clear();
    this.clientAccounts.clear();
    this.existingProvider = null;
    this.identities.set('identity-fixture', {
      id: 'identity-fixture', email: 'perfil@servipronto.test', phone: clientPhone,
      passwordHash: this.adminPasswordHash, status: 'ACTIVE', phoneVerifiedAt: new Date('2026-09-15T00:00:00Z'),
    });
  }

  identityCount(): number { return this.identities.size; }
  clientAccountCount(): number { return this.clientAccounts.size; }
  seedExistingProvider(): void {
    this.existingProvider = { id: providerId, identityId: 'identity-fixture', status: 'INCOMPLETE' };
  }
  existingProviderSnapshot(): { id: string; identityId: string; status: 'INCOMPLETE' } | null {
    return this.existingProvider && { ...this.existingProvider };
  }
  challengeCount(): number { return this.challenges.size; }
  storedSecretHashes(): string[] {
    return [
      ...[...this.identities.values()].map((identity) => identity.passwordHash),
      ...[...this.challenges.values()].map((challenge) => challenge.codeHash),
    ];
  }
  expireChallenge(id: string): void {
    const challenge = this.challenges.get(id);
    if (!challenge) throw new Error(`Desafío de prueba inexistente: ${id}`);
    challenge.expiresAt = new Date(Date.now() - 1);
  }

  readonly appIdentity = {
    findUnique: async ({ where }: { where: { email?: string; id?: string; phone?: string } }) =>
      [...this.identities.values()].find((identity) => identity.email === where.email || identity.id === where.id || identity.phone === where.phone) ?? null,
    create: async ({ data }: { data: Omit<Identity, 'id'> }) => {
      if ([...this.identities.values()].some((identity) => identity.phone === data.phone || identity.email === data.email)) {
        throw new Prisma.PrismaClientKnownRequestError('Identidad duplicada', {
          code: 'P2002', clientVersion: '6.12.0', meta: { target: ['phone'] },
        });
      }
      const identity = { ...data, id: randomUUID() };
      this.identities.set(identity.id, identity);
      return identity;
    },
    update: async ({ where, data }: { where: { id: string }; data: Partial<Identity> }) => {
      const identity = this.identities.get(where.id);
      if (!identity) throw new Error('Identidad de prueba inexistente');
      Object.assign(identity, data);
      return identity;
    },
    updateMany: async ({ where, data }: { where: { id: string; status?: Identity['status'] }; data: Partial<Identity> }) => {
      const identity = this.identities.get(where.id);
      if (!identity || (where.status && identity.status !== where.status)) return { count: 0 };
      Object.assign(identity, data);
      return { count: 1 };
    },
    delete: async ({ where }: { where: { id: string } }) => this.identities.delete(where.id),
  };

  readonly phoneVerificationChallenge = {
    create: async ({ data }: { data: Omit<Challenge, 'id' | 'consumedAt' | 'attempts'> }) => {
      const challenge = { ...data, id: randomUUID(), consumedAt: null, attempts: 0 };
      this.challenges.set(challenge.id, challenge);
      return challenge;
    },
    findUnique: async ({ where }: { where: { id: string } }) => {
      const challenge = this.challenges.get(where.id);
      const identity = challenge && this.identities.get(challenge.identityId);
      return challenge && identity ? { ...challenge, identity } : null;
    },
    update: async ({ where, data }: { where: { id: string }; data: { consumedAt?: Date; attempts?: { increment: number } } }) => {
      const challenge = this.challenges.get(where.id);
      if (!challenge) throw new Error('Desafío de prueba inexistente');
      if (data.consumedAt) challenge.consumedAt = data.consumedAt;
      if (data.attempts) challenge.attempts += data.attempts.increment;
      return challenge;
    },
    updateMany: async ({ where, data }: { where: { id: string; purpose?: Challenge['purpose']; consumedAt?: null; expiresAt?: { gt: Date }; attempts?: { lt: number } }; data: { consumedAt?: Date; attempts?: { increment: number } } }) => {
      const challenge = this.challenges.get(where.id);
      if (!challenge || (where.purpose && challenge.purpose !== where.purpose)
        || (where.consumedAt === null && challenge.consumedAt !== null)
        || (where.expiresAt && challenge.expiresAt <= where.expiresAt.gt)
        || (where.attempts && challenge.attempts >= where.attempts.lt)) return { count: 0 };
      if (data.consumedAt) challenge.consumedAt = data.consumedAt;
      if (data.attempts) challenge.attempts += data.attempts.increment;
      return { count: 1 };
    },
  };

  readonly adminAccount = {
    findUnique: async ({ where }: { where: { id?: string; email?: string } }) =>
      where.id === adminId || where.email === 'admin@servipronto.test'
        ? { id: adminId, email: 'admin@servipronto.test', passwordHash: this.adminPasswordHash, displayName: 'Admin de prueba', status: 'ACTIVE' as const }
        : null,
  };

  readonly clientAccount = {
    findUnique: async ({ where, include }: ClientAccountQuery) => {
      const account = [...this.clientAccounts.values()]
        .find((item) => item.identityId === where.identityId || item.id === where.id);
      return account ? this.clientAccountResult(account, include) : null;
    },
    create: async ({ data, include }: { data: ClientAccountCreate; include?: ClientAccountQuery['include'] }) => {
      if (this.clientAccounts.has(data.identityId)) {
        throw new Prisma.PrismaClientKnownRequestError('Cuenta Cliente duplicada', {
          code: 'P2002', clientVersion: '6.12.0', meta: { target: ['identity_id'] },
        });
      }
      const account: ClientAccount = {
        id: randomUUID(), identityId: data.identityId, firstName: data.firstName ?? null,
        lastName: data.lastName ?? null, birthDate: data.birthDate ?? null,
        address: (data.address as unknown) === Prisma.JsonNull ? null : data.address ?? null,
        isComplete: data.isComplete ?? false,
      };
      this.clientAccounts.set(account.identityId, account);
      return this.clientAccountResult(account, include);
    },
    update: async ({ where, data, include }: ClientAccountQuery & { data: Partial<ClientAccount> }) => {
      const account = [...this.clientAccounts.values()]
        .find((item) => item.identityId === where.identityId || item.id === where.id);
      if (!account) throw new Error('Cuenta Cliente de prueba inexistente');
      Object.assign(account, data);
      return this.clientAccountResult(account, include);
    },
    upsert: async ({ where, create, update, include }: { where: { identityId: string }; create: ClientAccountCreate; update: Partial<ClientAccount>; include?: ClientAccountQuery['include'] }) => {
      const account = this.clientAccounts.get(where.identityId);
      if (account) {
        Object.assign(account, update);
        return this.clientAccountResult(account, include);
      }
      return this.clientAccount.create({ data: create, include });
    },
  };

  private clientAccountResult(account: ClientAccount, include?: { identity?: boolean }) {
    if (!include?.identity) return account;
    const identity = this.identities.get(account.identityId);
    if (!identity) throw new Error('Identidad de cuenta Cliente de prueba inexistente');
    return { ...account, identity };
  }

  readonly serviceCategory = {
    findUnique: async ({ where }: { where: { id?: string } }) =>
      where.id === 'plomeria' ? { id: 'plomeria', name: 'Plomería', enabled: true } : null,
    findFirst: async ({ where }: { where: { id?: string; enabled?: boolean } }) =>
      where.id === 'plomeria' && where.enabled !== false
        ? { id: 'plomeria', name: 'Plomería', enabled: true }
        : null,
  };

  async $transaction<T>(operation: (transaction: IsolatedDatabase) => Promise<T>): Promise<T> {
    return operation(this);
  }
}

export class RoleOnboardingFixture {
  app!: INestApplication;
  database = new IsolatedDatabase();
  deliveries: PhoneVerificationDelivery[] = [];
  private previousEnvironment = new Map<string, string | undefined>();

  async start(): Promise<void> {
    const testEnvironment = {
      NODE_ENV: 'test', DATABASE_URL: 'postgresql://isolated:isolated@127.0.0.1:1/isolated_contract_test',
      JWT_SECRET: secret, SEED_ADMIN_EMAIL: 'admin@servipronto.test', SEED_ADMIN_PASSWORD: 'Admin-contract-2026!',
      PHONE_VERIFICATION_LOCAL_ENABLED: 'false',
    };
    for (const [key, value] of Object.entries(testEnvironment)) {
      this.previousEnvironment.set(key, process.env[key]);
      process.env[key] = value;
    }
    const { AppModule } = await import('../../src/app.module.js');
    await this.database.prepare();
    const module = await Test.createTestingModule({ imports: [AppModule] })
      .overrideProvider(PrismaService)
      .useValue(this.database as unknown as PrismaService)
      .overrideProvider(PHONE_VERIFICATION_GATEWAY)
      .useValue({ deliver: async (delivery: PhoneVerificationDelivery) => { this.deliveries.push(delivery); } })
      .compile();
    this.app = module.createNestApplication();
    this.app.setGlobalPrefix('api/v1');
    this.app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
    await this.app.init();
  }

  reset(): void {
    this.database.reset();
    this.deliveries.length = 0;
  }

  async stop(): Promise<void> {
    await this.app?.close();
    for (const [key, value] of this.previousEnvironment) {
      if (value === undefined) delete process.env[key];
      else process.env[key] = value;
    }
  }
}

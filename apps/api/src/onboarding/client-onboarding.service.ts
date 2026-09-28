import { BadRequestException, Injectable, UnauthorizedException } from '@nestjs/common';
import { Prisma, type AppIdentity, type ClientAccount } from '@prisma/client';
import { PrismaService } from '../database/prisma.service.js';

export type ClientDraft = {
  firstName?: string;
  lastName?: string;
  birthDate?: string;
  address?: { street: string; number: string; city: string };
};

export type ClientProfile = {
  id: string | null;
  firstName: string | null;
  lastName: string | null;
  birthDate: string | null;
  address: { street: string; number: string; city: string } | null;
  email: string;
  phone: string;
  isComplete: boolean;
};

@Injectable()
export class ClientOnboardingService {
  constructor(private readonly prisma: PrismaService) {}

  async get(identityId: string): Promise<ClientProfile> {
    const account = await this.prisma.clientAccount.findUnique({
      where: { identityId }, include: { identity: true },
    });
    if (!account) {
      const identity = await this.prisma.appIdentity.findUnique({ where: { id: identityId } });
      this.requireVerifiedIdentity(identity);
      return {
        id: null, firstName: null, lastName: null, birthDate: null, address: null,
        email: identity.email, phone: identity.phone, isComplete: false,
      };
    }
    this.requireVerifiedIdentity(account.identity);
    return this.toProfile(account);
  }

  async save(identityId: string, draft: ClientDraft): Promise<ClientProfile> {
    this.requireEditableDraft(draft);
    const changes = {
      ...(draft.firstName !== undefined ? { firstName: this.normalizeName(draft.firstName) } : {}),
      ...(draft.lastName !== undefined ? { lastName: this.normalizeName(draft.lastName) } : {}),
      ...(draft.birthDate !== undefined ? { birthDate: this.parseBirthDate(draft.birthDate) } : {}),
      ...(draft.address !== undefined ? { address: this.normalizeAddress(draft.address) } : {}),
    };
    const persist = () => this.prisma.$transaction(async (transaction) => {
      const identity = await transaction.appIdentity.findUnique({ where: { id: identityId } });
      this.requireVerifiedIdentity(identity);
      const existing = await transaction.clientAccount.findUnique({ where: { identityId } });
      const merged = {
        firstName: changes.firstName !== undefined ? changes.firstName : existing?.firstName ?? null,
        lastName: changes.lastName !== undefined ? changes.lastName : existing?.lastName ?? null,
        birthDate: changes.birthDate !== undefined ? changes.birthDate : existing?.birthDate ?? null,
        address: changes.address !== undefined ? changes.address : existing?.address ?? null,
      };
      const isComplete = !!(merged.firstName && merged.lastName && merged.birthDate && this.hasCompleteAddress(merged.address));
      const account = await transaction.clientAccount.upsert({
        where: { identityId },
        create: {
          identityId, firstName: merged.firstName, lastName: merged.lastName,
          birthDate: merged.birthDate, address: merged.address ?? Prisma.JsonNull, isComplete,
        },
        update: { ...changes, isComplete },
      });
      return this.toProfile({ ...account, identity });
    }, { isolationLevel: Prisma.TransactionIsolationLevel.Serializable });
    for (let attempt = 0; attempt < 3; attempt += 1) {
      try {
        return await persist();
      } catch (error) {
        if (!(error instanceof Prisma.PrismaClientKnownRequestError)
          || !['P2034', 'P2002'].includes(error.code) || attempt === 2) throw error;
      }
    }
    throw new Error('No se pudo guardar el perfil Cliente');
  }

  private requireEditableDraft(draft: ClientDraft): void {
    if (!draft || typeof draft !== 'object' || Array.isArray(draft) || Object.values(draft).every((value) => value === undefined)
      || Object.keys(draft).some((key) => !['firstName', 'lastName', 'birthDate', 'address'].includes(key))) {
      throw new BadRequestException('Datos de perfil inválidos');
    }
  }

  private requireVerifiedIdentity(identity: AppIdentity | null): asserts identity is AppIdentity {
    if (!identity || identity.status !== 'ACTIVE' || !identity.phoneVerifiedAt) {
      throw new UnauthorizedException('Sesión inválida');
    }
  }

  private normalizeName(value: string): string | null {
    if (typeof value !== 'string') throw new BadRequestException('Nombre inválido');
    const normalized = value.trim().replace(/\s+/g, ' ');
    if (normalized.length > 120) throw new BadRequestException('Nombre inválido');
    return normalized || null;
  }

  private normalizeAddress(value: ClientDraft['address']): NonNullable<ClientProfile['address']> {
    if (!value || typeof value !== 'object' || Array.isArray(value)
      || Object.keys(value).some((key) => !['street', 'number', 'city'].includes(key))) {
      throw new BadRequestException('Dirección inválida');
    }
    const street = this.normalizeAddressPart(value.street);
    const number = this.normalizeAddressPart(value.number);
    const city = this.normalizeAddressPart(value.city);
    return { street, number, city };
  }

  private normalizeAddressPart(value: string): string {
    if (typeof value !== 'string') throw new BadRequestException('Dirección inválida');
    const normalized = value.trim().replace(/\s+/g, ' ');
    if (!normalized || normalized.length > 120) throw new BadRequestException('Dirección inválida');
    return normalized;
  }

  private parseBirthDate(value: string): Date {
    if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(value)) {
      throw new BadRequestException('Fecha de nacimiento inválida');
    }
    const date = new Date(`${value}T00:00:00.000Z`);
    if (Number.isNaN(date.getTime()) || date.toISOString().slice(0, 10) !== value || date > new Date()) {
      throw new BadRequestException('Fecha de nacimiento inválida');
    }
    return date;
  }

  private hasCompleteAddress(value: unknown): boolean {
    if (!value || typeof value !== 'object' || Array.isArray(value)) return false;
    const address = value as Record<string, unknown>;
    return ['street', 'number', 'city'].every((key) => typeof address[key] === 'string' && !!address[key].trim());
  }

  private toProfile(account: ClientAccount & { identity: AppIdentity }): ClientProfile {
    return {
      id: account.id,
      firstName: account.firstName,
      lastName: account.lastName,
      birthDate: account.birthDate ? account.birthDate.toISOString().slice(0, 10) : null,
      address: account.address as ClientProfile['address'],
      email: account.identity.email,
      phone: account.identity.phone,
      isComplete: !!(account.firstName && account.lastName && account.birthDate
        && this.hasCompleteAddress(account.address) && account.identity.status === 'ACTIVE'
        && account.identity.phoneVerifiedAt),
    };
  }
}

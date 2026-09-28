import { Prisma } from '@prisma/client';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import { IsolatedDatabase, clientPhone } from '../../test/support/role-onboarding.fixture.js';
import { PrismaService } from '../database/prisma.service.js';
import { ClientOnboardingService } from './client-onboarding.service.js';

describe('ClientOnboardingService', () => {
  const database = new IsolatedDatabase();
  const service = new ClientOnboardingService(database as unknown as PrismaService);
  const identityId = 'identity-fixture';

  beforeEach(() => database.reset());

  it('retoma el mismo borrador al guardar pasos separados', async () => {
    const first = await service.save(identityId, { firstName: 'Ana' });
    expect(first).toEqual({
      id: expect.any(String), firstName: 'Ana', lastName: null, birthDate: null,
      address: null, email: 'perfil@servipronto.test', phone: clientPhone, isComplete: false,
    });

    expect(await service.get(identityId)).toEqual(first);
    const second = await service.save(identityId, { lastName: 'Pérez' });
    expect(second).toEqual({ ...first, lastName: 'Pérez' });
    expect(database.clientAccountCount()).toBe(1);
  });

  it('normaliza espacios de nombres y dirección antes de persistir', async () => {
    const profile = await service.save(identityId, {
      firstName: '  Ana   María  ', lastName: '  Pérez  ',
      address: { street: '  Av.   Belgrano  ', number: ' 456  ', city: '  Tandil ' },
    });
    expect(profile).toMatchObject({
      firstName: 'Ana María', lastName: 'Pérez',
      address: { street: 'Av. Belgrano', number: '456', city: 'Tandil' },
      isComplete: false,
    });
    expect(await service.get(identityId)).toEqual(profile);
  });

  it('marca completo solo después de recibir fecha y dirección válidas', async () => {
    const incomplete = await service.save(identityId, {
      firstName: 'Ana', lastName: 'Pérez', birthDate: '1988-05-14',
    });
    expect(incomplete.isComplete).toBe(false);
    const complete = await service.save(identityId, {
      address: { street: 'Belgrano', number: '456', city: 'Tandil' },
    });
    expect(complete).toEqual({ ...incomplete,
      address: { street: 'Belgrano', number: '456', city: 'Tandil' }, isComplete: true,
    });
    expect(await service.get(identityId)).toEqual(complete);
  });

  it('rechaza fechas imposibles sin alterar el borrador', async () => {
    const existing = await service.save(identityId, { firstName: 'Ana' });
    await expect(service.save(identityId, { birthDate: '2026-02-30' })).rejects.toMatchObject({ status: 400 });
    expect(await service.get(identityId)).toEqual(existing);
  });

  it('no acepta correo, teléfono ni completitud enviados como datos de perfil', async () => {
    await expect(service.save(identityId, {
      firstName: 'Ana', phone: '+5492494999999', email: 'otro@servipronto.test', isComplete: true,
    } as Parameters<typeof service.save>[1])).rejects.toMatchObject({ status: 400 });
    expect(database.clientAccountCount()).toBe(0);
  });

  it('conserva intacta una cuenta Proveedor de la misma identidad', async () => {
    database.seedExistingProvider();
    const provider = database.existingProviderSnapshot();
    const client = await service.save(identityId, { firstName: 'Ana' });
    expect(client.id).not.toBe(provider?.id);
    expect(database.existingProviderSnapshot()).toEqual(provider);
    expect(database.clientAccountCount()).toBe(1);
  });

  it('vuelve incompleto si un nombre queda en blanco', async () => {
    await service.save(identityId, {
      firstName: 'Ana', lastName: 'Pérez', birthDate: '1988-05-14',
      address: { street: 'Belgrano', number: '456', city: 'Tandil' },
    });
    const revised = await service.save(identityId, { firstName: '   ' });
    expect(revised.firstName).toBeNull();
    expect(revised.isComplete).toBe(false);
    expect((await service.get(identityId)).isComplete).toBe(false);
  });

  it('no permite leer ni guardar con una identidad que dejó de estar verificada y activa', async () => {
    await service.save(identityId, { firstName: 'Ana' });
    await database.appIdentity.update({ where: { id: identityId }, data: { status: 'PENDING_PHONE_VERIFICATION' } });
    await expect(service.get(identityId)).rejects.toMatchObject({ status: 401 });
    await expect(service.save(identityId, { lastName: 'Pérez' })).rejects.toMatchObject({ status: 401 });
    expect(database.clientAccountCount()).toBe(1);
  });

  it('reintenta un conflicto de serialización y conserva una sola cuenta', async () => {
    const originalTransaction = database.$transaction.bind(database);
    const conflict = new Prisma.PrismaClientKnownRequestError('Conflicto transaccional', {
      code: 'P2034', clientVersion: '6.12.0',
    });
    const transaction = vi.spyOn(database, '$transaction')
      .mockRejectedValueOnce(conflict)
      .mockImplementation(originalTransaction);
    try {
      const profile = await service.save(identityId, { firstName: 'Ana' });
      expect(profile.firstName).toBe('Ana');
      expect(database.clientAccountCount()).toBe(1);
    } finally {
      transaction.mockRestore();
    }
  });
});

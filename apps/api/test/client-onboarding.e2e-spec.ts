import { HttpStatus } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import request from 'supertest';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { RoleOnboardingFixture, clientPhone, registrationPhone } from './support/role-onboarding.fixture.js';

const path = '/api/v1/onboarding/client';
const fixtureEmail = 'perfil@servipronto.test';
const fixturePassword = 'Admin-contract-2026!';
const address = { street: 'Belgrano', number: '456', city: 'Tandil' };

describe('Perfil Cliente progresivo', () => {
  const fixture = new RoleOnboardingFixture();
  const api = () => request(fixture.app.getHttpServer());

  const appSession = async (email = fixtureEmail, password = fixturePassword) => {
    const login = await api().post('/api/v1/app-auth/login').send({ email, password });
    expect(login.status).toBe(HttpStatus.OK);
    const delivery = fixture.deliveries.at(-1);
    expect(delivery?.purpose).toBe('SESSION');
    const verified = await api().post('/api/v1/app-auth/verify-login')
      .send({ challengeId: login.body.challengeId, code: delivery!.code });
    expect(verified.status).toBe(HttpStatus.OK);
    return verified.body.accessToken as string;
  };

  const expectPrivateProfile = (body: Record<string, unknown>, phone = clientPhone) => {
    expect(body.phone).toBe(phone);
    const { phone: _phone, ...withoutPhone } = body;
    const publicPart = JSON.stringify(withoutPhone);
    expect(publicPart).not.toContain(phone);
    expect(publicPart).not.toContain(registrationPhone);
    for (const secret of [
      fixturePassword,
      ...fixture.deliveries.map((delivery) => delivery.code),
      ...fixture.database.storedSecretHashes(),
    ]) expect(JSON.stringify(body)).not.toContain(secret);
    expect(body).not.toHaveProperty('accessToken');
    expect(body).not.toHaveProperty('passwordHash');
    expect(body).not.toHaveProperty('codeHash');
  };

  beforeAll(() => fixture.start());
  beforeEach(() => fixture.reset());
  afterAll(() => fixture.stop());

  it('guarda cada paso explícito y permite retomar el único borrador incompleto', async () => {
    const token = await appSession();
    const first = await api().put(path).set('Authorization', `Bearer ${token}`).send({ firstName: 'Ana' });
    expect(first.status).toBe(HttpStatus.OK);
    expect(first.body).toEqual({
      id: expect.any(String), firstName: 'Ana', lastName: null,
      birthDate: null, address: null, email: fixtureEmail, phone: clientPhone, isComplete: false,
    });
    const resumed = await api().get(path).set('Authorization', `Bearer ${token}`);
    expect(resumed.status).toBe(HttpStatus.OK);
    expect(resumed.body).toEqual(first.body);
    const second = await api().put(path).set('Authorization', `Bearer ${token}`).send({ lastName: 'Pérez' });
    expect(second.status).toBe(HttpStatus.OK);
    expect(second.body).toEqual({ ...first.body, lastName: 'Pérez' });
    expect(fixture.database.clientAccountCount()).toBe(1);
  });

  it('muestra los datos completos para revisión y marca completitud al guardar el último dato', async () => {
    const token = await appSession();
    const first = await api().put(path).set('Authorization', `Bearer ${token}`)
      .send({ firstName: 'Ana', lastName: 'Pérez', birthDate: '1988-05-14' });
    expect(first.status).toBe(HttpStatus.OK);
    expect(first.body.isComplete).toBe(false);
    const completed = await api().put(path).set('Authorization', `Bearer ${token}`).send({ address });
    expect(completed.status).toBe(HttpStatus.OK);
    expect(completed.body).toEqual({
      id: first.body.id, firstName: 'Ana', lastName: 'Pérez',
      birthDate: '1988-05-14', address, email: fixtureEmail, phone: clientPhone, isComplete: true,
    });
    const review = await api().get(path).set('Authorization', `Bearer ${token}`);
    expect(review.status).toBe(HttpStatus.OK);
    expect(review.body).toEqual(completed.body);
    expectPrivateProfile(review.body);
  });

  it('actualiza el mismo perfil sin duplicarlo y conserva los campos no enviados', async () => {
    const token = await appSession();
    const first = await api().put(path).set('Authorization', `Bearer ${token}`)
      .send({ firstName: 'Ana', lastName: 'Pérez', birthDate: '1988-05-14', address });
    expect(first.status).toBe(HttpStatus.OK);
    const corrected = await api().put(path).set('Authorization', `Bearer ${token}`)
      .send({ lastName: 'García', address: { ...address, number: '458' } });
    expect(corrected.status).toBe(HttpStatus.OK);
    expect(corrected.body).toEqual({ ...first.body, lastName: 'García', address: { ...address, number: '458' } });
    const repeated = await api().put(path).set('Authorization', `Bearer ${token}`)
      .send({ lastName: 'García', address: { ...address, number: '458' } });
    expect(repeated.status).toBe(HttpStatus.OK);
    expect(repeated.body).toEqual(corrected.body);
    expect(fixture.database.clientAccountCount()).toBe(1);
  });

  it.each([
    { replacement: { phone: '+5492494999999' }, field: 'teléfono' },
    { replacement: { email: 'reemplazo@servipronto.test' }, field: 'correo' },
  ])('impide cambiar el $field verificado desde el perfil', async ({ replacement }) => {
    const token = await appSession();
    const first = await api().put(path).set('Authorization', `Bearer ${token}`).send({ firstName: 'Ana' });
    expect(first.status).toBe(HttpStatus.OK);
    const rejected = await api().put(path).set('Authorization', `Bearer ${token}`).send(replacement);
    expect(rejected.status).toBe(HttpStatus.BAD_REQUEST);
    expect(JSON.stringify(rejected.body)).not.toContain(Object.values(replacement)[0]);
    const current = await api().get(path).set('Authorization', `Bearer ${token}`);
    expect(current.body).toEqual(first.body);
    expect(fixture.database.clientAccountCount()).toBe(1);
  });

  it('exige sesión APP para leer y guardar, sin revelar teléfono en los errores', async () => {
    for (const response of [
      await api().get(path),
      await api().put(path).send({ firstName: 'Ana' }),
    ]) {
      expect(response.status).toBe(HttpStatus.UNAUTHORIZED);
      expect(JSON.stringify(response.body)).not.toContain(clientPhone);
      expect(response.body).not.toHaveProperty('accessToken');
    }
    expect(fixture.database.clientAccountCount()).toBe(0);
  });

  it('rechaza un token administrativo en lectura y guardado', async () => {
    const login = await api().post('/api/v1/auth/login')
      .send({ email: 'admin@servipronto.test', password: fixturePassword });
    expect(login.status).toBe(HttpStatus.OK);
    for (const response of [
      await api().get(path).set('Authorization', `Bearer ${login.body.accessToken}`),
      await api().put(path).set('Authorization', `Bearer ${login.body.accessToken}`).send({ firstName: 'Ana' }),
    ]) {
      expect(response.status).toBe(HttpStatus.UNAUTHORIZED);
      expect(JSON.stringify(response.body)).not.toContain(clientPhone);
    }
    expect(fixture.database.clientAccountCount()).toBe(0);
  });

  it('limita el perfil al titular de la sesión autenticada', async () => {
    const firstToken = await appSession();
    const first = await api().put(path).set('Authorization', `Bearer ${firstToken}`).send({ firstName: 'Ana' });
    expect(first.status).toBe(HttpStatus.OK);
    const registration = await api().post('/api/v1/app-auth/register').send({
      email: 'otra@servipronto.test', password: 'Otra-clave-contract-2026!', phone: registrationPhone,
    });
    expect(registration.status).toBe(HttpStatus.CREATED);
    const verified = await api().post('/api/v1/app-auth/verify-registration')
      .send({ challengeId: registration.body.challengeId, code: fixture.deliveries.at(-1)!.code });
    expect(verified.status).toBe(HttpStatus.OK);
    const secondToken = verified.body.accessToken as string;
    const absent = await api().get(path).set('Authorization', `Bearer ${secondToken}`);
    expect(absent.status).toBe(HttpStatus.OK);
    expect(absent.body).toEqual({
      id: null, firstName: null, lastName: null, birthDate: null, address: null,
      email: 'otra@servipronto.test', phone: registrationPhone, isComplete: false,
    });
    expect(fixture.database.clientAccountCount()).toBe(1);
    expect(JSON.stringify(absent.body)).not.toContain(clientPhone);
    const second = await api().put(path).set('Authorization', `Bearer ${secondToken}`).send({ firstName: 'Lucía' });
    expect(second.status).toBe(HttpStatus.OK);
    expect(second.body.id).not.toBe(first.body.id);
    expectPrivateProfile(second.body, registrationPhone);
    expect(fixture.database.clientAccountCount()).toBe(2);
  });

  it('convive con una cuenta Proveedor preexistente sin alterar ninguno de sus datos', async () => {
    fixture.database.seedExistingProvider();
    const existing = fixture.database.existingProviderSnapshot();
    const token = await appSession();
    const client = await api().put(path).set('Authorization', `Bearer ${token}`).send({ firstName: 'Ana' });
    expect(client.status).toBe(HttpStatus.OK);
    expect(client.body.id).not.toBe(existing?.id);
    expect(client.body).not.toHaveProperty('providerStatus');
    expect(fixture.database.existingProviderSnapshot()).toEqual(existing);
    expect(fixture.database.clientAccountCount()).toBe(1);
  });

  it.each([{}, { firstName: '   ' }, { lastName: '\t' }, { address: { ...address, city: '   ' } }])
  ('rechaza un borrador vacío o texto en blanco sin crear cuenta: %j', async (draft) => {
    const token = await appSession();
    const response = await api().put(path).set('Authorization', `Bearer ${token}`).send(draft);
    expect(response.status).toBe(HttpStatus.BAD_REQUEST);
    expect(fixture.database.clientAccountCount()).toBe(0);
  });

  it.each([{ identityId: 'otra-identidad' }, { isComplete: true }])
  ('rechaza campos reservados de la identidad y la completitud: %j', async (draft) => {
    const token = await appSession();
    const response = await api().put(path).set('Authorization', `Bearer ${token}`)
      .send({ firstName: 'Ana', ...draft });
    expect(response.status).toBe(HttpStatus.BAD_REQUEST);
    expect(fixture.database.clientAccountCount()).toBe(0);
  });

  it('publica los dos métodos y el esquema editable en Swagger runtime', () => {
    const document = SwaggerModule.createDocument(fixture.app,
      new DocumentBuilder().addBearerAuth({ type: 'http', scheme: 'bearer' }, 'AppBearer').build());
    const route = document.paths?.[path];
    expect(route?.get?.responses).toHaveProperty('200');
    expect(route?.put?.responses).toHaveProperty('200');
    expect(route?.put?.responses).toHaveProperty('400');
    expect(route?.get?.security).toEqual([{ AppBearer: [] }]);
    expect(route?.put?.security).toEqual([{ AppBearer: [] }]);
    expect(document.components?.schemas?.ClientDraftDto).toMatchObject({
      properties: { firstName: expect.any(Object), lastName: expect.any(Object),
        birthDate: expect.any(Object), address: expect.any(Object) },
    });
    expect(document.components?.schemas?.ClientDraftDto).not.toHaveProperty('properties.email');
    expect(document.components?.schemas?.ClientDraftDto).not.toHaveProperty('properties.phone');
  });
});

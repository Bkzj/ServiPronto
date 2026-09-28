import { HttpStatus } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import request from 'supertest';
import { beforeAll, afterAll, beforeEach, describe, expect, it } from 'vitest';
import { RoleOnboardingFixture, clientPhone, registrationPhone, providerId, secret } from './support/role-onboarding.fixture.js';

describe('Contrato HTTP de alta y revisión inicial', () => {
  const fixture = new RoleOnboardingFixture();

  const api = () => request(fixture.app.getHttpServer());
  const sessionToken = (email = 'perfil@servipronto.test') =>
    new JwtService({ secret }).sign({ sub: 'identity-fixture', email, role: 'APP' });
  const expectErrorResponse = (response: { status: number; body: Record<string, unknown> }, status: number) => {
    expect(response.status).toBe(status);
    expect(Object.keys(response.body).sort()).toEqual(['error', 'message', 'statusCode']);
    expect(response.body.statusCode).toBe(status);
    expect(response.body.error).toEqual(expect.any(String));
    expect((response.body.error as string).length).toBeGreaterThan(0);
    const message = response.body.message;
    if (typeof message === 'string') expect(message.length).toBeGreaterThan(0);
    else {
      expect(Array.isArray(message)).toBe(true);
      expect(message).toEqual(expect.arrayContaining([expect.any(String)]));
    }
    expect(response.body).not.toHaveProperty('accessToken');
  };

  const clientDraft = {
    firstName: 'Ana', lastName: 'Pérez', phone: clientPhone,
    email: 'perfil@servipronto.test', birthDate: '1988-05-14',
    address: { street: 'Belgrano', number: '456', city: 'Tandil' },
  };
  const providerDraft = {
    firstName: 'Ana', lastName: 'Pérez', phone: clientPhone,
    email: 'perfil@servipronto.test', categoryId: 'plomeria',
    tasks: ['Reparación de pérdidas'], modality: 'AT_HOME',
    coverage: { city: 'Tandil' }, availability: 'PROGRAMMED',
    experience: 'Cinco años de trabajos domiciliarios',
    indicativePrice: 18000,
  };

  beforeAll(() => fixture.start());
  beforeEach(() => fixture.reset());
  afterAll(() => fixture.stop());

  it('inicia registro sin exponer código, contraseña ni sesión antes de verificar', async () => {
    const response = await api().post('/api/v1/app-auth/register').send({
      email: 'cliente@servipronto.test', password: 'Clave-contract-2026!', phone: registrationPhone,
    });
    expect(response.status).toBe(HttpStatus.CREATED);
    expect(response.body).toEqual(expect.objectContaining({ challengeId: expect.any(String), expiresAt: expect.any(String) }));
    expect(JSON.stringify(response.body)).not.toMatch(/"(?:code|verificationCode|otp|passwordHash|accessToken)"\s*:/i);
    expect(fixture.deliveries).toEqual([expect.objectContaining({ phone: registrationPhone, purpose: 'REGISTRATION' })]);
  });

  it('confirma registro con el código entregado solo al adaptador y recién entonces crea sesión', async () => {
    const registration = await api().post('/api/v1/app-auth/register').send({
      email: 'cliente@servipronto.test', password: 'Clave-contract-2026!', phone: registrationPhone,
    });
    expect(registration.status).toBe(HttpStatus.CREATED);
    expect(fixture.deliveries).toHaveLength(1);
    const verified = await api().post('/api/v1/app-auth/verify-registration').send({
      challengeId: registration.body.challengeId, code: fixture.deliveries[0].code,
    });
    expect(verified.status).toBe(HttpStatus.OK);
    expect(verified.body).toEqual(expect.objectContaining({
      accessToken: expect.any(String),
      profile: expect.objectContaining({ email: 'cliente@servipronto.test', phone: registrationPhone }),
    }));
    expect(JSON.stringify(verified.body)).not.toMatch(/"(?:code|passwordHash)"\s*:/i);
  });

  it('rechaza un código de registro incorrecto sin entregar sesión', async () => {
    const registration = await api().post('/api/v1/app-auth/register').send({
      email: 'cliente@servipronto.test', password: 'Clave-contract-2026!', phone: registrationPhone,
    });
    expect(registration.status).toBe(HttpStatus.CREATED);
    const wrongCode = fixture.deliveries[0].code === '000000' ? '999999' : '000000';
    const response = await api().post('/api/v1/app-auth/verify-registration').send({
      challengeId: registration.body.challengeId, code: wrongCode,
    });
    expectErrorResponse(response, HttpStatus.UNAUTHORIZED);
  });

  it('rechaza registrar otra identidad con un teléfono ya asociado', async () => {
    const first = await api().post('/api/v1/app-auth/register').send({
      email: 'primera@servipronto.test', password: 'Clave-contract-2026!', phone: registrationPhone,
    });
    expect(first.status).toBe(HttpStatus.CREATED);
    expect(fixture.deliveries).toHaveLength(1);
    const second = await api().post('/api/v1/app-auth/register').send({
      email: 'segunda@servipronto.test', password: 'Clave-contract-2026!', phone: registrationPhone,
    });
    expectErrorResponse(second, HttpStatus.CONFLICT);
    expect(fixture.deliveries).toHaveLength(1);
  });

  it('inicia login sin sesión y la entrega al verificar un desafío nuevo', async () => {
    const registration = await api().post('/api/v1/app-auth/register').send({
      email: 'cliente@servipronto.test', password: 'Clave-contract-2026!', phone: registrationPhone,
    });
    expect(registration.status).toBe(HttpStatus.CREATED);
    await api().post('/api/v1/app-auth/verify-registration').send({ challengeId: registration.body.challengeId, code: fixture.deliveries[0].code });
    const login = await api().post('/api/v1/app-auth/login').send({ email: 'cliente@servipronto.test', password: 'Clave-contract-2026!' });
    expect(login.status).toBe(HttpStatus.OK);
    expect(login.body).toEqual(expect.objectContaining({ challengeId: expect.any(String) }));
    expect(login.body).not.toHaveProperty('accessToken');
    expect(fixture.deliveries[1]).toEqual(expect.objectContaining({ phone: registrationPhone, purpose: 'SESSION' }));
    const verified = await api().post('/api/v1/app-auth/verify-login').send({ challengeId: login.body.challengeId, code: fixture.deliveries[1].code });
    expect(verified.status).toBe(HttpStatus.OK);
    expect(verified.body.accessToken).toEqual(expect.any(String));
  });

  it('guarda el perfil Cliente como cuenta de negocio separada', async () => {
    const response = await api().put('/api/v1/onboarding/client')
      .set('Authorization', `Bearer ${sessionToken()}`).send(clientDraft);
    expect(response.status).toBe(HttpStatus.OK);
    expect(response.body).toEqual(expect.objectContaining({ id: expect.any(String), phone: clientPhone }));
    expect(response.body).not.toHaveProperty('providerStatus');
  });

  it.each([
    ['client', clientDraft],
    ['provider', providerDraft],
  ] as const)('actualiza la misma cuenta %s sin duplicarla por teléfono y rol', async (role, draft) => {
    const token = sessionToken();
    const first = await api().put(`/api/v1/onboarding/${role}`).set('Authorization', `Bearer ${token}`).send(draft);
    expect(first.status).toBe(HttpStatus.OK);
    const second = await api().put(`/api/v1/onboarding/${role}`).set('Authorization', `Bearer ${token}`).send(draft);
    expect(second.status).toBe(HttpStatus.OK);
    expect(second.body).toEqual(expect.objectContaining({ id: first.body.id, phone: clientPhone }));
  });

  it('permite perfil Proveedor con el mismo teléfono, en estado no público', async () => {
    const token = sessionToken();
    const client = await api().put('/api/v1/onboarding/client').set('Authorization', `Bearer ${token}`).send(clientDraft);
    expect(client.status).toBe(HttpStatus.OK);
    const provider = await api().put('/api/v1/onboarding/provider').set('Authorization', `Bearer ${token}`).send(providerDraft);
    expect(provider.status).toBe(HttpStatus.OK);
    expect(provider.body).toEqual(expect.objectContaining({ phone: clientPhone, status: 'INCOMPLETE' }));
    expect(provider.body.id).not.toBe(client.body.id);
  });

  it('envía un proveedor completo a revisión', async () => {
    const token = sessionToken();
    const draft = await api().put('/api/v1/onboarding/provider').set('Authorization', `Bearer ${token}`).send(providerDraft);
    expect(draft.status).toBe(HttpStatus.OK);
    const submitted = await api().post('/api/v1/onboarding/provider/submit').set('Authorization', `Bearer ${token}`).send({});
    expect(submitted.status).toBe(HttpStatus.OK);
    expect(submitted.body).toEqual(expect.objectContaining({ status: 'IN_REVIEW', submittedAt: expect.any(String) }));
    expect(submitted.body.id).toBe(draft.body.id);
  });

  it.each([
    ['put', '/api/v1/onboarding/client', clientDraft],
    ['put', '/api/v1/onboarding/provider', providerDraft],
    ['post', '/api/v1/onboarding/provider/submit', {}],
  ] as const)('requiere sesión de aplicación en %s %s', async (method, path, body) => {
    const response = await api()[method](path).send(body);
    expectErrorResponse(response, HttpStatus.UNAUTHORIZED);
  });

  it('permite al administrador ver la cola de presentaciones', async () => {
    const adminLogin = await api().post('/api/v1/auth/login').send({ email: 'admin@servipronto.test', password: 'Admin-contract-2026!' });
    expect(adminLogin.status).toBe(HttpStatus.OK);
    const response = await api().get('/api/v1/admin/provider-reviews').set('Authorization', `Bearer ${adminLogin.body.accessToken}`);
    expect(response.status).toBe(HttpStatus.OK);
    expect(response.body).toEqual(expect.objectContaining({ providers: expect.any(Array) }));
  });

  it('permite aprobar una presentación enviada y devuelve el estado resultante', async () => {
    const token = sessionToken();
    const draft = await api().put('/api/v1/onboarding/provider').set('Authorization', `Bearer ${token}`).send(providerDraft);
    expect(draft.status).toBe(HttpStatus.OK);
    const submitted = await api().post('/api/v1/onboarding/provider/submit').set('Authorization', `Bearer ${token}`).send({});
    expect(submitted.status).toBe(HttpStatus.OK);
    const adminLogin = await api().post('/api/v1/auth/login').send({ email: 'admin@servipronto.test', password: 'Admin-contract-2026!' });
    expect(adminLogin.status).toBe(HttpStatus.OK);
    const decision = await api().post(`/api/v1/admin/provider-reviews/${draft.body.id}/decision`)
      .set('Authorization', `Bearer ${adminLogin.body.accessToken}`)
      .send({ decision: 'APPROVED' });
    expect(decision.status).toBe(HttpStatus.OK);
    expect(decision.body).toEqual(expect.objectContaining({ providerId: draft.body.id, status: 'APPROVED' }));
  });

  it('impide leer la cola con una sesión de aplicación', async () => {
    const appToken = sessionToken();
    const queue = await api().get('/api/v1/admin/provider-reviews').set('Authorization', `Bearer ${appToken}`);
    expectErrorResponse(queue, HttpStatus.UNAUTHORIZED);
  });

  it('impide resolver una revisión con una sesión de aplicación', async () => {
    const appToken = sessionToken();
    const decision = await api().post(`/api/v1/admin/provider-reviews/${providerId}/decision`)
      .set('Authorization', `Bearer ${appToken}`).send({ decision: 'APPROVED' });
    expectErrorResponse(decision, HttpStatus.UNAUTHORIZED);
  });

  it.each([
    ['/api/v1/app-auth/login', { email: 'unknown@servipronto.test', password: 'Clave-contract-2026!' }],
  ] as const)('rechaza credenciales o desafíos inválidos en %s', async (path, body) => {
    const response = await api().post(path).send(body);
    expectErrorResponse(response, HttpStatus.UNAUTHORIZED);
  });

  it.each(['/api/v1/app-auth/verify-registration', '/api/v1/app-auth/verify-login'])('rechaza un ID de desafío mal formado en %s', async (path) => {
    const response = await api().post(path).send({ challengeId: 'missing', code: '123456' });
    expectErrorResponse(response, HttpStatus.BAD_REQUEST);
  });

  it.each(['CHANGES_REQUIRED', 'REJECTED'] as const)('exige motivo para decisión %s', async (decision) => {
    const token = sessionToken();
    const draft = await api().put('/api/v1/onboarding/provider').set('Authorization', `Bearer ${token}`).send(providerDraft);
    expect(draft.status).toBe(HttpStatus.OK);
    const submitted = await api().post('/api/v1/onboarding/provider/submit').set('Authorization', `Bearer ${token}`).send({});
    expect(submitted.status).toBe(HttpStatus.OK);
    expect(submitted.body).toEqual(expect.objectContaining({ id: draft.body.id, status: 'IN_REVIEW' }));
    const adminLogin = await api().post('/api/v1/auth/login').send({ email: 'admin@servipronto.test', password: 'Admin-contract-2026!' });
    expect(adminLogin.status).toBe(HttpStatus.OK);
    const response = await api().post(`/api/v1/admin/provider-reviews/${draft.body.id}/decision`)
      .set('Authorization', `Bearer ${adminLogin.body.accessToken}`)
      .send({ decision, reason: '   ' });
    expectErrorResponse(response, HttpStatus.BAD_REQUEST);
  });
});

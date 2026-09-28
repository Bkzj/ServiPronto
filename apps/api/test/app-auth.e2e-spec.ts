import { HttpStatus } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import request from 'supertest';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { RoleOnboardingFixture, clientPhone, registrationPhone, secret } from './support/role-onboarding.fixture.js';

const email = 'cliente@servipronto.test';
const password = 'Clave-contract-2026!';
const fixturePassword = 'Admin-contract-2026!';
const invalidPassword = 'Contraseña-incorrecta-2026!';
const replacementPassword = 'Otra-clave-segura-2026!';
const registration = { email, password, phone: registrationPhone };

describe('Acceso telefónico de aplicación', () => {
  const fixture = new RoleOnboardingFixture();
  const attemptedCodes = new Set<string>();
  const api = () => request(fixture.app.getHttpServer());
  const wrongCode = (code: string) => code === '000000' ? '999999' : '000000';

  const expectNoSecret = (body: unknown, allowedProfilePhone?: string) => {
    const payload = body as Record<string, unknown>;
    const rawBody = JSON.stringify(payload);
    for (const value of [
      ...fixture.deliveries.map((delivery) => delivery.code),
      ...attemptedCodes,
      password, fixturePassword, invalidPassword, replacementPassword,
      ...fixture.database.storedSecretHashes(),
    ]) {
      expect(rawBody.includes(value)).toBe(false);
    }
    expect(rawBody).not.toMatch(/"(?:code|verificationCode|otp|password|passwordHash|codeHash)"\s*:/i);
    let bodyWithoutAllowedPhone = payload;
    if (allowedProfilePhone) {
      const { profile, ...outsideProfile } = payload;
      const { phone, ...profileWithoutPhone } = profile as Record<string, unknown>;
      expect(phone).toBe(allowedProfilePhone);
      bodyWithoutAllowedPhone = { ...outsideProfile, profile: profileWithoutPhone };
    }
    const publicBody = JSON.stringify(bodyWithoutAllowedPhone);
    expect(publicBody.includes(registrationPhone)).toBe(false);
    expect(publicBody.includes(clientPhone)).toBe(false);
  };
  const register = async () => {
    const response = await api().post('/api/v1/app-auth/register').send(registration);
    expectNoSecret(response.body);
    return response;
  };
  const verifyRegistration = async (challengeId: string, code: string) => {
    attemptedCodes.add(code);
    const response = await api().post('/api/v1/app-auth/verify-registration').send({ challengeId, code });
    expectNoSecret(response.body, response.status === HttpStatus.OK ? registrationPhone : undefined);
    return response;
  };
  const beginLogin = async (credentials: { email: string; password: string }) => {
    const response = await api().post('/api/v1/app-auth/login').send(credentials);
    expectNoSecret(response.body);
    return response;
  };
  const verifyLogin = async (challengeId: string, code: string) => {
    attemptedCodes.add(code);
    const response = await api().post('/api/v1/app-auth/verify-login').send({ challengeId, code });
    expectNoSecret(response.body, response.status === HttpStatus.OK ? clientPhone : undefined);
    return response;
  };
  const expectUnauthorized = (response: { status: number; body: unknown }) => {
    expect(response.status).toBe(HttpStatus.UNAUTHORIZED);
    expect(response.body).toEqual(expect.objectContaining({ statusCode: HttpStatus.UNAUTHORIZED }));
    expect(response.body).not.toHaveProperty('accessToken');
    expectNoSecret(response.body);
  };

  beforeAll(() => fixture.start());
  beforeEach(() => {
    fixture.reset();
    attemptedCodes.clear();
  });
  afterAll(() => fixture.stop());

  it('inicia un registro pendiente sin emitir sesión ni revelar datos sensibles', async () => {
    const response = await register();
    expect(response.status).toBe(HttpStatus.CREATED);
    expect(response.body).toEqual({ challengeId: expect.any(String), expiresAt: expect.any(String) });
    expect(response.body).not.toHaveProperty('accessToken');
    expectNoSecret(response.body);
    expect(fixture.deliveries).toEqual([expect.objectContaining({ phone: registrationPhone, purpose: 'REGISTRATION' })]);
    expect(fixture.database.identityCount()).toBe(2); // Incluye la identidad activa del fixture.
  });

  it('publica en OpenAPI solo los cuatro contratos de acceso y sus respuestas', () => {
    const document = SwaggerModule.createDocument(fixture.app, new DocumentBuilder().setTitle('Contrato').setVersion('1').build());
    const paths = Object.keys(document.paths).filter((path) => path.startsWith('/api/v1/app-auth/')).sort();
    expect(paths).toEqual([
      '/api/v1/app-auth/login', '/api/v1/app-auth/register',
      '/api/v1/app-auth/verify-login', '/api/v1/app-auth/verify-registration',
    ]);
    expect(document.paths['/api/v1/app-auth/register'].post?.responses?.['201'])
      .toEqual(expect.objectContaining({ content: { 'application/json': { schema: { $ref: '#/components/schemas/AppChallengeResponseDto' } } } }));
    expect(document.paths['/api/v1/app-auth/verify-login'].post?.responses?.['200'])
      .toEqual(expect.objectContaining({ content: { 'application/json': { schema: { $ref: '#/components/schemas/AppSessionResponseDto' } } } }));
    expect(document.components?.schemas?.AppLoginDto).toEqual(expect.objectContaining({
      properties: expect.objectContaining({ email: expect.objectContaining({ format: 'email' }) }),
    }));
    expect(document.components?.schemas?.AppRegistrationDto).toEqual(expect.objectContaining({
      properties: expect.objectContaining({
        email: expect.objectContaining({ format: 'email' }),
        phone: expect.objectContaining({ pattern: '^\\+[1-9]\\d{7,14}$' }),
      }),
    }));
    expect(document.paths['/api/v1/app-auth/register'].post?.responses?.['201'])
      .toEqual(expect.objectContaining({ description: expect.stringContaining('contraseña original') }));
  });

  it('verifica el teléfono y emite una sesión APP sin filtrar código ni hashes', async () => {
    const pending = await register();
    expect(pending.status).toBe(HttpStatus.CREATED);
    const response = await verifyRegistration(pending.body.challengeId, fixture.deliveries[0].code);
    expect(response.status).toBe(HttpStatus.OK);
    expect(response.body).toEqual({
      accessToken: expect.any(String),
      profile: expect.objectContaining({ id: expect.any(String), email, phone: registrationPhone }),
    });
    expect(new JwtService({ secret }).verify(response.body.accessToken)).toEqual(
      expect.objectContaining({ sub: response.body.profile.id, role: 'APP' }),
    );
    expectNoSecret(response.body, registrationPhone);
  });

  it('rechaza una contraseña inválida sin crear desafío ni revelar el teléfono', async () => {
    const response = await beginLogin({ email: 'perfil@servipronto.test', password: invalidPassword });
    expectUnauthorized(response);
    expect(fixture.deliveries).toHaveLength(0);
    expect(fixture.database.challengeCount()).toBe(0);
  });

  it('rechaza un código incorrecto y no emite sesión', async () => {
    const pending = await register();
    expect(pending.status).toBe(HttpStatus.CREATED);
    const response = await verifyRegistration(pending.body.challengeId, wrongCode(fixture.deliveries[0].code));
    expectUnauthorized(response);
  });

  it('no filtra secretos en el error de un código mal formado', async () => {
    const pending = await register();
    expect(pending.status).toBe(HttpStatus.CREATED);
    const response = await verifyRegistration(pending.body.challengeId, 'CODIGO_MALFORMADO_7Q4M');
    expect(response.status).toBe(HttpStatus.BAD_REQUEST);
    expect(response.body).toEqual(expect.objectContaining({ statusCode: HttpStatus.BAD_REQUEST }));
    expect(response.body).not.toHaveProperty('accessToken');
  });

  it('rechaza un desafío vencido aunque el código sea correcto', async () => {
    const pending = await register();
    expect(pending.status).toBe(HttpStatus.CREATED);
    fixture.database.expireChallenge(pending.body.challengeId);
    const response = await verifyRegistration(pending.body.challengeId, fixture.deliveries[0].code);
    expectUnauthorized(response);
  });

  it('bloquea el desafío tras cinco códigos incorrectos', async () => {
    const pending = await register();
    expect(pending.status).toBe(HttpStatus.CREATED);
    const code = fixture.deliveries[0].code;
    for (let attempt = 0; attempt < 5; attempt++) {
      expectUnauthorized(await verifyRegistration(pending.body.challengeId, wrongCode(code)));
    }
    expectUnauthorized(await verifyRegistration(pending.body.challengeId, code));
  });

  it('consume una sola vez el desafío de registro', async () => {
    const pending = await register();
    expect(pending.status).toBe(HttpStatus.CREATED);
    const code = fixture.deliveries[0].code;
    const first = await verifyRegistration(pending.body.challengeId, code);
    expect(first.status).toBe(HttpStatus.OK);
    expectUnauthorized(await verifyRegistration(pending.body.challengeId, code));
  });

  it('reenvía el código del registro pendiente sin crear otra identidad', async () => {
    const first = await register();
    expect(first.status).toBe(HttpStatus.CREATED);
    const identityCount = fixture.database.identityCount();
    const resent = await register();
    expect(resent.status).toBe(HttpStatus.CREATED);
    expect(resent.body.challengeId).not.toBe(first.body.challengeId);
    expectNoSecret(resent.body);
    expect(fixture.database.identityCount()).toBe(identityCount);
    expect(fixture.deliveries).toHaveLength(2);
    expect(fixture.deliveries[1]).toEqual(expect.objectContaining({ phone: registrationPhone, purpose: 'REGISTRATION' }));
    const verified = await verifyRegistration(resent.body.challengeId, fixture.deliveries[1].code);
    expect(verified.status).toBe(HttpStatus.OK);
  });

  it('reenvía a un registro pendiente sin sustituir su contraseña original', async () => {
    const first = await register();
    expect(first.status).toBe(HttpStatus.CREATED);
    const resent = await api().post('/api/v1/app-auth/register').send({ ...registration, password: replacementPassword });
    expect(resent.status).toBe(HttpStatus.CREATED);
    expectNoSecret(resent.body);
    const verified = await verifyRegistration(resent.body.challengeId, fixture.deliveries[1].code);
    expect(verified.status).toBe(HttpStatus.OK);

    const originalLogin = await beginLogin({ email, password });
    expect(originalLogin.status).toBe(HttpStatus.OK);
    const replacementLogin = await beginLogin({ email, password: replacementPassword });
    expectUnauthorized(replacementLogin);
  });

  it('rechaza otro correo con el mismo teléfono sin filtrar secretos en el conflicto', async () => {
    const first = await register();
    expect(first.status).toBe(HttpStatus.CREATED);
    const conflict = await api().post('/api/v1/app-auth/register').send({
      ...registration, email: 'otra@servipronto.test',
    });
    expectNoSecret(conflict.body);
    expect(conflict.status).toBe(HttpStatus.CONFLICT);
    expect(conflict.body).toEqual(expect.objectContaining({ statusCode: HttpStatus.CONFLICT }));
    expect(conflict.body).not.toHaveProperty('accessToken');
  });

  it('rechaza una cuenta activa con un conflicto genérico', async () => {
    const response = await api().post('/api/v1/app-auth/register').send({
      email: 'perfil@servipronto.test', password, phone: clientPhone,
    });
    expect(response.status).toBe(HttpStatus.CONFLICT);
    expect(response.body.message).toBe('No se puede iniciar el registro');
    expectNoSecret(response.body);
  });

  it.each([
    [{ ...registration, email: 'correo-invalido' }, 'correo inválido'],
    [{ ...registration, password: 'corta' }, 'contraseña corta'],
    [{ ...registration, phone: '2494000002' }, 'teléfono no E.164'],
  ])('rechaza %s antes de persistir el registro (%s)', async (body) => {
    const response = await api().post('/api/v1/app-auth/register').send(body);
    expect(response.status).toBe(HttpStatus.BAD_REQUEST);
    expect(fixture.database.identityCount()).toBe(1);
    expect(fixture.deliveries).toHaveLength(0);
  });

  it('solicita un código nuevo para login y entrega sesión solo tras verificarlo', async () => {
    const login = await beginLogin({ email: 'perfil@servipronto.test', password: fixturePassword });
    expect(login.status).toBe(HttpStatus.OK);
    expect(login.body).toEqual({ challengeId: expect.any(String), expiresAt: expect.any(String) });
    expect(login.body).not.toHaveProperty('accessToken');
    expectNoSecret(login.body);
    expect(fixture.deliveries).toEqual([expect.objectContaining({ purpose: 'SESSION' })]);
    const verified = await verifyLogin(login.body.challengeId, fixture.deliveries[0].code);
    expect(verified.status).toBe(HttpStatus.OK);
    expect(verified.body.accessToken).toEqual(expect.any(String));
    expectNoSecret(verified.body, clientPhone);
  });

  it('solo una de dos verificaciones concurrentes del mismo desafío emite sesión', async () => {
    const login = await beginLogin({ email: 'perfil@servipronto.test', password: fixturePassword });
    expect(login.status).toBe(HttpStatus.OK);
    const code = fixture.deliveries[0].code;
    const responses = await Promise.all([
      verifyLogin(login.body.challengeId, code),
      verifyLogin(login.body.challengeId, code),
    ]);
    expect(responses.map((response) => response.status).sort((a, b) => a - b))
      .toEqual([HttpStatus.OK, HttpStatus.UNAUTHORIZED]);
    const accepted = responses.find((response) => response.status === HttpStatus.OK);
    expect(accepted?.body.accessToken).toEqual(expect.any(String));
    expectUnauthorized(responses.find((response) => response.status === HttpStatus.UNAUTHORIZED)!);
  });
});

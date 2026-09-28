import { describe, expect, it } from 'vitest';
import { validateEnvironment } from './environment.js';

const validInput = {
  DATABASE_URL: 'postgresql://localhost:5432/servipronto',
  JWT_SECRET: 'a-local-secret-with-at-least-32-characters',
  SEED_ADMIN_EMAIL: 'admin@example.com',
  SEED_ADMIN_PASSWORD: 'local-password',
};

describe('validateEnvironment', () => {
  it('deja deshabilitado el adaptador local por defecto', () => {
    expect(validateEnvironment({ ...validInput, NODE_ENV: 'development' }).PHONE_VERIFICATION_LOCAL_ENABLED).toBe(false);
  });

  it.each(['development', 'test'])('permite habilitar el adaptador local en %s', (nodeEnv) => {
    expect(validateEnvironment({ ...validInput, NODE_ENV: nodeEnv, PHONE_VERIFICATION_LOCAL_ENABLED: 'true' }).PHONE_VERIFICATION_LOCAL_ENABLED).toBe(true);
  });

  it('rechaza la habilitación del adaptador local en producción', () => {
    expect(() => validateEnvironment({ ...validInput, NODE_ENV: 'production', PHONE_VERIFICATION_LOCAL_ENABLED: 'true' })).toThrow();
  });
});

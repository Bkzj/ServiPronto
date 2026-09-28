import { z } from 'zod';

const environmentSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  PORT: z.coerce.number().int().positive().default(3000),
  DATABASE_URL: z.string().startsWith('postgresql://'),
  CORS_ORIGINS: z.string().default('http://localhost:5173'),
  LOG_LEVEL: z.enum(['fatal', 'error', 'warn', 'info', 'debug', 'trace']).default('info'),
  JWT_SECRET: z.string().min(32),
  SEED_ADMIN_EMAIL: z.string().email(),
  SEED_ADMIN_PASSWORD: z.string().min(8),
  PHONE_VERIFICATION_LOCAL_ENABLED: z.enum(['true', 'false']).default('false').transform((value) => value === 'true'),
}).refine(
  ({ NODE_ENV, PHONE_VERIFICATION_LOCAL_ENABLED }) => NODE_ENV !== 'production' || !PHONE_VERIFICATION_LOCAL_ENABLED,
  { path: ['PHONE_VERIFICATION_LOCAL_ENABLED'], message: 'El adaptador local no puede habilitarse en producción' },
);

export type Environment = z.infer<typeof environmentSchema>;

export function validateEnvironment(input: Record<string, unknown>): Environment {
  return environmentSchema.parse(input);
}

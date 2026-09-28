import { ServiceUnavailableException } from '@nestjs/common';
import { describe, expect, it, vi } from 'vitest';
import { PrismaService } from '../database/prisma.service.js';
import { HealthController } from './health.controller.js';

function controllerWithQuery(query: () => Promise<unknown>): HealthController {
  return new HealthController({ $queryRaw: query } as unknown as PrismaService);
}

describe('HealthController', () => {
  it('reports that the API process is alive', () => {
    expect(controllerWithQuery(vi.fn()).live()).toMatchObject({ status: 'ok', service: 'api' });
  });

  it('reports readiness only after PostgreSQL answers', async () => {
    const controller = controllerWithQuery(vi.fn().mockResolvedValue([{ value: 1 }]));
    await expect(controller.ready()).resolves.toMatchObject({ status: 'ok', service: 'database' });
  });

  it('fails honestly when PostgreSQL is unavailable', async () => {
    const controller = controllerWithQuery(vi.fn().mockRejectedValue(new Error('offline')));
    await expect(controller.ready()).rejects.toBeInstanceOf(ServiceUnavailableException);
  });
});

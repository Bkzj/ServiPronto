import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { PrismaClient } from '@prisma/client';
import { describe, expect, it } from 'vitest';

const expectedCategories = [
  ['aire-acondicionado', 'Aire acondicionado'],
  ['camaras-y-seguridad', 'Cámaras y seguridad'],
  ['clases-particulares', 'Clases particulares'],
  ['electricidad', 'Electricidad'],
  ['gas-y-calefaccion', 'Gas y calefacción'],
  ['jardineria', 'Jardinería'],
  ['limpieza', 'Limpieza'],
  ['mecanica-a-domicilio', 'Mecánica a domicilio'],
  ['mudanzas-y-fletes', 'Mudanzas y fletes'],
  ['plomeria', 'Plomería'],
  ['reparacion-tecnica-a-domicilio', 'Reparación técnica a domicilio'],
] as const;

const prismaDirectory = fileURLToPath(new URL('.', import.meta.url));
const runSeed = () => execFileSync(process.execPath, ['--import', 'tsx', 'seed.ts'], {
  cwd: prismaDirectory,
  env: process.env,
  stdio: 'pipe',
});

describe('semilla de categorías de Tandil', () => {
  it('crea las once categorías una sola vez y conserva una categoría deshabilitada', async () => {
    const prisma = new PrismaClient();
    const previousPlumbing = await prisma.serviceCategory.findUnique({ where: { slug: 'plomeria' } });

    try {
      runSeed();
      const first = await prisma.serviceCategory.findMany({
        where: { slug: { in: expectedCategories.map(([slug]) => slug) } },
        orderBy: { slug: 'asc' },
      });
      expect(first.map(({ slug, name }) => [slug, name])).toEqual(expectedCategories);

      await prisma.serviceCategory.update({ where: { slug: 'plomeria' }, data: { enabled: false } });
      runSeed();

      const second = await prisma.serviceCategory.findMany({
        where: { slug: { in: expectedCategories.map(([slug]) => slug) } },
        orderBy: { slug: 'asc' },
      });
      expect(second).toHaveLength(11);
      expect(second.map(({ id }) => id)).toEqual(first.map(({ id }) => id));
      expect(second.find(({ slug }) => slug === 'plomeria')?.enabled).toBe(false);
    } finally {
      if (previousPlumbing) {
        await prisma.serviceCategory.update({
          where: { slug: 'plomeria' },
          data: { enabled: previousPlumbing.enabled },
        });
      }
      await prisma.$disconnect();
    }
  });
});

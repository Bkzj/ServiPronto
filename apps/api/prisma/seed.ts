import { hash } from 'bcryptjs';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const initialCategories = [
  { slug: 'plomeria', name: 'Plomería' },
  { slug: 'electricidad', name: 'Electricidad' },
  { slug: 'gas-y-calefaccion', name: 'Gas y calefacción' },
  { slug: 'limpieza', name: 'Limpieza' },
  { slug: 'jardineria', name: 'Jardinería' },
  { slug: 'mudanzas-y-fletes', name: 'Mudanzas y fletes' },
  { slug: 'clases-particulares', name: 'Clases particulares' },
  { slug: 'reparacion-tecnica-a-domicilio', name: 'Reparación técnica a domicilio' },
  { slug: 'aire-acondicionado', name: 'Aire acondicionado' },
  { slug: 'camaras-y-seguridad', name: 'Cámaras y seguridad' },
  { slug: 'mecanica-a-domicilio', name: 'Mecánica a domicilio' },
] as const;

async function seed(): Promise<void> {
  const email = process.env.SEED_ADMIN_EMAIL?.trim().toLowerCase();
  const password = process.env.SEED_ADMIN_PASSWORD;
  if (!email || !password) throw new Error('Faltan SEED_ADMIN_EMAIL o SEED_ADMIN_PASSWORD.');

  const passwordHash = await hash(password, 12);
  await prisma.adminAccount.upsert({
    where: { email },
    update: { passwordHash, status: 'ACTIVE' },
    create: { email, passwordHash, displayName: 'Agustina Rispe López', status: 'ACTIVE' },
  });
  console.info(`Cuenta administradora local preparada: ${email}`);

  for (const category of initialCategories) {
    await prisma.serviceCategory.upsert({
      where: { slug: category.slug },
      update: {},
      create: { ...category, enabled: false },
    });
  }
  console.info(`Categorías iniciales de Tandil preparadas: ${initialCategories.length}`);
}

seed()
  .finally(async () => prisma.$disconnect())
  .catch((error: unknown) => {
    console.error(error instanceof Error ? error.message : 'No se pudo preparar la cuenta administradora.');
    process.exitCode = 1;
  });

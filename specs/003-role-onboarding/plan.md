# Implementation Plan: Alta progresiva y revisión inicial

**Branch**: `003-role-onboarding` | **Date**: 2026-09-15 | **Spec**: [spec.md](spec.md)

## Summary

Implementar el acceso C de la beta —correo, contraseña y código temporal de teléfono— junto con el alta progresiva de Cliente y Proveedor, la presentación inicial de una categoría y la revisión manual desde el panel. La identidad de acceso será común; las cuentas de negocio permanecerán separadas por rol y teléfono. La mensajería del código se expone mediante un contrato propio y usa un adaptador local solo en desarrollo.

## Technical Context

**Language/Version**: TypeScript 5.9 (Node.js 24) y Dart 3.10 / Flutter 3.38.

**Primary Dependencies**: NestJS 11, Prisma 7, PostgreSQL 18, React 19/Vite, React Hook Form/Zod, Flutter/Riverpod/GoRouter.

**Storage**: PostgreSQL mediante Prisma; contraseñas y códigos se almacenan únicamente como hashes.

**Testing**: Vitest/Supertest para API y panel; `flutter test` para móvil; pruebas de contrato y de transición de estado.

**Target Platform**: API Linux en contenedor, panel web moderno y aplicación Flutter Android/iOS.

**Project Type**: Monorepo móvil + API + panel administrativo.

**Performance Goals**: Recorridos de alta fluidos en red móvil; validación de código y guardado de borrador con respuesta objetivo p95 menor a 500 ms sin contar entrega externa futura.

**Constraints**: Sin SMS real, documentos sensibles, pagos, contratación, ranking ni mensajería de servicio. Una matrícula puede declararse solamente como texto no verificado; no se reciben ni almacenan comprobantes. El código expira, tiene intentos limitados, consumo atómico y nunca se devuelve desde la API fuera del adaptador local de pruebas. Jorge no interviene.

**Scale/Scope**: Beta cerrada en Tandil, once categorías generales y operación manual por dos personas.

## Constitution Check

| Principio | Resultado | Aplicación en este plan |
| --- | --- | --- |
| I. Operación pequeña | Pasa | Una categoría inicial, borradores y revisión manual. |
| II. Sin IA obligatoria | Pasa | Alta y revisión completamente manuales. |
| III. Estados verificables | Pasa | Código temporal, estados de proveedor y decisiones inmutables con auditoría. |
| IV. Confianza relevante | Pasa | Solo Aprobado será elegible para la futura visibilidad; matrícula es declarativa. |
| V. Acceso sencillo | Pasa | Formularios por pasos, revisión previa y mensaje breve de recuperación. |
| VII. Identidad visual | Pasa | Dominancia azul/naranja, G2 y texto además de color. |
| VIII. Administración justificada | Pasa | Solo administradores existentes resuelven altas pendientes. |
| IX. Independencia de IA | No aplica | No se modifica Jorge ni se introduce SDK de IA. |

Revisión posterior a diseño: pasa. El adaptador de verificación telefónica no es un proveedor de IA y queda aislado para evitar dependencia de una empresa de mensajería en el dominio.

## Project Structure

```text
apps/
├── api/
│   ├── prisma/schema.prisma
│   ├── src/app-auth/                 # identidad, contraseña y desafíos de teléfono
│   ├── src/onboarding/               # cuentas por rol, borradores y categorías
│   ├── src/admin-provider-review/    # cola y decisiones administrativas
│   └── test/                         # integración y contratos API
├── admin/src/features/provider-review/
└── mobile/lib/features/
    ├── app_auth/
    └── onboarding/

specs/003-role-onboarding/
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/openapi.yaml
```

**Structure Decision**: se conserva el monolito modular NestJS y las dos interfaces existentes. El dominio no depende del proveedor de códigos: `PhoneVerificationGateway` pertenece a la aplicación y sus adaptadores viven en infraestructura.

## Complexity Tracking

No hay violaciones que justificar. La separación Identidad/Cuenta Cliente/Cuenta Proveedor refleja una decisión explícita del producto y evita una tabla de rol mutable que contradiga el flujo acordado.

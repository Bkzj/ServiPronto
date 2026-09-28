# Implementation Plan: Base de desarrollo reproducible

**Branch**: `main` | **Date**: 2026-09-14 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/001-development-foundation/spec.md`

## Summary

Crear una fundación local reproducible: PostgreSQL, API NestJS y panel React en Docker Compose, más una aplicación Flutter compartida ejecutada con los SDK del anfitrión. El primer corte prueba configuración, persistencia y comunicación real sin implementar dominio ni integraciones externas.

## Technical Context

**Language/Version**: TypeScript 6 / Node.js 24.15; Dart 3.10 / Flutter 3.38.1; SQL PostgreSQL 18.6

**Primary Dependencies**: NestJS 12, Prisma 6.12, React 19, Vite 8, TanStack Query, React Router, Zod, React Hook Form, Riverpod, GoRouter, Dio

**Storage**: PostgreSQL 18.6 con volumen local nombrado; Prisma migrations

**Testing**: Vitest y Supertest para API; Vitest + Testing Library para panel; flutter_test y mocktail para móvil; pruebas de salud de Compose

**Target Platform**: Contenedores Linux para API/panel/base; Android desde Windows o Mac; iOS desde Mac

**Project Type**: Monorepo liviano de API, panel web y aplicación móvil

**Performance Goals**: Entorno listo en menos de 3 minutos con imágenes presentes; comprobaciones locales de salud en menos de 2 segundos

**Constraints**: Sin secretos versionados; puertos solo locales; Flutter fuera de Docker; ninguna integración paga o externa; Docker Compose sin orquestación de producción

**Scale/Scope**: Dos desarrolladores; una API, un panel, una app y una base; una tabla técnica sin entidades de producto

## Constitution Check

- **I Equipo pequeño**: PASS. Tres piezas inevitables, coordinadas con un comando y sin plataforma adicional de monorepo.
- **II Producto sin IA**: PASS. La base funciona sin Jorge y no se agrega ningún proveedor de IA.
- **III Estados reales**: PASS. Salud viva y lista se informan por separado y readiness consulta la base.
- **V Acceso simple**: PASS. La pantalla inicial usa estados claros y acción de reintento.
- **VII Identidad consistente**: PASS. Se crean tokens iniciales azul/naranja, curvas continuas aproximadas y modos claro/oscuro; no se declaran componentes finales.
- **VIII Administración auditable**: PASS. No se implementa acceso administrativo real todavía.
- **IX Independencia de IA**: PASS. Ningún SDK de IA entra en la fundación.
- **Calidad y pruebas**: PASS. Cada pieza incluye análisis, pruebas y build; versiones y locks quedan registrados.

Revisión posterior al diseño: PASS. No hay excepciones constitucionales.

## Project Structure

### Documentation (this feature)

```text
specs/001-development-foundation/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/health-api.yaml
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
apps/
├── api/
│   ├── prisma/
│   ├── src/health/
│   └── test/
├── admin/
│   └── src/
└── mobile/
    ├── android/
    ├── ios/
    ├── lib/
    └── test/

docker-compose.yml
package.json
.env.example
```

**Structure Decision**: npm workspaces administra `apps/api` y `apps/admin`; Flutter conserva su gestor y lock propios. Docker Compose es la entrada local común.

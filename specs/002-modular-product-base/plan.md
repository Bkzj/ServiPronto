# Implementation Plan: Base modular y acceso administrador

**Branch**: `main` | **Date**: 2026-09-14 | **Spec**: [spec.md](spec.md)

## Summary

Extender la API NestJS/PostgreSQL con una cuenta administrativa independiente, autenticación de alcance local y módulos de dominio vacíos pero explícitos. El panel React pasa de diagnóstico a inicio de sesión y tablero. Flutter adopta su shell de cinco destinos. Jorge incorpora contrato/gateway propios y un adaptador sin red.

## Technical Context

**Language/Version**: TypeScript 6 / Node 24.15; Dart 3.10 / Flutter 3.38.1

**Primary Dependencies**: NestJS JWT, bcryptjs, Prisma; React Hook Form + Zod; Riverpod + GoRouter

**Storage**: PostgreSQL, migración `AdminAccount`, semilla idempotente

**Testing**: Vitest/Supertest, Testing Library, flutter_test; import-boundary test para Jorge

**Target Platform**: Misma base Docker local y clientes web/móvil de la fundación

**Constraints**: Credenciales solo en `.env`; sesión no productiva; sin llamadas de IA; sin funciones comerciales simuladas

## Constitution Check

- Equipo pequeño: PASS, API modular única.
- Manual sin IA: PASS, Jorge es opcional y no configurado.
- Estados honestos: PASS, módulos declaran `foundation`/`planned`.
- Administración: PASS, cuenta privada y guardas; auditoría detallada queda para su feature.
- Independencia IA: PASS, contrato/gateway/adaptador y prueba de frontera.
- Calidad: PASS, pruebas de credenciales inválidas, hash, autorización y adaptador.

## Project Structure

```text
apps/api/src/
├── auth/
├── admin/
├── modules/<bounded-context>/
└── jorge/{domain,application,infrastructure}/
apps/admin/src/{auth,dashboard}/
apps/mobile/lib/src/{navigation,features}/
```

**Structure Decision**: Monolito modular; cada frontera se puede completar mediante una especificación posterior sin cambiar la topología.

# Tasks: Base de desarrollo reproducible

**Input**: Design documents from `specs/001-development-foundation/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Incluidas porque la especificación exige verificaciones automatizadas.

## Phase 1: Setup (Shared Infrastructure)

- [x] T001 Inicializar la estructura del monorepo y archivos de exclusión en `package.json`, `.gitignore` y `.dockerignore`
- [x] T002 [P] Crear el proyecto NestJS estricto en `apps/api/`
- [x] T003 [P] Crear el panel React TypeScript en `apps/admin/`
- [x] T004 [P] Crear la aplicación Flutter para Android/iOS en `apps/mobile/`

## Phase 2: Foundational (Blocking Prerequisites)

- [x] T005 Configurar variables validadas y ejemplo sin secretos en `.env.example`, `docker-compose.yml` y `apps/api/src/config/`
- [x] T006 Crear PostgreSQL persistente, healthcheck y red local en `docker-compose.yml`
- [x] T007 [P] Configurar Prisma y la migración técnica RuntimeProbe en `apps/api/prisma/`
- [x] T008 [P] Configurar CORS local, seguridad HTTP, Swagger y logging en `apps/api/src/main.ts`
- [x] T009 Configurar scripts raíz de lint, test, build y check en `package.json`

## Phase 3: User Story 1 - Levantar el entorno completo (Priority: P1)

**Independent Test**: Compose inicia los tres servicios, respeta sus healthchecks y PostgreSQL conserva RuntimeProbe tras reiniciar.

- [x] T010 [P] [US1] Escribir pruebas de liveness y readiness en `apps/api/src/health/health.controller.spec.ts`
- [x] T011 [US1] Implementar liveness/readiness con consulta real en `apps/api/src/health/`
- [x] T012 [US1] Crear Dockerfiles de desarrollo y producción en `apps/api/Dockerfile` y `apps/admin/Dockerfile`
- [x] T013 [US1] Integrar dependencias y healthchecks en `docker-compose.yml`

## Phase 4: User Story 2 - Verificar el panel administrativo (Priority: P2)

**Independent Test**: La prueba de interfaz confirma los estados conectado, desconectado y reintento.

- [x] T014 [P] [US2] Escribir pruebas del estado de API en `apps/admin/src/App.test.tsx`
- [x] T015 [US2] Implementar cliente de salud y reintento en `apps/admin/src/`
- [x] T016 [US2] Aplicar los tokens visuales iniciales y modos claro/oscuro en `apps/admin/src/index.css`

## Phase 5: User Story 3 - Ejecutar la aplicación móvil base (Priority: P3)

**Independent Test**: La prueba de widget cubre estado inicial, éxito, fallo y reintento; Android inicia con la URL del emulador.

- [x] T017 [P] [US3] Escribir pruebas de la pantalla y servicio de salud en `apps/mobile/test/`
- [x] T018 [US3] Implementar configuración, navegación, estado y cliente HTTP en `apps/mobile/lib/`
- [x] T019 [US3] Aplicar tema ServiPronto claro/oscuro y accesible en `apps/mobile/lib/src/theme/`

## Phase 6: Polish & Cross-Cutting Concerns

- [x] T020 Documentar uso y decisiones actuales en `README.md`, `docs/DECISIONES.md` y `ROADMAP.md`
- [x] T021 Ejecutar y corregir lint, pruebas y builds de API, panel y móvil según `specs/001-development-foundation/quickstart.md`
- [x] T022 Validar Compose, salud, persistencia y ausencia de secretos; registrar resultados en `specs/001-development-foundation/quickstart.md`

## Dependencies & Execution Order

- T001 precede a los proyectos T002-T004.
- T005-T009 dependen del scaffolding y bloquean las historias.
- US1 habilita la integración real de US2 y US3.
- US2 y US3 son independientes entre sí después de US1.

## Implementation Strategy

Primero completar el entorno y la salud real (US1); luego validar cada cliente por separado. Con dos integrantes, API/Compose y las interfaces web/móvil pueden repartirse después de la fase fundacional.

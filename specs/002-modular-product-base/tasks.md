# Tasks: Base modular y acceso administrador

## Phase 1: Setup

- [x] T001 Agregar dependencias de autenticación bloqueadas en `apps/api/package.json` y `package-lock.json`
- [x] T002 Ampliar variables validadas sin versionar en `.env.example` y `apps/api/src/config/environment.ts`

## Phase 2: Foundational

- [x] T003 Crear modelo, migración y semilla idempotente de `AdminAccount` en `apps/api/prisma/`
- [x] T004 Crear fronteras de módulos y registro de estados en `apps/api/src/modules/`
- [x] T005 Crear contrato, gateway y adaptador no configurado de Jorge en `apps/api/src/jorge/`

## Phase 3: User Story 1 - Acceso administrador (P1)

- [x] T006 [P] [US1] Escribir pruebas de login, rechazo y guardia en `apps/api/src/auth/`
- [x] T007 [US1] Implementar login, JWT, perfil y guardia administrativa en `apps/api/src/auth/`
- [x] T008 [P] [US1] Escribir pruebas del formulario en `apps/admin/src/App.test.tsx`
- [x] T009 [US1] Implementar acceso, sesión en memoria y salida en `apps/admin/src/`

## Phase 4: User Story 2 - Arquitectura visible (P2)

- [x] T010 [P] [US2] Probar autorización y contenido del registro en `apps/api/src/admin/`
- [x] T011 [US2] Exponer el registro protegido en `apps/api/src/admin/`
- [x] T012 [US2] Mostrar perfil y módulos en el tablero `apps/admin/src/`

## Phase 5: User Story 3 - Jorge desacoplado y shell móvil (P3)

- [x] T013 [P] [US3] Probar gateway y frontera de importaciones en `apps/api/src/jorge/`
- [x] T014 [US3] Conectar orquestador con adaptador no configurado en `apps/api/src/jorge/`
- [x] T015 [US3] Crear navegación de cinco destinos en `apps/mobile/lib/src/`

## Phase 6: Validation

- [x] T016 Ejecutar migración, semilla repetida, login real y rutas protegidas en Docker
- [x] T017 Ejecutar auditoría, lint, tipos, pruebas y builds en toda la base
- [x] T018 Sincronizar documentación y resultados en `README.md`, `docs/DECISIONES.md` y `ROADMAP.md`

## Dependencies

- T001-T005 bloquean las historias.
- US1 habilita US2. US3 es independiente tras la fundación.

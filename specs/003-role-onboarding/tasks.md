# Tasks: Alta progresiva y revisión inicial

**Input**: [spec.md](spec.md), [plan.md](plan.md), [research.md](research.md), [data-model.md](data-model.md) y [contrato](contracts/openapi.yaml).

**Tests**: obligatorios; cada prueba se escribe y se ejecuta fallando antes de su implementación.

## Phase 1: Preparación

- [x] T001 Documentar el modo local del desafío telefónico sin secretos en `.env.example` y extender la validación de configuración en `apps/api/src/config/environment.ts`.
- [x] T003 [P] Agregar pruebas de contrato de acceso y altas en `apps/api/test/role-onboarding.e2e-spec.ts`.

## Phase 2: Fundaciones bloqueantes

- [x] T004 Extender el modelo Prisma con `AppIdentity`, `PhoneVerificationChallenge`, `ClientAccount`, `ProviderAccount`, `ProviderPresentation`, `ProviderReviewDecision` y `ServiceCategory` en `apps/api/prisma/schema.prisma`.
- [x] T005 Crear y aplicar la migración de identidad y alta en `apps/api/prisma/migrations/`.
- [x] T002 Preparar semillas idempotentes de las once categorías de Tandil en `apps/api/prisma/seed.ts` después de crear `ServiceCategory`.
- [x] T006 Implementar `AppAuthGuard` y sesión de aplicación separados del acceso administrativo en `apps/api/src/app-auth/`.
- [x] T007 Implementar `PhoneVerificationGateway` y adaptador local limitado a desarrollo en `apps/api/src/app-auth/phone-verification/`.
- [x] T008 Registrar módulos y configuración segura de acceso de aplicación en `apps/api/src/app.module.ts` y `apps/api/src/config/`.

## Phase 3: User Story 1 — Elegir y completar cliente (P1)

**Goal**: una identidad verificada crea o retoma un único perfil Cliente en pasos y puede revisarlo.

**Independent Test**: crear una sesión C, guardar los datos de cliente y comprobar que el teléfono duplicado se rechaza solo para el mismo rol.

- [x] T009 [P] [US1] Escribir pruebas fallidas de registro, desafío, código vencido y sesión en `apps/api/test/app-auth.e2e-spec.ts`.
- [x] T010 [P] [US1] Escribir pruebas fallidas de borrador y completitud de cliente en `apps/api/test/client-onboarding.e2e-spec.ts`.
- [x] T011 [US1] Implementar registro, reenvío, login y confirmación atómica de sesión C en `apps/api/src/app-auth/app-auth.service.ts` y `apps/api/src/app-auth/app-auth.controller.ts`, sin exponer códigos ni teléfonos completos fuera del adaptador local de desarrollo.
- [x] T012 [US1] Implementar perfil Cliente con teléfono único por rol en `apps/api/src/onboarding/client-onboarding.service.ts`.
- [ ] T013 [US1] Exponer DTOs validados y endpoints de cliente en `apps/api/src/onboarding/`.
- [ ] T014 [US1] Implementar recorrido Flutter de correo, contraseña, código y perfil Cliente en `apps/mobile/lib/features/app_auth/` y `apps/mobile/lib/features/onboarding/`.
- [ ] T015 [US1] Agregar pruebas de widgets para los pasos y estados comprensibles en `apps/mobile/test/features/client_onboarding_test.dart`.

## Phase 4: User Story 2 — Presentar proveedor (P1)

**Goal**: una identidad verificada crea un único proveedor, selecciona una categoría, conserva borrador y lo envía a revisión.

**Independent Test**: guardar proveedor con una categoría habilitada, enviarlo y verificar que queda `IN_REVIEW` sin visibilidad pública.

- [ ] T016 [P] [US2] Escribir pruebas fallidas de proveedor, categoría deshabilitada y transiciones en `apps/api/test/provider-onboarding.e2e-spec.ts`.
- [ ] T017 [US2] Implementar categorías habilitadas y borrador de proveedor en `apps/api/src/onboarding/provider-onboarding.service.ts`.
- [ ] T018 [US2] Implementar validación de información mínima y envío `INCOMPLETE/CHANGES_REQUIRED → IN_REVIEW` en `apps/api/src/onboarding/provider-onboarding.service.ts`.
- [ ] T019 [US2] Exponer endpoints y DTOs de proveedor en `apps/api/src/onboarding/`.
- [ ] T020 [US2] Implementar formulario Flutter de proveedor con dominancia naranja, revisión previa y borrador en `apps/mobile/lib/features/onboarding/`.
- [ ] T021 [US2] Agregar pruebas Flutter del estado y revisión de proveedor en `apps/mobile/test/features/provider_onboarding_test.dart`.

## Phase 5: User Story 3 — Revisión administrativa (P2)

**Goal**: administración revisa solicitudes pendientes y guarda una decisión trazable.

**Independent Test**: un administrador aprueba, pide cambios o rechaza un proveedor En revisión y el proveedor puede consultar el resultado y el historial.

- [ ] T022 [P] [US3] Escribir pruebas fallidas de permisos, decisiones y auditoría en `apps/api/test/admin-provider-review.e2e-spec.ts`.
- [ ] T023 [US3] Implementar máquina de estados e historial inmutable en `apps/api/src/admin-provider-review/provider-review.service.ts`.
- [ ] T024 [US3] Exponer cola y decisión para administradores existentes en `apps/api/src/admin-provider-review/provider-review.controller.ts`.
- [ ] T025 [US3] Implementar lista, detalle y decisión con motivo en `apps/admin/src/features/provider-review/`.
- [ ] T026 [US3] Agregar pruebas del panel para estados y motivo requerido en `apps/admin/src/features/provider-review/*.test.tsx`.

## Phase 6: Pulido y verificación

- [ ] T027 Actualizar `README.md` y `docs/DECISIONES.md` con el acceso C y el límite del adaptador local.
- [ ] T028 Ejecutar análisis de calidad Spec Kit sobre `specs/003-role-onboarding/` y resolver hallazgos críticos.
- [ ] T029 Ejecutar `npm run check`, pruebas de API, `flutter analyze`, `flutter test` y una validación de quickstart.
- [ ] T030 Revisar configuración para confirmar que no se expone código, contraseña ni teléfono completo en logs o respuestas de producción.

## Dependencies & Execution Order

`T001–T008` bloquean las historias. US1 entrega la sesión C y Cliente; US2 depende de la sesión C y agrega Proveedor; US3 depende del estado `IN_REVIEW` de US2. El pulido requiere las tres historias.

## Parallel Opportunities

- T002 y T003 pueden realizarse en paralelo; T009 y T010 también.
- Tras la fundación, la interfaz Flutter puede avanzar contra el contrato mientras el servicio API se termina, sin modificar los mismos archivos.

## Implementation Strategy

Primero se valida el núcleo de acceso C y Cliente. Después se completa Proveedor sin introducir visibilidad pública. Por último se suma la revisión administrativa; pagos, documentos sensibles, Jorge y mensajería real permanecen fuera de esta entrega.

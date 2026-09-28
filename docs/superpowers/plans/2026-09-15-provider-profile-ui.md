# Alta visual de Proveedor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construir el flujo visual progresivo de Proveedor para una categoría inicial y su estado de revisión.

**Architecture:** Widgets locales separan el perfil Cliente del perfil Proveedor. La información se mantiene solo durante la demo y el estado de revisión es explícitamente visual, sin habilitar publicación ni trabajos.

**Tech Stack:** Flutter, Material 3, flutter_test.

**Spec:** `specs/010-provider-profile-ui/spec.md`

### Task 1: Provider onboarding draft

**Files:**
- Create: `apps/mobile/lib/src/features/provider/provider_profile_flow.dart`
- Create: `apps/mobile/test/provider_profile_flow_test.dart`

- [ ] Escribir prueba roja para categoría inicial, tareas, modalidad, cobertura, disponibilidad, experiencia y precio.
- [ ] Ejecutar test focal y confirmar fallo.
- [ ] Implementar borrador visual naranja sin documentos, pagos ni perfil público.
- [ ] Ejecutar suite Flutter y análisis.

### Task 2: Review and status UI

**Files:**
- Create: `apps/mobile/lib/src/features/provider/provider_review_status.dart`
- Modify: `apps/mobile/test/provider_profile_flow_test.dart`

- [ ] Escribir prueba roja para revisión previa y estados de proveedor.
- [ ] Ejecutar test focal y confirmar fallo.
- [ ] Implementar estados Incompleto, En revisión, Requiere cambios, Aprobado, Rechazado y Suspendido como demo local.
- [ ] Ejecutar suite, análisis y APK debug.

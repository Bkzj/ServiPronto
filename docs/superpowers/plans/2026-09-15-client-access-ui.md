# Acceso y alta visual de Cliente Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construir la experiencia móvil de acceso C y perfil Cliente progresivo sin duplicar la seguridad del backend.

**Architecture:** Las pantallas se modelan como widgets locales y reciben un puerto de acceso para conectar endpoints cuando estén expuestos. El primer corte usa un adaptador de demostración explícito y no persiste contraseñas, códigos ni datos de una persona real.

**Tech Stack:** Flutter, Material 3, flutter_test.

**Spec:** `specs/005-client-onboarding-ui/spec.md`

## Global Constraints

- Un dato o decisión por paso, títulos breves, una acción dominante y sin bordes decorativos.
- Código y contraseña nunca se muestran como texto ni se escriben en logs.
- Objetivos de 48 dp, texto grande, tema sistema, etiquetas accesibles y movimiento reducido.
- Reutilizar el shell Cliente tras una sesión confirmada; no implementar pagos, proveedor ni documentos sensibles.

### Task 1: Access C UI state machine

**Files:**
- Create: `apps/mobile/lib/src/features/client_access/client_access_flow.dart`
- Create: `apps/mobile/test/client_access_flow_test.dart`

- [ ] Write failing widget tests for email/password/phone, code entry and invalid code recovery.
- [ ] Run the targeted test and confirm it fails because the flow is absent.
- [ ] Implement a local, explicit demo flow that validates screen state only and never stores secrets.
- [ ] Run the targeted test and the full suite.

### Task 2: Client profile progressive UI

**Files:**
- Create: `apps/mobile/lib/src/features/client_access/client_profile_flow.dart`
- Modify: `apps/mobile/test/client_access_flow_test.dart`

- [ ] Write failing tests for one-field steps, save/resume presentation and review/edit action.
- [ ] Run the targeted test and confirm it fails.
- [ ] Implement minimum visual progress without persistence or real account data.
- [ ] Run targeted and full tests, then `flutter analyze`.

### Task 3: Shell handoff and accessibility

**Files:**
- Modify: `apps/mobile/lib/src/app.dart`
- Modify: `apps/mobile/test/client_access_flow_test.dart`

- [ ] Write failing test for the handoff from confirmed access to `ClientShell`.
- [ ] Run the targeted test and confirm it fails.
- [ ] Implement the handoff and semantic 48 dp actions.
- [ ] Run `flutter test`, `flutter analyze` and `flutter build apk --debug`.

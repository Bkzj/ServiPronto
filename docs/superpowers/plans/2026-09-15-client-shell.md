# Shell Cliente Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construir el primer shell móvil navegable de Cliente con Inicio, Explorar, Jorge, Actividad y Perfil usando contenido de muestra honesto.

**Architecture:** La app Flutter conserva un único `MaterialApp` y el shell administra el destino seleccionado y el estado local de Explorar. Las pantallas son widgets pequeños dentro de `lib/src/features/client_shell`; no consumen red ni simulan proveedores, pagos o contrataciones.

**Tech Stack:** Flutter, Material 3, flutter_test.

**Spec:** `specs/004-client-app-shell/spec.md`

## Global Constraints

- Cliente azul predominante y naranja de acento; curvas continuas G2.
- No usar bordes decorativos. Foco, error y selección son excepciones funcionales.
- Un título y como máximo una línea de apoyo por bloque; no usar texto redundante.
- Los objetivos táctiles miden como mínimo 48 por 48 dp; soporte de texto grande, lectores de pantalla, claro/oscuro/sistema y movimiento reducido.
- Jorge es opcional, breve y no finge conversación ni acciones reales.
- Datos de muestra explícitos; no implementar contratación, pago, chat de servicio, ranking ni publicidad de terceros.

### Task 1: Design tokens and five-destination navigation

**Files:**
- Modify: `apps/mobile/lib/src/app.dart`
- Create: `apps/mobile/lib/src/features/client_shell/client_shell.dart`
- Create: `apps/mobile/test/client_shell_test.dart`

**Interfaces:**
- Produces `ClientShell`, a widget exposing the five labeled destinations.

- [ ] **Step 1: Write the failing widget tests** for initial Inicio, every semantic destination and Jorge central.
- [ ] **Step 2: Run** `flutter test test/client_shell_test.dart` and verify failure because `ClientShell` does not exist.
- [ ] **Step 3: Implement** a minimal Material navigation shell with accessible labels and selected state.
- [ ] **Step 4: Run** `flutter test test/client_shell_test.dart` and verify passing.

### Task 2: Inicio and Explorar with sample categories

**Files:**
- Create: `apps/mobile/lib/src/features/client_shell/home_tab.dart`
- Create: `apps/mobile/lib/src/features/client_shell/explore_tab.dart`
- Modify: `apps/mobile/lib/src/features/client_shell/client_shell.dart`
- Modify: `apps/mobile/test/client_shell_test.dart`

- [ ] **Step 1: Write failing tests** for search, sample category list and no-results action.
- [ ] **Step 2: Run the targeted test** and confirm it fails for missing behavior.
- [ ] **Step 3: Implement** brief Inicio and vertical Explorar list using only sample categories.
- [ ] **Step 4: Run targeted and full Flutter tests** and confirm passing.

### Task 3: Jorge, Actividad and Perfil empty states

**Files:**
- Create: `apps/mobile/lib/src/features/client_shell/jorge_tab.dart`
- Create: `apps/mobile/lib/src/features/client_shell/activity_tab.dart`
- Create: `apps/mobile/lib/src/features/client_shell/profile_tab.dart`
- Modify: `apps/mobile/test/client_shell_test.dart`

- [ ] **Step 1: Write failing tests** for manual alternatives in Jorge and one useful action in each empty state.
- [ ] **Step 2: Run the targeted test** and verify a behavior failure.
- [ ] **Step 3: Implement** concise states with no fake conversation or job.
- [ ] **Step 4: Run targeted and full Flutter tests** and confirm passing.

### Task 4: Themes, accessibility and verification

**Files:**
- Modify: `apps/mobile/lib/src/theme/app_theme.dart`
- Modify: `apps/mobile/lib/src/app.dart`
- Modify: `apps/mobile/test/client_shell_test.dart`

- [ ] **Step 1: Write failing tests** for semantic names, 48 dp tap targets and dark theme rendering.
- [ ] **Step 2: Run targeted tests** and verify failure.
- [ ] **Step 3: Implement** semantic palette, theme modes and focus-safe controls without decorative strokes.
- [ ] **Step 4: Run** `flutter analyze`, `flutter test` and `flutter build apk --debug`.

## Coverage review

Tasks 1-4 cover all functional requirements of 004. Search produces only categories/sample states; the API and all commercial actions remain out of scope.

# Actividad y agenda visual Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convertir Actividad en una vista útil de pendientes e historial visual, sin afirmar que exista un trabajo contratado.

**Architecture:** Widgets locales de actividad reciben estados de muestra y una referencia opcional de borrador. La agenda se limita a representación visual y no reprograma, confirma ni comunica a terceros.

**Tech Stack:** Flutter, Material 3, flutter_test.

**Spec:** `specs/007-activity-schedule-ui/spec.md`

### Task 1: Client activity states

**Files:**
- Create: `apps/mobile/lib/src/features/activity/client_activity_tab.dart`
- Create: `apps/mobile/test/client_activity_tab_test.dart`
- Modify: `apps/mobile/lib/src/features/client_shell/client_shell.dart`

- [ ] Escribir prueba roja para pendientes, historial vacío y acción Explorar servicios.
- [ ] Ejecutar test focal y confirmar fallo.
- [ ] Implementar estados locales de actividad claramente identificados como muestra.
- [ ] Ejecutar suite y análisis Flutter.

### Task 2: Visual agenda detail

**Files:**
- Create: `apps/mobile/lib/src/features/activity/schedule_preview.dart`
- Modify: `apps/mobile/test/client_activity_tab_test.dart`

- [x] Escribir prueba roja para agenda de muestra y detalle sin acciones reales.
- [x] Ejecutar test focal y confirmar fallo.
- [x] Implementar preview de agenda con estado no contractual.
- [x] Ejecutar suite, análisis y APK debug.

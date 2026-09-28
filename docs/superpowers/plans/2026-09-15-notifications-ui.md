# Notificaciones visuales Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Añadir un centro de avisos y preferencias locales, con mensajes transaccionales de muestra y sin publicidad ni entrega externa.

**Architecture:** El centro se abre desde un control contextual de Inicio y presenta notificaciones locales, estados de lectura y preferencias en memoria. No usa push, permisos del sistema ni servidores.

**Tech Stack:** Flutter, Material 3, flutter_test.

**Spec:** `specs/009-notifications-ui/spec.md`

### Task 1: Notification center

**Files:**
- Create: `apps/mobile/lib/src/features/notifications/notification_center.dart`
- Create: `apps/mobile/test/notification_center_test.dart`
- Modify: `apps/mobile/lib/src/features/client_shell/home_tab.dart`
- Modify: `apps/mobile/lib/src/features/client_shell/client_shell.dart`

- [ ] Escribir prueba roja para abrir centro, lectura y estado vacío.
- [ ] Ejecutar test focal y confirmar fallo.
- [ ] Implementar centro local con avisos de muestra y salida contextual.
- [ ] Ejecutar suite Flutter y análisis.

### Task 2: Preferences

**Files:**
- Create: `apps/mobile/lib/src/features/notifications/notification_preferences.dart`
- Modify: `apps/mobile/test/notification_center_test.dart`

- [ ] Escribir prueba roja para preferencias transaccionales locales.
- [ ] Ejecutar test focal y confirmar fallo.
- [ ] Implementar preferencias en memoria sin permisos ni promociones.
- [ ] Ejecutar suite, análisis y APK debug.

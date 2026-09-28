# Chat visual de Jorge Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Crear el recorrido conversacional visual de Jorge, breve y opcional, con texto, adjunto de muestra y recomendaciones no contractuales.

**Architecture:** Un widget local controla una conversación de demostración con respuestas deterministas propias. Las tarjetas representan orientación y siempre explicitan que no crean una solicitud ni contactan proveedores.

**Tech Stack:** Flutter, Material 3, flutter_test.

**Spec:** `specs/008-jorge-chat-ui/spec.md`

### Task 1: Jorge conversation and safe states

**Files:**
- Create: `apps/mobile/lib/src/features/jorge/jorge_chat_tab.dart`
- Create: `apps/mobile/test/jorge_chat_tab_test.dart`
- Modify: `apps/mobile/lib/src/features/client_shell/client_shell.dart`

- [ ] Escribir pruebas rojas para mensaje, respuesta breve, adjunto visual y estado de error honesto.
- [ ] Ejecutar test focal y confirmar fallo.
- [ ] Implementar conversación local con texto e imagen de muestra, sin voz ni efectos comerciales.
- [ ] Ejecutar suite Flutter y análisis.

### Task 2: Recommendation cards and manual exits

**Files:**
- Modify: `apps/mobile/lib/src/features/jorge/jorge_chat_tab.dart`
- Modify: `apps/mobile/test/jorge_chat_tab_test.dart`

- [ ] Escribir prueba roja para tarjeta no contractual y salida a Explorar.
- [ ] Ejecutar test focal y confirmar fallo.
- [ ] Implementar tarjeta y navegación manual sin afirmar disponibilidad real.
- [ ] Ejecutar suite, análisis y APK debug.

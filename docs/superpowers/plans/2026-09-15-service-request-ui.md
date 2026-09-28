# Solicitud manual de servicio Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Permitir que Cliente prepare y revise una solicitud manual visual desde una categoría, sin generar una contratación.

**Architecture:** Un flujo Flutter local recibe una categoría de muestra, captura una descripción, urgencia, modalidad y lugar en memoria de sesión, y termina en una revisión explícita “sin enviar todavía”. Se conecta desde Explorar tras elegir una categoría.

**Tech Stack:** Flutter, Material 3, flutter_test.

**Spec:** `specs/006-service-request-flow/spec.md`

## Global Constraints

- No crear solicitud real, matching, proveedor, presupuesto, pago, chat ni ubicación GPS.
- Un paso por decisión, G2, sin bordes decorativos, acciones de 48 dp y texto breve.
- Jorge es una guía opcional; las imágenes son opcionales y permanecen locales al flujo.

### Task 1: Request draft flow

**Files:**
- Create: `apps/mobile/lib/src/features/service_request/service_request_flow.dart`
- Create: `apps/mobile/test/service_request_flow_test.dart`

- [ ] Escribir test rojo para descripción, urgencia, modalidad y revisión no contractual.
- [ ] Ejecutar el test focal y verificar fallo.
- [ ] Implementar flujo local mínimo con estado y navegación entre pasos.
- [ ] Ejecutar test focal, suite Flutter y análisis.

### Task 2: Entry from category and family recipient

**Files:**
- Modify: `apps/mobile/lib/src/features/client_shell/explore_tab.dart`
- Modify: `apps/mobile/lib/src/features/client_shell/client_shell.dart`
- Modify: `apps/mobile/test/service_request_flow_test.dart`

- [x] Escribir test rojo para abrir solicitud desde una categoría y activar destinatario familiar opcional.
- [x] Ejecutar el test focal y verificar fallo.
- [x] Implementar la entrada y datos locales de receptor sin dirección real.
- [x] Ejecutar suite Flutter, análisis y APK debug.

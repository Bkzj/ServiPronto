# Specification Quality Checklist: Avisos y preferencias del Cliente

**Purpose**: Validar que el centro de avisos sea claro, no invasivo y delimitado antes de planificarlo.

**Created**: 2026-09-15

**Feature**: [spec.md](../spec.md)

## Content Quality

- [x] No convierte una preferencia visual en una integración técnica o proveedor de avisos.
- [x] Se concentra en mensajes y eventos transaccionales, no en promociones ni automatizaciones aplazadas.
- [x] Separa lectura de un aviso, lectura de chat y confirmación contractual.
- [x] Todas las secciones obligatorias están completas.

## Requirement Completeness

- [x] Incluye recorridos de consulta, gestión de leído/no leído, preferencias y recuperación.
- [x] Define estados de permiso denegado, revocado, vacío, error, destino no disponible y duplicados.
- [x] Declara los extras de D-24 fuera de alcance de forma explícita.
- [x] Las entidades distinguen aviso, lectura, preferencia, permiso y destino.
- [x] Los criterios de éxito son verificables y no dependen de una tecnología particular.

## Frontend Quality Guardrails

- [x] Exige G2, predominio azul Cliente, acento naranja y prohíbe bordes decorativos o líneas de separación.
- [x] Limita el texto y evita banners, tarjetas y leyendas redundantes.
- [x] Incluye tema claro, oscuro, sistema, texto ampliado, lector de pantalla y movimiento reducido.
- [x] Jorge permanece como ayuda breve y opcional, sin convertirse en alerta ni duplicar avisos.
- [x] No agrega publicidad, sonidos obligatorios, recordatorios, pagos ni compromisos automáticos.

## Notes

- La entrega de avisos al dispositivo, permisos de plataforma y reglas de frecuencia se planificarán por separado cuando se autorice esa integración.

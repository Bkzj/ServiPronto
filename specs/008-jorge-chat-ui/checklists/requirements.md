# Specification Quality Checklist: Conversación visual con Jorge

**Purpose**: Validar que la interfaz opcional de Jorge sea clara, segura y acotada antes de planificarla.

**Created**: 2026-09-15

**Feature**: [spec.md](../spec.md)

## Content Quality

- [x] No incluye SDK, proveedor, modelo, API ni detalle de infraestructura como requisito visual.
- [x] Se concentra en orientación útil, transparencia y autonomía de la persona.
- [x] Distingue al personaje cálido de un operador humano o un profesional verificado.
- [x] Todas las secciones obligatorias están completas.

## Requirement Completeness

- [x] Los recorridos de texto, imagen, recomendación, salida manual y recuperación son independientes y verificables.
- [x] Las recomendaciones están acotadas y no simulan contratación, reserva, pago o confirmación.
- [x] Se contemplan estados de espera, error, respuesta parcial, cancelación, adjunto inválido y riesgo físico.
- [x] Los requisitos de accesibilidad, temas, movimiento reducido y jerarquía visual son verificables.
- [x] Las entidades separan sesión, mensaje, adjunto, recomendación y estado del turno.
- [x] Los criterios de éxito son medibles y no dependen de un framework.

## Frontend Quality Guardrails

- [x] Cliente usa azul dominante y naranja de acento, con Jorge como identidad coherente.
- [x] Exige G2 y prohíbe bordes decorativos y líneas de separación en tarjetas, botones y superficies.
- [x] Favorece espacio, superficies y texto breve antes que tarjetas repetitivas o leyendas redundantes.
- [x] El recorrido manual permanece disponible ante cualquier estado de Jorge.
- [x] No agrega voz, pagos, contratación, diagnóstico profesional ni promesas de acciones no confirmadas.

## Notes

- La integración de IA, sus adaptadores, permisos y evaluaciones se especifican por separado según `docs/ARQUITECTURA_JORGE.md`; esta especificación describe exclusivamente la experiencia móvil.

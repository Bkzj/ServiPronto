# Checklist de requisitos: Panel administrativo inicial

**Purpose**: Verificar que la especificación del panel web privado sea completa, consistente con el producto y acotada para la operación manual inicial.
**Created**: 2026-09-15
**Feature**: [spec.md](../spec.md)
**Review Ownership**: Este artefacto revisa la calidad de requisitos. Un marcador `[x]` confirma que el criterio fue revisado y satisfecho; no confirma implementación.

## Alcance y recorridos

- [x] CHK001 Las historias priorizadas cubren la revisión manual, la trazabilidad, la visibilidad de categorías/promociones y las métricas iniciales de forma independiente.
- [x] CHK002 Cada recorrido define aceptación verificable sin exigir datos, perfiles ni integraciones que están fuera de este corte.
- [x] CHK003 La especificación mantiene el panel como acceso privado y justificado, sin autorregistro administrativo ni capacidad pública.
- [x] CHK004 El alcance excluye explícitamente pagos, conversaciones, documentos sensibles, automatizaciones, suspensiones y editor universal de reglas.

## Decisiones de proveedor y privacidad

- [x] CHK005 Los estados de proveedor y las transiciones permitidas coinciden con el producto y evitan reactivar o resolver estados no autorizados.
- [x] CHK006 Aprobar, pedir cambios y rechazar describen cuándo requieren motivo, qué trazabilidad conservan y cómo se evita una resolución duplicada.
- [x] CHK007 La ficha enumera los datos profesionales permitidos y prohíbe DNI, selfie, antecedentes, domicilio preciso, cobro y archivos sensibles.
- [x] CHK008 El historial distingue declaración vigente, decisiones y motivos históricos sin permitir edición retrospectiva.

## Contenido y métricas

- [x] CHK009 Las categorías se limitan a visibilidad de opciones preparadas, sin introducir subcategorías ni reglas configurables.
- [x] CHK010 Las promociones de muestra tienen estados, previsualización, espacio y período, y se separan explícitamente del ranking orgánico y de Jorge.
- [x] CHK011 Las métricas se definen como cantidades con período, actualización y ausencia explícita de datos; no prometen conversión, ingresos ni tendencias inexistentes.
- [x] CHK012 Las rutas desde métricas a filtros operativos no suponen que los módulos futuros de solicitudes, pagos o soporte ya existan.

## Diseño y accesibilidad

- [x] CHK013 La composición de escritorio, la adaptación a pantalla angosta, el foco de tarea y las jerarquías sin bordes decorativos están especificados.
- [x] CHK014 La identidad naranja/azul, curvatura G2, texto breve y ausencia de leyendas repetidas son requisitos comprobables.
- [x] CHK015 Temas, contraste, teclado, lector de pantalla, zoom al 200 %, foco visible y movimiento reducido tienen requisitos y criterios de éxito.
- [x] CHK016 Los estados de carga, vacío, error, conflicto y resultado incierto evitan confirmaciones ficticias o callejones sin salida.

## Notas

- La especificación está lista para planificación. Las decisiones regulatorias o de retención de datos sensibles permanecen fuera de este corte y requieren una especificación dedicada antes de ser implementadas.

# Requirements Checklist: Actividad, detalle y agenda visual

**Purpose**: Revisar que la especificación del flujo visual de actividad y agenda sea verificable, acotada y no prometa operaciones inexistentes.

**Created**: 2026-09-15

**Feature**: [spec.md](../spec.md)

**Review Ownership**: Lista de calidad de requisitos. Una marca `[x]` confirma que el criterio está cubierto por la especificación; no indica que el código esté implementado.

## Alcance y límites

- [x] CHK001 El documento separa explícitamente UI de muestra de solicitudes, agenda, contratación y persistencia reales.
- [x] CHK002 Pagos, importes, códigos de visita, ubicación, chat real y notificaciones reales están excluidos de forma verificable.
- [x] CHK003 La reprogramación se limita a representación visual y aclara que no modifica estados ni disponibilidad.
- [x] CHK004 El alcance conecta con R04 y R08 sin anticipar sus reglas de negocio pendientes.

## Recorridos por rol

- [x] CHK005 Cliente puede reconocer pendientes, próximos compromisos, historial y el detalle de una referencia de trabajo.
- [x] CHK006 Proveedor dispone de una agenda diaria y compromisos cronológicos sin reutilizar controles o lenguaje de Cliente.
- [x] CHK007 El detalle compartido mantiene coherencia por referencia de trabajo y restringe información y acciones según rol.
- [x] CHK008 Los estados visuales mínimos están enumerados y cada uno exige una comunicación no basada solo en color.
- [x] CHK009 La propuesta de reprogramación identifica horario vigente, alternativas, iniciador y necesidad de acuerdo.

## Calidad visual y accesibilidad

- [x] CHK010 La jerarquía prioriza un próximo paso, información breve y acciones únicas, evitando tarjetas o leyendas repetidas.
- [x] CHK011 La regla G2 prohíbe bordes decorativos, líneas superiores y laterales, con excepciones funcionales acotadas.
- [x] CHK012 La dominancia azul/naranja cambia con el rol sin ser la única señal de contexto.
- [x] CHK013 Tema claro, oscuro, sistema, texto al 200 %, movimiento reducido, foco y objetivos de 48 dp tienen criterios verificables.
- [x] CHK014 Estados vacíos, carga, error, datos desactualizados, referencias inexistentes y horarios sin confirmar tienen respuesta definida.

## Medición

- [x] CHK015 Los resultados de comprensión de actividad, reprogramación y rol incluyen métricas sin depender de una tecnología específica.
- [x] CHK016 La especificación no conserva marcadores de plantilla ni necesidades de aclaración que bloqueen el plan visual.

## Notes

- Esta checklist es la puerta de calidad para planificar la interfaz. No convierte acciones de demostración en comportamientos productivos.

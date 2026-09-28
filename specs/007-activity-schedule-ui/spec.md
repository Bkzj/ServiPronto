# Feature Specification: Actividad, detalle y agenda visual

**Feature Branch**: `007-activity-schedule-ui`

**Created**: 2026-09-15

**Status**: Ready for planning

**Input**: Recorrido móvil visual para que Cliente y Proveedor entiendan sus trabajos, abran un detalle, consulten una agenda y vean una propuesta de reprogramación. Usa información de muestra explícita; no cambia un trabajo real ni habilita pagos, códigos de visita, chat ni notificaciones reales.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Cliente encuentra y entiende un trabajo (Priority: P1)

Una persona Cliente abre Actividad y reconoce, sin memorizar etiquetas técnicas, qué está pendiente, qué tiene agendado y qué ya terminó. Puede abrir un trabajo de muestra para ver lo imprescindible antes de decidir el siguiente paso.

**Why this priority**: Actividad es uno de los cinco destinos fijos del Cliente y tiene que dar tranquilidad sin obligar a usar Jorge ni a leer una lista larga.

**Independent Test**: con trabajos de muestra en distintos estados, abrir Actividad, localizar una visita programada y entrar a su detalle en menos de tres toques.

**Acceptance Scenarios**:

1. **Given** un Cliente con actividad de muestra, **When** abre Actividad, **Then** ve primero el próximo paso relevante y después secciones breves para pendientes, próximos e historial.
2. **Given** un Cliente con un trabajo programado, **When** abre su detalle, **Then** identifica servicio, proveedor, fecha u horario, lugar del servicio, estado y una única acción contextual sin ver importes ni datos de pago.
3. **Given** un Cliente sin actividad, **When** abre Actividad, **Then** ve un estado vacío breve que explica qué aparecerá allí y ofrece explorar servicios como única salida principal.

---

### User Story 2 - Proveedor organiza el día sin confundirse con Cliente (Priority: P1)

Una persona Proveedora ve su agenda de muestra como herramienta de trabajo: entiende qué compromisos tiene, sus franjas libres y los trabajos que requieren una decisión. Su pantalla conserva el lenguaje y jerarquía propios de Proveedor.

**Why this priority**: la agenda es la base visual para disponibilidad y puntualidad; debe ser útil incluso antes de conectar solicitudes reales.

**Independent Test**: con una agenda de muestra, seleccionar un día, reconocer dos compromisos y abrir el detalle de uno sin mezclar acciones de Cliente.

**Acceptance Scenarios**:

1. **Given** un Proveedor aprobado con datos de muestra, **When** abre su área de Actividad, **Then** encuentra una agenda por día y una lista cronológica de compromisos sin una grilla de calendario obligatoria.
2. **Given** un Proveedor con una solicitud pendiente de respuesta, **When** revisa la actividad, **Then** distingue esa decisión de una visita ya programada mediante texto, icono y ubicación en la interfaz, no solo color.
3. **Given** un Proveedor sin compromisos para una fecha, **When** selecciona ese día, **Then** ve que está libre y puede volver al día actual sin una pantalla vacía ni una promesa de nuevos trabajos.

---

### User Story 3 - Consultar el detalle sin inventar acciones (Priority: P1)

Cada parte abre una ficha corta del mismo trabajo de muestra y entiende su etapa, cronología y próxima acción. La ficha adapta el contenido a quien la mira, sin simular un chat ni ocultar que los datos son de demostración.

**Why this priority**: el detalle une Actividad y Agenda; evita que una lista de estados se vuelva ambigua o que Cliente y Proveedor reciban controles equivocados.

**Independent Test**: abrir una misma referencia de trabajo desde Cliente y desde Proveedor; comprobar que comparten identificación, servicio y agenda, pero muestran acciones y textos acordes al rol.

**Acceptance Scenarios**:

1. **Given** una referencia de trabajo de muestra, **When** Cliente o Proveedor abre su detalle, **Then** ve título del servicio, identidad visible de la contraparte, dirección o zona pertinente, fecha/hora, estado y una cronología corta.
2. **Given** una etapa sin información adicional, **When** se muestra el detalle, **Then** la pantalla omite bloques vacíos, explicaciones genéricas y tarjetas repetidas.
3. **Given** una persona que toca una acción todavía no conectada, **When** intenta continuar, **Then** recibe una explicación breve de que es una demostración y conserva el detalle; no se registra una aceptación, cancelación ni cambio real.

---

### User Story 4 - Ver una propuesta de reprogramación (Priority: P2)

Cliente y Proveedor pueden comprender visualmente que se propuso mover una visita, qué horario actual se busca reemplazar y qué alternativas se están considerando. Ninguna de las partes queda con la impresión de que el cambio ya fue confirmado.

**Why this priority**: reprogramar es frecuente y sensible; fijar su lenguaje visual temprano evita diseñar después sobre un estado confuso.

**Independent Test**: abrir un trabajo de muestra con reprogramación propuesta; reconocer horario actual, alternativa propuesta, quién inició el pedido y que todavía falta acuerdo.

**Acceptance Scenarios**:

1. **Given** una visita de muestra con una reprogramación pendiente, **When** se abre el detalle, **Then** se diferencian claramente el horario vigente, la propuesta y el estado “Esperando acuerdo”.
2. **Given** una propuesta iniciada por Cliente o Proveedor, **When** la contraparte la consulta, **Then** el texto dice quién propuso el cambio y presenta alternativas de horario sin atribuir una decisión final.
3. **Given** una persona que elige una alternativa en esta entrega visual, **When** la confirma en la interfaz de muestra, **Then** recibe un estado de demostración y la visita no se modifica fuera de la pantalla.

---

### User Story 5 - Mantener orientación y accesibilidad en todos los estados (Priority: P2)

Una persona mayor, con texto grande, modo oscuro o movimiento reducido, puede recorrer Actividad, detalle y agenda sin que la prioridad del trabajo dependa de animaciones, color o letra pequeña.

**Why this priority**: los trabajos programados son información crítica y deben poder consultarse con calma desde cualquier dispositivo compatible.

**Independent Test**: recorrer cada estado con texto al 200 %, lector de pantalla, tema claro/oscuro y movimiento reducido; mantener accesibles las acciones y el orden temporal.

**Acceptance Scenarios**:

1. **Given** texto al 200 %, **When** se muestran jornadas con varios compromisos, **Then** fecha, hora, estado y acción siguen legibles sin superposición ni recorte.
2. **Given** lector de pantalla, **When** se explora una lista de trabajos o agenda, **Then** cada elemento anuncia servicio, fecha/hora, estado y destino de forma comprensible.
3. **Given** movimiento reducido, **When** cambia de día o abre un detalle, **Then** mantiene contexto sin desplazamientos decorativos ni vibración automática.

### Edge Cases

- La referencia de un trabajo no existe, se eliminó del contenido de muestra o no pertenece al rol activo: se muestra un mensaje corto y se vuelve a Actividad sin exponer información de otra cuenta.
- Hay dos compromisos superpuestos en la agenda de muestra: ambos se muestran con hora completa y una advertencia textual; la interfaz no intenta resolver disponibilidad.
- Una visita no tiene hora exacta todavía: se presenta como “Horario a confirmar”, separada de trabajos fechados, y no se ordena como si fuera una hora concreta.
- La dirección es extensa o contiene datos de privacidad: se muestra solo el nivel necesario para el rol; no hay mapa, navegación externa ni ubicación en tiempo real.
- Cambia el rol activo: se reinicia el contexto visual de Actividad y Agenda para no mostrar el trabajo de una cuenta en la otra.
- La conexión se interrumpe: se conserva el último contenido de muestra disponible, se indica que no hay actualización y se ofrece reintentar sin esconder la navegación.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La interfaz MUST ofrecer un destino Actividad para Cliente dentro de la navegación definida en 004 y una vista de actividad/agenda diferenciada para Proveedor; ambas deben usar contenido de muestra identificado mientras no exista el módulo de trabajos real.
- **FR-002**: Actividad Cliente MUST ordenar visualmente los trabajos por relevancia inmediata: requiere acción, próximo compromiso y luego historial, sin más de una acción principal por bloque.
- **FR-003**: La vista Proveedor MUST priorizar agenda diaria y compromisos cronológicos, con acceso claro al día actual y sin requerir una grilla mensual para entender el día.
- **FR-004**: La interfaz MUST representar, como mínimo, los estados visuales: Solicitud pendiente, Esperando respuesta, Visita programada, En curso, Presupuesto pendiente, Esperando acuerdo, Finalizado, Cancelado y Reprogramación propuesta.
- **FR-005**: Cada estado MUST tener una etiqueta breve, icono o posición semántica y texto accesible; color por sí solo no puede comunicar el estado.
- **FR-006**: Un detalle de trabajo MUST mostrar únicamente información pertinente al rol: servicio, contraparte, fecha u horario, lugar o zona necesario, estado, cronología breve y próxima acción visual.
- **FR-007**: El mismo identificador de trabajo de muestra MUST producir información compartida coherente para Cliente y Proveedor, pero sus encabezados, textos y acciones no deben confundirse ni revelar datos ajenos.
- **FR-008**: La cronología MUST ordenar hechos y propuestas de forma temporal, usar fechas/horas legibles y no afirmar que se ejecutó una acción todavía no conectada.
- **FR-009**: Una reprogramación de muestra MUST mostrar horario vigente, propuesta, iniciador y estado pendiente de acuerdo. Hasta que exista la lógica de negocio correspondiente, seleccionar o aceptar una alternativa no puede modificar un trabajo, agenda ni disponibilidad reales.
- **FR-010**: La interfaz MUST incluir estados vacíos, carga, contenido desactualizado, error y sin horario confirmado; cada uno ofrece una explicación de una línea y, cuando corresponde, una sola acción útil.
- **FR-011**: Esta entrega MUST excluir pagos, importes, presupuestos detallados, confirmaciones por código, llegada/salida, seguimiento de ubicación, contratación, cancelación efectiva, chat real, imágenes de chat y notificaciones push o del sistema.
- **FR-012**: Si se muestra una señal visual de aviso en este corte, MUST ser local a la pantalla, identificarse como demostración y no simular que se envió una notificación a la contraparte.
- **FR-013**: Cliente MUST conservar azul predominante con naranja de acento y Proveedor naranja predominante con azul de acento. El cambio de rol también MUST cambiar etiquetas, encabezados y contenido, no solo colores.
- **FR-014**: Botones, tarjetas, filas de agenda y contenedores MUST usar curvas continuas G2, superficies limpias y jerarquía por espacio, tipografía, color y elevación. No deben tener bordes decorativos, líneas superiores, laterales ni marcos repetidos; un contorno se admite solo para foco, error, selección o separación funcional indispensable.
- **FR-015**: La interfaz MUST preferir títulos autosuficientes, horas y acciones visibles sobre párrafos explicativos, leyendas repetidas o una tarjeta por cada dato.
- **FR-016**: Todos los objetivos táctiles MUST medir como mínimo 48 por 48 dp, tener nombre accesible, foco visible funcional y orden de lectura lógico.
- **FR-017**: Con texto al 200 %, tema sistema/claro/oscuro y movimiento reducido, MUST conservarse todo el contenido, el orden cronológico, el acceso a cada acción y el contraste requerido por 004.
- **FR-018**: El movimiento MUST limitarse a orientación o confirmación visual, durar como máximo 180 ms, no bloquear acciones y reducirse a opacidad cuando la preferencia del sistema lo solicite.
- **FR-019**: La navegación hacia y desde detalle MUST conservar el día y la sección de origen durante la sesión. Volver nunca debe abrir otra cuenta ni mostrar datos del otro rol.

### Key Entities *(include if feature involves data)*

- **Referencia de trabajo**: objeto visual de muestra que representa un servicio entre Cliente y Proveedor, con identificador, categoría, contraparte, estado y próximo paso; no constituye una contratación real.
- **Estado visual de trabajo**: etapa comprensible para presentar progreso, acción pendiente o cierre, con vocabulario y significado equivalente entre roles cuando corresponda.
- **Compromiso de agenda**: bloque cronológico asociado a una referencia de trabajo, con día, hora o rango, zona pertinente y condición de confirmación.
- **Propuesta de reprogramación**: comparación entre un horario vigente y una o más alternativas, indicando quién la inició y que falta acuerdo.
- **Cronología de muestra**: secuencia corta de eventos o estados visuales; no es un chat, auditoría real ni registro legal.
- **Contexto de rol activo**: Cliente o Proveedor que determina la información y las acciones visibles durante la sesión.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: En una prueba guiada, al menos 9 de cada 10 participantes identifica el próximo compromiso y su estado en menos de 15 segundos desde Actividad.
- **SC-002**: Al menos 9 de cada 10 participantes distingue una propuesta pendiente de un horario confirmado sin ayuda externa.
- **SC-003**: Al menos 9 de cada 10 participantes reconoce si está consultando una vista Cliente o Proveedor antes de abrir una acción.
- **SC-004**: El 100 % de los estados visuales de trabajo comunica significado mediante texto o semántica accesible además de color.
- **SC-005**: Con texto al 200 %, el 100 % de los compromisos y acciones principales permanece visible, alcanzable y sin superposición.
- **SC-006**: El 100 % de las acciones de esta entrega deja claro que es una demostración cuando todavía no existe una operación real.

## Assumptions

- Esta especificación prepara la experiencia visual para R04 y R08, pero no implementa sus reglas, persistencia ni integraciones.
- Las referencias de trabajo de muestra no sustituyen catálogo, solicitud, presupuesto, pago, confirmación de visita ni agenda real; cada capacidad tendrá una especificación y autorización propias.
- El rol activo y los datos básicos de identidad provienen de R02 y de los flujos visuales de 004/005. El alta visual de Proveedor se especificará por separado.
- La contratación familiar, receptor del servicio y coordinación remota se integrarán al detalle de trabajo cuando se especifique R05; este corte solo reserva textos neutros para lugar o zona.
- No se incluyen notificaciones reales. Su contenido, permisos, frecuencia y entrega se definirán en una especificación independiente.

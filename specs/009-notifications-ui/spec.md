# Feature Specification: Avisos y preferencias del Cliente

**Feature Branch**: `009-notifications-ui`

**Created**: 2026-09-15

**Status**: Ready for planning

**Input**: Centro móvil de avisos y preferencias para comunicaciones transaccionales de ServiPronto. Incluye mensajes y eventos del servicio, no promociones, sonidos especiales, recordatorios horarios ni automatizaciones de disponibilidad.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Identificar novedades importantes (Priority: P1)

Una persona abre el centro de avisos desde una cabecera contextual y reconoce rápidamente qué cambió: un mensaje, una actualización del servicio o una acción que requiere atención. Cada aviso lleva a su origen sin mezclarse con publicidad.

**Why this priority**: evita perder eventos de servicios y mensajes sin agregar una pestaña principal de chat ni una bandeja compleja.

**Independent Test**: abrir el centro con avisos nuevos y vistos, reconocer el tipo, entrar a su contexto y volver conservando una indicación de lectura.

**Acceptance Scenarios**:

1. **Given** que existen avisos transaccionales, **When** la persona abre el centro, **Then** los ve en orden reciente, con tipo, resumen breve, momento relativo y destino claro.
2. **Given** un aviso de mensaje, **When** la persona lo elige, **Then** llega a la conversación asociada dentro de Actividad o del servicio, sin exponer números de teléfono.
3. **Given** un aviso de cambio de servicio, **When** la persona lo elige, **Then** llega a la actividad o detalle pertinente, sin afirmar que leyó, aceptó o confirmó el cambio por abrirlo.

---

### User Story 2 - Gestionar avisos de forma simple (Priority: P1)

Una persona puede ver qué avisos fueron atendidos, marcar un aviso individual como no leído y limpiar la atención pendiente sin borrar el historial del servicio ni perder eventos críticos.

**Why this priority**: el centro sigue siendo liviano y útil cuando crece la actividad, sin convertirlo en una lista infinita o una pantalla de configuración técnica.

**Independent Test**: abrir avisos nuevos, marcarlos individualmente como leídos o no leídos, usar la acción global y comprobar que la actividad del servicio no se altera.

**Acceptance Scenarios**:

1. **Given** avisos nuevos y vistos, **When** la persona cambia el estado de uno, **Then** el cambio es visible, entendible sin color exclusivo y no modifica el contenido del servicio original.
2. **Given** varios avisos nuevos, **When** la persona los marca todos como leídos, **Then** recibe una confirmación breve y no se eliminan de la lista por esa sola acción.
3. **Given** un aviso que ya no tiene destino disponible, **When** la persona intenta abrirlo, **Then** recibe una explicación breve y puede volver al centro o a Actividad.

---

### User Story 3 - Elegir cómo recibir avisos transaccionales (Priority: P2)

Una persona revisa en Perfil una preferencia clara para autorizar o pausar avisos de mensajes y servicios. Si el sistema operativo no permite avisos, entiende el motivo y conserva el centro interno como fuente de verdad.

**Why this priority**: respeta la elección de cada persona, especialmente quienes prefieren una experiencia tranquila o tienen poca familiaridad técnica.

**Independent Test**: abrir preferencias, activar o desactivar los avisos transaccionales y simular permiso del dispositivo denegado, sin ocultar el centro interno.

**Acceptance Scenarios**:

1. **Given** una persona en Perfil, **When** abre preferencias de avisos, **Then** entiende en pocas palabras qué comunicaciones transaccionales puede permitir o pausar.
2. **Given** permisos del dispositivo denegados o no disponibles, **When** intenta habilitar avisos, **Then** la interfaz explica el impedimento y ofrece una ruta de ajuste del sistema cuando sea posible, sin prometer que el aviso se enviará.
3. **Given** avisos externos pausados, **When** ocurre un evento dentro de ServiPronto, **Then** el evento sigue disponible en el centro interno y en su contexto de Actividad.

---

### User Story 4 - Reconocer el estado sin alarmas innecesarias (Priority: P2)

Una persona ve estados vacíos, carga, error y agrupación de avisos sin que la aplicación genere ruido visual, urgencias falsas ni interrupciones invasivas. Jorge puede sugerir ayuda dentro de la app, pero no sustituye ni repite los avisos del sistema.

**Why this priority**: el producto debe sentirse vivo y atento sin fatigarnos, especialmente para adultos mayores y personas con sensibilidad a notificaciones.

**Independent Test**: observar el centro sin avisos, en carga y con un error; comprobar que la persona entiende el estado y que la sugerencia de Jorge es discreta, opcional y no duplica el contenido.

**Acceptance Scenarios**:

1. **Given** que no hay avisos, **When** abre el centro, **Then** encuentra un estado vacío amable con una única salida útil a Actividad o Explorar.
2. **Given** que la lista no puede actualizarse, **When** aparece un error, **Then** muestra el último contenido conocido si existe, explica que no pudo actualizar y ofrece reintentar.
3. **Given** una sugerencia proactiva de Jorge, **When** aparece dentro de la aplicación, **Then** es breve, descartable, accesible y no se presenta como un aviso urgente ni como una acción ya realizada.

### Edge Cases

- Avisos repetidos para el mismo evento: presentar una sola entrada comprensible o una agrupación que conserve los cambios relevantes.
- Aviso recibido mientras el centro está abierto: actualizar sin mover el foco ni interrumpir a quien usa lector de pantalla.
- Permiso del sistema revocado después de habilitarlo: reflejar el estado real al volver a preferencias, sin marcar la elección como cumplida si no lo está.
- Destino eliminado, suspendido o sin permiso: no revelar datos privados; explicar la indisponibilidad y ofrecer una salida segura.
- Lista extensa: conservar prioridad temporal, separación visual sin bordes decorativos y acceso a avisos más antiguos sin saturar la primera vista.
- Texto ampliado, tema oscuro, contraste alto o movimiento reducido: contadores, estados de leído y acciones conservan significado sin depender exclusivamente de color, vibración o animación.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La aplicación MUST mostrar un acceso contextual al centro de avisos desde las pantallas que lo necesiten, con un indicador de novedades que no dependa únicamente del color.
- **FR-002**: El centro MUST contener exclusivamente avisos transaccionales de mensajes y eventos de servicio en este alcance; promociones, publicidad, recordatorios de horario, sonidos especiales para urgencias y pausas automáticas de disponibilidad están excluidos.
- **FR-003**: Cada aviso MUST mostrar un tipo identificable, un resumen breve, un momento relativo y un destino; no debe incluir información privada innecesaria ni números de teléfono de contrapartes.
- **FR-004**: La aplicación MUST ordenar los avisos por novedad y diferenciar leído de no leído mediante más de una señal visual o textual.
- **FR-005**: Una persona MUST poder abrir un aviso hacia su conversación, Actividad o detalle relacionado sin que esa navegación equivalga a lectura de un mensaje, aceptación de un cambio o confirmación contractual.
- **FR-006**: Una persona MUST poder marcar un aviso individual como leído o no leído y marcar los pendientes como leídos, sin borrar el historial de actividad ni el aviso por esa sola acción.
- **FR-007**: El centro MUST resolver avisos duplicados o agrupados de manera comprensible, conservando el acceso al evento relevante y evitando una lista ruidosa.
- **FR-008**: La aplicación MUST ofrecer desde Perfil una preferencia simple para autorizar o pausar avisos transaccionales externos, explicando en lenguaje claro que el centro interno continúa disponible.
- **FR-009**: Ante permiso del sistema denegado, revocado o no disponible, la interfaz MUST reflejar el estado real, explicar el límite sin tecnicismos y ofrecer una ruta de ajuste cuando el dispositivo la permita.
- **FR-010**: La aplicación MUST presentar estados de carga, vacío, error recuperable, último contenido conocido y destino no disponible sin prometer entrega, lectura o acciones que no estén confirmadas.
- **FR-011**: Jorge MAY aparecer como viñeta breve y descartable dentro de la aplicación cuando ayude a orientar, pero MUST permanecer opcional, no duplicar avisos transaccionales ni presentarse como alerta urgente.
- **FR-012**: La interfaz MUST utilizar azul dominante de Cliente, naranja de acento, tipografía amable y curvatura continua G2. Botones, superficies y filas no deben usar bordes decorativos ni líneas superior, izquierda, derecha o inferior como recurso de separación.
- **FR-013**: La interfaz MUST priorizar espacio, jerarquía tipográfica y superficies para agrupar avisos; debe evitar texto repetido, leyendas extensas, múltiples banners y tarjetas visualmente idénticas.
- **FR-014**: El centro y preferencias MUST ser utilizables en temas sistema, claro y oscuro, con objetivos táctiles de al menos 48 × 48 dp, foco visible, contraste suficiente, orden de lectura lógico, texto ampliado al 200 % y alternativa sin movimiento.
- **FR-015**: Los cambios de estado, llegada de un aviso y feedback de acciones MUST comunicar lo ocurrido sin sonidos obligatorios ni desplazamientos que impidan leer o tocar; con movimiento reducido se mantiene una señal no animada.

### Key Entities *(include if feature involves data)*

- **Aviso transaccional**: comunicación interna sobre un mensaje o evento de servicio, con tipo, resumen, fecha, destino y estado de atención.
- **Estado de lectura del aviso**: condición individual de nuevo, leído o marcado nuevamente como no leído; es distinta de la lectura de un mensaje del chat.
- **Preferencia de avisos**: elección de la persona sobre avisos externos transaccionales, separada del permiso efectivo del dispositivo.
- **Permiso del dispositivo**: disponibilidad real otorgada por el sistema operativo para entregar avisos externos.
- **Destino de aviso**: conversación, actividad o detalle al que un aviso puede conducir si permanece autorizado y disponible.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: En una prueba moderada de cinco personas, al menos cuatro identifican qué avisos son nuevos, abren su origen y regresan al centro sin ayuda externa.
- **SC-002**: En una revisión de contenido, el 100 % de los avisos de muestra puede entenderse con su tipo y resumen en una sola mirada, sin más de dos líneas de texto principal.
- **SC-003**: En pruebas con permiso concedido, denegado y revocado, el 100 % de las pantallas comunica el estado real sin prometer entrega externa; el centro interno queda disponible en todos los casos.
- **SC-004**: En pruebas de lista vacía, error, destino no disponible y avisos repetidos, el 100 % ofrece una salida recuperable o contexto alternativo sin eliminar información del historial del servicio.
- **SC-005**: En temas claro y oscuro, texto al 200 %, lector de pantalla y movimiento reducido, las acciones para abrir, marcar leído/no leído, reintentar y ajustar preferencias siguen siendo identificables y operables.

## Assumptions

- Esta especificación depende de la navegación Cliente de 004 y se conectará a conversaciones y actividad cuando esas capacidades existan; no define el backend de envío ni un proveedor de avisos.
- Los avisos transaccionales de mensajes y servicios continúan acordados; los extras aplazados en D-24 se mantienen explícitamente fuera de este primer alcance.
- La entrega externa no garantiza lectura y no sustituye las confirmaciones de una contratación, cambio de precio, pago o etapa.
- Las preferencias se redactan para Cliente en esta entrega. El proveedor podrá reutilizar el patrón con sus propios eventos en una especificación posterior.
- Políticas de retención, canales exactos, límites de frecuencia y notificaciones promocionales requieren definición posterior antes de una integración de producción.

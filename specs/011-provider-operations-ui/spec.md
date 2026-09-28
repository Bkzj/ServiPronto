# Feature Specification: Operación visual del proveedor

**Feature Branch**: `011-provider-operations-ui`  
**Created**: 2026-09-15  
**Status**: Ready for planning  
**Input**: Recorrido móvil visual para que un Proveedor aprobado vea su inicio de trabajo, elija entre estar disponible o pausado, consulte oportunidades, organice agenda y trabajos, y revise su perfil operativo. Usa información y cambios de muestra explícitamente identificados. No acepta solicitudes, no contrata, no cobra, no chatea ni rastrea ubicaciones.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Entender el día de trabajo (Priority: P1)

Una persona Proveedora abre la aplicación y entiende en una mirada si tiene un próximo compromiso, una oportunidad de muestra o una acción pendiente de su perfil. La pantalla prioriza una sola decisión útil en vez de repetir métricas, tarjetas o explicaciones.

**Why this priority**: el inicio de trabajo convierte la aplicación en una herramienta cotidiana para el proveedor, incluso antes de tener operación conectada.

**Independent Test**: abrir Inicio de trabajo con contenido de muestra y localizar el próximo compromiso, el estado de disponibilidad y una oportunidad en menos de tres toques.

**Acceptance Scenarios**:

1. **Given** un Proveedor aprobado con datos de muestra, **When** abre Inicio de trabajo, **Then** ve primero la información más cercana en el tiempo y una sola acción principal contextual.
2. **Given** un Proveedor sin agenda ni oportunidades de muestra, **When** abre Inicio de trabajo, **Then** encuentra un estado vacío útil que explica qué aparecerá allí y ofrece revisar disponibilidad o perfil, sin una pantalla desierta.
3. **Given** un perfil con una acción pendiente de muestra, **When** la pantalla la muestra, **Then** diferencia ese pendiente de un trabajo u oportunidad sin usar solo color ni presentarlo como un bloqueo real.

---

### User Story 2 - Elegir disponibilidad sin falsas promesas (Priority: P1)

Una persona Proveedora puede indicar visualmente que está disponible o pausada. Comprende que, en este corte, el cambio solo actualiza el estado de demostración de su pantalla y no le asigna ni le quita trabajos reales.

**Why this priority**: la disponibilidad es una decisión operativa básica y debe ser clara antes de conectar despacho, cobertura o alertas.

**Independent Test**: alternar entre Disponible y Pausado en contenido de muestra, abandonar y volver a Inicio de trabajo; comprobar que el estado, la explicación y la acción inversa son coherentes durante la sesión.

**Acceptance Scenarios**:

1. **Given** un Proveedor disponible de muestra, **When** elige pausar, **Then** el estado visible cambia a “Pausado”, explica brevemente que es una demostración y ofrece volver a estar disponible.
2. **Given** un Proveedor pausado de muestra, **When** elige estar disponible, **Then** la interfaz muestra “Disponible” mediante texto, icono y semántica accesible, sin afirmar que recibirá una solicitud.
3. **Given** una persona que intenta cambiar su disponibilidad sin conexión, **When** realiza la acción, **Then** el último estado conocido se conserva y se explica que el cambio no pudo confirmarse; no se inventa una actualización exitosa.

---

### User Story 3 - Consultar oportunidades sin aceptarlas (Priority: P1)

Una persona Proveedora reconoce oportunidades de servicio de muestra, las distingue de compromisos ya agendados y abre una ficha breve para entender categoría, modalidad, zona y momento solicitado. Puede explorar la interfaz sin que una pulsación constituya aceptación o comunicación con Cliente.

**Why this priority**: la futura toma de trabajos necesita una jerarquía visual transparente; ensayarla sin efectos comerciales evita confundir interés con compromiso.

**Independent Test**: desde Inicio de trabajo abrir Oportunidades, distinguir una oportunidad nueva de una visita programada y volver sin registrar una decisión.

**Acceptance Scenarios**:

1. **Given** una lista de oportunidades de muestra, **When** la persona la consulta, **Then** cada fila comunica servicio, modalidad, zona de nivel pertinente, momento solicitado y estado visual sin dirección precisa ni datos de contacto.
2. **Given** una oportunidad de muestra, **When** abre su detalle, **Then** ve una descripción corta, necesidades declaradas e información de agenda pertinente, junto con una acción de demostración que no acepta, rechaza ni reserva el servicio.
3. **Given** que no hay oportunidades de muestra, **When** abre la sección, **Then** ve un estado vacío que no culpa a la persona ni promete que aparecerán pedidos al activar disponibilidad.
4. **Given** una oportunidad que se vuelve indisponible en el contenido de muestra, **When** intenta abrirla, **Then** recibe una explicación breve y vuelve a la lista preservando su contexto.

---

### User Story 4 - Organizar agenda y trabajos de muestra (Priority: P1)

Una persona Proveedora recorre el día, los próximos compromisos y el historial visual desde una vista de actividad propia. Puede abrir un detalle y una propuesta de reprogramación de muestra sin alterar horarios, disponibilidad ni acuerdos.

**Why this priority**: agenda y actividad son el soporte de la puntualidad y de la operación multirrubro; el proveedor necesita entenderlas sin una grilla compleja.

**Independent Test**: seleccionar un día, identificar dos compromisos de muestra, abrir un detalle y reconocer una reprogramación pendiente sin modificar ninguna referencia.

**Acceptance Scenarios**:

1. **Given** una agenda de muestra, **When** la persona selecciona un día, **Then** ve los compromisos en orden cronológico y las franjas sin compromisos, sin tener que interpretar una vista mensual obligatoria.
2. **Given** una referencia con horario por confirmar, **When** se presenta junto a compromisos fechados, **Then** se muestra separada y no se ordena como si tuviera una hora definida.
3. **Given** un trabajo de muestra con una propuesta de reprogramación, **When** abre el detalle, **Then** distingue horario vigente, propuesta, iniciador y estado “Esperando acuerdo”, sin dar a entender que el cambio ya se realizó.
4. **Given** que toca una acción de trabajo, agenda o reprogramación todavía no conectada, **When** intenta continuar, **Then** recibe un feedback breve de demostración y ningún dato real se crea, modifica o elimina.

---

### User Story 5 - Revisar el perfil operativo (Priority: P2)

Una persona Proveedora encuentra en Perfil la información que condiciona su operación: estado de aprobación, categoría principal, zonas de cobertura, modalidades, disponibilidad y próximo dato útil. No necesita revisar un formulario entero ni interpreta el perfil como una promesa pública de ranking o verificación.

**Why this priority**: el perfil operativo conecta lo declarado en el alta con lo que el proveedor verá a diario, manteniendo clara la diferencia entre datos de perfil y oportunidades.

**Independent Test**: abrir Perfil desde el recorrido proveedor con contenidos de muestra; identificar aprobación, categoría y cobertura, y comprender qué sección editaría sin modificar datos persistentes.

**Acceptance Scenarios**:

1. **Given** un Proveedor aprobado de muestra, **When** abre Perfil, **Then** reconoce su estado, categoría inicial, cobertura, modalidades y disponibilidad sin repetir esos datos en tarjetas separadas.
2. **Given** un Proveedor en revisión, requiere cambios, rechazado o suspendido de muestra, **When** abre Perfil u operación, **Then** ve un estado explícito y una siguiente orientación segura; no se muestra como disponible ni con oportunidades operables.
3. **Given** una matrícula declarada de muestra, **When** se muestra en Perfil, **Then** se presenta como información declarada y no como una verificación, habilitación ni ventaja de ranking.
4. **Given** una persona que intenta editar un dato operativo en este corte, **When** toca la acción correspondiente, **Then** comprende que la edición real se conectará al alta/perfil y conserva el contenido de muestra.

---

### User Story 6 - Mantener una operación legible y accesible (Priority: P2)

Una persona, incluso con texto grande, tema oscuro, lector de pantalla o movimiento reducido, puede identificar disponibilidad, oportunidad, compromiso y próxima acción sin depender de animaciones, color o una lectura extensa.

**Why this priority**: la herramienta de trabajo debe ser tranquila y verificable en momentos de atención, no solamente atractiva en condiciones ideales.

**Independent Test**: recorrer Inicio de trabajo, disponibilidad, oportunidades, agenda y Perfil con texto al 200 %, lector de pantalla, tema claro/oscuro y movimiento reducido; comprobar que los estados y acciones mantienen contexto.

**Acceptance Scenarios**:

1. **Given** texto al 200 %, **When** se presenta un día con varios compromisos y oportunidades, **Then** servicio, horario, estado y acción permanecen visibles sin superposición ni recorte.
2. **Given** lector de pantalla, **When** explora disponibilidad, oportunidad o compromiso, **Then** cada control anuncia su propósito, estado actual y destino de forma comprensible.
3. **Given** movimiento reducido, **When** alterna disponibilidad, cambia de día o abre un detalle, **Then** conserva orientación sin desplazamientos decorativos, vibración automática ni información solamente animada.

### Edge Cases

- El proveedor no está aprobado, está suspendido o no tiene una categoría habilitada: se prioriza el estado de cuenta y una orientación segura; se ocultan las acciones de disponibilidad y oportunidades que darían una impresión operativa falsa.
- Hay compromisos superpuestos en la agenda de muestra: ambos muestran hora completa y una advertencia textual; la interfaz no intenta decidir cuál cancelar, mover o priorizar.
- Una oportunidad o referencia de trabajo contiene una zona extensa o información privada: se muestra solo la zona útil para operar; no se exponen dirección exacta, teléfono, foto personal ni ubicación en tiempo real.
- La lista de oportunidades es extensa: conserva orden y contexto con carga gradual visual; no obliga a desplazarse por una serie de tarjetas decorativas ni simula urgencia con cuenta regresiva.
- El cambio de rol activo ocurre durante una consulta: se descarta el contexto visual de Proveedor antes de mostrar el de Cliente, para no revelar oportunidades, agenda o perfil de la otra cuenta.
- La conexión falla o el contenido de muestra no carga: se conserva el último estado conocido si existe, se explica el límite y se ofrece reintentar sin afirmar que el estado de disponibilidad se actualizó.
- Tema oscuro, contraste alto, texto aumentado, lector de pantalla o movimiento reducido: disponibilidad, aprobación, oportunidad, agenda y error mantienen una señal textual y accesible además del color.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La aplicación MUST ofrecer un recorrido de operación propio para una cuenta Proveedor aprobada, con Inicio de trabajo, disponibilidad, oportunidades, agenda/actividad y Perfil operativo; las etiquetas, jerarquía y contenido deben diferenciarse del recorrido Cliente, no solo invertir colores.
- **FR-002**: Inicio de trabajo MUST priorizar una síntesis breve del día: próximo compromiso, oportunidad o dato de perfil más relevante. Debe presentar una sola acción principal contextual y omitir bloques vacíos, métricas sin decisión y leyendas repetidas.
- **FR-003**: La interfaz MUST representar los estados visuales de disponibilidad “Disponible” y “Pausado”, junto con una explicación de una línea sobre su alcance de demostración. Cada estado debe tener texto, icono o semántica accesible además del color.
- **FR-004**: Cambiar la disponibilidad en esta entrega MUST afectar exclusivamente el contenido visual de la sesión o de muestra. No debe activar despacho, cobertura real, alertas, asignación, visibilidad pública, aceptación ni ninguna promesa de recibir trabajo.
- **FR-005**: La sección Oportunidades MUST listar referencias de muestra separadas de compromisos de agenda. Cada referencia puede mostrar categoría, modalidad, zona pertinente, momento solicitado, resumen y estado visual, pero no dirección precisa, teléfono, datos de contacto ni ubicación en tiempo real.
- **FR-006**: Abrir una oportunidad de muestra MUST mostrar una ficha corta que deje claro que todavía no existe aceptación, reserva, contratación, contacto ni compromiso. Las acciones del detalle solo pueden demostrar navegación o feedback local.
- **FR-007**: La interfaz MUST incluir estados útiles para: sin oportunidades, oportunidad no disponible, contenido cargando, error recuperable y último contenido conocido. Ninguno debe culpar al proveedor, prometer nuevas oportunidades ni dejar la pantalla sin salida.
- **FR-008**: La agenda MUST permitir consultar el día actual, otros días cercanos, compromisos cronológicos, franjas libres y elementos con horario a confirmar. No debe requerir una grilla mensual ni convertir franjas libres en disponibilidad real.
- **FR-009**: Actividad y detalle de trabajo MUST usar referencias de muestra coherentes con 007: servicio, contraparte con identidad necesaria, zona o modalidad pertinente, fecha u horario, estado, cronología corta y próxima acción visual. No deben revelar datos de otro rol ni crear un registro operativo real.
- **FR-010**: Una propuesta de reprogramación de muestra MUST distinguir horario vigente, propuesta, iniciador y estado pendiente. Seleccionar, confirmar o descartar una alternativa en esta entrega no puede modificar trabajos, agenda, disponibilidad ni acuerdos.
- **FR-011**: Perfil operativo MUST mostrar estado de aprobación, categoría principal, cobertura, modalidades, disponibilidad y próximo paso de perfil en una composición escaneable. Una matrícula declarada, si aparece, debe llamarse declarada y no indicar verificación, habilitación, ranking ni prioridad.
- **FR-012**: Los estados de perfil Incompleto, En revisión, Requiere cambios, Aprobado, Rechazado y Suspendido MUST ser distinguibles con texto y semántica además de color. Solo Aprobado puede presentar el recorrido operativo de muestra como disponible; los otros estados deben explicar una siguiente orientación y no ofrecer oportunidades operables.
- **FR-013**: Todas las acciones sin capacidad conectada, incluidas editar perfil, responder una oportunidad, modificar agenda, confirmar reprogramación o cambiar disponibilidad, MUST devolver un feedback corto de demostración y no crear, aceptar, rechazar, pausar, publicar, cancelar ni modificar datos reales.
- **FR-014**: Esta entrega MUST excluir aceptación o rechazo contractual de solicitudes, contratación, pagos, señas, importes, presupuestos, cobros, comisión, chat real, envío de mensajes, llamadas, notificaciones reales, confirmaciones por código, seguimiento de llegada/salida, GPS, tracking, mapa, reputación, ranking, favoritos, publicidad y despacho o matching real.
- **FR-015**: Jorge MAY aparecer como una única viñeta comic breve, opcional y contextual para orientar disponibilidad, agenda o perfil. No debe iniciar un chat real, tomar decisiones, afirmar que encontró o aceptó un trabajo, ni sustituir las acciones manuales.
- **FR-016**: El recorrido Proveedor MUST usar naranja dominante y azul como acento, tipografía amable, curvas continuas G2 y superficies limpias. Botones, controles, tarjetas, filas y contenedores no deben usar bordes decorativos, líneas superiores, laterales o marcos perimetrales repetidos.
- **FR-017**: La jerarquía visual MUST construirse con espacio, tamaños tipográficos, color, elevación, agrupación y superficie. Un contorno se permite solo para foco, error, selección o separación funcional indispensable, no como ornamento.
- **FR-018**: La interfaz MUST utilizar títulos que expliquen cada bloque y contenido breve que destrabe la siguiente acción; debe evitar párrafos genéricos, leyendas redundantes, carruseles de tarjetas y una tarjeta por cada dato.
- **FR-019**: Todos los objetivos táctiles MUST medir al menos 48 por 48 dp, tener nombre accesible, foco visible funcional, orden de lectura lógico y estado seleccionado o expandido comprensible.
- **FR-020**: Con tema sistema, claro u oscuro, texto al 200 %, contraste alto, lector de pantalla o movimiento reducido, MUST conservarse la información, la prioridad temporal, las acciones y el significado de todos los estados. No puede dependerse únicamente de color, vibración o animación.
- **FR-021**: El movimiento MUST apoyar orientación o confirmación local, durar como máximo 180 ms y no bloquear una acción. Cuando se solicite movimiento reducido, debe limitarse a cambios de opacidad sin desplazamiento decorativo.
- **FR-022**: Al volver desde oportunidad, agenda, detalle o Perfil, la aplicación MUST conservar durante la sesión el día, sección y posición de origen del Proveedor. Cambiar a Cliente o perder autorización debe limpiar ese contexto antes de presentar datos del otro rol.

### Key Entities *(include if feature involves data)*

- **Inicio de trabajo**: síntesis operativa visual del proveedor con la información de muestra más relevante del día y una acción contextual.
- **Estado de disponibilidad visual**: condición local de demostración Disponible o Pausado; no equivale a cobertura, despacho, visibilidad pública ni compromiso de trabajo.
- **Oportunidad de muestra**: referencia visual de una necesidad potencial, con categoría, modalidad, zona, momento y resumen; no representa una oferta aceptable ni una contratación.
- **Compromiso de agenda**: bloque cronológico de muestra asociado a una referencia de trabajo, con día, horario o rango y estado de confirmación visual.
- **Referencia de trabajo**: objeto visual compartido con Actividad de 007 que representa un servicio y su estado; no constituye una visita, acuerdo, pago o registro real.
- **Perfil operativo**: síntesis de los datos que condicionan la operación visual del proveedor, incluidos estado de aprobación, categoría, cobertura, modalidades y disponibilidad.
- **Contexto de proveedor aprobado**: condición visual necesaria para mostrar operación de muestra; los estados no aprobados solo muestran su orientación segura.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: En una prueba guiada, al menos 9 de cada 10 participantes identifica disponibilidad, próximo compromiso y una oportunidad de muestra en menos de 20 segundos desde Inicio de trabajo.
- **SC-002**: Al menos 9 de cada 10 participantes distingue una oportunidad de muestra de una visita programada y reconoce que ninguna acción de este corte acepta un trabajo.
- **SC-003**: El 100 % de los estados de disponibilidad, aprobación, oportunidad, agenda y error comunica significado con texto o semántica accesible además de color.
- **SC-004**: En una prueba de recorrido, al menos 9 de cada 10 participantes localiza el día actual, abre un compromiso y vuelve al mismo día y sección sin ayuda.
- **SC-005**: Con texto al 200 %, temas claro y oscuro, lector de pantalla y movimiento reducido, el 100 % de las acciones principales, estados y referencias de muestra permanece visible, identificable y operable.
- **SC-006**: El 100 % de los controles de esta entrega que aún no tienen una operación real comunica que es una demostración y no registra una aceptación, cambio de disponibilidad, reprogramación ni edición real.

## Assumptions

- Este corte depende del alta y perfil visual de Proveedor (010) y reutiliza las convenciones de Actividad/agenda (007), pero no implementa sus datos, persistencia, permisos ni reglas de negocio.
- El recorrido se habilita visualmente para un Proveedor Aprobado de muestra. Los demás estados se muestran para preparar sus mensajes y restricciones, sin definir aquí la revisión administrativa.
- Las oportunidades y trabajos de muestra se redactan como información mínima necesaria para operar y no sustituyen catálogo, matching, aceptación, conversación, visita, presupuesto, pago, contratación familiar o reputación.
- La disponibilidad real, sus radios, su interacción con agenda, tiempos de traslado, preferencias de urgencia y notificaciones requerirán especificaciones de negocio y validaciones posteriores antes de conectarse.
- Jorge conserva su identidad cálida y opcional; su conversación, herramientas, imágenes y efectos reales se definen por separado en 008 y R09.

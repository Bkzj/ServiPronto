# Feature Specification: Panel administrativo inicial

**Feature Branch**: `012-admin-operations-ui`

**Created**: 2026-09-15

**Status**: Ready for planning

**Input**: Panel web privado, pensado para pantalla amplia, que permite revisar altas de proveedores, administrar la visibilidad de categorías y promociones preparadas, y consultar métricas iniciales. Es una herramienta operativa manual para el equipo de ServiPronto, no un editor general de reglas ni una consola de datos sensibles.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Resolver una alta de proveedor con contexto (Priority: P1)

Una persona administradora autorizada abre las altas pendientes, encuentra primero las que necesitan revisión y decide aprobar, pedir cambios o rechazar después de leer la información declarada por el proveedor. La decisión siempre deja un motivo claro para la persona proveedora y una traza para la operación.

**Why this priority**: la revisión manual es la barrera inicial para que solamente proveedores aprobados se presenten al público o reciban oportunidades.

**Independent Test**: con altas en los estados En revisión, Requiere cambios y Rechazado, filtrar una categoría, abrir una ficha, resolverla y comprobar el nuevo estado y la entrada de historial.

**Acceptance Scenarios**:

1. **Given** una persona administradora con acceso autorizado y una lista de altas en revisión, **When** abre el panel, **Then** identifica cuántas necesitan atención, sus categorías y el estado actual sin recorrer una tabla sobrecargada.
2. **Given** una alta En revisión, **When** abre su ficha, **Then** ve únicamente la información profesional declarada necesaria para decidir: identidad visible de trabajo, categoría inicial, tareas, modalidades, cobertura, disponibilidad, experiencia, precio y matrícula declarada si existe.
3. **Given** una ficha En revisión completa, **When** la administradora aprueba, pide cambios o rechaza con motivo, **Then** el estado cambia de forma explícita, se registra quién tomó la decisión y el proveedor recibe el motivo en su próximo recorrido habilitado.
4. **Given** una alta suspendida, rechazada o ya aprobada, **When** la administradora intenta aplicar una transición no permitida, **Then** el panel explica brevemente por qué no está disponible y no altera el historial.

---

### User Story 2 - Dar seguimiento a una revisión sin perder trazabilidad (Priority: P1)

Una persona administradora entiende qué ocurrió antes en una alta: presentación, pedidos de cambio y decisiones. Puede retomar una revisión devuelta con la información actual sin confundir el historial con una nueva resolución.

**Why this priority**: para un equipo de dos personas, la trazabilidad corta evita decisiones contradictorias, soporte manual y re-trabajo.

**Independent Test**: usar una alta que fue enviada, devuelta con cambios y reenviada; revisar la línea temporal y confirmar que la decisión actual no oculta los hitos anteriores.

**Acceptance Scenarios**:

1. **Given** una alta con más de una instancia de revisión, **When** se abre la ficha, **Then** la línea temporal distingue envío, pedido de cambios y decisión por fecha, actor y motivo breve.
2. **Given** una administradora que necesita distinguir información anterior de la actual, **When** consulta una ficha reenviada, **Then** ve cuál es la declaración vigente y conserva acceso de solo lectura a los motivos anteriores.
3. **Given** una decisión tomada, **When** la administradora regresa a la lista, **Then** el conteo, el estado y los filtros reflejan el resultado sin afirmar que el proveedor fue notificado por un canal externo.

---

### User Story 3 - Publicar contenido preparado sin afectar el ranking (Priority: P2)

Una persona administradora habilita u oculta categorías ya preparadas para Tandil y rota una promoción de ServiPronto de muestra. Puede ver dónde aparecerá el contenido antes de publicarlo y diferenciarlo del orden orgánico de proveedores.

**Why this priority**: el catálogo y el espacio promocional necesitan operaciones simples durante el lanzamiento, sin abrir un sistema editorial complejo ni un modelo de pago por posiciones.

**Independent Test**: ocultar y volver a publicar una categoría preparada; cambiar la promoción de Inicio entre piezas de muestra; revisar que el resultado se identifica como promoción de ServiPronto y no modifica ningún orden orgánico.

**Acceptance Scenarios**:

1. **Given** una categoría preparada, **When** la administradora cambia su visibilidad, **Then** el panel muestra de manera inequívoca si está pública u oculta y conserva una razón operativa opcional para el cambio.
2. **Given** una promoción de muestra en borrador, **When** la administradora la previsualiza y publica, **Then** ve título, pieza visual, destino y período de visibilidad antes de confirmar.
3. **Given** que existe una promoción activa, **When** una nueva promoción se publica para el mismo espacio, **Then** el panel solicita una decisión explícita de reemplazo o programación; nunca mantiene dos activas por accidente en el mismo espacio.
4. **Given** una categoría oculta o una promoción retirada, **When** se consulta su historial operativo, **Then** permanece identificable para administración y deja de ofrecerse al recorrido público correspondiente.

---

### User Story 4 - Consultar el pulso inicial de la operación (Priority: P2)

Una persona administradora abre un resumen breve de cantidades y detecta si faltan proveedores aprobados, si se acumulan revisiones o qué categorías y zonas tienen menos cobertura. Los datos no inventan conversión, ingresos ni eventos que todavía no existen.

**Why this priority**: el fundador necesita un único lugar para observar cantidades operativas durante la prueba cerrada y priorizar el trabajo manual.

**Independent Test**: abrir el tablero con datos de prueba y sin datos; consultar altas, aprobaciones y disponibilidad por categoría/zona; verificar que las cifras tienen período y estado de actualización identificables.

**Acceptance Scenarios**:

1. **Given** datos operativos disponibles, **When** la administradora abre el resumen, **Then** ve cantidades de cuentas, proveedores por estado, altas pendientes y disponibilidad por categoría y zona, con período de consulta visible.
2. **Given** que un indicador no tiene todavía datos suficientes o no existe su fuente, **When** se muestra en el panel, **Then** aparece como no disponible o sin datos, nunca como cero ni como una tendencia simulada.
3. **Given** una administradora que detecta una categoría con oferta baja, **When** selecciona el indicador, **Then** llega a una lista o filtro operacional relacionado, sin presentar una recomendación automática como decisión tomada.

### Edge Cases

- Dos administradores intentan resolver la misma alta: antes de confirmar, el panel valida el estado vigente y muestra que otra persona ya la resolvió si corresponde; no duplica la decisión.
- Una alta está incompleta, tiene campos demasiado largos o una categoría dejó de estar habilitada: se muestra el dato disponible, el límite de operación y una acción segura para pedir cambios o volver a la lista.
- La sesión vence, el acceso no está autorizado o la conexión falla: no se exponen datos de la ficha; se conserva el contexto visual no sensible cuando sea seguro y se solicita volver a ingresar o reintentar.
- Una persona intenta abrir una URL de ficha sin permiso: el panel no revela nombre, correo, teléfono, domicilio, documentos ni motivo de revisión.
- La lista de revisiones es larga: filtros por estado, categoría, zona y antigüedad permiten encontrar casos, conservando una vista inicial breve y sin desplazamiento horizontal obligatorio.
- Una promoción no tiene pieza visual válida, destino o período coherente: no puede publicarse y el problema se comunica junto al campo afectado, no solo por color.
- Tema oscuro, zoom del navegador al 200 %, navegación por teclado, lector de pantalla o movimiento reducido: las tablas, filtros, diálogos y confirmaciones conservan orden, foco y acciones equivalentes.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema MUST restringir este panel a sesiones administrativas autenticadas y autorizadas; no debe existir autorregistro público ni una ruta de administración visible dentro de la experiencia Cliente o Proveedor.
- **FR-002**: Cada acceso a la ficha de una alta y cada decisión administrativa MUST registrar actor, momento, entidad consultada o modificada y finalidad operativa. La finalidad de una decisión se expresa mediante su motivo; no se requiere un editor libre de permisos en este alcance.
- **FR-003**: El panel MUST presentar una bandeja inicial de altas de proveedor con conteos y filtros por estado, categoría, zona y antigüedad. Los estados admitidos son Incompleto, En revisión, Requiere cambios, Aprobado, Rechazado y Suspendido.
- **FR-004**: La ficha de revisión MUST mostrar solamente datos declarados relevantes para el alta: nombre profesional visible, categoría inicial, tareas, modalidades, cobertura, disponibilidad, experiencia, precio de la categoría y matrícula declarada opcional. No debe incluir DNI, selfie, antecedentes, domicilio preciso, datos bancarios, archivos sensibles ni sus previsualizaciones.
- **FR-005**: El panel MUST permitir aprobar, pedir cambios y rechazar una alta En revisión. Pedir cambios y rechazar MUST requerir un motivo breve; aprobar MAY incluir una nota interna opcional que no se muestra al proveedor.
- **FR-006**: El sistema MUST validar que las transiciones de estado permitidas sean explícitas y no permitir desde este panel reactivar una cuenta Suspendida, aprobar una alta Rechazada ni resolver una ficha con estado desactualizado.
- **FR-007**: Al aprobar una alta, el panel MUST expresar que el proveedor queda habilitado para ser visible y recibir oportunidades cuando el resto de los módulos correspondientes lo conecten. No debe afirmar que ya existe un perfil público, un trabajo o una notificación externa si todavía no está confirmado.
- **FR-008**: Cada ficha MUST incluir una línea temporal de solo lectura con presentación, reenvíos, pedidos de cambios y decisiones. Cada hito debe conservar fecha, actor, estado resultante y motivo aplicable.
- **FR-009**: Las listas y fichas MUST distinguir la declaración vigente de los motivos históricos, sin permitir editar retrospectivamente la decisión tomada ni ocultar trazabilidad.
- **FR-010**: El panel MUST permitir ocultar o publicar categorías generales ya preparadas. No debe crear subcategorías, editar requisitos por oficio, cambiar comisiones, preguntas, radios, reglas de elegibilidad ni algoritmos de ranking.
- **FR-011**: El panel MUST ofrecer una biblioteca limitada de promociones de muestra de ServiPronto, con estado de borrador, programada, activa u ocultada; cada pieza incluye título breve, recurso visual, destino interno o externo, espacio de publicación y período de visibilidad.
- **FR-012**: La publicación de promociones MUST usar una previsualización y una confirmación explícita para reemplazar o programar contenido del mismo espacio. Una promoción MUST identificarse como contenido promocional de ServiPronto y no puede modificar el ranking ni fingir recomendación neutral de Jorge.
- **FR-013**: El tablero inicial MUST mostrar cantidades, no metas porcentuales ni estimaciones: cuentas, proveedores por estado, altas pendientes, aprobados y disponibilidad por categoría y zona. Debe indicar período consultado, hora de actualización y ausencia de datos cuando corresponda.
- **FR-014**: Las métricas iniciales MUST conducir a filtros o listas operativas relacionadas cuando exista destino disponible. Solicitudes, visitas, presupuestos, pagos, incidencias, conversaciones, atribución de Jorge, exportaciones y métricas publicitarias quedan excluidos de este primer corte.
- **FR-015**: El panel MUST ofrecer estados de carga, vacío, error recuperable, datos obsoletos y conflicto de actualización; ninguna pantalla debe presentar como confirmada una operación cuyo resultado no se conoce.
- **FR-016**: La interfaz MUST usar una composición de escritorio amplia con navegación lateral contextual, área principal con foco en la tarea y detalle en panel o vista dedicada. En pantallas más angostas, el contenido se refluye sin requerir desplazamiento horizontal para decidir una revisión.
- **FR-017**: La interfaz MUST mantener el sistema visual ServiPronto con naranja dominante de operación, azul como acento funcional, tipografía amable, superficies limpias y curvatura continua G2. Botones, tarjetas, filas y paneles no deben usar bordes decorativos ni líneas en los lados, arriba o abajo como recurso visual principal.
- **FR-018**: La jerarquía MUST surgir de espacio, agrupación, tipografía, superficie, elevación suave y contraste. Los bordes se permiten solamente para foco de teclado, error, selección, tablas de datos cuando sean indispensables o separación funcional accesible.
- **FR-019**: Los textos MUST ser breves, accionables y no repetir información entre encabezados, métricas, tarjetas y diálogos. Los títulos deben explicar por sí mismos el bloque que encabezan.
- **FR-020**: El panel MUST ser utilizable en tema sistema, claro y oscuro, con contraste suficiente, foco visible, navegación completa por teclado, nombres accesibles, lector de pantalla, zoom/texto al 200 % y alternativa con movimiento reducido.
- **FR-021**: Los cambios de sección, filtros, diálogos y confirmaciones MAY usar transiciones de hasta 180 ms que no bloqueen interacción. Con movimiento reducido, se limitan a opacidad o se eliminan, preservando la confirmación textual.
- **FR-022**: Este corte MUST excluir acceso a conversaciones, pagos, cobros, documentación sensible, verificación documental, automatizaciones, integración de WhatsApp, gestión general de permisos, suspensión de cuentas, editor universal de reglas, exportaciones y acciones masivas.

### Key Entities *(include if feature involves data)*

- **Ficha de alta de proveedor**: vista administrativa de la declaración profesional vigente y de su estado de revisión, limitada a los datos necesarios para decidir el alta.
- **Decisión de revisión**: resultado manual de aprobar, pedir cambios o rechazar, con actor, momento, motivo obligatorio cuando corresponde y nota interna opcional de aprobación.
- **Historial de revisión**: secuencia inmutable de presentaciones, reenvíos, pedidos de cambios y decisiones asociada a un proveedor.
- **Categoría preparada**: categoría general definida por ServiPronto cuyo estado público puede ser visible u oculto; no es una subcategoría ni regla configurable.
- **Promoción de muestra**: contenido propio de ServiPronto con estado, pieza, destino, espacio y período. No compra ni altera posiciones orgánicas.
- **Indicador operativo**: cantidad con definición, período y hora de actualización, vinculada opcionalmente a una lista filtrada; no representa una meta ni una decisión automática.
- **Registro de acceso administrativo**: traza de acceso o consulta operativa con persona administradora, momento, entidad y finalidad, sin copiar datos sensibles al registro.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: En una prueba moderada con cinco personas administradoras o equivalentes, al menos cuatro encuentran y resuelven una alta En revisión con motivo correcto en menos de tres minutos, sin ayuda externa.
- **SC-002**: El 100 % de las decisiones de prueba deja actor, fecha, estado resultante y motivo cuando el flujo lo exige; ningún intento de transición no permitida modifica el estado ni el historial.
- **SC-003**: En una revisión de privacidad, el 100 % de las fichas y listas de este corte excluye DNI, selfie, antecedentes, domicilio preciso, datos de cobro, chat y archivos sensibles.
- **SC-004**: En escenarios de categoría y promoción, el 100 % de las publicaciones activas tiene un único espacio, estado y período coherentes; ninguna promoción de muestra cambia u ocupa un resultado orgánico de proveedor.
- **SC-005**: En un tablero con datos, sin datos y datos obsoletos, el 100 % de los indicadores distingue valor, período y actualización o ausencia de fuente sin mostrar ceros o tendencias ficticias.
- **SC-006**: Con tema claro u oscuro, zoom al 200 %, teclado, lector de pantalla y movimiento reducido, el 100 % de las acciones críticas para filtrar, abrir, decidir, publicar u ocultar sigue siendo identificable y operable.

## Assumptions

- La autenticación administrativa existente y los límites de módulo definidos en 002 se reutilizarán, pero esta especificación no define proveedores de identidad, recuperación de credenciales ni la matriz futura de roles administrativos.
- El perfil de proveedor y su alta visual se preparan en 010; esta especificación consume su declaración y estados, sin duplicar su captura ni habilitar documentos sensibles.
- Las categorías de lanzamiento siguen siendo generales y se habilitan gradualmente según la oferta real. La zona inicial de referencia es Tandil; su definición geográfica detallada queda fuera de la interfaz administrativa inicial.
- Las promociones son contenido propio de ServiPronto de muestra. Publicidad de terceros, venta de posiciones, compras de materiales y medición publicitaria requieren una especificación posterior.
- El tablero usa información realmente disponible y debe preferir ausencia explícita antes que una métrica derivada sin definición. Las metas y ventanas de medición se fijarán a partir de la línea de base de la beta.
- La suspensión, denuncias, casos de soporte, conversaciones y pagos tendrán flujos administrativos separados. Esta entrega no infiere ni implementa esas facultades.

# Feature Specification: Flujo visual inicial del cliente

**Feature Branch**: `004-client-app-shell`

**Created**: 2026-09-15

**Status**: Ready for planning

**Input**: Primer recorrido móvil navegable de ServiPronto: Inicio, Explorar, Jorge, Actividad y Perfil; identidad cálida, clara y breve, sin bordes decorativos ni pantallas cargadas.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Descubrir servicios desde Inicio (Priority: P1)

Una persona que abre ServiPronto reconoce al instante qué puede resolver. Encuentra un buscador dominante, una única promoción contextual, categorías destacadas y una vía visible para pedir ayuda a Jorge, sin leer bloques largos ni enfrentarse a una grilla pesada.

**Why this priority**: Inicio expresa la propuesta de valor y permite empezar manualmente o con ayuda, sin obligar a crear una solicitud ni usar IA.

**Independent Test**: abrir Inicio, reconocer la búsqueda, elegir una categoría destacada y abrir el acceso a Jorge sin depender de datos de contratación reales.

**Acceptance Scenarios**:

1. **Given** una persona en Inicio, **When** mira la primera pantalla, **Then** puede identificar búsqueda, promoción y servicios destacados sin desplazarse horizontalmente ni leer más de una frase por bloque.
2. **Given** una persona que no sabe qué categoría elegir, **When** toca el acceso secundario de ayuda, **Then** llega a Jorge con una invitación breve y no se la registra como una contratación.
3. **Given** una promoción ausente o no disponible, **When** abre Inicio, **Then** el espacio se reemplaza por contenido útil y la pantalla no deja un hueco vacío.

---

### User Story 2 - Explorar y elegir una categoría (Priority: P1)

Una persona explora servicios como en un catálogo de delivery: ve opciones claras, identifica cada rubro con una versión simple de Jorge y puede llegar al detalle de una categoría sin depender de un mapa.

**Why this priority**: permite descubrir la oferta disponible de Tandil mediante un camino manual y comprensible, central para quienes prefieren no conversar con Jorge.

**Independent Test**: desde Explorar, encontrar Plomería, Electricidad, Gas y calefacción, Limpieza, Jardinería, Mudanzas y fletes, Clases particulares, Reparación técnica, Aire acondicionado, Cámaras y seguridad o Mecánica a domicilio; abrir una categoría y volver sin perder contexto.

**Acceptance Scenarios**:

1. **Given** una persona en Explorar, **When** recorre el catálogo, **Then** ve las categorías generales habilitadas con nombre y una ilustración consistente, sin subcategorías prematuras.
2. **Given** una persona que escribe un servicio o problema, **When** toca Buscar, **Then** recibe categorías o una sugerencia breve para continuar con Jorge si la intención es ambigua.
3. **Given** una categoría temporalmente no disponible, **When** la consulta, **Then** ve una explicación corta y alternativas sin prometer proveedores inexistentes.
4. **Given** una persona que abre el detalle de una categoría de muestra, **When** decide volver, **Then** recupera su búsqueda y posición en Explorar.

---

### User Story 3 - Mantener orientación con navegación inferior (Priority: P1)

Una persona navega entre Inicio, Explorar, Jorge, Actividad y Perfil desde una barra inferior siempre comprensible. Jorge ocupa el centro como identidad de la aplicación, sin hacer creer que la conversación es obligatoria.

**Why this priority**: es el esqueleto común del producto y mantiene visible el camino manual incluso si Jorge no está configurado o no se utiliza.

**Independent Test**: abrir cada destino desde la barra, volver a Inicio y verificar que el estado activo se comprende por texto, icono y posición, no solo por color.

**Acceptance Scenarios**:

1. **Given** cualquier pantalla principal del cliente, **When** la persona toca una opción de la barra inferior, **Then** cambia al destino correspondiente y se conserva una referencia clara de dónde está.
2. **Given** una persona que toca el botón central de Jorge, **When** no hay una conversación disponible todavía, **Then** ve una pantalla cálida de preparación y conserva opciones manuales para Explorar y Buscar.
3. **Given** una pantalla de detalle, **When** navega hacia atrás, **Then** vuelve a la sección de origen sin reiniciar innecesariamente el catálogo.

---

### User Story 4 - Consultar actividad y perfil sin callejones vacíos (Priority: P2)

Una persona recién llegada puede abrir Actividad y Perfil aunque aún no tenga trabajos ni haya completado todos sus datos. Cada estado vacío explica el siguiente paso con una sola acción útil.

**Why this priority**: evita que las secciones iniciales parezcan rotas y mantiene el recorrido amable para una persona mayor o una primera visita.

**Independent Test**: abrir Actividad y Perfil sin datos previos; comprender qué contiene cada área y llegar al siguiente paso desde una acción visible.

**Acceptance Scenarios**:

1. **Given** una persona sin actividad, **When** abre Actividad, **Then** ve que allí aparecerán pendientes e historial, junto con una acción para explorar servicios.
2. **Given** una persona con perfil incompleto, **When** abre Perfil, **Then** distingue los datos pendientes de los guardados y puede continuar sin recibir un formulario invasivo completo.
3. **Given** una persona que configura tema, **When** elige sistema, claro u oscuro, **Then** la jerarquía, los textos y los controles siguen siendo legibles y reconocibles.

### Edge Cases

- La conexión se interrumpe al abrir el catálogo: se muestra un estado breve de reintento sin ocultar la navegación inferior.
- Una imagen de categoría no está disponible: se usa el símbolo o variante simplificada aprobada de Jorge, sin alterar el tamaño de la tarjeta.
- El texto de un nombre o servicio es largo: se trunca de forma legible y el detalle conserva el nombre completo.
- Una persona usa texto grande, lector de pantalla, modo oscuro o movimiento reducido: conserva orden de lectura, contraste y acciones equivalentes; el movimiento decorativo se reduce sin quitar información.
- La persona vuelve al flujo tras usar el selector del sistema: no pierde la sección ni el contenido que estaba explorando.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La aplicación MUST ofrecer las cinco secciones principales Cliente: Inicio, Explorar, Jorge, Actividad y Perfil.
- **FR-002**: La navegación inferior MUST estar disponible en las secciones principales y expresar el destino activo mediante texto, icono y estado visual, no solo color.
- **FR-003**: Inicio MUST priorizar un buscador, una sola promoción contextual y una selección breve de servicios destacados; no debe repetir la misma información en tarjetas separadas.
- **FR-004**: Inicio MUST ofrecer un acceso claro pero secundario a Jorge para quien no sabe qué servicio necesita, sin bloquear el uso manual.
- **FR-005**: Explorar MUST mostrar únicamente categorías generales habilitadas y no debe introducir un árbol de subcategorías en esta entrega.
- **FR-006**: Cada categoría MUST combinar nombre legible con una representación simple y consistente de Jorge asociada al oficio.
- **FR-007**: La búsqueda MUST aceptar el nombre de una categoría, un proveedor o una descripción corta de un problema; cuando no alcance para orientar, debe ofrecer a Jorge como ayuda opcional.
- **FR-007a**: En esta entrega, una búsqueda no debe presentar proveedores, reputación ni ranking simulados como si fueran reales. Debe devolver categorías de muestra, sugerencias manuales y un estado sin coincidencias con una sola acción útil.
- **FR-007b**: El detalle de una categoría de muestra MUST incluir nombre completo, representación coherente de Jorge, una frase de alcance, disponibilidad expresada con claridad y una acción no contractual para continuar manualmente o hablar con Jorge.
- **FR-008**: Jorge MUST tener una pantalla propia de acceso y preparación que explique brevemente su ayuda por texto; no debe fingir una conversación, disponibilidad de proveedores ni acciones no ejecutadas.
- **FR-009**: Actividad MUST reunir un estado inicial para pendientes e historial y ofrecer una única acción útil para comenzar a explorar.
- **FR-010**: Perfil MUST mostrar progreso de datos de manera gradual, permitir continuar el alta y no exigir completar todos los datos para explorar.
- **FR-010a**: Una sesión Cliente completa entra a Inicio; una sesión Cliente incompleta puede recorrer el shell y encuentra su siguiente paso en Perfil; una persona sin sesión se dirige al acceso definido en la especificación 003.
- **FR-010b**: Al alternar destinos principales, la aplicación MUST conservar la consulta, selección y posición de Explorar durante la sesión. Volver desde detalle conserva el mismo contexto.
- **FR-010c**: No debe existir una cabecera superior global persistente. Cada destino muestra un encabezado contextual solamente si suma orientación o una acción.
- **FR-011**: Cliente MUST usar azul como color predominante y naranja como acento; todos los componentes deben conservar curvas continuas G2 y superficies limpias, sin bordes decorativos de lado, arriba o alrededor de cada tarjeta.
- **FR-012**: Las tarjetas, botones y controles MUST usar jerarquía por espacio, color, tipografía, elevación o superficie; un borde solo se permite cuando comunica foco, error, selección o una separación funcional indispensable.
- **FR-012a**: Inicio MUST componer los destacados sin carrusel horizontal ni una grilla pesada. Explorar MUST presentar las categorías en una lista vertical de filas compactas, sin repetir cajas decorativas.
- **FR-013**: Las pantallas MUST evitar párrafos genéricos y leyendas redundantes: cada título explica el bloque y el contenido muestra la acción o información necesaria.
- **FR-014**: La interfaz MUST soportar tema sistema, claro y oscuro con equivalencia de contenido, contraste legible y estados no dependientes únicamente de color.
- **FR-015**: Los objetivos táctiles y acciones principales MUST ser distinguibles, alcanzables y acompañados de texto accesible.
- **FR-015a**: Cada objetivo táctil, incluidos destinos de la navegación inferior y el acceso a Jorge, MUST medir al menos 48 por 48 dp y respetar áreas seguras del dispositivo.
- **FR-015b**: Cada destino principal MUST tener nombre accesible, estado seleccionado y orden de lectura comprensible. Al cambiar de destino, el foco del lector de pantalla llega al título del destino; el acceso central se anuncia como “Hablar con Jorge”.
- **FR-015c**: A escala de texto de 200%, ningún texto se corta, se superpone ni deja una acción inaccesible; las filas y superficies adaptan su alto al contenido.
- **FR-016**: El movimiento debe apoyar orientación, confirmación o calidez; las transiciones de interfaz duran como máximo 180 ms, no bloquean acciones y se reducen a cambios de opacidad cuando la persona lo solicita.
- **FR-016a**: Jorge puede aparecer en una única viñeta comic breve de una o dos líneas en momentos de ayuda. No debe usar bucles, rebotes ni aparecer automáticamente al reabrir un destino.
- **FR-016b**: La vibración háptica, si está disponible, solo acompaña una confirmación deliberada y nunca comunica por sí sola un estado ni se ejecuta en cada cambio de pestaña.
- **FR-017**: La primera entrega MUST usar contenido de muestra explícitamente identificado y no habilitar contratación, pagos, chat de servicio, reputación real, publicidad de terceros ni resultados reales de proveedores.
- **FR-017a**: La promoción del primer corte MUST identificarse como contenido de ServiPronto. Si no está disponible, se reemplaza por una recomendación útil para explorar o pedir orientación; nunca se muestra un espacio vacío.
- **FR-017b**: Las ilustraciones de categoría MUST usar encuadre uniforme, no incluir texto incrustado ajeno a ServiPronto y no ser la única fuente para entender una acción.

### Key Entities *(include if feature involves data)*

- **Destino principal**: una de las cinco secciones permanentes de la navegación Cliente.
- **Categoría visible**: rubro general habilitado para presentación en el catálogo, con nombre, representación de Jorge y estado de disponibilidad para el recorrido visual.
- **Promoción contextual**: pieza breve de ServiPronto que ocupa un único espacio de Inicio y puede reemplazarse por contenido útil.
- **Estado de actividad**: representación de pendientes e historial de la persona; en esta entrega puede estar vacío y no implica una solicitud real.
- **Progreso de perfil**: indicación gradual de la información de Cliente ya guardada y del siguiente dato que falta.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: En una prueba guiada, al menos 9 de cada 10 participantes identifican cómo buscar un servicio o hablar con Jorge en menos de 15 segundos desde Inicio.
- **SC-002**: Al menos 9 de cada 10 participantes llegan desde Inicio a una categoría general elegida en menos de 3 toques.
- **SC-003**: Al menos 9 de cada 10 participantes diferencian Inicio, Explorar, Jorge, Actividad y Perfil sin recibir ayuda externa.
- **SC-004**: El 100% de los estados vacíos, de carga y de indisponibilidad conserva una acción clara y no presenta una pantalla sin salida.
- **SC-005**: En las pruebas de accesibilidad, el 100% de las acciones principales conserva nombre accesible, contraste suficiente y una diferencia no basada solo en color.
- **SC-006**: En modos claro y oscuro, el 100% del texto normal alcanza contraste mínimo de 4,5:1; texto grande e iconos funcionales alcanzan como mínimo 3:1, incluyendo foco, error y selección.
- **SC-007**: Con texto al 200%, el 100% de las acciones principales continúa disponible y no hay superposiciones ni recortes de contenido.
- **SC-008**: Con movimiento reducido habilitado, el 100% de las transiciones necesarias conserva la información sin desplazamientos decorativos.

## Assumptions

- El alcance representa el primer recorrido visual del cliente y puede usar categorías, promociones y actividad de muestra mientras los módulos de catálogo, proveedores y trabajos no estén disponibles.
- El acceso de la alternativa C y el alta progresiva se conectarán cuando la especificación 003 exponga sus recorridos; este corte no duplica ni reemplaza esa lógica.
- Las ilustraciones existentes son referencia visual. Sus textos ajenos a ServiPronto se eliminarán o no se mostrarán antes de convertirlas en elementos finales.
- La conversación funcional de Jorge, sus herramientas y los resultados reales se especifican por separado; esta entrega solo reserva su lugar y comunica su carácter opcional.
- La regla de no usar bordes decorativos no prohíbe indicadores funcionales de foco, error, selección ni separadores necesarios para accesibilidad.

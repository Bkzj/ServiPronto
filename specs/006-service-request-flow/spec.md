# Feature Specification: Solicitud manual de servicio

**Feature Branch**: `006-service-request-flow`  
**Created**: 2026-09-15  
**Status**: Ready for planning  
**Input**: Recorrido visual para que un Cliente inicie una solicitud desde una categoría o desde un proveedor, describa su necesidad, indique urgencia, modalidad y ubicación, y revise el pedido antes de enviarlo. Jorge es ayuda opcional. Este corte no contrata ni cobra.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Iniciar un pedido manual (Priority: P1)

Una persona que ya eligió una categoría o vio un proveedor puede empezar un pedido sin tener que hablar con Jorge. Reconoce desde qué servicio parte y llega a una primera pregunta concreta, sin encontrar formularios extensos ni asumir que el pedido ya está contratado.

**Why this priority**: convierte la exploración manual en una intención de servicio comprensible, manteniendo a Jorge como alternativa y no como una barrera.

**Independent Test**: abrir el inicio de solicitud desde el detalle de una categoría y desde un perfil de proveedor de muestra; comprobar que ambos caminos muestran el servicio de origen y permiten cancelar o continuar sin enviar nada.

**Acceptance Scenarios**:

1. **Given** una persona en el detalle de una categoría, **When** toca la acción para pedir ese servicio, **Then** entra al flujo con la categoría visible y una opción clara para volver.
2. **Given** una persona frente a un proveedor visible, **When** elige pedirle un servicio, **Then** el flujo conserva la referencia del proveedor sin asegurar aceptación, disponibilidad ni precio.
3. **Given** una persona que no está segura del rubro, **When** llega al inicio del pedido, **Then** puede abrir a Jorge como ayuda opcional o volver a Explorar, sin perder la categoría elegida si decide continuar manualmente.

---

### User Story 2 - Explicar lo que necesita (Priority: P1)

Una persona describe el problema con sus palabras y, si corresponde, agrega imágenes. El recorrido adapta ejemplos muy breves a la categoría para ayudar a dar información útil, sin obligarla a conocer términos técnicos ni a completar datos que no aplican.

**Why this priority**: la calidad de la descripción determina si el pedido puede ser entendido por el proveedor y por futuras herramientas de orientación.

**Independent Test**: iniciar pedidos de Plomería, Mudanzas y Clases particulares; escribir una descripción, agregar y eliminar imágenes de muestra, y verificar que cada categoría ofrece una guía distinta sin transformar el flujo en un árbol de subcategorías.

**Acceptance Scenarios**:

1. **Given** una categoría de atención en el hogar, **When** la persona llega a la descripción, **Then** encuentra una pregunta principal y un ejemplo corto relacionado con el rubro.
2. **Given** una solicitud que admite imágenes, **When** la persona agrega una, elimina una o no agrega ninguna, **Then** entiende qué se incluirá y puede continuar sin que las imágenes sean obligatorias.
3. **Given** una solicitud de Mudanzas y fletes, **When** completa la descripción, **Then** puede indicar de forma simple qué se mueve, origen y destino como información complementaria.
4. **Given** una solicitud de Clases particulares, **When** completa la descripción, **Then** puede indicar materia o tema, nivel y modalidad deseada como información complementaria.

---

### User Story 3 - Definir cuándo y dónde (Priority: P1)

Una persona comunica si necesita atención urgente o programada, selecciona una modalidad compatible con el rubro y aporta la ubicación que corresponde. Entiende que la ubicación se usa para coordinar, no se publica innecesariamente, y puede pedir para un familiar sin convertirlo en titular de la cuenta.

**Why this priority**: urgencia, modalidad y lugar son las señales mínimas para encaminar un servicio de hogares sin mostrar un mapa como experiencia principal.

**Independent Test**: crear un pedido urgente a domicilio, uno programado y una clase online; verificar que el flujo muestra únicamente las alternativas compatibles, no pide dirección en modalidad online y permite registrar un receptor distinto.

**Acceptance Scenarios**:

1. **Given** una persona que elige urgencia, **When** confirma que lo necesita cuanto antes, **Then** el resumen muestra la urgencia sin prometer que habrá un proveedor disponible.
2. **Given** una persona que elige un pedido programado, **When** elige una fecha y franja horaria, **Then** puede revisar y modificar la selección antes del envío.
3. **Given** una modalidad a domicilio, **When** la persona continúa, **Then** informa una dirección o ubicación para el servicio y puede añadir indicaciones breves de llegada.
4. **Given** una modalidad online compatible, **When** la selecciona, **Then** no se le exige dirección y se explica en una frase que la coordinación se definirá después.
5. **Given** una persona que contrata para otra, **When** activa esa opción, **Then** puede indicar nombre y contacto del receptor de forma separada, sin cambiar quién realiza el pedido.

---

### User Story 4 - Revisar antes de enviar (Priority: P1)

Una persona revisa una síntesis breve de lo informado, corrige cualquier paso y realiza una acción final inequívoca para enviar la solicitud. Sabe que el envío abre una solicitud y no confirma una visita, una contratación, una aceptación de proveedor ni un cobro.

**Why this priority**: evita malentendidos en un flujo donde las categorías y modalidades varían, especialmente para personas mayores o contrataciones para familiares.

**Independent Test**: completar datos mínimos, abrir la revisión, volver a editar cada bloque y usar la acción final; comprobar que la pantalla de confirmación describe el estado inicial y no simula asignación ni pago.

**Acceptance Scenarios**:

1. **Given** una persona con los datos mínimos completos, **When** abre la revisión, **Then** ve servicio, descripción, urgencia, modalidad, momento y ubicación o canal online en un resumen escaneable.
2. **Given** una persona en revisión, **When** toca Editar junto a un bloque, **Then** vuelve al paso correspondiente y al retornar conserva los demás datos.
3. **Given** una persona que confirma el envío, **When** la solicitud se registra, **Then** ve una confirmación breve con el estado “Solicitud enviada” y el siguiente paso, sin señalar a un proveedor como aceptado.
4. **Given** una persona que abandona antes de enviar, **When** vuelve al flujo durante la misma sesión, **Then** recupera un borrador identificable y puede descartarlo de manera explícita.

### Edge Cases

- La categoría o el proveedor de origen deja de estar disponible mientras se completa el pedido: se explica en una línea, se conserva el borrador y se propone elegir otra opción o volver a Explorar.
- Una urgencia no permite fecha o franja: el flujo oculta esos controles, marca “Lo antes posible” en el resumen y nunca inventa una hora de llegada.
- La dirección es incompleta, está fuera de la zona inicial o no puede validarse: se solicita corrección sin exponerla en listados públicos ni perder el resto del borrador.
- Una persona intenta enviar sin información necesaria para la modalidad elegida: el paso incompleto explica lo mínimo que falta y lleva a corregirlo.
- La carga de una imagen falla, demora o se cancela: la descripción sigue disponible, la imagen fallida se identifica con claridad y se ofrece reintentar o quitarla.
- La conexión se interrumpe durante el envío: la persona ve que no se pudo confirmar el resultado y puede reintentar sin crear pedidos duplicados.
- Texto al 200%, lector de pantalla, tema oscuro o movimiento reducido: cada paso, error, adjunto y revisión conserva orden, contexto y acciones equivalentes.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El Cliente MUST poder iniciar una solicitud manual desde el detalle de una categoría y, cuando exista un perfil de proveedor visible, desde ese perfil.
- **FR-002**: El flujo MUST conservar y mostrar la categoría de origen. Cuando se origine desde un proveedor, MUST mostrarlo como preferencia solicitada y no como aceptación, contratación ni disponibilidad confirmada.
- **FR-003**: El flujo MUST ofrecer una vía opcional a Jorge para orientar la necesidad y una vía para regresar a Explorar; ninguna debe bloquear el recorrido manual.
- **FR-004**: La solicitud MUST pedir una descripción libre del problema o necesidad mediante una pregunta principal y una guía de una línea específica de la categoría.
- **FR-005**: La solicitud MUST permitir adjuntar imágenes cuando la categoría lo admita, mostrar cuáles serán enviadas y permitir quitarlas antes de enviar. Las imágenes no serán obligatorias en este corte.
- **FR-006**: Para Mudanzas y fletes, el flujo MUST permitir agregar qué se moverá, origen y destino como información complementaria. Para Clases particulares, MUST permitir agregar materia o tema, nivel y modalidad deseada. No debe crear subcategorías visibles para ello.
- **FR-007**: El flujo MUST ofrecer la elección explícita entre urgencia y pedido programado cuando la categoría admita ambas alternativas; las categorías con una sola alternativa deben mostrarla sin presentar una elección falsa.
- **FR-008**: Una solicitud urgente MUST expresar “Lo antes posible” y no debe prometer asignación, cercanía, aceptación ni hora de llegada.
- **FR-009**: Una solicitud programada MUST permitir seleccionar y revisar fecha y franja horaria antes de enviar.
- **FR-010**: El flujo MUST mostrar únicamente modalidades compatibles con la categoría. Una modalidad a domicilio requiere ubicación; una modalidad online compatible no debe requerirla.
- **FR-011**: Para modalidad a domicilio, la persona MUST poder informar dirección o ubicación e indicaciones breves de llegada. Esta información no debe presentarse como pública ni en pantallas de exploración.
- **FR-012**: El Cliente MUST poder indicar que contrata para otra persona e informar nombre y contacto del receptor por separado. El resumen debe mantener a quien solicita como titular del pedido.
- **FR-013**: Antes de enviar, el flujo MUST ofrecer una revisión escaneable con servicio, descripción, urgencia, modalidad, momento y ubicación o canal online, además de un acceso para editar cada bloque.
- **FR-014**: La acción final MUST llamarse de forma inequívoca “Enviar solicitud” o equivalente claro. Su confirmación MUST explicar que abre una solicitud y no confirma visita, precio, cobro, proveedor ni contratación.
- **FR-015**: El flujo MUST conservar un borrador durante la sesión y permitir descartarlo mediante una acción explícita. Volver a un paso previo no debe borrar los datos de otros pasos.
- **FR-016**: Los estados de carga, error, indisponibilidad y reintento MUST explicar la situación con texto corto, una sola acción principal y sin ocultar el borrador.
- **FR-017**: Cliente MUST usar azul predominante, naranja de acento, curvas continuas G2 y superficies limpias. Tarjetas, botones, pasos y resúmenes no deben depender de bordes decorativos superiores, laterales o perimetrales.
- **FR-018**: La jerarquía visual MUST surgir de espacio, tipografía, color, elevación o superficie. Un borde solo se permite para comunicar foco, error, selección o separación funcional indispensable.
- **FR-019**: Cada paso MUST concentrarse en una decisión principal, usar títulos que expliquen el contenido y evitar bloques de texto genérico o leyendas repetidas.
- **FR-020**: Todas las acciones táctiles MUST medir al menos 48 por 48 dp, conservar etiqueta accesible y estado de foco visible. La urgencia, el estado de selección y los errores no deben depender solamente del color.
- **FR-021**: Con texto al 200%, tema claro u oscuro, lector de pantalla o movimiento reducido, MUST conservarse el orden de lectura, los controles, las acciones de edición y el contenido completo de la revisión.
- **FR-022**: Las transiciones entre pasos MUST apoyar la orientación, durar como máximo 180 ms y reducirse a cambios de opacidad si se solicita movimiento reducido. No deben bloquear la acción principal.
- **FR-023**: Jorge puede aparecer como una única viñeta comic breve de una o dos líneas cuando la descripción resulte difícil. No debe aparecer en bucle, sustituir la acción manual ni fingir haber enviado o encontrado un proveedor.
- **FR-024**: Este corte MUST excluir matching real, despacho a proveedores, aceptación, chat de servicio, agenda confirmada, pagos, señas, presupuestos, calificaciones y reputación real.

### Key Entities *(include if feature involves data)*

- **Borrador de solicitud**: información aún no enviada, con categoría de origen, preferencia de proveedor opcional y avance por pasos.
- **Necesidad declarada**: descripción libre, imágenes opcionales e información complementaria adaptada a la categoría.
- **Preferencia de atención**: urgencia o programación, más fecha y franja cuando corresponda.
- **Modalidad y lugar**: atención a domicilio u online, con ubicación e indicaciones solo cuando aplique.
- **Receptor del servicio**: persona distinta del Cliente que recibirá la prestación, sin convertirse en titular de la solicitud.
- **Revisión de solicitud**: síntesis previa al envío con accesos de edición y confirmación explícita.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: En una prueba guiada, al menos 9 de cada 10 participantes inicia una solicitud desde una categoría y llega a revisión en menos de 3 minutos sin ayuda.
- **SC-002**: Al menos 9 de cada 10 participantes diferencia una solicitud urgente de una programada y puede corregir su elección antes de enviarla.
- **SC-003**: Al menos 9 de cada 10 participantes identifica que “Enviar solicitud” no confirma proveedor, visita ni cobro.
- **SC-004**: El 100% de las categorías probadas presenta únicamente preguntas y modalidades compatibles, sin exigir una dirección para una opción online.
- **SC-005**: El 100% de los borradores interrumpidos conserva una salida explícita: continuar, editar, volver a Explorar o descartar.
- **SC-006**: Con texto al 200%, tema claro u oscuro y movimiento reducido, el 100% de las acciones principales y de edición continúa disponible sin recortes ni superposiciones.

## Assumptions

- Este es el primer flujo visual de solicitud. Puede usar categorías y proveedor de muestra definidos en el shell Cliente hasta que catálogo y perfiles reales estén disponibles.
- La ubicación inicial se limita a la cobertura de Tandil cuando corresponda; la validación geográfica y el alcance exacto de cada proveedor se definen en funcionalidades posteriores.
- “Enviar solicitud” crea solo la intención inicial. Las reglas de distribución, aceptación, confirmación, pagos, señas y cancelaciones se especifican e implementan por separado.
- Las categorías pueden definir qué modalidades, datos complementarios e imágenes admiten. La administración de esas reglas no forma parte de este corte.
- Jorge se conecta en una especificación propia de conversación y herramientas. Aquí solo se reserva una entrada opcional y honesta.

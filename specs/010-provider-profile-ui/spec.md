# Feature Specification: Alta y perfil visual de Proveedor

**Feature Branch**: `010-provider-profile-ui`  
**Created**: 2026-09-15  
**Status**: Ready for planning  
**Input**: Recorrido móvil visual para que una persona cree y mantenga su primera presentación como Proveedor individual. Incluye una categoría inicial, datos progresivos por rubro, borrador, revisión previa y lectura de los estados de habilitación. No incorpora documentación sensible, pagos, ranking, empresa ni contratación.

**Roadmap**: R02 — Cuentas y aprobación. Complementa la especificación de dominio [003-role-onboarding](../003-role-onboarding/spec.md) y el mapa [FRONTEND_SPECS](../../docs/FRONTEND_SPECS.md).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Empezar una presentación profesional sin un formulario pesado (Priority: P1)

Una persona que creó una cuenta de Proveedor inicia una única presentación individual. Elige una categoría inicial disponible y completa su información en bloques cortos, pudiendo guardar y retomar sin perder el avance ni confundirse con un perfil de Cliente.

**Why this priority**: una alta breve y comprensible permite sumar oferta local sin hacer que una persona experta en su oficio tenga que entender un sistema complejo antes de mostrar qué puede hacer.

**Independent Test**: abrir el alta como Proveedor sin presentación previa, elegir Plomería o Clases particulares, completar un bloque y salir; al volver, reconocer la categoría y retomar el mismo borrador.

**Acceptance Scenarios**:

1. **Given** una persona autenticada sin cuenta de Proveedor, **When** elige crearla, **Then** entra a una experiencia de Proveedor distinta de Cliente y ve que iniciará con una sola categoría.
2. **Given** una persona con una cuenta de Proveedor sin categoría inicial, **When** abre el flujo, **Then** puede elegir solamente entre categorías que ServiPronto tenga habilitadas para altas.
3. **Given** una categoría elegida, **When** completa un bloque y guarda, **Then** puede salir, volver y encontrar el avance como borrador sin crear otra cuenta ni otra categoría inicial.
4. **Given** una persona que intenta cambiar la categoría tras haber cargado datos específicos, **When** confirma el cambio, **Then** recibe una advertencia breve sobre los datos que deberán revisarse y no pierde el borrador sin una confirmación explícita.

---

### User Story 2 - Explicar el servicio con datos útiles para ese rubro (Priority: P1)

La persona describe qué tareas realiza y completa solo los datos operativos necesarios para su primera categoría: modalidad, cobertura, disponibilidad, experiencia y cómo cobra. Las preguntas se adaptan al rubro sin abrir subcategorías profundas ni pedir información que corresponde a pagos o verificación futura.

**Why this priority**: Cliente y administración necesitan una presentación comparable y útil, pero cada oficio usa señales diferentes y una plantilla genérica vacía reduce la calidad de la oferta.

**Independent Test**: comparar el flujo de Plomería con el de Clases particulares: ambos permiten completar la información común, pero muestran preguntas y modalidades pertinentes a cada categoría sin exigir las de la otra.

**Acceptance Scenarios**:

1. **Given** un Proveedor en una categoría inicial, **When** llega a “Lo que hacés”, **Then** puede seleccionar tareas definidas por ServiPronto y agregar una aclaración breve, sin crear públicamente una categoría nueva.
2. **Given** una categoría con más de una modalidad compatible, **When** la persona elige cómo trabaja, **Then** solo ve modalidades propias de ese rubro, como domicilio, online o lugar a coordinar cuando corresponda.
3. **Given** una modalidad que requiere desplazamiento, **When** informa cobertura, **Then** puede expresar una zona o radio de trabajo sin que el flujo represente un mapa como pantalla principal.
4. **Given** una persona que define disponibilidad, **When** guarda ese bloque, **Then** puede indicar una disponibilidad inicial clara sin que la interfaz prometa agenda, asignación ni oportunidades reales.
5. **Given** una persona que llega a experiencia y precio, **When** completa el bloque, **Then** puede describir experiencia y declarar precio por hora, precio orientativo o visita configurable cuando la categoría lo admita; no se le solicitan datos bancarios ni se simula un cobro.
6. **Given** una categoría en la que una matrícula pueda ser relevante, **When** la persona decide declararla, **Then** puede escribirla como dato opcional y ve que no queda verificada ni mejora su posición automáticamente.

---

### User Story 3 - Revisar y enviar una presentación con expectativas claras (Priority: P1)

Antes de enviarla, la persona revisa una síntesis breve de su categoría y su forma de trabajo. Puede corregir cada bloque y entiende que el envío abre una revisión manual, no publica su perfil ni garantiza trabajos.

**Why this priority**: evita perfiles incompletos, promesas equivocadas y trabajo manual de corrección para un equipo pequeño.

**Independent Test**: completar lo mínimo para una categoría, abrir la revisión, editar dos bloques y enviar; comprobar que la confirmación dice “En revisión” y no muestra búsquedas, ranking, pagos o solicitudes reales.

**Acceptance Scenarios**:

1. **Given** todos los datos mínimos de la categoría, **When** la persona abre la revisión, **Then** ve identidad profesional, categoría, tareas, modalidad, cobertura, disponibilidad, experiencia, precio y matrícula declarada si existe, en una síntesis escaneable.
2. **Given** una persona en revisión, **When** toca Editar en un bloque, **Then** vuelve al paso correspondiente y al regresar conserva el resto del borrador.
3. **Given** información mínima incompleta, **When** intenta enviar, **Then** el flujo identifica el único bloque que falta y ofrece volver a él sin borrar el avance.
4. **Given** una presentación revisada, **When** toca “Enviar a revisión”, **Then** recibe confirmación de que ServiPronto la revisará y que todavía no aparecerá en resultados ni recibirá trabajos.

---

### User Story 4 - Entender y actuar según el estado de aprobación (Priority: P1)

Una persona Proveedora abre su perfil y reconoce de inmediato si todavía debe completarlo, está esperando revisión, debe corregir algo, fue aprobada, fue rechazada o se encuentra suspendida. Cuando hay una corrección, entiende el motivo y qué puede hacer sin interpretar la pantalla como un castigo ni quedar atrapada.

**Why this priority**: el estado es la explicación principal del período entre alta y visibilidad, y debe reducir consultas manuales sin ocultar decisiones importantes.

**Independent Test**: abrir el perfil con cada uno de los seis estados y comprobar que muestra una explicación corta, el motivo cuando exista y solo la acción que corresponde a ese estado.

**Acceptance Scenarios**:

1. **Given** un perfil Incompleto, **When** la persona abre Perfil, **Then** ve el próximo bloque pendiente y una acción para continuarlo.
2. **Given** un perfil En revisión, **When** abre Perfil, **Then** ve la fecha de envío y entiende que no puede aparecer ni recibir trabajos hasta una decisión, sin una acción de publicación falsa.
3. **Given** un perfil Requiere cambios, **When** abre Perfil, **Then** ve el motivo breve indicado por administración y una acción para editar y reenviar, conservando el resto de la presentación.
4. **Given** un perfil Aprobado, **When** abre Perfil, **Then** ve una confirmación sobria de habilitación y su categoría inicial; no se inventan reputación, posiciones ni oportunidades.
5. **Given** un perfil Rechazado, **When** abre Perfil, **Then** ve el motivo breve y un camino seguro de contacto o soporte, sin prometer que una edición lo publica.
6. **Given** un perfil Suspendido, **When** abre Perfil, **Then** ve que no puede reenviar ni reactivar por sí mismo y un canal de contacto justificado.

---

### User Story 5 - Recibir orientación opcional y respetuosa (Priority: P2)

Jorge puede ofrecer una ayuda breve para explicar un campo confuso, por ejemplo la diferencia entre radio de cobertura y modalidad. La persona conserva siempre los controles manuales y Jorge no dice que verificó credenciales, envió la presentación o consiguió trabajo si no ocurrió.

**Why this priority**: acompaña a quienes tienen menos familiaridad digital, sin volver a Jorge una condición de alta ni una fuente de afirmaciones engañosas.

**Independent Test**: en un campo de precio, cobertura y matrícula, activar y cerrar la ayuda de Jorge; verificar que el paso manual queda disponible y la ayuda no altera datos ni estado.

**Acceptance Scenarios**:

1. **Given** un campo que puede generar dudas, **When** la persona abre “¿Necesitás ayuda?”, **Then** Jorge muestra una viñeta de una o dos líneas con un ejemplo neutro y una forma de cerrarla.
2. **Given** una persona que no usa Jorge, **When** completa el flujo manual, **Then** logra guardar y enviar la presentación con los mismos resultados.

### Edge Cases

- La categoría inicial deja de estar habilitada mientras existe un borrador: el borrador se conserva, pero la persona ve que debe elegir una alternativa antes de enviarlo.
- Una categoría no admite la modalidad o el tipo de precio seleccionado: el control se corrige con una explicación corta, sin borrar los otros bloques.
- La conexión se corta al guardar o enviar: se conserva el último borrador confirmado, se comunica si el envío no pudo confirmarse y se permite reintentar sin duplicar la presentación.
- Una revisión llega mientras el perfil está abierto: la pantalla no cambia foco ni pierde edición; al volver a Perfil se muestra el estado actualizado de forma clara.
- El motivo de corrección o rechazo no está disponible: se evita inventarlo y se ofrece el canal de soporte correspondiente.
- Una persona intenta enviar desde Rechazado o Suspendido: el botón no inicia una transición inexistente y explica la salida permitida.
- Con texto al 200 %, lector de pantalla, tema oscuro o movimiento reducido, cada paso, estado, motivo, acción de edición y confirmación sigue siendo alcanzable y comprensible.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La interfaz MUST ofrecer un alta de Proveedor individual separada de Cliente y explicar, en una sola línea cuando sea necesario, que la primera alta usa una categoría.
- **FR-002**: La interfaz MUST permitir elegir únicamente una categoría general habilitada por ServiPronto como categoría inicial. No debe mostrar un árbol profundo de subcategorías ni permitir publicar una categoría sugerida desde este flujo.
- **FR-003**: La interfaz MUST organizar el alta en bloques progresivos: identidad profesional básica, categoría y tareas, modalidad, cobertura, disponibilidad, experiencia y precio. Cada bloque debe poder guardarse como borrador y retomarse.
- **FR-004**: La interfaz MUST adaptar etiquetas, ejemplos breves, tareas disponibles, modalidades y formas de precio a la categoría seleccionada, sin pedir campos incompatibles con ese rubro.
- **FR-005**: La interfaz MUST permitir seleccionar tareas definidas por ServiPronto y agregar una aclaración breve; también MUST permitir sugerir una categoría nueva como comentario no publicable.
- **FR-006**: La interfaz MUST permitir declarar modalidades compatibles, cobertura o radio cuando aplique, disponibilidad inicial y experiencia breve. Ningún dato de este corte debe afirmar agenda confirmada, ubicación en vivo ni recepción de oportunidades.
- **FR-007**: La interfaz MUST permitir declarar precio por hora, precio orientativo o una visita configurable solo cuando la categoría lo admita. Debe dejar claro que es información de presentación y no un cobro, presupuesto aceptado ni vinculación de pago.
- **FR-008**: La interfaz MUST permitir declarar una matrícula o credencial relevante como información opcional. Debe nombrarla como declarada y no verificada, sin insignias, ranking ni beneficios automáticos.
- **FR-009**: La interfaz MUST permitir guardar borradores identificables, retomarlos y descartarlos con confirmación explícita. Cambiar de categoría con información específica cargada MUST pedir confirmación antes de invalidar campos incompatibles.
- **FR-010**: Antes del envío, la interfaz MUST presentar una revisión escaneable con accesos a editar cada bloque y MUST indicar el único bloque faltante cuando la presentación no esté lista.
- **FR-011**: La acción final MUST llamarse “Enviar a revisión” o un equivalente inequívoco. La confirmación MUST comunicar que administración revisará la presentación y que el perfil aún no será visible ni recibirá solicitudes.
- **FR-012**: La interfaz MUST presentar los estados Incompleto, En revisión, Requiere cambios, Aprobado, Rechazado y Suspendido mediante nombre, descripción breve y acción permitida. El color por sí solo no puede expresar el estado.
- **FR-013**: Para Requiere cambios y Rechazado, la interfaz MUST mostrar el motivo provisto por administración cuando exista. Requiere cambios MUST permitir editar y reenviar; Rechazado y Suspendido MUST dirigir a soporte y no simular reactivación automática.
- **FR-014**: El estado Aprobado MUST identificar la categoría inicial habilitada sin mostrar ranking, reputación, posiciones, resultados públicos, trabajos ni métricas todavía inexistentes.
- **FR-015**: La interfaz MUST incluir estados de carga, borrador vacío, indisponibilidad de categoría, guardado pendiente, envío no confirmado, error recuperable y soporte. Cada uno debe usar texto corto y una única acción principal pertinente.
- **FR-016**: Jorge MAY orientar un campo mediante una única viñeta comic breve, descartable y opcional. No puede modificar datos, decidir precios, verificar identidad o matrícula, enviar la presentación ni afirmar publicaciones o trabajos inexistentes.
- **FR-017**: Este corte MUST excluir carga, almacenamiento o visualización de DNI, selfies, antecedentes, documentos, archivos de matrícula, datos bancarios, cuentas de cobro, portfolio, fotos de trabajos, pagos, presupuestos, ranking, empresas, equipos, chat de servicio, solicitudes, contratación y oportunidades reales.
- **FR-018**: El Proveedor MUST usar naranja predominante y azul como acento, tipografía redondeada y amable, y curvas continuas G2. Botones, superficies, opciones y resúmenes no deben usar bordes decorativos, líneas superiores, laterales o marcos repetidos.
- **FR-019**: La jerarquía MUST depender de espacio, superficie, tipografía, color y elevación discreta. Un contorno solo se permite para foco, error, selección o una separación funcional indispensable.
- **FR-020**: Cada pantalla MUST mostrar una decisión principal, un título autosuficiente y, solo cuando ayude a avanzar, una línea de apoyo. Debe evitar párrafos genéricos, leyendas repetidas y una tarjeta por cada dato.
- **FR-021**: Todos los objetivos táctiles MUST medir al menos 48 × 48 dp, tener nombre accesible, foco visible y orden de lectura lógico. Los estados, errores, obligatoriedad y selección no deben depender exclusivamente del color.
- **FR-022**: En tema sistema, claro u oscuro, texto al 200 %, lector de pantalla y movimiento reducido, MUST conservarse el contenido completo, los motivos de revisión, los controles y las acciones. Las transiciones de orientación no pueden durar más de 180 ms y se reducen a opacidad si se solicita menos movimiento.

### Key Entities *(include if feature involves data)*

- **Borrador de presentación**: avance editable y aún no enviado de un Proveedor individual, asociado a una sola categoría inicial.
- **Categoría inicial habilitada**: categoría general que ServiPronto permite seleccionar para la primera alta en la etapa y ciudad actual.
- **Configuración por categoría**: tareas, modalidades, campos de cobertura y formas de precio que el flujo muestra para una categoría, sin convertirse en subcategorías públicas.
- **Presentación profesional**: síntesis revisable de identidad, tareas, modalidad, cobertura, disponibilidad, experiencia, precio y credencial declarada si existe.
- **Credencial declarada**: dato opcional provisto por el Proveedor que no posee estado de verificación ni efecto sobre ranking en este corte.
- **Estado de perfil de Proveedor**: Incompleto, En revisión, Requiere cambios, Aprobado, Rechazado o Suspendido, junto con su acción permitida y motivo cuando corresponde.
- **Motivo de revisión**: texto breve emitido por administración para solicitar cambios o explicar un rechazo, visible solo a la persona Proveedora pertinente.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: En una prueba guiada, al menos 9 de cada 10 personas proveedoras elige una categoría inicial y guarda su primer borrador en menos de 3 minutos sin asistencia humana.
- **SC-002**: Al menos 8 de cada 10 personas proveedoras con datos listos completa y envía una presentación inicial en menos de 8 minutos, sin contar pausas propias.
- **SC-003**: El 100 % de las categorías de muestra presenta solo modalidades, preguntas y tipos de precio compatibles, sin convertir los campos en subcategorías visibles.
- **SC-004**: El 100 % de las personas probadas distingue En revisión de Aprobado y reconoce que enviar no publica ni genera trabajos.
- **SC-005**: El 100 % de los estados Requiere cambios, Rechazado y Suspendido presenta una acción coherente con la transición permitida y no ofrece publicación o reactivación inexistentes.
- **SC-006**: Con texto al 200 %, temas claro y oscuro, lector de pantalla y movimiento reducido, el 100 % de las acciones para guardar, editar, enviar, leer motivos y contactar soporte permanece visible y operable.

## Assumptions

- La identidad de acceso, teléfono confirmado y la separación de cuentas provienen de 003 y de 005; esta especificación describe la capa móvil de Proveedor, no los contratos de autenticación.
- La lista inicial de categorías es la acordada para Tandil y puede habilitarse gradualmente por ServiPronto. Esta interfaz consume esa disponibilidad, no administra la lista.
- Los campos específicos por oficio se modelarán como configuración de categoría en una planificación posterior. El contenido de ejemplo no reemplaza requisitos regulatorios ni habilita tareas reguladas.
- La decisión administrativa, su historial y los permisos provienen de 003. Esta entrega solo hace legible el resultado a la persona Proveedora; el panel de revisión se define en 012.
- El patrón podrá ampliarse para nuevas categorías y, más adelante, empresas o equipos, pero no debe anticipar esos conceptos en la primera experiencia individual.
- Jorge conserva su arquitectura y conversación propias. Aquí se reserva una ayuda honesta y opcional, sin conectar herramientas ni capacidades de IA reales.

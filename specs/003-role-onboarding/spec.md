# Feature Specification: Alta progresiva y revisión inicial

**Feature Branch**: `003-role-onboarding`

**Created**: 2026-09-14

**Status**: Ready for planning

**Input**: User description: "Iniciar las especificaciones del producto usando Superpowers y GitHub Spec Kit."

**Roadmap**: R02 — Cuentas y aprobación. Esta especificación toma AC-01 a AC-06, PR-01 a PR-10 y los principios I, IV, V y VIII de la constitución.

## Clarifications

### Session 2026-09-15

- **Acceso inicial**: se implementará la alternativa C: correo y contraseña, seguidos por un código temporal enviado al teléfono para confirmar cada nueva sesión. Durante desarrollo, el envío se resolverá mediante un adaptador local; el proveedor real de mensajería se incorporará después detrás del mismo contrato.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Elegir y completar el perfil de cliente (Priority: P1)

Una persona con una sesión iniciada elige crear una cuenta de cliente solo durante su primera alta. Puede explorar la aplicación sin atravesar un formulario largo; cuando decide completar el perfil, proporciona los datos básicos en pasos visuales y puede corregirlos antes de guardar.

**Why this priority**: habilita el lado de la demanda sin forzar a usar a Jorge ni pedir toda la información antes de explorar.

**Independent Test**: con una sesión sin cuenta de negocio, se puede elegir Cliente, completar los datos obligatorios paso a paso y ver el perfil de cliente guardado, separado de cualquier cuenta de proveedor.

**Acceptance Scenarios**:

1. **Given** una persona con sesión iniciada y sin cuenta de negocio, **When** elige crear una cuenta de cliente, **Then** el sistema crea un flujo de cliente y no vuelve a preguntar el rol en los ingresos posteriores.
2. **Given** un cliente que todavía no completó el perfil, **When** navega por Inicio o Explorar, **Then** puede hacerlo sin que se le exija completar un formulario extenso.
3. **Given** un cliente en el flujo de perfil, **When** completa nombre, apellido, teléfono, correo, fecha de nacimiento y una dirección, **Then** el sistema muestra una revisión clara antes de confirmar los datos.
4. **Given** un cliente que ya tiene cuenta de cliente, **When** intenta crear otra cuenta de cliente con el mismo teléfono, **Then** el sistema no crea un duplicado y explica cómo recuperar el acceso.

---

### User Story 2 - Presentar un perfil de proveedor para revisión (Priority: P1)

Una persona con una sesión iniciada elige crear una cuenta de proveedor solo durante su primera alta. Completa una presentación profesional progresiva, carga una única categoría inicial con su información operativa y la envía a revisión. Hasta recibir aprobación no aparece en búsquedas ni recibe oportunidades.

**Why this priority**: la confianza del marketplace requiere que la oferta inicial sea revisable y que ningún proveedor incompleto quede visible al público.

**Independent Test**: con una sesión sin cuenta de proveedor, se puede crear un perfil, declarar una categoría inicial, enviarlo a revisión y comprobar que permanece invisible para clientes.

**Acceptance Scenarios**:

1. **Given** una persona sin cuenta de proveedor, **When** elige Proveedor, **Then** el sistema inicia un flujo distinto del de cliente y conserva las cuentas de negocio separadas.
2. **Given** un proveedor que completa la información personal y una categoría inicial, **When** informa la tarea que ofrece, modalidad, cobertura, disponibilidad aplicable, experiencia y precio orientativo o precio por hora según corresponda, **Then** puede revisar esa información antes de enviarla.
3. **Given** una categoría donde una matrícula resulte relevante, **When** el proveedor decide declararla, **Then** puede incorporarla como credencial opcional sin que la declaración por sí sola le otorgue una verificación o posición preferente.
4. **Given** un proveedor con información mínima completa, **When** envía el perfil, **Then** su estado pasa a En revisión y se registra la fecha de presentación.
5. **Given** un proveedor En revisión, Incompleto, Requiere cambios, Rechazado o Suspendido, **When** un cliente explora proveedores, **Then** ese proveedor no aparece ni puede recibir una solicitud.
6. **Given** un proveedor Aprobado, **When** vuelve a ingresar, **Then** puede consultar claramente el estado de su perfil y la categoría aprobada.

---

### User Story 3 - Revisar una presentación de proveedor (Priority: P2)

Un administrador autorizado consulta las presentaciones pendientes, revisa la información declarada y decide aprobarla, pedir cambios o rechazarla con un motivo breve. La decisión queda visible para el proveedor; una corrección no borra el historial de revisión.

**Why this priority**: permite operar manualmente el lanzamiento en Tandil con control suficiente para un equipo de dos personas.

**Independent Test**: con un proveedor En revisión, un administrador puede aprobar, solicitar cambios o rechazar y el proveedor ve el nuevo estado y motivo correspondiente.

**Acceptance Scenarios**:

1. **Given** un administrador autorizado y un proveedor En revisión, **When** el administrador aprueba el perfil, **Then** el proveedor pasa a Aprobado y queda habilitado para la futura visibilidad pública.
2. **Given** un administrador autorizado y un proveedor En revisión, **When** solicita cambios o rechaza la presentación, **Then** debe indicar un motivo breve visible solo para ese proveedor y el perfil no se publica.
3. **Given** un proveedor Requiere cambios, **When** actualiza la información solicitada y vuelve a enviarla, **Then** el sistema conserva las decisiones anteriores y devuelve la presentación a En revisión.

### Edge Cases

- La persona pierde conexión o sale del flujo antes de confirmar: se conserva únicamente el avance explícitamente guardado y se permite retomarlo sin duplicar la cuenta.
- El teléfono ya pertenece a otra identidad de acceso, incluso pendiente de verificación: se rechaza el segundo registro. Una identidad puede tener una cuenta Cliente y una Proveedor con ese mismo teléfono, pero no dos cuentas del mismo rol.
- El correo de acceso es único por identidad y se comparte entre sus cuentas Cliente y Proveedor; no se crean dos identidades con el mismo teléfono para reutilizar el correo.
- La categoría elegida deja de estar habilitada para altas: el proveedor conserva su borrador, pero no puede enviarlo hasta elegir una categoría disponible.
- Un administrador intenta aprobar una presentación sin información mínima o que ya fue resuelta: el sistema impide la transición e informa el estado actual.
- Un proveedor suspendido intenta reenviar su perfil: el sistema no reanuda la publicación automáticamente y muestra que debe contactar a soporte.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema MUST permitir elegir Cliente o Proveedor únicamente al crear una nueva cuenta de negocio.
- **FR-002**: El sistema MUST mantener los datos y estados de cliente y proveedor separados, sin un cambio libre de rol dentro de una misma cuenta de negocio.
- **FR-003**: El sistema MUST asociar cada teléfono a una única identidad de acceso, rechazando con conflicto el registro de otra identidad con ese teléfono, y MUST permitir a esa identidad una sola cuenta Cliente y una sola cuenta Proveedor una vez verificado el teléfono. Repetir el alta del mismo rol actualiza su cuenta existente, sin duplicarla.
- **FR-004**: El sistema MUST permitir que las cuentas Cliente y Proveedor de una misma identidad compartan el correo y teléfono de acceso verificados; esto no habilita una segunda identidad con el mismo teléfono.
- **FR-004a**: El sistema MUST requerir correo, contraseña y un código temporal enviado al teléfono para crear o confirmar una nueva sesión de acceso de la aplicación.
- **FR-004b**: El sistema MUST aislar el envío y la validación del código temporal detrás de un contrato propio, usando un adaptador local únicamente en desarrollo y sin acoplar el resto del producto a un proveedor de mensajería.
- **FR-005**: El sistema MUST permitir al cliente explorar antes de completar el perfil, y MUST requerir el perfil completo antes de cualquier acción futura que requiera sus datos personales o de contacto.
- **FR-006**: El sistema MUST solicitar al cliente, en pasos pequeños y visualmente claros, nombre, apellido, teléfono, correo, fecha de nacimiento y dirección.
- **FR-007**: El sistema MUST permitir al proveedor iniciar con una sola categoría general disponible y MUST pedir únicamente la información necesaria para ofrecer esa categoría en la primera alta.
- **FR-008**: El sistema MUST permitir que el proveedor declare, para su categoría inicial, tareas o aclaración breve, modalidad, cobertura, disponibilidad aplicable, experiencia y precio orientativo o por hora aplicable.
- **FR-008a**: El sistema MUST permitir declarar una matrícula o credencial relevante como información opcional, sin tratarla como verificada ni usarla para ranking o visibilidad en esta entrega.
- **FR-009**: El sistema MUST mostrar al proveedor una revisión de la información antes de enviar la presentación y MUST permitirle corregirla.
- **FR-010**: El sistema MUST usar los estados Incompleto, En revisión, Requiere cambios, Aprobado, Rechazado y Suspendido para el perfil de proveedor.
- **FR-011**: El sistema MUST impedir que un proveedor no Aprobado aparezca en resultados públicos o reciba oportunidades.
- **FR-012**: El sistema MUST permitir a un administrador autorizado revisar presentaciones En revisión y aprobar, requerir cambios o rechazar con un motivo breve.
- **FR-013**: El sistema MUST conservar una copia inmutable de los datos de cada presentación enviada, identificada por versión y fecha, y el historial de decisiones vinculado al envío concreto, incluyendo estado anterior y resultante, fecha, autor administrativo cuando exista y motivo de corrección o rechazo. La edición o el reenvío del borrador no modifica presentaciones ni decisiones anteriores.
- **FR-014**: El sistema MUST informar al proveedor su estado actual y los cambios solicitados en lenguaje claro y breve.
- **FR-015**: El sistema MUST permitir que un proveedor Requiere cambios actualice la información solicitada y vuelva a enviar la presentación.
- **FR-016**: El sistema MUST no solicitar, almacenar ni mostrar documentos de identidad, selfies, antecedentes, comprobantes o archivos de matrícula, datos bancarios, credenciales de cobro ni archivos de portfolio en esta entrega. Puede conservar únicamente el texto breve de una credencial o matrícula declarada voluntariamente según FR-008a, identificado como no verificado.
- **FR-017**: El sistema MUST no habilitar pagos, contratación, ranking público, mensajería de servicio ni publicación de categorías como parte de esta entrega.
- **FR-018**: El sistema MUST ofrecer el recorrido manual completo; Jorge puede orientar sobre campos del formulario en una etapa posterior, pero no es necesario para crear ni revisar un perfil.
- **FR-019**: El sistema MUST presentar los pasos de cliente con predominio azul y los de proveedor con predominio naranja, en modos claro, oscuro y sistema, usando texto legible, objetivos táctiles claros y estados comprensibles sin depender solo del color.

### Key Entities *(include if feature involves data)*

- **Cuenta de negocio de cliente**: identidad operativa separada de una persona que contrata servicios; contiene datos personales y de contacto declarados.
- **Cuenta de negocio de proveedor**: identidad operativa separada de una persona que ofrece servicios; conserva el estado de habilitación y su categoría inicial.
- **Presentación de proveedor**: versión enviada para revisión que reúne la información declarada para la categoría inicial y su resultado de revisión.
- **Decisión de revisión**: registro inmutable de una aprobación, pedido de cambios o rechazo, con fecha, autor autorizado y motivo cuando aplica.
- **Categoría habilitada**: categoría general que ServiPronto decidió mostrar para altas en la ciudad y etapa actual.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: En una prueba guiada, al menos 9 de cada 10 participantes pueden elegir su tipo de cuenta y completar el primer paso del perfil sin ayuda externa.
- **SC-002**: Un cliente puede completar y revisar su perfil básico en menos de 4 minutos, sin contar el tiempo de ingreso del código temporal de acceso.
- **SC-003**: Un proveedor puede guardar un borrador de la presentación inicial y enviarlo a revisión en menos de 8 minutos cuando ya conoce los datos de su categoría.
- **SC-004**: El 100% de proveedores no Aprobados permanece fuera de los resultados públicos y de las oportunidades durante las pruebas automatizadas del flujo.
- **SC-005**: El 100% de decisiones administrativas de revisión conserva un estado, fecha y autor consultables por administración.
- **SC-006**: Un proveedor que recibe un pedido de cambios puede identificar el motivo y reenviar una versión corregida sin crear una cuenta nueva.
- **SC-007**: En la prueba de accesibilidad del flujo, todos los estados de cuenta y revisión se distinguen mediante texto además de color.

## Assumptions

- La primera beta usa correo y contraseña más un código temporal al teléfono para confirmar una sesión nueva. La recuperación de acceso, la entrega real de códigos y los límites comerciales del proveedor de mensajería se especificarán por separado.
- La primera entrega usa categorías generales que ServiPronto habilita previamente para Tandil; no incluye un editor administrativo de reglas de categoría.
- La revisión inicial puede ser manual y no equivale a una verificación legal, profesional o de identidad completa.
- La información sensible y los archivos requeridos para validar identidad, matrículas, antecedentes o cobro se resolverán después de definir su base legal, permisos, retención y seguridad.
- La contratación para un familiar, la dirección exacta de cada servicio y los pagos se especificarán en recorridos posteriores.
- Declarar una matrícula no equivale a validarla ni autoriza a habilitar un oficio regulado; esos requisitos se investigarán antes de la publicación pública. Esta entrega conserva, como máximo, el texto declarado: no recibe ni valida documentos.

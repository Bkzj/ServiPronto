# Feature Specification: Acceso y alta visual de Cliente

**Feature Branch**: `005-client-onboarding-ui`

**Created**: 2026-09-15

**Status**: Ready for planning

**Input**: Recorrido visual de correo, contraseña y código temporal, seguido por la creación progresiva de perfil Cliente. Debe ser simple, cálido y útil para personas mayores.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Entrar sin fricción (Priority: P1)

Una persona crea o recupera su sesión con correo, contraseña y código temporal al teléfono. Entiende qué paso está realizando sin tecnicismos, puede corregir un error y no queda atrapada si el código vence.

**Why this priority**: conecta la alternativa C existente con una experiencia segura y accesible.

**Independent Test**: completar registro, código correcto y llegada al shell Cliente; probar código incorrecto, vencido y reenvío sin exponer secretos.

**Acceptance Scenarios**:

1. **Given** una persona nueva, **When** ingresa correo, contraseña y teléfono, **Then** ve un paso por vez, una explicación corta y el avance hacia la confirmación.
2. **Given** un código inválido o vencido, **When** intenta confirmarlo, **Then** recibe un mensaje claro, conserva el teléfono enmascarado y puede pedir otro código cuando corresponda.
3. **Given** una sesión confirmada, **When** termina el acceso, **Then** llega a Inicio o a Perfil según su progreso, sin elegir el rol en cada ingreso.

---

### User Story 2 - Completar perfil Cliente de a poco (Priority: P1)

Una persona entrega nombre, apellido, fecha de nacimiento y dirección en pasos visuales, revisa lo informado y puede explorar antes de terminar.

**Why this priority**: protege la conversión y evita un formulario invasivo.

**Independent Test**: guardar avance parcial, explorar, retomarlo, revisar y confirmar sin perder datos.

**Acceptance Scenarios**:

1. **Given** una persona con sesión, **When** abre Perfil, **Then** ve un único siguiente dato y una razón corta cuando ese dato desbloquea una acción futura.
2. **Given** una persona que sale antes de terminar, **When** vuelve, **Then** encuentra su avance explícitamente guardado sin duplicar su cuenta.
3. **Given** una persona que revisa sus datos, **When** confirma, **Then** puede editar un paso puntual antes de guardar.

### Edge Cases

- El teclado cubre una acción: la pantalla permite desplazarse y conserva el botón disponible.
- El teléfono está asociado a otro Cliente: se explica cómo recuperar acceso, sin revelar datos de la otra cuenta.
- Sin conexión: se conserva solo el avance guardado y se ofrece reintentar.
- Texto al 200% y lector de pantalla: cada paso, error y progreso conserva lectura clara y objetivos de 48 por 48 dp.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El flujo MUST representar visualmente el acceso C de la especificación 003 sin duplicar su lógica de seguridad.
- **FR-002**: Cada pantalla MUST pedir una sola decisión o dato principal, con título corto, una ayuda opcional de una línea y una acción dominante.
- **FR-003**: El código temporal MUST mostrarse mediante entrada clara, estados de carga/error/vencimiento y reenvío controlado; nunca muestra el código ni una contraseña en pantalla.
- **FR-004**: El teléfono MUST mostrarse enmascarado durante confirmación y permitir volver a corregirlo antes de solicitar un nuevo desafío.
- **FR-005**: El alta Cliente MUST pedir progresivamente nombre, apellido, fecha de nacimiento y dirección, reutilizando correo y teléfono confirmados.
- **FR-006**: Perfil MUST permitir pausar, retomar, revisar y editar el avance sin impedir Explorar.
- **FR-007**: Cliente MUST usar azul predominante, naranja de acento, G2, superficies sin bordes decorativos y texto breve.
- **FR-008**: El progreso se comunica con nombre del paso y contenido pendiente, no con porcentajes ornamentales ni color como único indicador.
- **FR-009**: Todas las acciones táctiles MUST tener al menos 48 por 48 dp, foco visible funcional, etiquetas accesibles y compatibilidad con texto al 200%.
- **FR-010**: El movimiento de confirmación o cambio de paso MUST durar como máximo 180 ms, no bloquear interacción y reducirse según preferencia del sistema.
- **FR-011**: Esta entrega MUST excluir documentos sensibles, selfie, pagos, contratación, chat y decisiones de proveedor.

### Key Entities *(include if feature involves data)*

- **Paso de acceso**: estado visual de correo, contraseña, teléfono o código temporal.
- **Progreso Cliente**: siguiente dato pendiente, datos guardados y revisión antes de confirmación.
- **Estado de desafío**: esperando código, validando, vencido, incorrecto o confirmado.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 9 de cada 10 participantes completan el acceso o identifican cómo corregir un código inválido sin ayuda.
- **SC-002**: 9 de cada 10 participantes completan el primer dato del perfil en menos de 45 segundos.
- **SC-003**: El 100% de los pasos conserva una acción clara, un estado de carga y una recuperación comprensible ante error.
- **SC-004**: El 100% de los controles principales sigue disponible con texto al 200%, tema claro/oscuro y movimiento reducido.

## Assumptions

- El backend de acceso C definido en 003 provee los estados, vencimiento y errores; este corte define su experiencia móvil.
- La elección Cliente ocurre una vez durante el alta de cuenta de negocio. El flujo Proveedor tendrá especificación visual separada.
- Jorge no interviene en acceso ni alta; puede orientar campos más adelante sin reemplazar este camino manual.

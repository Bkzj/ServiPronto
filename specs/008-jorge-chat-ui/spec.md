# Feature Specification: Conversación visual con Jorge

**Feature Branch**: `008-jorge-chat-ui`

**Created**: 2026-09-15

**Status**: Ready for planning

**Input**: Superficie móvil opcional para conversar por texto e imágenes con Jorge, el castor de ServiPronto. Debe orientar y recomendar sin ejecutar contrataciones, pagos ni acciones sensibles.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Pedir orientación en lenguaje natural (Priority: P1)

Una persona que no sabe qué servicio necesita abre a Jorge desde la navegación central o desde una sugerencia contextual. Escribe un problema cotidiano y recibe una respuesta breve, cálida y argentina, con una única pregunta útil cuando falta información.

**Why this priority**: la persona puede pedir ayuda sin conocer las categorías y sin reemplazar el recorrido manual.

**Independent Test**: abrir Jorge desde Inicio, enviar un texto ambiguo y comprobar que aparece una respuesta concisa, una pregunta de seguimiento o una salida manual clara, sin crear una solicitud.

**Acceptance Scenarios**:

1. **Given** una persona autenticada en cualquier sección de Cliente, **When** abre el botón central Jorge, **Then** llega a una conversación identificada con el castor y un mensaje inicial breve, sin obligarla a escribir.
2. **Given** un mensaje de problema incompleto, **When** Jorge necesita más contexto, **Then** formula una sola pregunta por vez y conserva visible lo ya escrito.
3. **Given** una persona que no quiere conversar, **When** vuelve o elige explorar manualmente, **Then** sale de Jorge sin penalización ni una contratación creada.

---

### User Story 2 - Adjuntar una imagen del problema (Priority: P1)

Una persona puede sumar una foto para explicar mejor un problema del hogar. Antes de enviarla entiende que la imagen se comparte con Jorge y puede quitarla. La interfaz no afirma diagnósticos profesionales por una foto.

**Why this priority**: una imagen reduce fricción para problemas difíciles de describir, manteniendo una decisión informada y segura.

**Independent Test**: seleccionar una imagen, ver su previsualización y quitarla antes de enviar; simular archivo no admitido, fallo de carga y análisis no disponible.

**Acceptance Scenarios**:

1. **Given** un borrador vacío o con texto, **When** la persona agrega una imagen admitida, **Then** ve una previsualización accesible y puede eliminarla antes de enviar.
2. **Given** una imagen no admitida, demasiado grande o que no se puede procesar, **When** intenta adjuntarla, **Then** recibe un motivo breve y puede continuar escribiendo sin perder el borrador.
3. **Given** una respuesta basada en imagen, **When** Jorge la muestra, **Then** se presenta como orientación y no como diagnóstico definitivo ni verificación de una condición física.

---

### User Story 3 - Ver recomendaciones y elegir el próximo paso (Priority: P1)

Después de entender el caso, Jorge puede mostrar hasta tres recomendaciones concretas de categoría, proveedor o recorrido manual. Cada recomendación distingue claramente entre información disponible, sugerencia y acción que todavía requiere decisión de la persona.

**Why this priority**: da utilidad real a la conversación sin inventar resultados ni convertirla en una contratación encubierta.

**Independent Test**: usar una respuesta con recomendaciones y comprobar que se ven datos esenciales, que se puede abrir la alternativa manual y que ninguna tarjeta confirma, reserva o cobra por sí sola.

**Acceptance Scenarios**:

1. **Given** que Jorge tiene una sugerencia pertinente, **When** entrega su respuesta, **Then** puede adjuntar hasta tres tarjetas con nombre, categoría, disponibilidad o señal disponible y un destino explícito.
2. **Given** una recomendación sin datos completos o sin candidatos, **When** se muestra el resultado, **Then** comunica la limitación en una frase y ofrece explorar o reformular, sin inventar disponibilidad, precios ni verificaciones.
3. **Given** una tarjeta que propone avanzar, **When** la persona la selecciona, **Then** llega a un flujo manual o de preparación claramente rotulado; no se confirma proveedor, precio, pago ni reserva desde Jorge.

---

### User Story 4 - Recuperarse de una respuesta incierta o un caso riesgoso (Priority: P2)

Una persona reconoce cuándo Jorge está pensando, no puede responder, perdió conexión o detecta una posible urgencia física. El estado preserva el contexto y propone un siguiente paso seguro, sin fingir que una herramienta actuó ni que un profesional revisó el caso.

**Why this priority**: la confianza depende de distinguir una ayuda disponible de una respuesta incompleta, especialmente ante situaciones sensibles.

**Independent Test**: simular espera prolongada, interrupción, respuesta vacía y orientación de seguridad; comprobar que siempre queda disponible el camino manual y que el mensaje no promete una acción inexistente.

**Acceptance Scenarios**:

1. **Given** un turno en proceso, **When** Jorge todavía no respondió, **Then** la conversación muestra un estado de espera comprensible y permite cancelar o volver sin duplicar el envío.
2. **Given** una falla de conexión, servicio no disponible o respuesta incompleta, **When** el turno no puede finalizar, **Then** muestra qué no pudo hacer, conserva el mensaje y ofrece reintentar o continuar manualmente.
3. **Given** un mensaje o imagen que sugiere riesgo físico inmediato, **When** Jorge responde, **Then** prioriza una indicación breve de seguridad y una derivación apropiada sin diagnosticar ni minimizar el riesgo.

### Edge Cases

- Conversación sin historial: mostrar una invitación breve y ejemplos opcionales, sin una pared de texto ni recomendaciones ficticias.
- Historial largo: mantener accesible el contexto reciente y una forma de volver al final sin ocultar el campo de redacción.
- Respuesta que llega después de cancelar o salir: no volver a abrir la conversación ni presentar una acción como realizada.
- Recomendación que deja de estar disponible antes de abrirse: comunicarlo y ofrecer alternativas manuales.
- Imagen local eliminada, permiso denegado o conexión interrumpida: no enviar un adjunto parcial ni perder el texto.
- Persona que usa lector de pantalla, texto ampliado o movimiento reducido: todos los estados, adjuntos y tarjetas conservan nombre, orden y propósito comprensibles.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La aplicación MUST ofrecer una entrada persistente a Jorge desde el centro de la navegación del Cliente y enlaces contextuales desde otras pantallas, sin impedir ningún recorrido manual.
- **FR-002**: La conversación MUST identificar a Jorge como el asistente de ServiPronto, con avatar de castor y tono breve, cálido, comprensivo y rioplatense; no debe presentarlo como una persona humana.
- **FR-003**: La pantalla MUST mostrar mensajes de la persona y de Jorge con orden temporal, identificación no basada solo en color y una zona de redacción de texto accesible.
- **FR-004**: Jorge MUST pedir como máximo una aclaración principal por respuesta cuando necesite información adicional; la interfaz debe permitir responder, editar el borrador o continuar manualmente.
- **FR-005**: La aplicación MUST permitir adjuntar imágenes desde el flujo de conversación, mostrar previsualización con texto alternativo o nombre accesible y permitir retirarlas antes del envío.
- **FR-006**: La interfaz MUST explicar de manera breve los errores de adjunto, procesamiento o envío y conservar el texto no enviado cuando sea posible.
- **FR-007**: Las respuestas relacionadas con imágenes MUST distinguir orientación de diagnóstico, verificación profesional o atención de emergencia.
- **FR-008**: La aplicación MUST presentar las recomendaciones de Jorge como tarjetas propias de ServiPronto, limitadas a tres por respuesta y con un destino, estado de disponibilidad y datos visibles que no induzcan a error.
- **FR-009**: Una tarjeta de recomendación MUST diferenciar una sugerencia de una acción confirmada; en este alcance no puede confirmar proveedor, reserva, cambio de precio, pago ni contratación.
- **FR-010**: La interfaz MUST ofrecer salida a Explorar o a la categoría pertinente cuando Jorge no tenga candidatos, tenga información insuficiente o la persona prefiera no continuar conversando.
- **FR-011**: La pantalla MUST representar claramente espera, respuesta parcial, interrupción, error recuperable, reintento y cancelación, sin afirmar que Jorge consultó datos o ejecutó una acción si no hay resultado confirmado.
- **FR-012**: Ante señales de riesgo físico, la interfaz MUST destacar una orientación breve de seguridad y derivación, sin diagnóstico definitivo, sin garantías y sin retrasar la posibilidad de salir del flujo.
- **FR-013**: La conversación MUST conservar el contexto visual del turno y evitar reabrir, reenviar o duplicar mensajes al volver desde otra pantalla o tras una respuesta tardía.
- **FR-014**: La interfaz MUST usar azul dominante de Cliente, naranja de acento, tipografía amable y curvatura continua G2. Botones, superficies y tarjetas no deben usar bordes decorativos ni líneas superior, izquierda, derecha o inferior como recurso de separación.
- **FR-015**: La interfaz MUST priorizar espacio, jerarquía tipográfica, superficies y color para agrupar; cada bloque debe usar texto breve y no repetir leyendas que el título, icono o destino ya expliquen.
- **FR-016**: La conversación MUST ser utilizable en temas sistema, claro y oscuro, con objetivos táctiles de al menos 48 × 48 dp, foco visible, contraste suficiente, orden de lectura lógico, texto ampliado al 200 % y alternativa sin movimiento.
- **FR-017**: Las transiciones de envío, aparición de respuesta y tarjetas MUST comunicar estado sin bloquear la interacción; con movimiento reducido se eliminan desplazamientos no esenciales y se conserva la señal de cambio.

### Key Entities *(include if feature involves data)*

- **Sesión de Jorge**: conversación visual asociada a una persona autenticada, con estado del turno y un historial funcional propio de ServiPronto.
- **Mensaje de conversación**: aporte de la persona o de Jorge con texto, momento, estado de entrega y semántica de seguridad cuando corresponda.
- **Adjunto de conversación**: imagen elegida para un turno, con estado de selección, validación, envío o error; no implica diagnóstico.
- **Recomendación de Jorge**: propuesta no contractual de categoría, perfil o recorrido manual, con estado y destino explícitos.
- **Estado del turno**: espera, respuesta disponible, interrumpido, error recuperable, cancelado o cerrado; es distinto de una contratación o pago.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: En una prueba moderada de cinco personas, al menos cuatro pueden iniciar una conversación, enviar un texto y volver al recorrido manual sin asistencia externa.
- **SC-002**: En una prueba de contenido, el 100 % de las respuestas de ejemplo ocupa como máximo tres frases breves antes de tarjetas o una pregunta de seguimiento.
- **SC-003**: En revisiones de los estados de espera, error, interrupción y seguridad, el 100 % indica explícitamente qué ocurrió y ofrece al menos una salida recuperable o manual.
- **SC-004**: En pruebas de interfaz, el 100 % de las tarjetas de recomendación deja claro que todavía no hay contratación, pago, reserva ni precio confirmado.
- **SC-005**: En temas claro y oscuro, texto al 200 %, lector de pantalla y movimiento reducido, las acciones de enviar, quitar imagen, reintentar, cancelar y explorar manualmente siguen siendo identificables y operables.

## Assumptions

- Esta superficie depende de una sesión de aplicación autenticada y de la navegación visual de Cliente especificada en 004; no define acceso ni alta de cuentas.
- El primer alcance usa texto e imágenes; voz, audios, videollamadas, chat humano, pagos, contratos y contratación ejecutable quedan fuera.
- El contenido puede provenir de un contrato propio de Jorge y adaptadores futuros, pero las pantallas no conocen proveedor, modelo ni SDK de IA.
- La recomendación utiliza datos disponibles cuando existan; la interfaz debe tener variantes de muestra y error mientras catálogo, perfiles y búsqueda se construyen en especificaciones separadas.
- Las reglas exactas de detección de riesgo, retención de conversaciones y permisos de imágenes requieren la validación de datos y operación antes de usar información real.

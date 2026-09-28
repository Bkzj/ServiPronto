# ServiPronto — documento central del producto

**Versión:** 1.1.0  
**Actualizado:** 2026-09-14  
**Origen:** conversación de descubrimiento con el fundador, tandas 1 a 24, aclaraciones intermedias, decisiones de stack e independencia de IA.  
**Estado:** base de producto documentada; aplicación y operaciones todavía no implementadas.

Este documento conserva el qué y el porqué de ServiPronto. Las decisiones explícitas del fundador predominan sobre recomendaciones anteriores. Los puntos identificados como propuesta, hipótesis o pendiente no son hechos implementados ni reglas comerciales definitivas. Su evolución se detalla en [DECISIONES](DECISIONES.md).

## 1. Visión y contexto

ServiPronto es un marketplace bilateral que conecta personas que necesitan servicios con profesionales que pueden realizarlos. La referencia de experiencia es la facilidad para buscar, solicitar y seguir un pedido de aplicaciones como Uber o PedidosYa, adaptada a servicios cuya duración, presupuesto y forma de prestación varían mucho.

El lanzamiento se enfoca en hogares de Tandil. El contratante puede estar en otra ciudad cuando pide un servicio para alguien que está dentro de la cobertura. La visión contempla expansión geográfica, más categorías y, en el futuro, empresas. El equipo actual es de dos ingenieros en sistemas, dispuestos a adaptarse a la tecnología, y se ocupa de producto, diseño, desarrollo, operación y comercialización.

En la selección técnica posterior se confirmó una base de código móvil compartida para iOS/Android, backend propio, PostgreSQL autoadministrado y acceso a una Mac. El fundador aceptó Flutter + Dart con la condición de no encontrar limitaciones relevantes en las bibliotecas necesarias; no se prometió compatibilidad universal y las integraciones críticas siguen pendientes de prueba. Aceptó NestJS + TypeScript y dejó Python como alternativa. Railway es la preferencia inicial de alojamiento. Ver [decisiones técnicas](DECISIONES.md#decisiones-de-stack).

No hay fecha, meta numérica de proveedores ni volumen de usuarios comprometidos. El presupuesto inicial declarado para infraestructura fue US$5/mes; posteriormente el fundador pidió analizar las opciones priorizando calidad, sin limitar el diseño a ese monto. Esta instrucción no autoriza gastos ni fija un nuevo presupuesto operativo. El consumo de IA se había planteado por separado y todavía no tiene presupuesto; los costos se acordarán antes de contratar. La primera prueba será cerrada con personas seleccionadas. Se pretende validar captación de ambos lados, servicios efectivamente realizados, pagos y utilidad de Jorge.

### Principios de negocio

- Encontrar profesionales adecuados con señales de confianza y disponibilidad real.
- Atender tanto servicios programados como necesidades de atención rápida.
- Dar al proveedor una herramienta útil de trabajo, agenda, presupuestos, cobro y reputación.
- Facilitar la continuidad y las contrataciones repetidas dentro de la plataforma.
- Ofrecer asistencia con IA de manera opcional. Todos los recorridos centrales tienen alternativa manual.
- Mantener el alcance inicial simple y administrable para dos personas.

## 2. Actores, cuentas y responsabilidades de interacción

### Cliente

Busca, compara, solicita, aprueba presupuestos, paga, sigue el servicio y califica. Puede contratar para sí o para otra persona. Tiene un avatar de Jorge tierno con identidad de cliente, distinto de las ilustraciones de oficios y de las fotos profesionales.

La propuesta de beta es que quien contrata y paga tenga 18 años o más; un menor puede recibir clases a través de un adulto responsable. El fundador expresó preferencia por este criterio y pidió opinión. La redacción de la política y las excepciones legales se revisan antes del lanzamiento; no se presupone que cualquier contratación por un menor sea legalmente imposible.

### Proveedor

Inicialmente representa a una persona, no a una empresa ni a un equipo. Puede ofrecer varias categorías y dispone de disponibilidad inmediata, agenda, oportunidades, solicitudes, presupuestos, historial y resumen de cobros.

### Administrador

Es un rol de acceso privilegiado con panel web, pensado para una pantalla amplia. Inicialmente puede existir un administrador total y luego perfiles con permisos limitados. No es una opción pública de autorregistro.

### Receptor del servicio

Persona que recibe la prestación cuando no coincide con quien contrata. No necesita crear una cuenta. Puede ser un familiar mayor, un hijo que recibe clases u otra persona indicada por el contratante. No se convierte automáticamente en titular de los pagos ni en administrador de la reserva.

### Reglas de cuenta

- **AC-01:** cliente y proveedor usan la misma aplicación, pero tienen cuentas de negocio independientes; no se cambia libremente el rol de una única cuenta.
- **AC-02:** el tipo de cuenta se elige al crearla. No se pregunta qué rol crear en cada inicio de sesión.
- **AC-03:** un teléfono puede estar asociado a una cuenta de cliente y una de proveedor; no a dos cuentas del mismo tipo. Se permite reutilizar correo entre ambos tipos. La resolución de acceso y recuperación queda para el diseño técnico.
- **AC-04:** mantener separados los datos de cliente y proveedor. El fundador sugirió tablas separadas; reutilizar autenticación es una propuesta técnica, no una decisión de base de datos cerrada.
- **AC-05:** registro progresivo, visual, pidiendo los datos de a uno o en pasos pequeños. El conjunto previsto para el cliente incluye nombre, apellido, teléfono, correo, fecha de nacimiento y dirección; no se exige llenar un formulario largo antes de explorar.
- **AC-06:** la referencia de ingreso es PedidosYa. Los métodos concretos de autenticación no se especificaron todavía.

## 3. Marca y sistema visual

Jorge es el castor de ServiPronto. Debe aparecer de forma consistente en la identidad, las categorías, el acompañamiento y momentos de la aplicación. La intención es ternura, cercanía y vida, sin perder claridad para contratar.

- **VI-01:** cliente: azul dominante con naranja de acento. Proveedor: naranja dominante con azul de acento. Ambos comparten el mismo sistema visual.
- **VI-02:** la paleta se inspira en el naranja fuerte del casco y el azul de uniforme de trabajo de las imágenes aportadas. No hay códigos de color definitivos.
- **VI-03:** tipografía redondeada, amigable y con carácter. La familia concreta no está elegida.
- **VI-04:** botones, tarjetas, buscadores, modales y paneles con esquinas de curvatura continua G2. No interpretar G2 como grosor de 2 píxeles ni dar por equivalente cualquier redondeado circular. La geometría y su implementación se validarán en el sistema de componentes.
- **VI-05:** modos sistema, claro y oscuro. En oscuro se contemplan versiones visualmente más suaves de los colores, con contraste legible.
- **VI-06:** expresiones, microanimaciones y transiciones dan vida a Jorge. Su ayuda contextual puede aparecer como viñeta breve con vibración. Frecuencia y disparadores exactos pendientes; respetar preferencias de accesibilidad es criterio de implementación.
- **VI-07:** iconos de categorías: versiones simplificadas y consistentes del castor realizando la profesión. Las ilustraciones completas sirven de referencia; no se consideran iconos pequeños finales.
- **VI-08:** formularios y recorridos deben poder usarse con texto legible, objetivos táctiles claros y estados que no se entiendan solo por su color.
- **VI-09:** presupuestos, exportaciones y panel administrativo también deben tener presentación moderna y cuidada.

El fundador enlazó [esta referencia visual sobre curvatura continua](https://www.applesfera.com/curiosidades/todos-productos-apple-se-rigen-patron-diseno-que-se-remonta-a-1744-que-clotoide-curva-euler). Se conserva como intención estética, no como especificación matemática de todos los productos de Apple.

Las imágenes contienen diferencias de estilo y algunos textos ajenos a la marca, como «BEAVER BUILD». Unificarlas y corregir los textos es trabajo de diseño pendiente; no se modificaron los originales.

## 4. Navegación y descubrimiento

- **EX-01:** navegación inferior del cliente: Inicio, Explorar, Jorge, Actividad y Perfil. El botón central usa la identidad de la app y abre la conversación con Jorge.
- **EX-02:** Inicio incluye buscador, banner publicitario/promocional y servicios destacados. No tiene una cabecera fija con todos los datos; los controles superiores, como notificaciones, dependen de la pantalla.
- **EX-03:** Explorar muestra opciones y proveedores en un catálogo tipo PedidosYa. El mapa no es el medio principal de exploración.
- **EX-04:** búsqueda por categorías, nombres de proveedores y problemas en lenguaje natural. Si la consulta requiere aclaraciones, ofrecer conversar con Jorge.
- **EX-05:** tarjetas de proveedor: foto, nombre y apellido completos, servicio, reputación, disponibilidad, distancia cuando sea pertinente, precio orientativo y verificaciones relevantes.
- **EX-06:** perfiles con experiencia, tareas que ofrece, fotos de trabajos, reseñas por aspectos y credenciales adecuadas a la categoría.
- **EX-07:** Actividad reúne pendientes, trabajos en curso, programados, finalizados, historial y una bandeja de mensajes vinculados a servicios. No hay una pestaña principal exclusiva de mensajes en la beta.
- **EX-08:** guardar proveedores como favoritos y volver a contratarlos desde el historial.

## 5. Catálogo inicial y datos por categoría

La lista inicial evolucionó de aproximadamente diez a once categorías al separar aire acondicionado de cámaras:

1. Plomería.
2. Electricidad.
3. Gas y calefacción.
4. Limpieza.
5. Jardinería.
6. Mudanzas y fletes.
7. Clases particulares.
8. Reparación técnica a domicilio.
9. Aire acondicionado.
10. Cámaras y seguridad.
11. Mecánica a domicilio.

- **CA-01:** categorías generales, sin árbol profundo de subcategorías en la beta. Esto reemplaza la idea inicial de categorización profunda.
- **CA-02:** Reparación técnica permanece agrupada; el proveedor aclara qué equipos y tareas atiende.
- **CA-03:** las tareas ofrecidas se seleccionan entre opciones definidas por ServiPronto y se aclaran con información breve. El proveedor puede sugerir una nueva categoría, pero no publicarla por sí mismo.
- **CA-04:** formularios adaptados al servicio. Ejemplos: mudanza con origen, destino y cosas a mover; profesor con materias, nivel y modalidad; reparación con descripción y fotos.
- **CA-05:** el administrador puede ocultar o publicar categorías preparadas. No se comprometió un editor completo de categorías, preguntas, comisiones ni reglas desde el panel.
- **CA-06:** habilitación gradual según disponibilidad de oferta. No se fijó un mínimo exacto de proveedores por categoría.
- **CA-07:** masajes y terapia ocupacional quedaron fuera de la selección inicial aceptada. Su incorporación posterior requiere definición propia.

«No sé qué profesional necesito» puede ser un acceso secundario a Jorge al final de las opciones, no una categoría contratada ni un reemplazo de su botón central.

## 6. Alta del proveedor y verificaciones

- **PR-01:** el proveedor carga una sola categoría al registrarse, con lo necesario para ofrecerla. Luego puede agregar otras; Jorge lo ayuda a reutilizar información y completar lo específico.
- **PR-02:** precios, cobertura, modalidades, disponibilidad aplicable y experiencia pueden variar por categoría, pero la persona conserva una agenda coherente entre todas.
- **PR-03:** identidad y contacto previstos: DNI, selfie de validación, domicilio, teléfono y correo. Cómo se verifica cada elemento y qué se almacena queda para el plan técnico y la revisión de requisitos.
- **PR-04:** la vinculación para recibir pagos es de la cuenta del proveedor; los precios pertenecen a cada categoría o servicio. Son datos distintos.
- **PR-05:** matriculación opcional como preferencia general del fundador, con ventaja para una credencial verificada. Las tareas que exijan habilitación deben investigarse y delimitarse antes de habilitarlas; la preferencia no resuelve por sí sola sus requisitos.
- **PR-06:** antecedentes penales muy opcionales. No usar su ausencia como acusación ni presumir que tener una insignia garantiza seguridad. El tratamiento de esa información requiere revisión específica.
- **PR-07:** perfil profesional con descripción breve, referencias y portfolio acotado. Compresión y límites de imágenes para controlar almacenamiento; seis imágenes por categoría fue una propuesta, no un límite confirmado.
- **PR-08:** documentación con vencimiento y alertas de renovación cuando corresponda.
- **PR-09:** estados iniciales: Incompleto, En revisión, Requiere cambios, Aprobado, Rechazado y Suspendido.
- **PR-10:** solo un proveedor aprobado aparece en búsquedas y puede recibir trabajos. El administrador puede solicitar correcciones indicando el motivo.

## 7. Solicitudes, disponibilidad y elección

- **SO-01:** combinación de exploración directa, recomendaciones y solicitudes de propuestas. Jorge puede orientar, pero no es obligatorio usarlo.
- **SO-02:** el proveedor debe aceptar su participación y el cliente debe revisar el perfil y confirmar su elección. En una urgencia, aceptar primero no equivale por sí solo a quedar contratado automáticamente.
- **SO-03:** el cliente puede priorizar rapidez o comparación de opciones.
- **SO-04:** en urgencias pesa especialmente la cercanía; también importan cobertura, disponibilidad, idoneidad y agenda. Una credencial o un buen precio no compensa no poder atender el trabajo.
- **SO-05:** el envío a todos los disponibles o a grupos sucesivos fue discutido, sin cerrar algoritmo ni tiempos. La propuesta de grupos cercanos con expansión gradual es un valor inicial a validar, no una regla ya aprobada.
- **SO-06:** si no se avanza o no hay respuestas, Jorge intenta ayudar proponiendo alternativas de horario, cobertura o interpretación del problema. Los cambios relevantes se presentan al cliente.
- **SO-07:** antes de confirmar, el proveedor ve descripción, fotos, zona aproximada, distancia, precio de visita o seña, horario e indicadores permitidos del cliente. La dirección exacta se revela al proveedor confirmado.
- **SO-08:** rechazar solicitudes puede incluir motivo, útil para mejorar las oportunidades sugeridas. Un rechazo no se equipara automáticamente a una ausencia o cancelación de trabajo confirmado.
- **SO-09:** límites de cobertura por proveedor y datos del domicilio del servicio; no usar sin más la ubicación del teléfono del contratante.

Se delegó al asistente proponer las categorías de urgencia. La propuesta inicial prioriza plomería, electricidad, gas/calefacción, mecánica y tareas técnicas apropiadas. Sus etiquetas y reglas se probarán. Ante indicios de peligro, Jorge prioriza seguridad y los canales de emergencia correspondientes; no promete resolver una emergencia con la llegada de un proveedor de la plataforma.

## 8. Visita, presupuesto y precios

### Visita con valor propio

- **VP-01:** el proveedor define un precio orientativo y puede establecer un importe de visita o traslado, incluso $0. ServiPronto recomienda cobrar la visita cuando corresponda.
- **VP-02:** cuando la visita tiene costo, se cobra antes de concurrir al domicilio. Compensa ese tiempo aunque el cliente no contrate la reparación.
- **VP-03:** una visita realizada se registra simplemente como «Visita». No se la presenta como trabajo fallido por no tener continuación.
- **VP-04:** el pago de visita no se interpreta automáticamente como anticipo descontable de una reparación posterior. La propuesta de descontarlo por defecto fue corregida por el fundador.
- **VP-05:** el presupuesto puede tener un precio aparte, conocido antes de solicitarlo. No se puede cobrar dos conceptos que no se hayan informado y aceptado.

El término «seña» se usó coloquialmente para el costo de ir. La interfaz deberá aclarar qué se paga y qué incluye; no usar nombres ambiguos para esconder el costo de la visita o de la elaboración del presupuesto.

### Presupuesto asistido

- **VP-06:** Jorge hace preguntas al proveedor y organiza su información en una plantilla HTML propia con salida PDF descargable.
- **VP-07:** contiene alcance, tareas, mano de obra, materiales declarados, visita/traslado, duración estimada, vigencia, total y condiciones pertinentes. Solo se muestran conceptos que correspondan al caso.
- **VP-08:** el proveedor confirma el contenido antes de enviarlo. Jorge no inventa precios, medidas, materiales ni certezas de diagnóstico.
- **VP-09:** el cliente puede aceptar, rechazar o pedir cambios desde la conversación o la vista del presupuesto. Conservar el acuerdo aceptado y sus revisiones.
- **VP-10:** máximo de tres presupuestos simultáneos por solicitud, no por cuenta. La liberación de cupos tras rechazo o vencimiento es detalle de implementación pendiente.
- **VP-11:** el fundador quiere formato estándar y marca de ServiPronto. La propuesta es identificar al proveedor como emisor y a ServiPronto como herramienta de generación. La marca visual no debe presentarse como firma fiscal, peritaje ni garantía de la reparación.
- **VP-12:** Jorge puede dar una orientación aproximada gratuita, identificada como estimación; el presupuesto profesional depende de la información y confirmación del proveedor.

### Por categoría

- **VP-13:** clases particulares con precio por hora y pago al reservar. Modalidad en domicilio del cliente/receptor, en domicilio del profesor o por Google Meet, según lo ofrecido.
- **VP-14:** limpieza por hora, con duración acordada. El proveedor puede proponer un precio diferente para tiempo adicional; el cliente lo aprueba antes de cobrarlo. Jorge asesora sin fijar unilateralmente el importe.
- **VP-15:** oficios con visita/diagnóstico, mano de obra y materiales separados cuando corresponda. El modelo preciso de cada rubro se configura en desarrollo, no en un editor administrativo universal inicial.

## 9. Continuidad, trabajos largos y materiales

El fundador aceptó expresamente el enfoque de continuidad por etapas para reducir la salida de trabajos hacia acuerdos externos.

- **ET-01:** desde una visita se puede continuar con el mismo profesional y conservar datos, fotos, chat e historial del trabajo.
- **ET-02:** el proveedor, manualmente o con Jorge, define etapas con alcance, fecha, importe y condiciones de pago. El cliente las revisa y acepta.
- **ET-03:** cada etapa tiene confirmaciones y cobros asociados. Puede requerir varias jornadas; cerrar una etapa no cierra las restantes.
- **ET-04:** los adicionales se incorporan al mismo trabajo mediante una modificación aprobada. No se aumenta unilateralmente el precio aceptado.
- **ET-05:** las etapas no multiplican artificialmente los trabajos completados o las calificaciones de un único encargo.
- **ET-06:** materiales aportados por el cliente o importes declarados por el proveedor pueden quedar registrados. Un comprobante adjunto aporta respaldo; su ausencia no convierte el importe en verificado.
- **ET-07:** ServiPronto no conoce necesariamente dónde, cómo o por cuánto se compraron materiales fuera de la plataforma. No atribuir a la app control ni auditoría de hechos que no puede comprobar.
- **ET-08:** una visita sin continuación registrada no prueba evasión, fraude ni contratación externa. Se puede pedir feedback sin acusación automática.

La propuesta de retención combina facilidad de continuidad, presupuestos presentables, cobros por avances, agenda, historial, reputación y futuras recompensas. Comisión menor o tope para continuaciones es una hipótesis comercial pendiente, no una tarifa prometida.

## 10. Pagos, ingresos y propinas

- **PA-01:** Mercado Pago será el único procesador inicial. El proveedor vincula la cuenta correspondiente para cobrar.
- **PA-02:** pagos del servicio dentro de la aplicación como modelo buscado. Esto no implica capacidad de detectar o controlar todos los acuerdos externos.
- **PA-03:** comisión de ServiPronto del 0% durante la beta. El costo del procesador queda a cargo del proveedor. Mostrar la diferencia con claridad.
- **PA-04:** modelo futuro: publicidad, comisiones por consulta/contratación y premium para clientes y proveedores. Comisiones variables por rubro, todavía sin porcentajes ni base imponible comercial elegidos.
- **PA-05:** el fundador prefiere liquidaciones agrupadas semanalmente buscando reducir costos. El ahorro y la disponibilidad de esa modalidad siguen pendientes de validación; no están prometidos.
- **PA-06:** cobro anticipado con liberación al finalizar es un comportamiento deseado, cuya viabilidad depende del producto de Mercado Pago y del medio de pago. No confundir una reserva de tarjeta, un cobro capturado y la disponibilidad para el proveedor.
- **PA-07:** el panel del proveedor muestra cobros, pendientes, importes transferidos/acreditados y descuentos con nombres que correspondan al flujo realmente elegido. No se pretende una billetera para transferir entre usuarios ni almacenar saldo para comprar en ServiPronto.
- **PA-08:** propinas opcionales, incentivadas sin obligación, sin comisión de ServiPronto; solo los costos del procesador que correspondan.
- **PA-09:** el fundador desea que recibir propinas sea una señal positiva de valoración. Cómo influye en insignias o ranking sigue abierto; no se aprobó una fórmula ni el aumento automático de estrellas por importe.
- **PA-10:** separar el presupuesto, el registro de un pago y el comprobante fiscal. Requisitos fiscales del proveedor, facturación del servicio y obligaciones de ServiPronto se revisan para Argentina antes de cobrar en producción.

### Validaciones externas ya identificadas

Mercado Pago documenta [división de pagos entre proveedor y marketplace](https://www.mercadopago.com.ar/developers/es/docs/split-payments/split-1-1/integration-configuration/integrate-marketplace). Esto no demuestra por sí solo que pueda retenerse cualquier pago hasta completar un trabajo ni liquidarlo semanalmente por instrucción de ServiPronto.

La [reserva de fondos en tarjeta documentada para Checkout Bricks](https://www.mercadopago.com.ar/developers/es/docs/checkout-bricks/additional-content/payment-management/make-value-reserve) tiene validez de siete días. No asumir una reserva indefinida para trabajos largos ni extrapolarla a todos los medios de pago.

Los [costos de Checkout](https://www.mercadopago.com.ar/herramientas-para-vender/check-out) dependen, entre otros factores, del plazo de disponibilidad y se aplican a ventas aprobadas. No se tomó como hecho que agrupar retiros reduzca la comisión por venta.

ARCA describe las [obligaciones de facturación de monotributistas](https://www.arca.gob.ar/monotributo/ayuda/facturacion.asp). Esto es una referencia para la revisión; no resuelve el encuadre completo del marketplace ni el de cada prestador.

## 11. Códigos, etapas y cierre

- **CO-01:** doble confirmación: al comenzar, el proveedor muestra o comunica su código y el cliente lo ingresa; al terminar, el cliente entrega su código y el proveedor lo ingresa.
- **CO-02:** códigos vinculados al trabajo o etapa correspondiente, únicos para esa confirmación. Vigencia, reintentos y recuperación son parte del diseño técnico pendiente.
- **CO-03:** estados operativos contemplados: aceptado/confirmado, en camino, llegó, iniciado y finalizado, adaptados a servicios online o realizados en el domicilio del proveedor.
- **CO-04:** en trabajos largos se confirma la etapa, manteniendo abiertas las demás. El total del trabajo no cambia por terminar una jornada incidental.
- **CO-05:** para contratación familiar, quien contrató puede confirmar desde su cuenta después de hablar con el receptor. Registrar que se trata de una confirmación remota; no presentarla como geolocalización o presencia verificada del contratante.
- **CO-06:** fallo de conexión, imposibilidad de usar un código o desacuerdo sobre el cierre requieren recuperación o revisión; no cerrar ni mover dinero basándose únicamente en una inferencia de Jorge.

El código registra una conformidad de inicio o finalización. No demuestra por sí solo que el trabajo esté libre de defectos, que ambas partes estén físicamente presentes ni que proceda una liberación inmediata del dinero.

## 12. Cancelaciones, ausencias e incidentes

### Intención comercial todavía por convertir en regla final

El fundador propuso cancelación gratuita con al menos tres horas antes de la salida prevista del proveedor, cargo parcial dentro de ese margen si aún no salió y cargo total si ya está en camino. El asistente sugirió limitar o adaptar ese cargo por rubro, especialmente cuando aún no se prestó el trabajo. No hubo aprobación explícita de esa alternativa.

**Pendiente:** importe parcial, alcance de «total», tratamiento exacto del límite de tres horas, referencia de salida prevista, visitas sin costo y adecuación de la política. No activar cargos automáticos con esta ambigüedad.

- **IN-01:** si el proveedor cancela, ayudar a buscar un reemplazo y permitir al cliente decidir cómo continuar. No sustituirlo sin confirmación.
- **IN-02:** no se definió un número de cancelaciones para sancionar. Se propuso evaluar gravedad, anticipación, volumen e historial, con revisión de casos dudosos.
- **IN-03:** ante ausencia denunciada, solicitar evidencia de la visita: foto tomada en ese momento, ubicación asociada a esa toma, horario e intentos de contacto. No implica seguimiento permanente.
- **IN-04:** al inicio, el equipo revisa manualmente ausencias para reducir errores y estafas. Foto o GPS aportan evidencia; no son demostración infalible por sí solos.
- **IN-05:** fotos antes y después del servicio cuando sean útiles, según rubro.
- **IN-06:** denuncias graves pueden producir suspensión preventiva mientras se revisa; bloqueo definitivo si la investigación determina la responsabilidad correspondiente.
- **IN-07:** ante una emergencia real del proveedor, Jorge ayuda a buscar una alternativa sin aplicar automáticamente una penalización por el solo aviso.
- **IN-08:** Jorge recibe el problema y deriva casos graves o sensibles a la operación humana. La beta no presupone atención humana permanente las 24 horas.
- **IN-09:** el fundador no desea inicialmente un mecanismo propio general de congelamiento de pagos por insatisfacción ni una garantía de volver a corregir el trabajo. Sí quiere reseñas y revisión de incidentes. Esto no equivale a eliminar reclamos, contracargos ni derechos aplicables; validar el procedimiento antes del lanzamiento.

## 13. Contratación familiar y acceso sencillo

- **FA-01:** contratar para otra persona es primordial desde la beta, no una extensión futura.
- **FA-02:** guardar personas y domicilios habituales, con etiquetas como «Casa de mamá».
- **FA-03:** distinguir contratante que administra/paga, receptor y dirección del servicio.
- **FA-04:** buscar por la dirección del receptor aunque el contratante esté lejos. No exigir que su ubicación actual coincida con el lugar de prestación. Para clases online no imponer una presencia física ficticia.
- **FA-05:** el receptor no está obligado a instalar la app ni a tener una cuenta. Se contempla apoyo del familiar para las confirmaciones.
- **FA-06:** el proveedor confirmado recibe nombre e indicaciones pertinentes: ingreso, timbre, cómo avisar llegada y otras instrucciones aportadas para atender el servicio. Los teléfonos no se muestran a la contraparte.
- **FA-07:** quien paga conserva la aprobación de gastos adicionales; no se deduce autorización financiera de la sola presencia del receptor.
- **FA-08:** el contratante puede publicar la reseña tras consultar a quien recibió el servicio, con indicación de que contrató para otra persona.

No se debe confundir edad avanzada con incapacidad. El flujo ofrece ayuda y delegación práctica sin exigir que todos los receptores aprendan a utilizar una cuenta.

## 14. Agenda, recurrencia y estimaciones

- **AG-01:** disponibilidad inmediata y calendario de días/horarios.
- **AG-02:** inicio del proveedor con control Disponible/No disponible, calendario, pendientes y oportunidades.
- **AG-03:** bloquear horarios por compromisos personales o trabajos conseguidos fuera de ServiPronto. Su detalle es privado y sirve para evitar superposiciones.
- **AG-04:** tener varias categorías no multiplica la capacidad de atender en simultáneo. Las reservas comparten disponibilidad de la misma persona.
- **AG-05:** duración orientativa apoyada en información pública pertinente, descripción del caso y datos del proveedor. Registrar fuente, fecha y contexto cuando se incorporen referencias.
- **AG-06:** traslado según domicilios y recorrido; margen configurable para preparación e imprevistos. Jorge ayuda a sugerirlo.
- **AG-07:** con suficientes servicios reales, mejorar estimaciones. No se considera que ya exista una base fiable de duración para todos los oficios de Tandil.
- **AG-08:** botón para informar demora, comunicar nueva estimación y ayudar a los siguientes clientes a reorganizarse. Un cambio de cita no queda aceptado unilateralmente.
- **AG-09:** reservar servicios recurrentes manteniendo profesional y horario acordado. Pago por encuentro según sus condiciones, sin imponer un abono mensual.
- **AG-10:** pausa temporal de la recurrencia, por ejemplo vacaciones, conservando la continuidad cuando ambas partes lo acuerden.

La propuesta de agenda es duración estimada del trabajo + traslado + margen. El tiempo estimado no debe transformarse automáticamente en penalización si se excede. [Google Routes](https://developers.google.com/maps/documentation/routes/config_trade_offs) es un ejemplo investigado de cálculo con tráfico; no fue elegido ni contratado como integración.

## 15. Chat y notificaciones

- **CH-01:** chat interno asociado a una solicitud concreta de visita o presupuesto. El fundador delegó ajustar el momento de apertura; no es un chat público irrestricto con cualquier perfil.
- **CH-02:** texto e imágenes. Mensajes de voz expresamente excluidos.
- **CH-03:** mantener ocultos los números de teléfono de las contrapartes. No hay autorización para exponerlos como atajo de contacto.
- **CH-04:** mensajes accesibles desde Actividad y desde el historial del servicio, con posibilidad de guardar al proveedor y volver a contratarlo.
- **CH-05:** confirmación de lectura importante para el fundador. Mostrar lectura al abrir la conversación es el criterio inicial propuesto, no al mero envío de una notificación.
- **CH-06:** avisos transaccionales de mensajes y servicios forman parte de lo esperado. Su entrega no garantiza lectura ni reemplaza confirmaciones explícitas.
- **CH-07:** la tanda 24 propuso recordatorios con horarios concretos, sonido especial para urgencias, pausa automática por no responder y notificaciones promocionales. La respuesta fue «no, por el momento no; más adelante sí». Se difieren estos extras sin dar por eliminados los avisos transaccionales ya acordados. Ver [D-24](DECISIONES.md#d-24-notificaciones-adicionales).

No se definió retención indefinida de mensajes ni una política de chat de solo lectura tras el cierre. Son detalles de ciclo de vida a resolver con requisitos de soporte y privacidad.

## 16. Jorge: personalidad, capacidades y límites

- **JO-01:** castor tierno, adorable, argentino, muy amable, paciente y comprensivo. Habla de vos y evita respuestas largas.
- **JO-02:** interacción inicial por texto y comprensión de imágenes. Sin conversación de voz en este alcance.
- **JO-03:** pregunta de manera conversacional cuando necesita entender el problema, preferentemente de a una para no abrumar.
- **JO-04:** recomienda opciones concretas y ayuda a contratar. No explica automáticamente todos los criterios de recomendación; si se le pregunta, responde corto y con fundamento real.
- **JO-05:** ayuda al proveedor a completar categorías, fijar referencias de visita, organizar horarios y redactar presupuestos con los datos que este aporta.
- **JO-06:** consulta herramientas para información actual de cuentas, preferencias, historial, favoritos, domicilios, servicios, disponibilidad, trabajos y pagos, según permisos.
- **JO-07:** el fundador requiere orquestadores, con preparación separada de las consultas a IA y pocos módulos responsables de comunicarse con modelos. El diseño de referencia separa coordinación de conversación, flujos, gateway y adaptadores; no exige un modelo o microservicio por agente. Modelos, biblioteca y cantidad de agentes siguen pendientes. La interfaz mantiene un único personaje.
- **JO-08:** ayuda proactiva si alguien se atasca, no encuentra resultados o tiene dificultades; viñeta breve y vibración dentro de reglas de accesibilidad y frecuencia por definir.
- **JO-09:** puede preparar una solicitud, un presupuesto o una acción. No elige definitivamente proveedor, acepta un cambio de precio ni realiza un pago sin la autorización explícita correspondiente.
- **JO-10:** ante riesgo físico prioriza seguridad y derivación apropiada. No realiza un diagnóstico profesional definitivo por una foto.
- **JO-11:** guía general para completar requisitos y formalización del proveedor, usando información vigente y sin inventar obligaciones o resultados de trámites.
- **JO-12:** soporte inicial y derivación humana con contexto cuando el caso lo requiere.
- **JO-13:** independencia de proveedores de IA mediante un contrato propio de ServiPronto y adaptadores de entrada/salida. Cambiar entre OpenAI y Gemini compatibles debe poder configurarse sin reescribir pantallas ni reglas de negocio, una vez implementados y probados ambos adaptadores.
- **JO-14:** solo los adaptadores se comunican con las APIs de modelos. Preparación, orquestación y servicios de negocio usan interfaces propias, sin tipos ni claves de SDK externos; las herramientas mantienen sus permisos y confirmaciones fuera del modelo.
- **JO-15:** conservar historial funcional y estado de negocio propios. Aislar el estado privado de cada API y cambiar de destino en puntos seguros; no prometer transferir razonamiento interno ni repetir operaciones por un cambio de proveedor.
- **JO-16:** versionar contratos, instrucciones, herramientas e integraciones; verificar capacidades y comportamiento por destino. Una incompatibilidad no autoriza descartar imágenes, quitar validaciones o ejecutar acciones sin confirmación. La independencia reduce el alcance del mantenimiento, no lo elimina.

El detalle y los criterios de verificación se conservan en [ARQUITECTURA_JORGE](ARQUITECTURA_JORGE.md), que distingue el requisito del fundador del diseño propuesto y las pruebas pendientes.

La personificación expresa identidad de marca; no se presenta a Jorge como un operador humano. Debe distinguir sugerencias, datos verificados y acciones realmente ejecutadas. Datos de otros usuarios, documentos privados o conversaciones no autorizadas no se convierten en información disponible por el solo hecho de que Jorge use herramientas.

## 17. Reputación, ranking e incentivos

- **RE-01:** reseñas por dimensiones relevantes a cada categoría, más una representación general por colores estilo MercadoLibre y un resumen comprensible en el perfil.
- **RE-02:** cercanía especialmente importante en urgencias; calificación, cancelaciones, respuesta y comportamiento real son señales de confianza.
- **RE-03:** el fundador delegó cómo dar oportunidades a nuevos proveedores. Propuesta: mostrar que son nuevos, aprovechar verificaciones y disponibilidad y rotar oportunidades comparables, sin inventar valoraciones.
- **RE-04:** el fundador delegó la reputación del cliente buscando minimizar perjuicios. Propuesta inicial: indicadores objetivos e información interna revisable, sin estrellas públicas; no hay fórmula definitiva aprobada.
- **RE-05:** insignias tipo videojuego, ganadas por verificaciones y logros. Los beneficios concretos llegan más adelante. No se pueden comprar.
- **RE-06:** futuras recompensas por tomar y completar trabajos, buena atención, puntualidad y confiabilidad. No premiar aceptar indiscriminadamente trabajos que luego se cancelan.
- **RE-07:** propinas como posible señal de satisfacción, sin fórmula cerrada ni certeza de que quien no recibe propina atiende peor.
- **RE-08:** publicidad separada del ranking orgánico. El fundador rechaza el pay to win.

La ponderación, el mínimo de reseñas, los umbrales de colores y las reglas de oportunidad para nuevos requieren propuesta y prueba. No están definidos por copiar de forma literal los sistemas de otras plataformas.

## 18. Panel, soporte, publicidad y métricas

- **AD-01:** panel web privado con información accesible y acciones simples desde la ficha de la entidad correspondiente.
- **AD-02:** aprobar, rechazar o solicitar nuevamente documentación; revisar el motivo y estado del alta.
- **AD-03:** pausar cliente, proveedor, categoría o zona cuando corresponda, con trazabilidad administrativa.
- **AD-04:** consulta de conversaciones con acceso justificado y registrado.
- **AD-05:** revisar denuncias, ausencias, problemas operativos y transacciones. La revisión inicial puede ser manual.
- **AD-06:** cargar y rotar banners, promociones e ilustraciones fácilmente. Ocultar o publicar contenido y categorías preparadas.
- **AD-07:** el panel no será inicialmente un editor de requisitos, preguntas, comisiones, radios y reglas de toda la aplicación.
- **AD-08:** avisos por WhatsApp al administrador para situaciones graves y nuevas altas que necesiten revisión. No se proporcionó un número ni se eligió una integración. Propuesta de implementación: aviso breve y enlace seguro al caso, sin reenviar documentos sensibles completos.
- **AD-09:** soporte permanece registrado en ServiPronto aunque el administrador reciba un aviso externo. No prometer atención humana instantánea.
- **AD-10:** informes descargables en Excel/CSV con presentación cuidada; definir columnas y permisos al implementar.

El banner puede contener publicidad y promociones de ServiPronto. No se aprobó vender posiciones de ranking. Recomendaciones patrocinadas de lugares para materiales son una posibilidad a explorar; la marca publicitaria debe distinguirse de la recomendación de Jorge y no implica que la app tramite la compra de materiales.

### Métricas a incluir

- Usuarios y proveedores, altas en revisión, aprobados y disponibilidad por categoría/zona.
- Solicitudes, visitas, presupuestos, aceptaciones, trabajos y etapas; distinguirlos para no duplicar cifras.
- Cobros procesados, costos del procesador, comisión efectiva de ServiPronto y pendientes según el procesador.
- Continuidad: visitas que generan propuestas y propuestas que terminan contratadas dentro de la app.
- Cancelaciones, ausencias, incidentes y tiempos de revisión.
- Recontratación, recurrencia y favoritos.
- Jorge: conversaciones, solicitudes preparadas, contrataciones atribuibles y derivaciones; medir utilidad y costos.
- Contenido publicitario: métricas pertinentes para demostrar alcance, sin afirmar que los datos personales o las conversaciones se venderán a anunciantes.

Los números objetivo y las ventanas de medición se fijarán con una línea de base de la beta. El fundador pidió métricas en cantidades, no comprometió porcentajes de conversión ni ingresos mínimos.

## 19. Entidades conceptuales

Este listado organiza la información sin fijar todavía tablas ni arquitectura. PostgreSQL autoadministrado fue elegido posteriormente como motor; el esquema sigue pendiente.

- Identidad de acceso y cuentas de cliente/proveedor.
- Perfil profesional, categoría ofrecida, tareas, cobertura y credenciales.
- Domicilio guardado, receptor y relación autorizada con la reserva.
- Disponibilidad, bloqueo de agenda, cita y recurrencia.
- Solicitud, candidato, visita, trabajo y etapa.
- Presupuesto, revisión, concepto y aceptación.
- Pago, costo, comisión, propina y estado de disponibilidad del procesador.
- Conversación, mensaje, adjunto y lectura.
- Confirmación por código o remota, con actor y momento.
- Reseña, aspectos evaluados, insignia e indicadores de reputación.
- Incidente, evidencia y revisión administrativa.
- Banner, promoción y visibilidad de contenido.
- Sesión de Jorge, consulta de herramienta, acción propuesta y autorización.
- Evento de métricas y registro de acceso administrativo.

## 20. Escenarios que deberán verificarse en la beta

Estos son criterios de producto para las futuras especificaciones, no pruebas ya ejecutadas:

1. Un cliente completa una contratación manual sin abrir a Jorge.
2. Un proveedor no aprobado no aparece ni recibe trabajos; se publica después de la aprobación.
3. El mismo teléfono crea una cuenta de cada tipo, pero no duplica cuentas del mismo tipo.
4. Una visita de precio informado se paga antes de concurrir y se cierra como Visita aunque no haya reparación posterior.
5. Una solicitud no mantiene más de tres presupuestos simultáneos; el límite no bloquea otras solicitudes de la misma cuenta.
6. Un presupuesto confirmado por el proveedor conserva en su PDF los importes y condiciones aceptados.
7. Un adicional no se cobra sin aprobación de quien paga.
8. Un trabajo por etapas mantiene pendientes las etapas no completadas y no duplica su reputación por cada cobro.
9. Un familiar desde otra ciudad contrata para Tandil sin una ubicación ficticia y sin exigir cuenta al receptor.
10. Una confirmación remota queda distinguida de una confirmación presencial.
11. Los códigos no se reutilizan para otra etapa ni permiten que un actor confirme lo que no le corresponde.
12. La agenda considera compromisos externos y las categorías del mismo proveedor.
13. Una demora genera un aviso y una propuesta; no cambia silenciosamente el acuerdo de otro cliente.
14. Los mensajes de voz están excluidos y los teléfonos de las contrapartes no se muestran.
15. Un administrador debe justificar el acceso a una conversación y esa consulta queda registrada.
16. El resumen económico distingue comisión ServiPronto del 0%, costo de Mercado Pago y estado real de cada pago.
17. Una falla de conexión o una respuesta incierta del procesador no provoca un cobro duplicado ni un éxito ficticio.
18. El usuario entiende los estados importantes tanto en modo claro como oscuro y sin depender exclusivamente del color.

## 21. Fuera del compromiso inicial y pendientes

No están implementados ni comprometidos para la beta: empresas, subcategorías profundas, premium, porcentajes de comisión futuros, recompensas con beneficios concretos, garantías ampliadas, custodia propia de dinero, liquidación semanal no validada, chat de voz, video integrado propio ni los extras de notificaciones de la tanda 24.

La selección final de herramientas, requisitos por oficio, política de cancelación, requisitos fiscales, tratamiento de documentos, autenticación, costos y reglas cuantitativas se resolverá con investigación y pruebas. Consultar [DECISIONES](DECISIONES.md) y [ROADMAP](../ROADMAP.md). No hace falta un nuevo cuestionario general al fundador.

## 22. Referencias visuales aportadas

Las rutas siguientes son las originales compartidas en la conversación. Las imágenes se observaron en los mensajes, pero no se copiaron, modificaron ni verificaron en disco en esta entrega documental.

- Logo principal: `C:/Users/nouso/AppData/Local/Temp/codex-clipboard-84418015-0888-4fbe-ac25-86e58e8f2fbb.png`.
- Carpeta de ilustraciones: `C:/Users/nouso/OneDrive/Escritorio/ServiPronto/Proveedores/`.
- Archivos: `Electricista Icon.png`, `Gasista Icon.png`, `General Icon.png`, `Jardinero Icon.png`, `Limpieza Icon.png`, `Mudanza Icon.png`, `Particular Icon.png` y `Plomero Icon.png`.

Antes de producir activos definitivos se deberá verificar disponibilidad de los originales, normalizar el personaje, eliminar textos ajenos a la marca y preparar las variantes simples de categorías y el avatar de cliente.

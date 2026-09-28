# ServiPronto — decisiones y pendientes

**Actualizado:** 2026-09-14. **Fuente:** conversación con el fundador, cierre de las tandas iniciales, selección de tecnologías y arquitectura independiente de IA.

Complementa [PRODUCTO](PRODUCTO.md). Es un registro de descubrimiento: no certifica implementación, contratos, habilitaciones, publicación ni pruebas reales.

## Cómo interpretar el estado

- **Confirmado:** respuesta expresa del fundador o aceptación clara de un enfoque completo.
- **Delegado:** el fundador pidió al asistente elegir. Se puede avanzar con una propuesta razonable, identificando sus hipótesis.
- **Propuesto:** sugerencia del asistente sin aprobación inequívoca; no transformarla silenciosamente en requisito cerrado.
- **Validar:** depende de investigación, requisitos externos, viabilidad técnica o pruebas de producto.
- **Posterior:** fuera del compromiso inicial o aplazado.

Una respuesta genérica de aprobación adopta el enfoque razonablemente discutido, pero no convierte en hechos comprobados las capacidades de un procesador ni resuelve una obligación legal. Una respuesta nueva y específica corrige las formulaciones anteriores.

## Recorrido de las decisiones

| ID / tanda | Acuerdos y evolución | Estado y límites |
| --- | --- | --- |
| D-01 | Comienzo del proyecto, equipo de dos personas, hogares de Tandil, servicios urgentes y programados. Castor como identidad. Experiencia tipo Uber/PedidosYa con IA opcional. | Confirmado. Reemplaza la posible lectura de una app exclusivamente conversacional. |
| D-02 | Inicio con buscador, banner y destacados; botón central de Jorge; perfiles fiables por rubro; proveedor acepta; chat interno sin teléfonos públicos. | Confirmado. Detalles de selección híbrida por resolver; incentivos pedidos para más adelante. |
| D-03 | Publicidad y comisiones, futuros premium; pagos dentro de la app; seña según rubro; Jorge ayuda a crear presupuestos; adicionales aprobados. | Confirmado como modelo. No se aprobó vender ranking ni una garantía automática al cliente. |
| D-04 | Incorporación por múltiples canales; matrícula opcional como preferencia general; agenda y disponibilidad inmediata; tarifa de traslado; comisión variable. | Confirmado como intención. Requisitos por oficio, algoritmo de asignación y porcentajes pendientes. |
| D-05 | Cliente revisa perfil incluso en urgencia; rapidez o comparación; cercanía y comportamiento real; reputación por aspectos y colores; favoritos. | Confirmado. Oportunidades a nuevos y reputación del cliente delegadas; sin fórmula final. |
| D-06 | Jorge argentino, tierno, breve, texto e imágenes, ayuda proactiva, datos mediante herramientas y orquestador de agentes; acciones sensibles requieren aprobación. | Confirmado. La independencia arquitectónica se amplía en T-11; modelos, disparadores y cantidad de agentes siguen pendientes. |
| D-07 | Cuentas cliente/proveedor independientes; misma app; registro visual progresivo; proveedor individual aprobado; múltiples servicios y nombre completo público. | Confirmado. Tablas separadas expresadas como preferencia; diseño de autenticación todavía no cerrado. |
| D-08 | Cabecera contextual, catálogo sin mapa como protagonista, castores simplificados, Actividad con mensajes y Jorge animado. | Confirmado. No se generaron interfaces ni activos finales. |
| D-09 | Una cuenta de cada tipo por teléfono, correo reutilizable; inicio operativo proveedor; códigos; cobros sin billetera; una categoría al alta. | Confirmado. Los nombres del panel de cobros dependen del flujo real de Mercado Pago. |
| D-10 | Código del proveedor al comenzar y del cliente al terminar; anticipos según rubro; propinas; recurrencia; no congelamiento propio general por insatisfacción inicialmente. | Confirmado como intención. Retención de dinero, excepciones de cierre y tratamiento de reclamos pendientes. |
| D-11 | Cancelación libre con anticipación de tres horas a la salida, parcial dentro del margen y total en camino; foto/ubicación para auditar ausencia; revisión manual; suspensiones y aviso privado al administrador. | Política de cancelación expresada, pero importes y alcance sin cerrar. Sugerencia posterior de limitar cargos no aprobada expresamente. |
| D-12 | Beta cerrada para Android e iOS, sin fecha ni presupuesto; categorías graduales; algunas operaciones manuales; panel administrativo importante; comisión inicial 0%. | Confirmado. No se fijaron mínimos de oferta, objetivos numéricos ni cuál operación exacta será manual. |
| D-13 | Administración con aprobación, pausas, acceso justificado, métricas y exportaciones; gestión de banners; sin editor general de reglas; identidad azul/naranja y uso obligatorio de GitHub Spec Kit. | Confirmado. El acceso administrativo evolucionó en la tanda siguiente a panel web. |
| D-14 | Panel web amplio; referencia G2; colores del castor; tipografía amable; modos sistema/claro/oscuro; no revisar cada especificación; documentar todo el descubrimiento. | Confirmado. Paleta, fuente y componentes concretos por diseñar. |
| D-15 | Datos iniciales cliente; avatar Jorge cliente; DNI/selfie/contacto para proveedor; antecedentes muy opcionales; formularios por categoría; estados de alta e insignias. | Confirmado. Foto de DNI y selfie no equivalen a una verificación automática ya resuelta. |
| D-16 | Selección de categorías aceptada; técnica agrupada; aire y cámaras separados; sin subcategorías; tareas predefinidas; sugerencias de categorías; clases presenciales y online. | Confirmado. La lista resultante tiene once categorías. Habilitación gradual y tareas reguladas por validar. |
| D-17 | Clases y limpieza por hora; visita configurable; presupuesto generado con datos del proveedor en HTML; tres presupuestos; propinas sin comisión ServiPronto y deseo de señal positiva. | Confirmado. La comisión futura sobre materiales y el efecto de propinas en valoración quedaron abiertos. |
| D-18 | Solo Mercado Pago; costos del procesador a cargo del proveedor; preferencia por agrupación semanal; visita puede valer $0; PDF desde HTML; límite por solicitud. | Confirmado. Requisitos fiscales, retención y beneficio real de liquidación semanal por validar. |
| D-19 | La visita se cobra antes de ir y tiene valor propio; cierre «Visita»; extras por hora con acuerdo; continuidad y cobros por etapas aceptados expresamente. | Confirmado. No hay control omnisciente de materiales/acuerdos externos. Tarifa menor para continuaciones sigue como hipótesis futura. |
| D-20 | Clases en domicilio de cliente/profesor o Google Meet; adulto contratante; recurrencia por encuentro; pausa acordada; contratación para familiares desde otra ciudad primordial. | Confirmado salvo revisión de política de edad. Google Meet elegido; modo de crear/vincular encuentros no especificado. |
| D-21 | Personas y domicilios guardados; receptor sin cuenta; familiar confirma a distancia después de comunicarse; instrucciones útiles; reseña del contratante consultando al receptor. | Confirmado. La confirmación remota debe identificarse como tal. |
| D-22 | Chat al pedir visita o según criterio delegado; sin voz; proveedor guardado e historial; lectura y notificaciones importantes. | Confirmado. No se definió retención indefinida, bloqueo de chat posterior ni un sistema de llamadas. |
| D-23 | Bloquear horarios por compromisos externos, estimaciones con datos públicos, margen de traslado e información de demoras asistida por Jorge. | Confirmado. No se investigó todavía una tabla completa de tiempos reales por rubro ni se contrató un servicio de mapas. |

### D-24. Notificaciones adicionales

Se propusieron cuatro extras: recordatorios con horarios concretos, sonido especial para urgencias, pausa automática de disponibilidad tras solicitudes sin respuesta y notificaciones de promociones. El fundador respondió «no, por el momento no; más adelante sí» y preguntó cuánto faltaba para terminar de contestar.

**Interpretación conservadora para esta base:** aplazar esos cuatro extras. La respuesta no elimina las notificaciones de mensajes/servicios confirmadas en D-22 ni la ayuda contextual de Jorge acordada en D-06. Tampoco se interpreta como autorización para iniciar otro cuestionario.

**Estado del descubrimiento:** cerrado para comenzar la preparación de especificaciones. No hacen falta más tandas generales obligatorias. Si una decisión material sigue realmente abierta al implementarla, hacer una consulta concreta con una propuesta ya trabajada.

## Decisiones de stack

El fundador pidió expresamente pasar a elegir tecnologías con preguntas breves. Esta etapa no reabre el descubrimiento de producto ni autoriza instalaciones, contratación de infraestructura o despliegues por sí sola.

| ID | Decisión o contexto | Estado y límites |
| --- | --- | --- |
| T-01 | Ambos integrantes son ingenieros en sistemas y se adaptan a la tecnología. | Confirmado. No suponer experiencia específica en un framework ni elegir solo por una familiaridad no expresada. |
| T-02 | Una base de código móvil compartida para iOS y Android. | Confirmado. No implica un único binario ni eliminar configuración, pruebas o código específico de cada plataforma. |
| T-03 | Backend propio y PostgreSQL propio. | Confirmado en respuesta a la pregunta sobre mantenimiento: PostgreSQL autoadministrado, no un servicio de base de datos administrado como elección por defecto. Railway fue propuesto posteriormente por el fundador como alojamiento inicial; topología y región pendientes. No se afirmó tener servidores físicos. |
| T-04 | El equipo tiene acceso a una Mac. | Confirmado. No se verificaron herramientas instaladas, cuentas de desarrollador ni acceso remoto a ese equipo. |
| T-05 | Flutter + Dart como base móvil. | Aceptado el 2026-09-08, condicionado por el fundador a la disponibilidad de bibliotecas necesarias. Su preocupación era limitar capacidades, no reducir trabajo. No se interpreta como aceptación de obstáculos desconocidos ni como garantía de compatibilidad universal. Validar integraciones críticas antes de comprometer la interfaz final; React Native + Expo fue una recomendación anterior, no la elección actual. |
| T-06 | Docker fue mencionado por el fundador; el asistente propone usar contenedores para backend y entorno de desarrollo. | Candidato, no configuración cerrada. No elegir Kubernetes, clústeres ni una topología de producción por esa mención. Docker no reemplaza las compilaciones móviles ni las copias de seguridad. |
| T-07 | NestJS + TypeScript para el backend. | Aceptado el 2026-09-08 con Python como alternativa. Se mantiene NestJS como base; no agregar un segundo backend Python por defecto ni afirmar que uno resulte más barato sin mediciones. |
| T-08 | Railway al principio; US$5/mes para infraestructura como presupuesto histórico. | Expresado el 2026-09-08. La instrucción posterior T-10 reemplaza ese límite para el análisis arquitectónico, no autoriza gastos ni fija un monto nuevo. La preferencia de alojamiento se conserva; presupuesto IA y operación integral siguen pendientes. No se contrató plan, creó servicio ni configuró facturación. |
| T-09 | PostGIS y Rive. | Propuestas para consultas geográficas y animación del personaje, no aprobadas por separado. Framework web, IA, autenticación y demás integraciones permanecen abiertos. En Railway no asumir que el PostgreSQL por defecto ya incluya PostGIS. |
| T-10 | Priorizar calidad del código y analizar opciones sin centrarse ahora en cuánto se gastará. | Instrucción expresa del fundador, registrada el 2026-09-14. No justificar recortes de seguridad o mantenibilidad por el presupuesto histórico; tampoco interpretar calidad como complejidad obligatoria ni autorización para contratar. La base tecnológica se da por aceptada sin convertir cada biblioteca sugerida en una decisión cerrada. |
| T-11 | Jorge independiente de una empresa de IA; «peaje» de adaptación, pocos módulos con comunicación externa, módulos de preparación y orquestadores. | Requisito expreso del 2026-09-14. Contrato propio y adaptación bidireccional documentados en ARQUITECTURA_JORGE. Se implementó el gateway, el orquestador base y un adaptador local que declara explícitamente que no hay proveedor configurado. No se eligieron modelos, versiones, SDK ni una biblioteca de agentes; la portabilidad real continúa pendiente de probar con al menos dos adaptadores externos. |
| T-12 | Fundación con Docker, React, Flutter, NestJS y PostgreSQL; comenzar una base modular y un acceso administrador local. | Instrucción expresa del 2026-09-14. Implementado en `001-development-foundation` y `002-modular-product-base`: contenedores locales, migraciones, semilla idempotente, JWT administrativo, tablero, shell móvil y frontera inicial de Jorge. No equivale a funcionalidades comerciales terminadas ni a un despliegue remoto. |

### Arquitectura de Jorge: decisión del 2026-09-14

La [arquitectura independiente de Jorge](ARQUITECTURA_JORGE.md) desarrolla T-11: contrato propio, gateway, adaptadores por proveedor, preparación separada, orquestadores y ejecutor de herramientas con autorización del backend. La recomendación es comenzar dentro de una API modular NestJS, no desplegar un servicio por agente.

Cambiar entre destinos compatibles se resolverá por configuración después de implementar y probar sus adaptadores. Las diferencias de capacidades y estado de protocolo no desaparecen; actualizaciones de API pueden exigir cambios del adaptador y nuevas evaluaciones, sin trasladar esa dependencia a las reglas de negocio. La documentación técnica consultada y los criterios de aceptación están en ese documento.

### Evidencia y validaciones técnicas

- Flutter documenta un [sistema de animaciones propio](https://docs.flutter.dev/ui/animations/overview). Rive tiene [runtime oficial de Flutter](https://rive.app/docs/runtimes/flutter/flutter) y [vinculación de datos con animaciones](https://rive.app/docs/runtimes/flutter/data-binding). Permiten plantear transiciones y expresiones de Jorge; no son evidencia de rendimiento de ServiPronto ni de compatibilidad de todas las funciones y versiones. Preparar los activos animables es trabajo de diseño pendiente.
- Si una integración carece de un paquete adecuado, Flutter permite [código específico para cada plataforma](https://docs.flutter.dev/platform-integration/platform-channels). Esto puede sumar mantenimiento de Swift/Kotlin; no prometer que cualquier SDK tenga un equivalente Dart listo para usar.
- Antes de comprometer la interfaz final, proponer una prueba acotada de animación de Jorge, geometría G2, accesibilidad y desempeño en teléfonos modestos, junto con integraciones críticas de pagos, notificaciones y ubicación. Son comprobaciones pendientes, no pruebas ya realizadas.
- La operación propia debe contemplar actualizaciones, permisos y red privada para PostgreSQL, almacenamiento persistente, monitoreo, secretos, copias externas y pruebas de restauración. No inferir que un volumen Docker o un único VPS resuelven recuperación o alta disponibilidad. El presupuesto inicial está en T-08; las responsabilidades operativas concretas y los objetivos de recuperación siguen por definir antes de producción.

### Railway y presupuesto: verificación del 2026-09-08

**Registro histórico:** los precios siguientes corresponden a la consulta de esa fecha y deben volver a verificarse antes de contratar. T-10 retira US$5 como restricción del análisis actual; no establece un nuevo presupuesto ni habilita gasto.

El plan Hobby tiene un mínimo de US$5/mes e incluye US$5 de recursos: si el consumo supera ese importe, se paga la diferencia. No es una tarifa plana ilimitada ni son US$5 adicionales a todo el consumo. Los recursos activos pueden generar costo aun sin usuarios. [Facturación de Railway](https://docs.railway.com/pricing/understanding-your-bill).

Ejemplo ilustrativo, no medición de ServiPronto: 0,5 GB de RAM promedio sostenidos 30 días cuestan aproximadamente US$5,00 aplicando la tarifa publicada de US$0,00000386 por GB/segundo. CPU, volúmenes, backups y transferencia deben presupuestarse además; no se incluyeron impuestos, cargos locales ni servicios externos en este cálculo. Por eso aún no se puede garantizar API, PostgreSQL y la beta completa funcionando permanentemente por US$5. [Precios de Railway](https://railway.com/pricing).

La plantilla de [PostgreSQL de Railway](https://docs.railway.com/databases/postgresql) se describe como no administrada: es compatible con querer controlar configuración y mantenimiento aunque la plataforma gestione la infraestructura subyacente. PostGIS requiere elegir y validar una imagen o plantilla que lo incluya, no asumirlo disponible por defecto.

Los [límites de consumo](https://docs.railway.com/pricing/cost-control) permiten alertas y un límite duro; al alcanzar este último se interrumpen los servicios. Proponerlos antes de desplegar explicando ese efecto y comprobando sus mínimos y alcance vigentes. No se configuró ningún límite y no se prometió continuidad si se agota el presupuesto. El límite de «Railway Agent» corresponde al asistente de Railway, no al consumo de Jorge en otra API.

**Base local ejecutada:** una API modular NestJS, PostgreSQL persistente, panel React y aplicación Flutter Android/iOS. La orquestación de Jorge no requiere un proceso desplegado por cada agente y por ahora usa un adaptador explícitamente no configurado. Esto valida la organización local, no el alojamiento remoto, los adjuntos, los pagos ni el costo o la portabilidad real entre modelos de IA.

## Correcciones que no deben perderse

### C-01. IA opcional

La visión inicial destacaba al agente como núcleo. La aclaración posterior fue una aplicación convencional completa con acceso central a Jorge como opción adicional. No reemplazar todas las pantallas por chat.

### C-02. Roles

La posibilidad inicial de que una misma cuenta tuviera ambos roles fue descartada. Se quiere una cuenta por tipo, permitiendo el mismo teléfono para una de cada tipo. No convertir automáticamente esa regla en cambio libre de modo dentro de una única cuenta.

### C-03. Ubicación

Se pidió ubicación al contratar, pero luego se confirmó la contratación para familiares desde otra ciudad. El domicilio del servicio gobierna la búsqueda. Exigir GPS coincidente del contratante bloquearía un recorrido prioritario. La toma puntual de ubicación como evidencia de ausencia es una función distinta.

### C-04. Catálogo y administración

La idea de árbol profundo quedó aplazada. Se usan categorías generales y tareas simples. El fundador quiere publicar/ocultar categorías preparadas; no aprobó crearlas y editar todas sus reglas libremente desde el panel.

### C-05. Visita y reparación

La visita es una prestación cobrable anticipadamente y puede terminar sin reparación posterior. No descontarla automáticamente del nuevo presupuesto ni contar ese cierre como fracaso o fraude. El presupuesto también puede ser un concepto pago aparte si se informa y acuerda.

### C-06. Materiales y acuerdos externos

El fundador aclaró que no puede conocer todas las compras ni transacciones externas. No prometer su detección ni suponer un comprobante para cada gasto. Si el sistema registra una declaración sin evidencia, distinguirla de un dato verificado.

### C-07. Dinero y códigos

Querer retener fondos hasta el final no demuestra que la integración lo permita. Los códigos confirman la etapa; no constituyen automáticamente la orden de liquidación ni una garantía universal. Agrupar cobros no elimina por sí solo costos por transacción.

### C-08. Publicidad y reputación

El fundador rechazó el pay to win. Una sugerencia temprana de vender visibilidad no autoriza vender ranking orgánico ni insignias. La propina fue deseada como señal positiva, pero ni aumentar estrellas por dinero ni la fórmula alternativa propuesta quedaron cerradas.

### C-09. Seguridad y reclamos

El fundador no quiere inicialmente congelamientos propios generales por insatisfacción, pero sí revisión manual de ausencias y denuncias graves. No convertir esto en ausencia total de soporte ni en promesa de eliminar contracargos, obligaciones o mecanismos del procesador.

### C-10. Operación y alcance real

La aprobación de este enfoque no significa que todo deba estar automatizado desde la primera prueba. La beta puede incluir tareas manuales y categorías habilitadas progresivamente, manteniendo claros los acuerdos y los estados de los servicios.

## Pendientes agrupados por cómo se resolverán

Estos grupos no son preguntas nuevas para el fundador. Se investigan o se proponen al trabajar la especificación correspondiente.

| ID | Tema | Qué falta resolver | Acción siguiente | Cuándo condiciona el avance |
| --- | --- | --- | --- | --- |
| P-01 | Mercado Pago | Vinculación y elegibilidad de cada prestador; medios admitidos; anticipos; captura; disponibilidad; etapas; devoluciones; costos; preferencia semanal. | Prueba de viabilidad con documentación vigente y entorno de prueba. Separar escenarios admitidos de los que requieran otro acuerdo comercial. | Antes de prometer retención/liberación y antes de pagos reales. No bloquea prototipos sin dinero real. |
| P-02 | Requisitos argentinos | Habilitaciones por tarea, matrículas aplicables, identidad, edad de contratación, encuadre fiscal y responsabilidad del intermediario. | Investigación por rubro y revisión profesional de los temas que lo requieran. | Antes de habilitar la categoría y operar cobros reales. |
| P-03 | Cancelaciones y cierre | Alcance del cargo total, monto parcial, corte de tres horas, prueba de salida, excepciones de códigos y reclamos. | Redactar políticas por casos, comprobar viabilidad y presentar al fundador solo la elección comercial que siga abierta. | Antes de activar sanciones o cargos automáticos. |
| P-04 | Datos y acceso | Datos mínimos, validación de identidad, almacenamiento de documentos, retención, eliminación, recuperación de cuenta, permisos de familiares y acceso administrativo. | Proponer diseño proporcional para la beta y validar tratamiento de datos. | Antes de recoger documentación real o abrir acceso a conversaciones. |
| P-05 | Arquitectura, calidad y operación | Validación de Flutter y NestJS, framework web, adjuntos, backups y recuperación, notificaciones, modelos y adaptadores IA, orquestación, mapas, monitoreo y viabilidad operativa de Railway. | Partir de T-01 a T-11 y ARQUITECTURA_JORGE; probar portabilidad y riesgos reales, priorizar mantenibilidad y medir recursos. Acordar presupuesto operativo/IA antes de gastar y fijar versión de Spec Kit. | Antes de habilitar cada integración o comprometer infraestructura/gasto; no requiere otro descubrimiento general. |
| P-06 | Reglas operativas cuantitativas | Duraciones por tarea, margen, grupos de asignación, tiempos de espera, reputación, oportunidades de nuevos y señales de propinas. | Proponer valores iniciales revisables y medirlos. No atribuir a fuentes públicas una precisión que no ofrecen. | Antes de activar cada regla; iteración posterior con datos de beta. |
| P-07 | Beta y operación manual | Invitados, primeras categorías con oferta, responsabilidades de soporte, qué se hará manualmente y métricas base. | Plan acotado de prueba; conseguir oferta antes de abrir categorías. | Antes de invitar usuarios externos. No hay fecha comprometida. |
| P-08 | Diseño y contenido | Disponibilidad de imágenes originales, castor consistente, paleta/fuente, geometría G2, plantillas y textos. | Prototipos y sistema visual, preservando las referencias aportadas. | Antes de entregar activos o interfaz final. |

### Detalles delegados y propuestas reversibles

Se pueden resolver sin una tanda nueva: nombres internos de entidades, orden de formularios, compresión de imágenes, presentación de filtros, campos de exportación, distribución del panel, primeros textos de Jorge y límites operativos razonables. Las decisiones que cambien un cobro, una garantía, una sanción o el acceso a datos no se tratan como simples ajustes visuales.

No se aprobó un plazo de disponibilidad de dinero ni una promesa de garantía por el solo hecho de delegar decisiones técnicas. El presupuesto histórico y la prioridad actual de calidad están registrados en T-08 y T-10; no autorizan gastos ni contratación automática.

## Referencias para la investigación posterior

Las referencias se consultaron durante la conversación o esta entrega. Sus contenidos pueden cambiar y se deben revisar al integrar. Cada fuente respalda el tema señalado, no todas las decisiones del producto.

| Fuente primaria | Qué respalda | Qué no resuelve por sí sola |
| --- | --- | --- |
| [GitHub Spec Kit](https://github.com/github/spec-kit) y [mapa de especificaciones](https://github.com/github/spec-kit/blob/main/docs/concepts/spec-of-specs.md) | Organización de principios, especificaciones y trabajo por funcionalidades. | No hay instalación ni ejecución de comandos en esta entrega. |
| [Split de Mercado Pago](https://www.mercadopago.com.ar/developers/es/docs/split-payments/split-1-1/integration-configuration/integrate-marketplace) | División de un pago entre vendedor y marketplace, con condiciones del producto. | Custodia general, liquidación semanal o liberación de todos los medios mediante el código. |
| [Requisitos de Split](https://www.mercadopago.com.ar/developers/es/docs/split-payments/split-1-1/prerequisites) | Requisitos y vinculación del producto de pagos. | Cumplimiento profesional y fiscal completo de un proveedor de servicios. |
| [Reserva de fondos](https://www.mercadopago.com.ar/developers/es/docs/checkout-bricks/additional-content/payment-management/make-value-reserve) | Reserva de tarjeta con plazo documentado de siete días. | Una reserva indefinida ni compatibilidad automática con toda integración/medio. |
| [Costos de Checkout](https://www.mercadopago.com.ar/herramientas-para-vender/check-out) | Cobro por venta aprobada y factores que afectan costos. | Ahorro automático por agrupar transferencias semanalmente. |
| [Facturación ARCA](https://www.arca.gob.ar/monotributo/ayuda/facturacion.asp) | Información oficial de comprobantes para monotributistas. | Encaje fiscal integral del marketplace y cada rubro. |
| [Código Civil y Comercial](https://www.argentina.gob.ar/normativa/nacional/ley-26994-235975/actualizacion) | Mayoría de edad y capacidad progresiva, entre otros contenidos. | Redacción final de todos los términos y excepciones de la plataforma. |
| [Google Routes](https://developers.google.com/maps/documentation/routes/config_trade_offs) | Opciones de cálculo de tiempo de viaje con tráfico. | Duración de reparaciones ni elección o contratación de Google Maps para ServiPronto. |

La referencia estética aportada por el fundador fue [Applesfera sobre curvas continuas](https://www.applesfera.com/curiosidades/todos-productos-apple-se-rigen-patron-diseno-que-se-remonta-a-1744-que-clotoide-curva-euler). Se usa como inspiración visual, no como fuente de promesas técnicas sobre todas las interfaces de Apple.

## Qué se entregó y qué sigue

Se creó documentación central, un registro de decisiones y pendientes, una constitución y una hoja de ruta para Spec Kit. El 2026-09-14 se agregó la arquitectura independiente de Jorge, se instaló Spec Kit 1.0.6 y se implementaron las especificaciones de fundación técnica y base modular.

La base implementada no equivale a cuentas completas de clientes/proveedores, contratación, pagos, herramientas reales de Jorge ni integraciones de producción. Estos siguen pendientes, al igual que repositorio remoto y despliegues. No se enviaron mensajes por WhatsApp ni se procesó información o dinero de usuarios reales.

El siguiente trabajo es elegir un recorrido funcional pequeño de la hoja de ruta, especificarlo y construirlo sobre esta base. El descubrimiento inicial ya alcanza para hacerlo sin continuar con tandas generales de preguntas.

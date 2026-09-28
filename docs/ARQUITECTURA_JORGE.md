# Jorge — arquitectura independiente del proveedor de IA

**Versión:** 1.0.0  
**Actualizado:** 2026-09-14  
**Estado:** decisión arquitectónica documentada; diseño de referencia, sin implementación ni pruebas de integración realizadas.  
**Trazabilidad:** T-10 y T-11 de [DECISIONES](DECISIONES.md); JO-06, JO-07 y JO-09 a JO-16 de [PRODUCTO](PRODUCTO.md); bloque R09 de [ROADMAP](../ROADMAP.md).

## 1. Decisión y alcance

El fundador requiere que Jorge no dependa de una empresa de IA: debe ser posible pasar de OpenAI a Gemini, o incorporar otra alternativa, sin reescribir los recorridos de ServiPronto. Las comunicaciones con modelos se concentran en pocos módulos; el resto prepara información, coordina tareas, valida resultados o ejecuta reglas propias.

Adoptar un contrato interno de ServiPronto, un punto de acceso común a modelos —el «peaje» o gateway— y adaptadores por proveedor. La adaptación es de ida y vuelta: consultas, imágenes, herramientas, respuestas, eventos y errores. La app y las reglas de negocio no conocen los formatos ni los SDK de las empresas de IA.

**Confirmado por el fundador:** independencia, módulos de comunicación acotados, preparación separada y orquestadores. **Diseño de referencia propuesto:** los límites y mecanismos de este documento; se concretarán en especificaciones pequeñas de Spec Kit. No quedan seleccionados modelos, versiones de API, una biblioteca de agentes ni un proveedor activo por defecto.

La prioridad actual es calidad y mantenibilidad, sin usar el presupuesto histórico de US$5 como límite de este análisis. Esto no autoriza contratar servicios ni incurrir en gastos. La independencia tampoco exige desplegar un microservicio por módulo o agente.

## 2. Responsabilidades y dependencias

| Componente | Responsabilidad | Límite |
| --- | --- | --- |
| Entrada de Jorge | Recibir texto/imágenes, identificar la sesión y entregar respuestas y tarjetas propias a la app. | Sin SDK de IA, claves ni selección de proveedor en Flutter. |
| Preparación | Validar entradas, recuperar contexto autorizado, reducir datos, construir instrucciones versionadas y seleccionar herramientas disponibles. | Sin llamadas ocultas a modelos; no cargar toda la base de datos ni tratar documentos como instrucciones confiables. |
| Orquestador de conversación | Mantener el estado del turno, elegir un flujo, coordinar pasos, esperas de confirmación, límites y recuperación. | El control de ejecución pertenece al código, aunque el modelo proponga un siguiente paso. |
| Orquestadores de flujo | Organizar búsqueda, preparación de solicitudes, presupuestos o ayuda al proveedor con entradas/salidas definidas. | No requieren un modelo ni un proceso propio por cada flujo. Usan capacidades de negocio que ya existan. |
| Gateway de modelos | Aplicar la configuración aprobada, comprobar capacidades, asignar el adaptador y gestionar plazos y errores comunes. | Solo expone el contrato de ServiPronto; no decide precios ni autoriza operaciones. |
| Adaptador OpenAI / Gemini / futuro | Convertir solicitudes y respuestas, integrar el SDK/API, manejar archivos y conservar el estado de protocolo que corresponda. | Único lugar con comunicación externa a ese proveedor de IA y tipos de su SDK. |
| Ejecutor de herramientas | Validar la petición del modelo, comprobar permisos/confirmaciones y llamar a los servicios de negocio. | El modelo solicita una acción, no obtiene autorización por solicitarla. |
| Servicios de negocio | Resolver búsquedas autorizadas, reglas, acuerdos, reservas y pagos trazables. | No importan código de modelos. Sirven tanto al recorrido manual como a Jorge. |

Flujo de generación: entrada → preparación/orquestación → gateway → adaptador → modelo. El resultado vuelve por el adaptador al orquestador. Si incluye una solicitud de herramienta, pasa por el ejecutor; el resultado comprobado vuelve al flujo antes de responder al usuario.

En NestJS, comenzar con módulos internos de una API modular. Las interfaces estables pertenecen a la aplicación; los adaptadores las implementan y se inyectan desde la configuración. No hay una dependencia directa del dominio hacia infraestructura de IA. Separar despliegues solo cuando exista una necesidad operativa demostrada.

La mayor parte de la preparación debe ser determinista. Si una tarea realmente necesita interpretación semántica de un modelo, se expresa como una operación explícita a través del gateway; no se esconde una consulta de IA dentro de un helper. Los orquestadores tampoco son necesariamente agentes que conversan entre sí.

## 3. Contrato propio: genérico por dentro, específico en el borde

El contrato debe cubrir lo que necesita Jorge, no intentar copiar todas las funciones de todos los proveedores. Los nombres siguientes son conceptuales, no interfaces implementadas.

### Entrada común

- Identificador de ejecución y tarea, versiones del contrato, instrucciones y herramientas; plazo total y señal de cancelación.
- Instrucciones de ServiPronto separadas del contenido no confiable del usuario, documentos, imágenes y resultados externos.
- Historial normalizado: mensajes, texto, referencias internas a imágenes y pares de solicitud/resultado de herramientas.
- Herramientas permitidas con nombre estable, descripción y esquema validable; formato esperado de salida cuando corresponda.
- Capacidades requeridas por esa operación: por ejemplo, texto + imagen + herramientas. Los permisos efectivos se determinan en el servidor, no a partir de argumentos generados por la IA.

### Salida común

- Texto completo o eventos de texto incremental, solicitudes completas de herramientas, resultados estructurados y estado de finalización.
- Estados distinguibles: respuesta válida, rechazo, salida incompleta, interrupción o error. Una respuesta vacía no equivale a éxito.
- Metadatos operativos: proveedor/modelo efectivos, latencia y consumo informado. Un dato no informado se conserva como desconocido, no como cero; los tokens de distintos modelos no se consideran unidades idénticas de trabajo.
- Referencia a estado de continuidad privado del adaptador, cuando sea necesario. No exponer objetos del SDK al dominio ni a Flutter.

Las salidas del modelo se validan en tiempo de ejecución. Un objeto que se parece a JSON no prueba que respete el esquema ni las reglas comerciales. No se ejecutan herramientas con argumentos parciales recibidos durante streaming.

### Capacidades y extensiones

Mantener una matriz comprobada por proveedor, modelo y versión de API, incluyendo combinaciones: soportar imágenes y herramientas por separado no demuestra soportarlas juntas en el flujo elegido. Usar un subconjunto de esquemas compatible con los destinos habilitados, sin quitar restricciones silenciosamente.

Si un destino no cumple una capacidad obligatoria, rechazar el enrutamiento antes de enviar la consulta. No descartar una imagen, degradar una confirmación o interpretar un parámetro distinto como equivalente sin una política explícita y probada.

Las funciones específicas de una empresa pueden incorporarse detrás de una extensión acotada si aportan valor, con alternativa o limitación declarada. El estado esencial del producto no debe depender exclusivamente de conversaciones, archivos o bases de conocimiento alojados por esa empresa.

## 4. Cambio de proveedor y conservación de la conversación

El proveedor/modelo activo se resuelve con una configuración del servidor: perfil de tarea, destino aprobado, versión, capacidades y política de recuperación. No hace falta agregar un editor de estas reglas al panel administrativo ni una elección de modelo al usuario.

Una vez implementados y verificados los dos adaptadores, cambiar la configuración debe bastar para dirigir las nuevas ejecuciones compatibles a OpenAI o Gemini. Incorporar un proveedor nuevo todavía requiere desarrollar y probar su adaptador.

El destino se fija durante cada ejecución lógica y su ciclo de herramientas. Un cambio de configuración afecta a ejecuciones nuevas; no altera silenciosamente un paso en curso. Entre turnos, una conversación puede continuar en otro proveedor reconstruyendo contexto desde el historial propio y el estado confirmado del negocio.

ServiPronto conserva el historial funcional, las propuestas, las confirmaciones y los resultados de herramientas en su almacenamiento, con permisos y retención definidos. El adaptador conserva por separado los identificadores y metadatos opacos necesarios para continuar con su API. Estos metadatos pueden contener información sensible: no son logs públicos, no se decodifican para mostrarlos al usuario y no se envían al proveedor alternativo.

No es posible prometer trasladar el estado interno de razonamiento entre empresas. En un cambio se conserva la conversación útil y el estado real de ServiPronto; no se intenta traducir firmas privadas. La reanudación con el mismo proveedor sí debe preservar fielmente los elementos que exija su protocolo.

Las diferencias no son solo de nombres de campos: OpenAI documenta elementos de razonamiento que deben devolverse junto con resultados de herramientas en determinados modelos; Gemini documenta firmas y reglas de continuidad según su API. Esto justifica que el estado de protocolo permanezca encapsulado. [Herramientas de OpenAI](https://developers.openai.com/api/docs/guides/function-calling), [continuidad de Gemini](https://ai.google.dev/gemini-api/docs/thinking).

## 5. Ejecución segura, recuperación y datos

- La lista de herramientas disponibles se limita por tarea y sesión. Cada ejecución vuelve a comprobar esquema, identidad, autorización y estado actual del negocio; no se confía en un identificador de cliente propuesto por el modelo.
- Contratar, cambiar precios y pagar requiere la confirmación explícita correspondiente, vinculada a una propuesta y versión concretas. Si cambian los términos, la confirmación anterior no alcanza. Mostrar un mensaje afirmativo de Jorge no sustituye el resultado del backend.
- Los efectos de negocio usan claves de idempotencia propias: un reintento debe reconocer la misma operación. No usar el identificador de llamada generado por cada modelo como única protección, porque puede cambiar al repetir o cambiar de proveedor.
- Ante un timeout con resultado incierto, consultar y conciliar el estado de la operación antes de reintentar. Un fallback no puede cobrar o reservar de nuevo para «ver si esta vez funciona».
- Recuperación acotada: límites de pasos y llamadas, tiempo total, cancelación y protección frente a bucles. Un error en Jorge mantiene disponible el recorrido manual, sin simular disponibilidad ni acciones realizadas.
- Un destino alternativo debe estar previamente habilitado para esos datos y capacidades. No reenviar automáticamente fotos, domicilios o conversaciones a cualquier empresa que responda. Si corresponde nueva información o consentimiento sobre tratamiento de datos, resolverlo antes de enviarlos.
- No mezclar silenciosamente respuestas parciales de dos proveedores. Una interrupción y una recuperación deben tener estados claros, y las acciones ya ejecutadas no se repiten por reconstruir contexto.
- Las claves y las cargas de archivos al proveedor quedan en el backend y su adaptador. Las imágenes se autorizan y validan antes del envío; el adaptador no acepta URLs arbitrarias para descargar ni claves de almacenamiento elegidas por el modelo.
- Registrar trazas operativas con identificadores y datos minimizados; no registrar por defecto claves, documentos, fotos, prompts completos ni metadatos privados de continuidad. Definir retención y acceso antes de usar información real.
- Si un SDK ofrece ejecución automática de funciones, no debe saltarse el ejecutor propio. Las reglas sensibles se comprueban en código y servicios de negocio, no solo en un prompt.

## 6. Integración recomendada y alternativas

**Propuesta inicial:** contrato TypeScript propio y adaptadores acotados, usando los SDK oficiales dentro de cada adaptador cuando resulten adecuados. Esto deja el control del flujo y el historial en ServiPronto, sin construir un framework general de agentes.

Una biblioteca multiproveedor podría ayudar dentro de esta frontera, siempre que sus tipos, almacenamiento y herramientas no pasen a gobernar el negocio. Elegirla requerirá una prueba del flujo real; no queda incorporada por este documento.

No usar el formato de OpenAI como si fuera un estándar universal. Gemini ofrece una capa compatible con bibliotecas de OpenAI, pero la documentación consultada la identifica como beta y no demuestra equivalencia de todas las funciones. Puede evaluarse dentro de un adaptador, no reemplaza el contrato propio ni las pruebas. [Compatibilidad de Gemini con OpenAI](https://ai.google.dev/gemini-api/docs/openai).

La salida estructurada tampoco elimina las diferencias: OpenAI documenta un subconjunto de JSON Schema y restricciones de soporte. Los esquemas se prueban por destino y la validación comercial permanece local. [Salidas estructuradas de OpenAI](https://developers.openai.com/api/docs/guides/structured-outputs).

## 7. Versionado y pruebas de calidad

Versionar el contrato interno, las instrucciones de Jorge, las herramientas, los adaptadores y sus dependencias. Registrar el modelo/API efectivos en cada ejecución y fijar versiones o snapshots cuando estén disponibles. No actualizar SDK o alias de modelo a ciegas; tampoco congelar dependencias vulnerables indefinidamente.

Separar dos tipos de pruebas:

1. **Deterministas:** dobles de prueba, validadores, autorizaciones, estados, reintentos y contratos. Deben correr sin enviar información a una IA ni consumir su API.
2. **Integración y evaluación:** consultas reales autorizadas, con datos sintéticos o anonimizados, para comprobar cada combinación habilitada y la calidad de Jorge. No comparar texto idéntico: comprobar brevedad, utilidad, uso correcto de herramientas, ausencia de datos inventados y respeto por las confirmaciones.

Antes de habilitar un proveedor o cambiar una versión, verificar al menos:

- Texto e imágenes, búsqueda real mediante herramientas, resultados sin candidatos y datos incompletos.
- Solicitudes malformadas, esquema incompatible, rechazo, truncación e interrupción de streaming.
- Intentos de obtener datos de otra cuenta o de introducir instrucciones desde documentos y resultados de herramientas.
- Confirmación ausente o desactualizada, argumentos parciales y operaciones repetidas tras un timeout.
- Continuidad con el mismo proveedor y cambio entre turnos sin perder acuerdos ni reenviar metadatos privados al nuevo destino.
- Selección de una combinación incompatible: fallo explícito previo al envío, sin degradación silenciosa.
- Límites de pasos, latencia, cancelación y recuperación sin duplicar pagos o reservas.
- Comportamiento manual de ServiPronto cuando Jorge está deshabilitado o falla.

Agregar una regla automática de dependencias/importaciones para impedir SDK de IA fuera de los adaptadores y verificar los puntos de salida de red. Una actualización se promueve después de estas comprobaciones, con despliegue gradual y posibilidad de volver a una configuración compatible.

## 8. Preparación con GitHub Spec Kit

Este documento alimenta R09; no sustituye su especificación, plan, tareas ni pruebas. Dividir el trabajo futuro:

1. Contrato, límites de módulos, gateway y adaptador simulado; demostrar contexto autorizado y validación sin una IA externa.
2. Adaptadores OpenAI y Gemini para el mismo recorrido pequeño de texto/imágenes y una herramienta de consulta existente; ejecutar la misma batería de pruebas en ambos cuando se autorice la integración.
3. Orquestación de búsqueda y preparación de solicitudes sobre servicios ya implementados.
4. Operaciones sensibles con confirmaciones, idempotencia, recuperación y evaluaciones de seguridad antes de habilitarlas.

El primer bloque se puede preparar antes de completar todos los recorridos comerciales. Eso no habilita herramientas de contratación o pago inexistentes ni equivale a instalar Spec Kit o implementar R09 en esta entrega.

## 9. Límite de la promesa

La meta verificable es que cambiar entre destinos compatibles afecte a configuración, adaptadores y sus pruebas, no a Flutter ni a las reglas de negocio. Una nueva capacidad de producto puede requerir evolucionar el contrato y sus consumidores.

La arquitectura reduce el alcance de una incompatibilidad; no garantiza que ninguna API se retire ni que todos los modelos tengan la misma calidad. Las migraciones seguirán requiriendo mantenimiento y evaluación, pero dentro de fronteras conocidas.

Pendientes de integración: APIs/SDK y versiones exactas, modelos por tarea, almacenamiento y retención de continuidad, límites medidos, destinos habilitados para datos y eventual biblioteca de orquestación. No se realizaron llamadas reales, pruebas de modelos, compras ni despliegues al documentar esta decisión.

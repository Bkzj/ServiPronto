# Constitución de ServiPronto

**Versión:** 1.1.0  
**Fecha:** 2026-09-14  
**Estado:** principios del fundador, ampliados con independencia de IA; no representa una aplicación implementada ni una revisión jurídica completada.

## Principios centrales

### I. Resolver necesidades reales con una operación pequeña

ServiPronto conecta hogares con profesionales, inicialmente en Tandil. El equipo es de dos personas. Se priorizan recorridos completos, categorías generales y procesos administrables. La expansión futura no justifica construir desde el comienzo todas las categorías, empresas, beneficios, subcategorías ni automatizaciones imaginables.

### II. Experiencia completa sin IA y ayuda opcional con Jorge

El usuario debe poder buscar, comparar, contratar, pagar y consultar su actividad manualmente. Jorge ofrece una vía adicional de acompañamiento y acción. Se comunica por texto, comprende imágenes, habla de vos y usa mensajes breves, amables y comprensivos. Hace preguntas cuando falta información y consulta datos reales mediante herramientas. La orquestación interna queda fuera de la experiencia del usuario.

### III. Acuerdos explícitos y estados verificables

Jorge y el sistema pueden preparar propuestas y consultar información. La selección definitiva del proveedor, los cambios de importes y los pagos requieren autorización de quien corresponda. Los acuerdos conservan sus versiones. Una visita, una etapa, un trabajo y un pago tienen estados distintos. Los códigos confirman acciones registradas y no certifican por sí solos calidad, identidad infalible o hechos ajenos a la aplicación.

### IV. Confianza basada en experiencia y verificaciones relevantes

Solo aparecen proveedores aprobados. Las verificaciones se adaptan a las tareas. No se compra reputación ni posición orgánica. Las denuncias graves y las ausencias se revisan, con operación manual al inicio. Los antecedentes penales son una verificación muy opcional según la preferencia del fundador, sujeta a la validación de su tratamiento. Las exigencias profesionales aplicables deben investigarse antes de habilitar las tareas correspondientes.

### V. Acceso sencillo y contratación para otra persona

La app permite contratar para familiares, incluso desde otra ciudad. Debe distinguir contratante, receptor y lugar de prestación. La dirección del servicio guía la búsqueda; el GPS del contratante no puede impedir este recorrido. El receptor no está obligado a tener cuenta. Se contemplan confirmaciones remotas identificadas como tales, texto legible e interacciones simples.

### VI. Retener por utilidad

La visita puede ser un servicio pago independiente. La continuidad se facilita conservando el trabajo, los acuerdos, el chat, la agenda y los cobros por etapas. ServiPronto no puede verificar todos los acuerdos o compras externos y no debe presentarlos como conocidos. Una visita sin continuación registrada no demuestra una infracción. Los incentivos futuros se validan con resultados de la beta.

### VII. Identidad visual consistente

Jorge es el castor transversal de la marca. Se toma como referencia el naranja intenso del casco y el azul del uniforme. Cliente y proveedor comparten sistema visual con distinta dominancia de color. Botones, tarjetas, campos y contenedores usan esquinas de curvatura continua G2. La tipografía es redondeada, amigable y con carácter. Se incluyen modos sistema, claro y oscuro, con movimiento y contraste que respeten la accesibilidad.

### VIII. Administración suficiente y acceso justificado

El panel web permite aprobar proveedores, revisar documentación y casos, pausar entidades, gestionar contenido y consultar métricas. El acceso administrativo a conversaciones requiere justificación y registro. El alcance inicial no incluye un constructor de reglas de negocio desde el panel. El soporte grave y las altas que necesiten revisión pueden generar un aviso privado al administrador.

### IX. Jorge independiente de proveedores de IA

ServiPronto define su contrato interno de IA. Un gateway y adaptadores acotados aíslan las APIs externas; preparación, orquestadores, interfaz y reglas de negocio no dependen de los SDK de una empresa. El control de las herramientas, permisos, confirmaciones y efectos de negocio permanece en ServiPronto.

Cambiar entre proveedores compatibles no debe requerir reescribir los recorridos del producto. Se preserva el historial funcional propio, se encapsula el estado privado de cada API y se evitan cambios inseguros durante operaciones en curso. Versionar contratos e integraciones y comprobar capacidades, seguridad y calidad antes de habilitar un destino o actualizarlo. No prometer compatibilidad universal ni ausencia de mantenimiento. El [diseño de referencia de Jorge](../../docs/ARQUITECTURA_JORGE.md) alimenta las especificaciones correspondientes.

La instrucción actual prioriza calidad y mantenibilidad sobre el presupuesto histórico al analizar arquitectura, conservando una operación proporcionada para dos personas. No equivale a autorizar gastos ni a exigir más servicios o agentes.

## Restricciones acordadas

- Una app para Android e iOS; panel administrativo web.
- Cuentas cliente y proveedor independientes, máximo una de cada tipo por teléfono.
- Proveedores individuales; empresas para una etapa posterior.
- Mercado Pago como único procesador inicial. Comisión de ServiPronto del 0% en beta; costos de procesamiento a cargo del proveedor.
- Sin billetera de uso interno entre usuarios. Retención, liquidación semanal y disponibilidad del dinero pendientes de validación con el procesador.
- Texto e imágenes; sin audios de chat ni voz para Jorge en el alcance inicial.
- Presupuestos con plantilla HTML propia y salida PDF, basados en información confirmada por el proveedor.
- Beta cerrada con personas seleccionadas, categorías habilitadas gradualmente y operaciones manuales donde resulten suficientes.

## Flujo de desarrollo

Utilizar GitHub Spec Kit. Esta constitución y la documentación central alimentan las especificaciones acotadas, los planes, las tareas y sus verificaciones. No se solicita aprobación del fundador para cada documento. Las pruebas deben cubrir los riesgos del cambio y, en particular, los permisos, pagos, acuerdos y reservas cuando se implementen.

La ausencia de una respuesta de negocio no autoriza inventar un precio, una obligación legal, un plazo del procesador o una garantía al cliente. Registrar la incertidumbre y resolverla mediante investigación, una prueba técnica o una consulta breve cuando sea realmente necesaria.

## Mantenimiento

Las instrucciones explícitas nuevas del fundador pueden modificar los principios. Actualizar la documentación relacionada y registrar el cambio. La hoja de ruta expresa trabajo propuesto; solo se marca realizado cuando existe evidencia de implementación y verificación. Los documentos de descubrimiento no sustituyen especificaciones, planes, pruebas ni validaciones profesionales.

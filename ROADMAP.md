# Hoja de ruta de especificaciones de ServiPronto

**Fecha:** 2026-09-14. **Estado:** hoja de ruta activa; fundación técnica implementada y alcance funcional todavía en construcción.

El producto completo está descrito en [PRODUCTO](docs/PRODUCTO.md). Esta hoja de ruta divide ese alcance para preparar especificaciones manejables con GitHub Spec Kit. Las prioridades y agrupaciones son propuestas del asistente, no fechas ni compromisos aprobados de entrega.

## Bloques propuestos

| ID | Funcionalidad | Resultado demostrable y alcance | Dependencias | Estado |
| --- | --- | --- | --- | --- |
| R00 | Fundación técnica | Monorepo, Docker, PostgreSQL, API, panel web, Flutter Android/iOS, salud, migraciones y verificaciones. | — | Implementado en [001](specs/001-development-foundation/spec.md) |
| R01 | Identidad y navegación | Sistema visual G2, temas por rol, acceso central a Jorge, pantallas iniciales y componentes accesibles. No incluye generación de todas las ilustraciones ni operaciones reales. | R00 | Base parcial en [002](specs/002-modular-product-base/spec.md) |
| R02 | Cuentas y aprobación | Alta progresiva, cuentas por tipo, identidad, primera categoría y revisión administrativa; proveedor oculto hasta aprobación. No incluye verificación automática completa. | R01 | Acceso administrador base en [002](specs/002-modular-product-base/spec.md); resto planificado |
| R03 | Catálogo, perfiles y búsqueda | Categorías generales visibles, perfiles, tareas ofrecidas, cobertura, preferencias urgentes y elección de candidato. Sin subcategorías ni ranking definitivo. | R02 | Planificado |
| R04 | Solicitud, chat y visita | Solicitud contextual, chat texto/imagen con lectura, confirmación de candidato, visita y doble código. Pruebas iniciales con pagos simulados; no habilita cobros reales. | R03 | Planificado |
| R05 | Contratación familiar | Receptor sin cuenta, domicilios guardados, contratante remoto y confirmaciones identificadas. Requerido antes de abrir la beta. | R02, R04 | Planificado |
| R06 | Pagos y presupuestos | Investigación previa de Mercado Pago; visita anticipada, presupuesto HTML/PDF, aprobación, costos, conciliación y cobros permitidos. Sin prometer custodia ni liquidación semanal no verificada. | R04 | Planificado |
| R07 | Continuaciones y etapas | Mismo trabajo, etapas, importes y acuerdos versionados, adicionales y seguimiento de avances. No incluye gestión compleja de obras ni empresas. | R06 | Planificado |
| R08 | Agenda y recurrencia | Calendario común entre categorías, compromisos externos, tiempos sugeridos, margen, pausas y aviso de demoras. Sin integración de calendarios externos por defecto. | R04, R06 | Planificado |
| R09 | Jorge | Contrato propio, gateway y adaptadores de IA; preparación y orquestadores separados; herramientas sobre capacidades existentes, conversación breve, imágenes y límites de autorización. Verificar portabilidad y recuperación según ARQUITECTURA_JORGE. No habilita acciones inexistentes. | R03, R04, R05, R06 | Contrato/gateway base en [002](specs/002-modular-product-base/spec.md); integración planificada |
| R10 | Reputación y atención de casos | Reseñas por aspectos, representación general, revisión de incidentes y acceso administrativo justificado. Beneficios por insignias y fórmula de propinas quedan como hipótesis. | R04, R06 | Planificado |
| R11 | Administración, contenido y medición | Ampliación del panel inicial: banners, publicaciones, visibilidad de categorías, casos, métricas, exportaciones y avisos privados de altas/gravedad. Sin editor general de reglas. | R02, R06, R09, R10 | Acceso y tablero base en [002](specs/002-modular-product-base/spec.md); operaciones planificadas |
| R12 | Beta integrada | Recorridos completos en Android/iOS, prueba con invitados, categorías con oferta, comisión 0%, operación manual documentada y medición de continuidad. | R01–R11 | Planificado |

Cada especificación futura tendrá una referencia a su ID de esta tabla y a los requisitos del documento central. El enlace a la especificación se agrega cuando el archivo realmente exista.

Para R09, leer el [diseño arquitectónico de Jorge](docs/ARQUITECTURA_JORGE.md). Su contrato, límites y adaptador simulado pueden especificarse y probarse antes de completar las dependencias comerciales. La integración con herramientas reales sigue dependiendo de que esas capacidades existan. Este diseño está documentado; R09 no está implementado ni probado.

## Preparación inmediata

1. Conservar esta base de descubrimiento y los pendientes.
2. Mantener la versión fijada de GitHub Spec Kit y actualizarla deliberadamente, sin sobrescribir la constitución ni los documentos propios.
3. Resolver la viabilidad de pagos y los requisitos de los primeros rubros antes de comprometer sus comportamientos en producción.
4. Concretar y validar la base tecnológica seleccionada y la arquitectura independiente de Jorge, priorizando calidad y una operación mantenible para dos personas; resolver los componentes todavía abiertos sin reiniciar el descubrimiento.
5. Especificar y demostrar un recorrido pequeño de principio a fin; ampliar a partir de esa base.

Estos pasos no requieren reabrir las 24 tandas. Las alternativas técnicas y los números iniciales reversibles se proponen con evidencia y quedan identificados como tales.

## Alcance posterior

- Comisiones comerciales y premium para ambos roles.
- Recompensas con beneficios concretos.
- Empresas, equipos y nuevas ciudades.
- Subcategorías si el catálogo las necesita.
- Masajes y terapia ocupacional, sin una fecha comprometida.
- Automatizaciones administrativas más amplias.
- Garantías y procesos de corrección/reembolso adicionales que no fueron comprometidos para la beta.
- Notificaciones promocionales y los extras de notificaciones de la tanda 24, según [D-24](docs/DECISIONES.md#d-24-notificaciones-adicionales).

## Referencia metodológica

El formato de mapa de especificaciones se apoya en la [documentación oficial de Spec Kit](https://github.com/github/spec-kit/blob/main/docs/concepts/spec-of-specs.md). La CLI y la estructura operativa ya están disponibles localmente; cada estado de implementación debe seguir respaldado por su especificación y sus pruebas.

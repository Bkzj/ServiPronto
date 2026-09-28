# ServiPronto

Marketplace de servicios para hogares, con lanzamiento inicial en Tandil y Jorge, el castor de la marca, como asistente opcional para clientes y proveedores.

**Estado al 14 de septiembre de 2026:** descubrimiento inicial cerrado y primera base técnica implementada. El entorno local incluye API NestJS, PostgreSQL persistente y panel React en Docker; la aplicación Flutter comparte proyecto Android/iOS. Hay acceso administrativo real, límites iniciales de módulos y un gateway desacoplado para Jorge. Esto es una fundación demostrable, no el marketplace completo ni una beta pública.

## Empezar por acá

- [Documento central del producto](docs/PRODUCTO.md): visión, experiencias, reglas de negocio, diseño y alcance.
- [Decisiones, evolución y pendientes](docs/DECISIONES.md): qué confirmó el fundador, qué cambió, qué sigue como propuesta y qué requiere investigación.
- [Arquitectura independiente de Jorge](docs/ARQUITECTURA_JORGE.md): contrato propio, gateway, adaptadores de IA, preparación, orquestadores y verificaciones necesarias.
- [Hoja de ruta de especificaciones](ROADMAP.md): división propuesta del trabajo para avanzar con GitHub Spec Kit.
- [Constitución del proyecto](.specify/memory/constitution.md): principios de producto y desarrollo derivados del descubrimiento.

No hace falta responder más tandas para comenzar las especificaciones por funcionalidad. Los detalles reversibles se resuelven con criterio y las hipótesis se validan en la beta. Las consultas futuras al fundador deben ser breves y surgir de una decisión concreta que no pueda resolverse con esta documentación.

## Acuerdos principales

- Una aplicación, con cuentas independientes de cliente y proveedor; un panel web privado para administración.
- Búsqueda y contratación tradicionales completas, más Jorge como ayuda opcional.
- Jorge independiente de la empresa de IA: formatos externos aislados en adaptadores y reglas de negocio propias; cambiar de proveedor no debe exigir reescribir la aplicación.
- Castor presente en la identidad; azul dominante para cliente y naranja para proveedor; esquinas de curvatura continua G2; modos sistema, claro y oscuro.
- Categorías generales y habilitación gradual según oferta real.
- Proveedores aprobados antes de aparecer en búsquedas; reputación ganada y publicidad sin compra de posiciones orgánicas.
- Visitas cobrables antes de concurrir, con valor propio; presupuestos y continuaciones por etapas dentro del mismo trabajo.
- Mercado Pago como único procesador inicial, costos de procesamiento a cargo del proveedor y comisión de ServiPronto del 0% durante la beta.
- Contratación para familiares desde otra ciudad, sin exigir cuenta a quien recibe el servicio.
- Chat de texto e imágenes, sin audios, con lectura e historial.
- Administración, revisión de casos y métricas desde la beta.
- Flutter + Dart como base móvil compartida, condicionado a validar las integraciones necesarias; NestJS + TypeScript para el backend propio, con Python como alternativa si surge una razón concreta. PostgreSQL autoadministrado y acceso a una Mac. Railway es la preferencia inicial de alojamiento. La instrucción actual prioriza calidad y mantenibilidad sin limitar este análisis al presupuesto histórico de US$5/mes; no autoriza gastos. Ver [decisiones técnicas](docs/DECISIONES.md#decisiones-de-stack).

## Ejecutar la base local

1. Copiar `.env.example` como `.env` y completar valores locales. No versionar ese archivo.
2. Ejecutar `docker compose up --build -d`.
3. Abrir [el panel local](http://localhost:5173). Las credenciales sembradas se toman de `SEED_ADMIN_EMAIL` y `SEED_ADMIN_PASSWORD`.
4. Consultar [la documentación local de la API](http://localhost:3000/api/docs).

El panel conserva la sesión únicamente en memoria: al recargar vuelve a pedir acceso. La semilla es idempotente y almacena la contraseña con hash. Para verificar el código web y API usar `npm run check`. Para Flutter, entrar a `apps/mobile` y ejecutar `flutter analyze`, `flutter test` y, cuando corresponda, `flutter build apk --debug`.

Los contenedores son `postgres`, `api` y `admin`. `docker compose down` los detiene sin borrar la base. No usar `docker compose down -v` salvo que se quiera eliminar explícitamente el volumen local de PostgreSQL.

## Uso de GitHub Spec Kit

El fundador eligió [GitHub Spec Kit](https://github.com/github/spec-kit) como metodología. La documentación presente prepara su etapa de principios y definición. La hoja de ruta sigue la convención de un [mapa de especificaciones](https://github.com/github/spec-kit/blob/main/docs/concepts/spec-of-specs.md).

La CLI oficial de Spec Kit 1.0.6 está instalada y su estructura fue inicializada preservando la constitución y la documentación. Git fue inicializado localmente en la rama `main`; no se creó repositorio remoto, no se hizo publicación y no se contrató infraestructura. Las primeras especificaciones ejecutadas son [001-development-foundation](specs/001-development-foundation/spec.md) y [002-modular-product-base](specs/002-modular-product-base/spec.md).

El flujo posterior será principios → especificación acotada → aclaraciones necesarias → plan → tareas → análisis → implementación y verificación. El fundador no quiere aprobar cada documento ni cada paso rutinario.

## Cómo mantener la documentación

Las respuestas explícitas más recientes del fundador prevalecen sobre recomendaciones anteriores. Una sugerencia del asistente no se considera aprobada solo porque se haya continuado la conversación. Consultar las etiquetas y pendientes de [DECISIONES](docs/DECISIONES.md) antes de convertir una hipótesis en comportamiento de la app.

Esta documentación conserva el contexto en el proyecto. No implica que otras conversaciones ajenas a esta carpeta lo carguen automáticamente.

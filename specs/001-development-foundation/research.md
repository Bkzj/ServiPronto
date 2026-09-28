# Research: Base de desarrollo reproducible

## Decision 1: monorepo liviano

**Decision**: Mantener `apps/api`, `apps/admin` y `apps/mobile` en un único repositorio; npm workspaces coordina solo los dos proyectos TypeScript.

**Rationale**: Reduce coordinación y duplicación para dos desarrolladores sin introducir un gestor de monorepo adicional antes de necesitarlo.

**Alternatives considered**: Repositorios separados; Nx/Turborepo. Aportan valor con más equipos o pipelines, pero agregan operación prematura.

## Decision 2: límites de Docker

**Decision**: Contenerizar PostgreSQL, API y panel. Ejecutar Flutter en el anfitrión.

**Rationale**: Android e iOS requieren SDK, emulador, firma y Xcode del anfitrión. La aplicación móvil consume la API común, pero meter su toolchain en Linux no permite compilar iOS ni mejora el ciclo local.

**Alternatives considered**: Contenedor con Flutter; entorno completamente nativo. El primero no resuelve iOS y el segundo pierde reproducibilidad del backend.

## Decision 3: versiones estables y bloqueadas

**Decision**: Node 24.15 en contenedores, React 19, Vite 8, NestJS 12, TypeScript 6, PostgreSQL 18.6, Prisma 6.12 y Flutter 3.38.1/Dart 3.10 como línea inicial, con archivos de bloqueo versionados. Líneas posteriores de Prisma se evaluaron y se descartaron en esta fecha porque su cadena de desarrollo reportó una vulnerabilidad alta sin corrección compatible.

**Rationale**: Son líneas estables vigentes verificadas al preparar la base. Fijar versiones evita cambios invisibles entre los dos equipos de desarrollo.

**Alternatives considered**: Etiquetas `latest`; versiones históricas. Las etiquetas flotantes dañan la reproducibilidad y las líneas anteriores no aportan una ventaja concreta en esta fundación.

## Decision 4: librerías iniciales acotadas

**Decision**: API con configuración validada, Prisma/PostgreSQL, validación de entradas, Swagger, seguridad HTTP y logging estructurado; panel con router, consultas remotas, formularios y validación; móvil con Riverpod, GoRouter y Dio.

**Rationale**: Cubren necesidades transversales ya previsibles sin agregar librerías de mapas, pagos, IA, notificaciones o animación antes de sus pruebas específicas.

**Alternatives considered**: Incorporar de una vez todo el stack futuro. Aumentaría actualizaciones, permisos y superficie de fallo sin una función que lo valide.

## Decision 5: salud honesta

**Decision**: Separar `liveness` del proceso y `readiness` con consulta real a PostgreSQL.

**Rationale**: Evita indicar que la API está lista cuando su dependencia principal no responde y respeta el principio de no fingir estados.

**Alternatives considered**: Un único endpoint que siempre responde 200. Es insuficiente para diagnóstico y orden de inicio.

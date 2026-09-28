# Feature Specification: Base de desarrollo reproducible

**Feature Branch**: `main`

**Created**: 2026-09-14

**Status**: Approved

**Input**: Preparar el entorno inicial de ServiPronto con la aplicación móvil, el panel web, la API propia y una base de datos local reproducible.

## User Scenarios & Testing

### User Story 1 - Levantar el entorno completo (Priority: P1)

Como integrante del equipo, quiero iniciar todos los servicios locales con un único flujo documentado para comenzar a desarrollar sin configurar cada pieza manualmente.

**Why this priority**: Es la base que bloquea cualquier funcionalidad del producto y debe ser sostenible por un equipo de dos personas.

**Independent Test**: Desde una instalación con los prerrequisitos documentados, se inicia el entorno y se comprueba que la base de datos, la API y el panel quedan disponibles y reportan un estado verificable.

**Acceptance Scenarios**:

1. **Given** una copia nueva del repositorio y las variables locales configuradas, **When** un desarrollador inicia el entorno, **Then** los servicios arrancan en orden y los dependientes esperan a que sus dependencias estén saludables.
2. **Given** el entorno en ejecución, **When** se consulta su estado, **Then** se distinguen claramente la disponibilidad de la aplicación y la conexión a la base de datos.
3. **Given** datos creados durante una sesión, **When** los servicios se reinician sin solicitar un borrado, **Then** los datos locales se conservan.

---

### User Story 2 - Verificar el panel administrativo (Priority: P2)

Como integrante del equipo, quiero abrir el panel web inicial y ver si puede comunicarse con la API para detectar enseguida problemas del entorno.

**Why this priority**: Confirma la integración entre las dos piezas web antes de construir funciones administrativas sensibles.

**Independent Test**: Se abre el panel y se observa un estado de API disponible o un error explícito y recuperable si la API está detenida.

**Acceptance Scenarios**:

1. **Given** el panel y la API disponibles, **When** se abre la pantalla inicial, **Then** muestra que el entorno está conectado.
2. **Given** la API no disponible, **When** se abre o reintenta la pantalla, **Then** muestra un estado de desconexión sin inventar que el sistema funciona.

---

### User Story 3 - Ejecutar la aplicación móvil base (Priority: P3)

Como integrante del equipo, quiero ejecutar la misma aplicación móvil en Android y prepararla para iOS, con una configuración clara del servidor según el dispositivo usado.

**Why this priority**: Valida desde el inicio la base móvil compartida elegida y evita asumir que el acceso local funciona igual en emuladores y dispositivos.

**Independent Test**: La aplicación inicia en un emulador Android, presenta la identidad inicial de ServiPronto y permite comprobar la conexión con la API; el proyecto iOS queda generado para validarlo en la Mac.

**Acceptance Scenarios**:

1. **Given** un emulador Android y el entorno local disponible, **When** se inicia la aplicación, **Then** carga sin fallos y puede verificar el estado de la API.
2. **Given** una API inaccesible, **When** la aplicación intenta verificarla, **Then** informa la desconexión y permite reintentar.

### Edge Cases

- Un puerto requerido ya está ocupado: el inicio falla con un diagnóstico visible y no termina procesos ajenos.
- Faltan variables locales: el entorno rechaza la configuración antes de iniciar con valores inseguros o ambiguos.
- La base de datos tarda en estar lista: la API espera su estado saludable en vez de asumir disponibilidad.
- El emulador y un teléfono físico requieren direcciones distintas para llegar al equipo anfitrión.
- Un desarrollador usa Windows y otro macOS: los comandos principales y la configuración no dependen de rutas personales.

## Requirements

### Functional Requirements

- **FR-001**: El equipo MUST poder iniciar la base de datos, la API y el panel mediante un único flujo local documentado.
- **FR-002**: El entorno MUST comprobar la salud de cada servicio y respetar el orden de dependencias.
- **FR-003**: La base de datos local MUST conservar datos entre reinicios normales y requerir una acción deliberada para eliminarlos.
- **FR-004**: Las credenciales locales MUST provenir de un archivo no versionado basado en un ejemplo seguro.
- **FR-005**: La API MUST exponer una comprobación que diferencie el proceso activo de la conexión efectiva a la base de datos.
- **FR-006**: El panel MUST presentar el estado real de comunicación con la API y permitir reintentar una conexión fallida.
- **FR-007**: La aplicación móvil MUST ofrecer la misma comprobación y permitir configurar el servidor sin cambiar código fuente.
- **FR-008**: La base móvil MUST incluir proyectos Android e iOS desde el inicio.
- **FR-009**: El repositorio MUST incluir verificaciones automatizadas de formato, análisis estático, pruebas y construcción para cada pieza aplicable.
- **FR-010**: El entorno MUST utilizar versiones registradas y dependencias bloqueadas para ser reproducible.
- **FR-011**: El alcance MUST limitarse a una fundación técnica; no MUST simular usuarios, contrataciones, pagos, verificaciones ni acciones de Jorge todavía.
- **FR-012**: La documentación MUST explicar el acceso desde navegador, emulador Android, dispositivo físico y Mac sin afirmar que iOS fue compilado en Windows.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Un integrante con los prerrequisitos instalados puede levantar el entorno desde cero siguiendo la guía en menos de 15 minutos, sin decisiones no documentadas.
- **SC-002**: Después de descargar las imágenes y dependencias una vez, los tres servicios locales reportan estado saludable en menos de 3 minutos en el equipo de desarrollo.
- **SC-003**: El 100% de las comprobaciones automatizadas incluidas finaliza correctamente antes de considerar lista la base.
- **SC-004**: Reiniciar el entorno cinco veces conserva los datos locales en cinco de cinco intentos.
- **SC-005**: Tanto el panel como la aplicación móvil muestran un fallo comprobable cuando la API está detenida y se recuperan mediante reintento al restablecerla.
- **SC-006**: Ninguna clave real, credencial personal ni secreto queda versionado en el repositorio.

## Assumptions

- Los dos integrantes cuentan con Docker Desktop, Git y acceso de red para la descarga inicial.
- Flutter se ejecuta en el anfitrión para acceder a los SDK de Android y, en la Mac, a Xcode; no se intenta compilar iOS dentro de un contenedor Linux.
- El primer entorno es exclusivamente de desarrollo local y no define todavía la topología de producción en Railway.
- La salud inicial de la base utiliza una estructura mínima de diagnóstico; las entidades de producto se especificarán en funcionalidades posteriores.

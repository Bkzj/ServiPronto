# Feature Specification: Base modular y acceso administrador

**Feature Branch**: `main`

**Created**: 2026-09-14

**Status**: Approved

**Input**: Construir una base visible del producto, preparar sus módulos sin completarlos y crear un perfil administrador local accesible con las credenciales aportadas por el fundador.

## User Scenarios & Testing

### User Story 1 - Acceso administrador real (Priority: P1)

Como fundador, quiero ingresar al panel con mi correo y contraseña para acceder a una sesión administrativa identificada, sin que la contraseña quede guardada como texto en la base ni en el código.

**Independent Test**: Una cuenta sembrada desde variables locales puede iniciar sesión; una contraseña incorrecta recibe el mismo rechazo genérico que una cuenta inexistente; la sesión permite consultar el perfil autenticado.

**Acceptance Scenarios**:

1. **Given** la cuenta administradora activa, **When** se presentan las credenciales correctas, **Then** se inicia una sesión y se muestra el perfil correspondiente.
2. **Given** credenciales incorrectas o una cuenta suspendida, **When** se intenta ingresar, **Then** se rechaza el acceso sin revelar cuál dato falló.
3. **Given** una sesión válida, **When** se consulta el perfil, **Then** se devuelven únicamente identificador, correo, nombre, rol y estado permitidos.

---

### User Story 2 - Reconocer la arquitectura del marketplace (Priority: P2)

Como integrante del equipo, quiero ver módulos de negocio separados y su estado de avance para desarrollar cada función sin mezclar pagos, conversaciones, perfiles o solicitudes.

**Independent Test**: El administrador autenticado consulta el catálogo de módulos y recibe nombres, límites y estado honesto; ningún módulo base afirma que una operación todavía inexistente funciona.

**Acceptance Scenarios**:

1. **Given** una sesión administrativa, **When** se abre el panel, **Then** se muestran los módulos iniciales agrupados y marcados como base preparada.
2. **Given** una solicitud sin sesión, **When** intenta consultar información administrativa, **Then** se rechaza.

---

### User Story 3 - Preparar a Jorge sin proveedor externo (Priority: P3)

Como equipo, queremos una frontera propia para Jorge que permita sumar proveedores de IA más adelante sin acoplar reglas de negocio ni declarar respuestas inventadas ahora.

**Independent Test**: Una prueba usa un adaptador local simulado a través del mismo contrato que usarían adaptadores externos; ningún SDK de IA aparece fuera del directorio de adaptadores.

**Acceptance Scenarios**:

1. **Given** que no hay proveedor habilitado, **When** un orquestador solicita una generación, **Then** recibe un estado explícito de no configurado.
2. **Given** un adaptador simulado, **When** se ejecuta una solicitud compatible, **Then** el orquestador devuelve la respuesta normalizada sin conocer formatos externos.

### Edge Cases

- La semilla se ejecuta varias veces: actualiza el hash y mantiene una sola cuenta por correo normalizado.
- Faltan variables de la cuenta inicial: el proceso informa el problema sin imprimir la contraseña.
- Un token vencido, alterado o de otro rol no concede acceso.
- Un módulo incompleto se presenta como `planned` o `foundation`, nunca como operativo.

## Requirements

### Functional Requirements

- **FR-001**: El sistema MUST crear o actualizar de forma idempotente una cuenta administradora local a partir de variables no versionadas.
- **FR-002**: El sistema MUST almacenar únicamente un hash resistente de la contraseña y MUST excluir la contraseña de logs y respuestas.
- **FR-003**: El inicio de sesión MUST normalizar el correo y responder con un error genérico para credenciales inválidas.
- **FR-004**: Las rutas administrativas MUST exigir una sesión válida, activa y con rol administrador.
- **FR-005**: El panel MUST ofrecer un formulario accesible, estados de envío y error, cierre de sesión y perfil visible.
- **FR-006**: La API MUST separar como módulos: cuentas, proveedores, catálogo, solicitudes, visitas, presupuestos, trabajos, agenda, mensajes, pagos, reputación, incidentes, contenido, notificaciones, administración y Jorge.
- **FR-007**: Cada módulo incompleto MUST declarar explícitamente su alcance base y estado sin inventar capacidades.
- **FR-008**: Jorge MUST depender de un contrato interno, un gateway y adaptadores intercambiables; solo adaptadores futuros podrán importar SDK externos.
- **FR-009**: La implementación inicial de Jorge MUST funcionar sin llamadas externas ni costos y MUST fallar explícitamente cuando no hay proveedor configurado.
- **FR-010**: La aplicación móvil MUST presentar la navegación base Inicio, Explorar, Jorge, Actividad y Perfil, conservando el acceso central a Jorge como opción.

## Success Criteria

- **SC-001**: Las credenciales correctas permiten llegar al panel en menos de 10 segundos en el entorno local.
- **SC-002**: El 100% de las rutas administrativas de esta base rechaza solicitudes sin una sesión válida.
- **SC-003**: Ejecutar la semilla cinco veces produce exactamente una cuenta para el mismo correo.
- **SC-004**: Una búsqueda automática no encuentra contraseñas reales en archivos versionables ni dependencias de SDK de IA fuera de futuros adaptadores.
- **SC-005**: API, panel y aplicación móvil pasan sus pruebas, análisis y construcciones después de incorporar la base modular.

## Assumptions

- Este acceso es solo para desarrollo local y no reemplaza el futuro flujo de alta, recuperación, segundo factor ni políticas de producción.
- El token se conserva solo en memoria en esta primera base; al recargar se vuelve a ingresar.
- Los módulos representan fronteras y contratos iniciales, no funcionalidades comerciales terminadas.

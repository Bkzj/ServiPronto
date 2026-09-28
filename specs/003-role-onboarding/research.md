# Investigación técnica — alta y revisión inicial

## Decisiones

### Identidad compartida, cuentas de negocio separadas

**Decisión**: una `AppIdentity` representa el acceso por correo/contraseña y puede asociarse a una cuenta Cliente y otra Proveedor. Cada tabla de cuenta aplica unicidad por teléfono dentro de su rol.

**Motivo**: permite el mismo correo y teléfono en ambos roles, sin mezclar estados, perfiles ni permisos. Respeta la decisión del fundador de que no exista un cambio libre de rol.

### Alternativa C como desafío de nueva sesión

**Decisión**: iniciar sesión exige contraseña válida y después un código temporal enviado al teléfono verificado. La creación inicial exige esa misma verificación antes de habilitar una cuenta de negocio.

**Motivo**: eleva la trazabilidad de la sesión en la beta sin impedir una futura migración a OTP puro (A). No se afirma que sea una validación legal de identidad.

### Contrato de verificación telefónica propio

**Decisión**: `PhoneVerificationGateway` recibe un destino normalizado y un propósito, y expone entrega/verificación mediante desafíos propios. El adaptador local se habilita únicamente cuando `NODE_ENV=development`.

**Motivo**: los servicios de negocio no conocen Twilio, Mercado Pago, WhatsApp ni SDK de mensajería. Reemplazar el proveedor futuro afecta al adaptador y sus pruebas, no a los flujos de alta.

### Código y contraseña con hash

**Decisión**: aplicar hash fuerte a contraseña y código; guardar vencimiento, cantidad de intentos, propósito y consumo único. El código no se registra ni se expone en respuestas API.

**Motivo**: evita persistir secretos recuperables y permite rechazar reintentos o desafíos vencidos de manera determinista.

### Estados de proveedor como máquina de estados explícita

**Decisión**: solo `INCOMPLETE → IN_REVIEW`, `CHANGES_REQUIRED → IN_REVIEW` y las decisiones de administración desde `IN_REVIEW` son válidas. `SUSPENDED` no se reactiva desde el flujo.

**Motivo**: un proveedor no puede publicarse ni autoaprobarse por accidente; cada decisión deja historial.

### Categorías iniciales controladas por código

**Decisión**: cargar las once categorías generales de Tandil mediante datos iniciales y permitir que se inhabiliten sin borrar borradores.

**Motivo**: es suficiente para la beta y evita construir un editor administrativo no requerido.

## Riesgos y respuestas

| Riesgo | Respuesta |
| --- | --- |
| Adaptador local usado en producción | Validación de configuración que falla al iniciar fuera de desarrollo. |
| Ataques de fuerza bruta al código | Vencimiento corto, límite de intentos y desafío de un solo uso. |
| Duplicación por reintento móvil | Restricciones únicas y operaciones idempotentes por desafío/identidad. |
| Datos de proveedor incompletos | Validación antes de enviar y transición de estado cerrada. |
| Revisión administrativa poco trazable | Historial inmutable con administrador, fecha, estado y motivo. |

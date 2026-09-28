# Modelo de datos — alta y revisión inicial

## Identidad y acceso

### AppIdentity

| Campo | Regla |
| --- | --- |
| id | UUID interno |
| email | único, normalizado |
| passwordHash | nunca se devuelve |
| phone | E.164, único globalmente desde el registro; se confirma con el desafío telefónico |
| phoneVerifiedAt | fecha de verificación |
| createdAt / updatedAt | auditoría |

### PhoneVerificationChallenge

| Campo | Regla |
| --- | --- |
| id | UUID público no predecible |
| purpose | `REGISTRATION` o `SESSION` |
| identityId | identidad pendiente o existente |
| codeHash | hash; nunca código plano |
| expiresAt | vencimiento corto |
| attempts | límite estricto |
| consumedAt | consumo único |

## Cuentas de negocio

### ClientAccount

Una sola por identidad (`identityId` único). Conserva el teléfono verificado de su identidad, nombre, apellido, fecha de nacimiento, dirección y estado de completitud. El alta repetida actualiza la misma cuenta. No crea proveedor ni le concede permisos de proveedor.

### ProviderAccount

Una sola por identidad (`identityId` único). Conserva el teléfono verificado de su identidad, estado actual, borrador editable, fecha del último envío y número de versión. El alta repetida actualiza la misma cuenta. No conserva documentos ni comprobantes de la credencial en esta entrega.

Estados: `INCOMPLETE`, `IN_REVIEW`, `CHANGES_REQUIRED`, `APPROVED`, `REJECTED`, `SUSPENDED`.

### ProviderPresentation

Cada envío crea una fila nueva ligada al proveedor, con versión única por proveedor y fecha de envío. Conserva una copia de los datos efectivamente presentados: correo y teléfono de contacto verificado, nombre, apellido, categoría y su nombre/slug en ese momento, tareas y aclaración, modalidad, cobertura, disponibilidad, experiencia, precio orientativo o por hora y texto opcional de credencial declarada. Los campos tipados excluyen DNI, selfies, comprobantes, documentos, datos de cobro y portfolio. El proveedor puede modificar su borrador para reenviar sin alterar las presentaciones previas.

### ProviderReviewDecision

Registro inmutable de decisión: proveedor, presentación concreta, administrador, estado anterior, estado resultante, motivo opcional/obligatorio según resultado y fecha. La referencia a presentación incluye el proveedor en la clave externa para impedir que una decisión de un proveedor apunte al envío de otro. La versión se obtiene de la presentación referenciada.

### ServiceCategory

Catálogo inicial: Plomería, Electricidad, Gas y calefacción, Limpieza, Jardinería, Mudanzas, Clases particulares, Técnico a domicilio, Aire acondicionado, Cámaras y seguridad, Mecánica a domicilio. Incluye `enabled` para impedir nuevos envíos sin borrar datos existentes.

## Invariantes

1. `AppIdentity.phone` es único globalmente: otra identidad no puede registrarse con ese teléfono. Una identidad puede tener una cuenta Cliente y una Proveedor con ese mismo teléfono verificado, pero nunca dos cuentas del mismo rol.
2. Solo una identidad con teléfono verificado puede crear o recibir una sesión de aplicación.
3. Solo un proveedor `APPROVED` podrá ser consultable en una capacidad pública futura.
4. Cada reenvío conserva una presentación nueva y los datos enviados en ese momento; editar el borrador no cambia envíos ni decisiones anteriores. Toda decisión administrativa apunta a una de esas presentaciones.
5. Una credencial declarada no cambia estados ni ranking.

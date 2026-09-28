# Data model: Base modular y acceso administrador

## AdminAccount

- `id`: UUID único.
- `email`: correo normalizado y único.
- `passwordHash`: hash bcrypt; nunca se devuelve.
- `displayName`: nombre visible.
- `status`: `ACTIVE` o `SUSPENDED`.
- `createdAt`, `updatedAt`: trazabilidad temporal.

La cuenta administradora es independiente de las futuras cuentas de cliente y proveedor. Esta decisión evita convertir el rol privilegiado en una variante de autorregistro público.

# Quickstart: acceso y base modular

1. Configurar en `.env` `JWT_SECRET`, `SEED_ADMIN_EMAIL` y `SEED_ADMIN_PASSWORD`.
2. Ejecutar `docker compose up --build -d`; la API aplica migraciones y la semilla idempotente sin imprimir la clave.
3. Abrir `http://localhost:5173` e ingresar con las credenciales locales.
4. Verificar que el tablero muestre el perfil y los módulos con estado base, sin funciones ficticias.
5. Ejecutar `npm run check` y, en `apps/mobile`, `flutter analyze && flutter test`.

## Resultado verificado — 2026-09-14

- Las dos migraciones se aplicaron y la semilla se ejecutó cinco veces dejando exactamente una cuenta administradora.
- La contraseña almacenada usa hash bcrypt y no coincide con el texto recibido por configuración.
- El login real, `/auth/me` y el registro de 15 módulos respondieron correctamente en Docker.
- Una solicitud sin token al registro administrativo respondió `401`.
- El panel completó el acceso en navegador y mostró el perfil, 13 bases creadas y 2 áreas futuras.
- Jorge devuelve un estado explícito de no disponibilidad mientras no exista proveedor configurado; no simula una respuesta ni una acción.
- La aplicación móvil muestra Inicio, Explorar, Jorge, Actividad y Perfil, con una vista base para cada destino.

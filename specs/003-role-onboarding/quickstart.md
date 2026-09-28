# Validación local — alta y revisión inicial

1. Iniciar los servicios con `docker compose up --build`.
2. Configurar en el archivo local no versionado el código de desarrollo para teléfono y verificar que el entorno sea `development`.
3. Crear una identidad de aplicación con correo, contraseña y teléfono; confirmar el código local y obtener una sesión.
4. Crear un Cliente, guardar sus datos en pasos y comprobar que puede retomarlos.
5. Crear un Proveedor con una categoría, guardar borrador, enviar a revisión y comprobar que no aparece como elegible.
6. Acceder al panel con la cuenta administrativa local, aprobar o pedir cambios con motivo y comprobar el historial.
7. Ejecutar `npm run check`, las pruebas específicas del API y `flutter test`.

No se usan números, documentos ni datos reales durante esta validación.

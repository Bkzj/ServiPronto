# Quickstart: entorno local

## Prerrequisitos

- Docker Desktop con el motor Linux iniciado.
- Flutter estable y Android SDK para ejecutar Android.
- Para iOS: Mac con Flutter y Xcode; la generación del proyecto puede inspeccionarse en Windows, pero la compilación se valida en la Mac.

## Primera ejecución

1. Copiar `.env.example` como `.env` y conservarlo fuera de Git.
2. Ejecutar `docker compose up --build -d` desde la raíz.
3. Consultar `docker compose ps`; `postgres`, `api` y `admin` deben quedar saludables.
4. Abrir `http://localhost:5173` y verificar que el panel informa conexión real.
5. Abrir `http://localhost:3000/api/docs` para inspeccionar el contrato de la API.

## Aplicación móvil

1. Entrar a `apps/mobile` y ejecutar `flutter pub get`.
2. Emulador Android: usar `--dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1`.
3. Dispositivo físico: usar la IP local del equipo anfitrión, accesible desde la misma red.
4. Simulador iOS en Mac: usar `--dart-define=API_BASE_URL=http://127.0.0.1:3000/api/v1`.

## Validación

- `npm run check` ejecuta las verificaciones de API y panel.
- `flutter analyze` y `flutter test` verifican la app móvil.
- `docker compose exec postgres pg_isready -U servipronto -d servipronto` verifica PostgreSQL.
- Detener con `docker compose down`. Los datos se conservan.
- Eliminar datos requiere la acción explícita `docker compose down -v`.

## Resultado verificado — 2026-09-14

- `postgres`, `api` y `admin` iniciaron saludables; los puertos web/API quedaron publicados solo en loopback.
- Liveness y readiness respondieron correctamente, incluida una consulta real a PostgreSQL.
- La fila técnica persistió después de reiniciar PostgreSQL.
- API: tipos, lint, compilación y 10 pruebas correctas.
- Panel: tipos, lint, compilación y 2 pruebas correctas.
- Las imágenes de producción de API y panel compilaron; la API de producción inició y respondió readiness contra PostgreSQL.
- Flutter: análisis sin observaciones, 3 pruebas correctas y APK Android debug generado.
- `npm audit` informó 0 vulnerabilidades conocidas en el lockfile utilizado.
- `.env` quedó excluido de Git y no se incorporaron credenciales a los archivos versionables.

# Data model: Base de desarrollo reproducible

Esta funcionalidad no introduce entidades de negocio. Agrega una única tabla técnica mínima para verificar migraciones y persistencia.

## RuntimeProbe

- `id`: identificador entero único.
- `createdAt`: fecha y hora asignada por la base.
- Finalidad: permitir una comprobación local de escritura/persistencia sin inventar usuarios, servicios ni pagos.

La tabla puede eliminarse o reemplazarse cuando una especificación posterior introduzca la primera entidad real. No participa del dominio de ServiPronto.

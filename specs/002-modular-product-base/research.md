# Research: Base modular y acceso administrador

## Sesión inicial

**Decision**: Token firmado de vida corta, mantenido solo en memoria por el panel; contraseña con bcrypt de costo 12 y semilla idempotente desde variables locales.

**Rationale**: Entrega un acceso real y testeable sin persistir tokens en almacenamiento web ni introducir todavía cookies, renovación y CSRF que requieren una especificación de autenticación completa.

**Alternatives considered**: Token en localStorage; cookie persistente. La primera amplía el impacto de XSS; la segunda exige completar políticas que exceden esta base.

## Límites de módulos

**Decision**: API modular única con fronteras explícitas, no microservicios. Un registro administrativo expone solo nombre, descripción y estado de cada módulo.

**Rationale**: Mantiene claridad arquitectónica y operación simple para dos personas.

## Jorge

**Decision**: Contrato y gateway propios con adaptador no configurado y doble de prueba. No se instala SDK ni se hace una llamada externa.

**Rationale**: Valida la dirección arquitectónica acordada sin costo, claves ni dependencia prematura.

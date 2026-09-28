# Mapa de especificaciones de frontend

Este mapa divide la interfaz en recorridos pequeños. Cada bloque se puede diseñar, probar e implementar sin prometer capacidades comerciales que aún no existan.

| Orden | Especificación | Recorrido | Depende de |
| --- | --- | --- | --- |
| 004 | Shell Cliente | Inicio, Explorar, Jorge, Actividad y Perfil | R01, R02 parcial |
| 005 | Acceso y perfil Cliente | Correo, contraseña, código temporal y datos progresivos | 003 |
| 006 | Crear solicitud | Categoría, necesidad, urgencia, ubicación, revisión | 004, 005 |
| 007 | Actividad y agenda | Pendientes, detalle, estados y agenda visual | 004, 006 |
| 008 | Chat de Jorge | Conversación, imágenes, tarjetas y estados seguros | 004, R09 base |
| 009 | Notificaciones | Centro, preferencias y enlaces contextuales | 004 |
| 010 | Perfil de Proveedor | Alta, categoría, borrador y revisión visual | 003 |
| 011 | Operación de Proveedor | Disponibilidad, oportunidades, trabajos y agenda | 010, 006, 007 |
| 012 | Panel administrativo | Revisión de proveedores, contenido y operación | 003, 010 |

## Reglas visuales comunes

- Curvas continuas G2, con jerarquía por espacio, superficie, tipografía y color.
- Sin bordes decorativos superiores, laterales o alrededor de cada tarjeta. Los anillos de foco, error y selección son excepciones funcionales.
- Cliente usa azul predominante y naranja de acento. Proveedor invierte la dominancia.
- Texto corto: un título y, solo si destraba una acción, una línea de apoyo.
- Tema sistema, claro y oscuro; contraste, texto grande, lector de pantalla, objetivos táctiles y movimiento reducido son requisitos de cada corte.
- Jorge acompaña pero nunca reemplaza el recorrido manual ni afirma acciones no ejecutadas.

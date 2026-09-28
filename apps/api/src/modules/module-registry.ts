export type ModuleStatus = 'foundation' | 'planned';
export type ModuleDescriptor = { key: string; name: string; description: string; status: ModuleStatus };

export const moduleRegistry: ReadonlyArray<ModuleDescriptor> = [
  { key: 'accounts', name: 'Cuentas', description: 'Identidades separadas de clientes y proveedores.', status: 'foundation' },
  { key: 'providers', name: 'Proveedores', description: 'Perfil profesional, aprobación y servicios ofrecidos.', status: 'foundation' },
  { key: 'catalog', name: 'Catálogo', description: 'Categorías, tareas y descubrimiento manual.', status: 'foundation' },
  { key: 'requests', name: 'Solicitudes', description: 'Necesidad, urgencia, domicilio y candidatos.', status: 'foundation' },
  { key: 'visits', name: 'Visitas', description: 'Reserva, costo informado y confirmaciones.', status: 'foundation' },
  { key: 'quotes', name: 'Presupuestos', description: 'Versiones, conceptos, aceptación y PDF.', status: 'foundation' },
  { key: 'jobs', name: 'Trabajos', description: 'Ciclo de vida, etapas y continuidad.', status: 'foundation' },
  { key: 'scheduling', name: 'Agenda', description: 'Disponibilidad, bloqueos y recurrencia.', status: 'foundation' },
  { key: 'messaging', name: 'Mensajes', description: 'Chat interno por servicio, texto e imágenes.', status: 'foundation' },
  { key: 'payments', name: 'Pagos', description: 'Estados trazables; Mercado Pago aún no integrado.', status: 'planned' },
  { key: 'reputation', name: 'Reputación', description: 'Reseñas por aspectos e insignias verificables.', status: 'foundation' },
  { key: 'incidents', name: 'Incidentes', description: 'Evidencias y revisión administrativa.', status: 'foundation' },
  { key: 'content', name: 'Contenido', description: 'Banners, promociones y categorías visibles.', status: 'foundation' },
  { key: 'notifications', name: 'Notificaciones', description: 'Avisos transaccionales; extras posteriores.', status: 'planned' },
  { key: 'jorge', name: 'Jorge', description: 'Contrato y gateway listos; proveedor de IA no configurado.', status: 'foundation' },
];

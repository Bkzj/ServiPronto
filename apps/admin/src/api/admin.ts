import { apiRequest } from './client'

export type ModuleDescriptor = {
  key: string
  name: string
  description: string
  status: 'foundation' | 'planned'
}

export function getAdminModules(token: string) {
  return apiRequest<{ modules: ModuleDescriptor[] }>('/admin/modules', {
    headers: { Authorization: `Bearer ${token}` },
  })
}

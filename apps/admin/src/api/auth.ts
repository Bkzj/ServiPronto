import { apiRequest } from './client'

export type AdminProfile = {
  id: string
  email: string
  displayName: string
  role: 'ADMIN'
  status: 'ACTIVE' | 'SUSPENDED'
}

export type LoginResponse = { accessToken: string; profile: AdminProfile }

export function loginAdmin(email: string, password: string) {
  return apiRequest<LoginResponse>('/auth/login', {
    method: 'POST',
    body: JSON.stringify({ email, password }),
  })
}

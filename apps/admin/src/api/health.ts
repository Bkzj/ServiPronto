export type HealthStatus = {
  status: 'ok' | 'unavailable'
  service: 'api' | 'database'
  timestamp: string
}

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:3000/api/v1'

export async function getApiReadiness(): Promise<HealthStatus> {
  const response = await fetch(`${apiBaseUrl}/health/ready`, { headers: { Accept: 'application/json' } })
  if (!response.ok) throw new Error(`La API respondió ${response.status}`)
  return response.json() as Promise<HealthStatus>
}

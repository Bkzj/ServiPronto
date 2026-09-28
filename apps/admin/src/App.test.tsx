import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { cleanup, render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { afterEach, describe, expect, it, vi } from 'vitest'
import App from './App'

function renderApp() {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } })
  return render(<QueryClientProvider client={client}><App /></QueryClientProvider>)
}

afterEach(() => { cleanup(); vi.unstubAllGlobals(); vi.restoreAllMocks() })

describe('administrative access', () => {
  it('logs in and shows protected modules', async () => {
    const fetchMock = vi.fn(async (input: RequestInfo | URL) => {
      const url = String(input)
      if (url.endsWith('/auth/login')) return { ok: true, json: async () => ({ accessToken: 'token', profile: { id: '1', email: 'admin@example.com', displayName: 'Agustina', role: 'ADMIN', status: 'ACTIVE' } }) }
      return { ok: true, json: async () => ({ modules: [{ key: 'jorge', name: 'Jorge', description: 'Gateway propio.', status: 'foundation' }] }) }
    })
    vi.stubGlobal('fetch', fetchMock)
    renderApp()
    await userEvent.type(screen.getByLabelText('Correo electrónico'), 'admin@example.com')
    await userEvent.type(screen.getByLabelText('Contraseña'), 'secreto')
    await userEvent.click(screen.getByRole('button', { name: 'Ingresar' }))
    expect(await screen.findByRole('heading', { name: 'Buen día, Agustina' })).toBeInTheDocument()
    expect(await screen.findByText('Gateway propio.')).toBeInTheDocument()
  })

  it('does not reveal whether the email or password failed', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({ ok: false, status: 401 }))
    renderApp()
    await userEvent.type(screen.getByLabelText('Correo electrónico'), 'admin@example.com')
    await userEvent.type(screen.getByLabelText('Contraseña'), 'incorrecta')
    await userEvent.click(screen.getByRole('button', { name: 'Ingresar' }))
    expect(await screen.findByRole('alert')).toHaveTextContent('El correo o la contraseña no son válidos.')
  })
})

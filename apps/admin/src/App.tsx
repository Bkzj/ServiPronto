import { zodResolver } from '@hookform/resolvers/zod'
import { useQuery } from '@tanstack/react-query'
import { Boxes, ChevronRight, LayoutDashboard, LogOut, ShieldCheck, Sparkles } from 'lucide-react'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { z } from 'zod'
import { getAdminModules } from './api/admin'
import { loginAdmin, type AdminProfile } from './api/auth'
import './App.css'

const loginSchema = z.object({
  email: z.email('Ingresá un correo válido.'),
  password: z.string().min(1, 'Ingresá tu contraseña.'),
})
type LoginFields = z.infer<typeof loginSchema>

export default function App() {
  const [session, setSession] = useState<{ token: string; profile: AdminProfile } | null>(null)
  if (!session) return <LoginScreen onLogin={setSession} />
  return <Dashboard session={session} onLogout={() => setSession(null)} />
}

function Brand() {
  return (
    <div className="brand">
      <span className="brand-mark" aria-hidden="true">SP</span>
      <span><strong>ServiPronto</strong><small>Administración</small></span>
    </div>
  )
}

function LoginScreen({ onLogin }: { onLogin: (session: { token: string; profile: AdminProfile }) => void }) {
  const [serverError, setServerError] = useState('')
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<LoginFields>({ resolver: zodResolver(loginSchema) })

  const submit = handleSubmit(async (values) => {
    setServerError('')
    try {
      const result = await loginAdmin(values.email, values.password)
      onLogin({ token: result.accessToken, profile: result.profile })
    } catch (error) {
      setServerError(error instanceof Error ? error.message : 'No pudimos iniciar sesión.')
    }
  })

  return (
    <main className="login-page">
      <section className="welcome-panel">
        <Brand />
        <div className="welcome-copy">
          <span className="eyebrow">Centro de operaciones</span>
          <h1>Todo ServiPronto,<br />en un solo lugar.</h1>
          <p>La base para aprobar proveedores, acompañar servicios y cuidar la confianza de la comunidad.</p>
        </div>
        <div className="jorge-note"><span>J</span><p><strong>¡Hola! Soy Jorge.</strong> Acá vas a poder ver cómo crece ServiPronto.</p></div>
      </section>
      <section className="login-panel" aria-labelledby="login-title">
        <form className="login-card" onSubmit={submit} noValidate>
          <div className="secure-icon"><ShieldCheck aria-hidden="true" /></div>
          <span className="eyebrow">Acceso protegido</span>
          <h2 id="login-title">Ingresá al panel</h2>
          <p className="form-intro">Usá tu cuenta de administración.</p>
          <label>Correo electrónico<input type="email" autoComplete="username" {...register('email')} aria-invalid={Boolean(errors.email)} /></label>
          {errors.email && <span className="field-error">{errors.email.message}</span>}
          <label>Contraseña<input type="password" autoComplete="current-password" {...register('password')} aria-invalid={Boolean(errors.password)} /></label>
          {errors.password && <span className="field-error">{errors.password.message}</span>}
          {serverError && <div className="form-error" role="alert">{serverError}</div>}
          <button type="submit" disabled={isSubmitting}>{isSubmitting ? 'Ingresando…' : 'Ingresar'}<ChevronRight aria-hidden="true" /></button>
        </form>
      </section>
    </main>
  )
}

function Dashboard({ session, onLogout }: { session: { token: string; profile: AdminProfile }; onLogout: () => void }) {
  const modules = useQuery({ queryKey: ['admin-modules'], queryFn: () => getAdminModules(session.token) })
  const ready = modules.data?.modules.filter((module) => module.status === 'foundation').length ?? 0
  return (
    <div className="app-shell">
      <aside>
        <Brand />
        <nav aria-label="Administración"><a className="active" href="#overview"><LayoutDashboard />Resumen</a><a href="#modules"><Boxes />Módulos</a></nav>
        <div className="sidebar-profile"><span>{session.profile.displayName.charAt(0)}</span><div><strong>{session.profile.displayName}</strong><small>{session.profile.email}</small></div></div>
        <button className="logout" type="button" onClick={onLogout}><LogOut />Cerrar sesión</button>
      </aside>
      <main className="dashboard" id="overview">
        <header><div><span className="eyebrow">Panel general</span><h1>Buen día, {session.profile.displayName.split(' ')[0]}</h1><p>Esta es la base operativa que vamos a hacer crecer.</p></div><span className="live-pill"><i />Entorno activo</span></header>
        <section className="summary-grid" aria-label="Resumen">
          <article><span>Módulos preparados</span><strong>{modules.isPending ? '—' : ready}</strong><small>fronteras listas para desarrollar</small></article>
          <article><span>Rol de acceso</span><strong>Admin</strong><small>cuenta protegida y autorizada</small></article>
          <article className="jorge-card"><Sparkles /><span>Jorge</span><strong>Base lista</strong><small>independiente del proveedor de IA</small></article>
        </section>
        <section className="modules-section" id="modules">
          <div className="section-title"><div><span className="eyebrow">Arquitectura del producto</span><h2>Módulos de ServiPronto</h2></div><p>{modules.data?.modules.length ?? 0} áreas definidas</p></div>
          {modules.isError && <div className="form-error" role="alert">No pudimos cargar los módulos.</div>}
          <div className="module-grid">
            {modules.data?.modules.map((module) => <article key={module.key}><div><span className={`module-dot ${module.status}`} /><small>{module.status === 'foundation' ? 'Base creada' : 'Próxima etapa'}</small></div><h3>{module.name}</h3><p>{module.description}</p></article>)}
          </div>
        </section>
      </main>
    </div>
  )
}

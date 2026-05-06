'use client';

import Link from 'next/link';
import { useState, useCallback, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import type { User } from '@supabase/supabase-js';

export default function Header() {
  const [menuOpen, setMenuOpen] = useState(false);
  const [user, setUser] = useState<User | null>(null);
  const router = useRouter();

  useEffect(() => {
    let sub: { unsubscribe: () => void } | null = null;
    import('@/lib/supabase/client').then(({ createClient }) => {
      const supabase = createClient();
      supabase.auth.getUser().then(({ data }) => setUser(data.user));
      const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
        setUser(session?.user ?? null);
      });
      sub = subscription;
    });
    return () => { sub?.unsubscribe(); };
  }, []);

  const handleSignOut = useCallback(async () => {
    const { createClient } = await import('@/lib/supabase/client');
    const supabase = createClient();
    await supabase.auth.signOut();
    setUser(null);
    router.push('/');
    router.refresh();
  }, [router]);

  return (
    <header className="bg-surface border-b border-line sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6">
        <div className="flex items-center justify-between h-14">
          {/* Logo — blue dominant, yellow accent dot for the wordmark */}
          <Link href="/" className="flex items-center gap-2 group">
            <span className="inline-block w-2 h-2 rounded-full bg-brand-yellow group-hover:bg-brand-red transition-colors" aria-hidden="true" />
            <span className="text-xl font-black text-brand-blue tracking-tight">
              Lleva<span className="text-ink">Lleva</span>
            </span>
          </Link>

          {/* Search bar — desktop */}
          <div className="hidden md:flex flex-1 max-w-lg mx-6">
            <form action="/buscar" className="w-full relative">
              <svg
                className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-ink-2/60 pointer-events-none"
                fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true"
              >
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
                  d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
              <input
                type="search"
                name="q"
                placeholder="¿Qué estás buscando?"
                aria-label="Buscar anuncios"
                className="w-full pl-10 pr-4 py-2 text-sm bg-white border border-line rounded-full focus:outline-none focus:ring-2 focus:ring-brand-blue focus:border-transparent placeholder:text-ink-2/60"
              />
            </form>
          </div>

          {/* Nav */}
          <nav className="flex items-center gap-2">
            <Link
              href="/publicar"
              className="hidden sm:inline-flex items-center gap-1.5 bg-brand-yellow text-ink text-sm font-bold px-4 py-2 rounded-full hover:bg-brand-yellow-600 transition-colors shadow-sm"
            >
              <span aria-hidden="true">+</span> Publicar
            </Link>
            {user ? (
              <>
                <Link
                  href="/dashboard"
                  className="hidden sm:inline-flex text-sm text-ink-2 hover:text-brand-blue px-3 py-2 rounded-lg hover:bg-brand-blue-50 transition-colors font-medium items-center gap-1.5"
                >
                  <span className="inline-block w-6 h-6 rounded-full bg-brand-blue text-white text-xs font-bold flex items-center justify-center flex-shrink-0">
                    {(user.email ?? 'U').charAt(0).toUpperCase()}
                  </span>
                  <span className="max-w-[80px] truncate">{user.email?.split('@')[0]}</span>
                </Link>
                <button
                  onClick={handleSignOut}
                  className="hidden sm:inline-flex text-xs text-ink-2/70 hover:text-red-500 px-2 py-1 rounded transition-colors"
                  aria-label="Cerrar sesión"
                >
                  Salir
                </button>
              </>
            ) : (
              <Link
                href="/auth/login"
                className="text-sm text-ink-2 hover:text-brand-blue px-3 py-2 rounded-lg hover:bg-brand-blue-50 transition-colors font-medium"
              >
                Ingresar
              </Link>
            )}
            <button
              className="md:hidden p-2 rounded-lg hover:bg-brand-blue-50 text-ink"
              onClick={() => setMenuOpen(!menuOpen)}
              aria-label="Menú"
              aria-expanded={menuOpen}
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
                  d={menuOpen ? 'M6 18L18 6M6 6l12 12' : 'M4 6h16M4 12h16M4 18h16'} />
              </svg>
            </button>
          </nav>
        </div>

        {/* Mobile search */}
        <div className="md:hidden pb-3">
          <form action="/buscar" className="relative">
            <svg
              className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-ink-2/60 pointer-events-none"
              fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true"
            >
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
            <input
              type="search"
              name="q"
              placeholder="¿Qué estás buscando?"
              aria-label="Buscar anuncios"
              className="w-full pl-10 pr-4 py-2 text-sm bg-white border border-line rounded-full focus:outline-none focus:ring-2 focus:ring-brand-blue placeholder:text-ink-2/60"
            />
          </form>
        </div>
      </div>

      {/* Mobile menu */}
      {menuOpen && (
        <div className="md:hidden border-t border-line bg-surface">
          <div className="px-4 py-3 space-y-2">
            <Link href="/publicar" className="block w-full text-center bg-brand-yellow text-ink text-sm font-bold px-4 py-2.5 rounded-full hover:bg-brand-yellow-600 transition-colors">
              + Publicar anuncio
            </Link>
            {user ? (
              <>
                <Link href="/dashboard" className="block text-center text-sm text-ink py-2 hover:text-brand-blue font-medium">
                  Mi cuenta ({user.email?.split('@')[0]})
                </Link>
                <button
                  onClick={handleSignOut}
                  className="block w-full text-center text-sm text-red-500 py-2 hover:text-red-700"
                >
                  Cerrar sesión
                </button>
              </>
            ) : (
              <>
                <Link href="/auth/login" className="block text-center text-sm text-ink py-2 hover:text-brand-blue">
                  Ingresar
                </Link>
                <Link href="/auth/register" className="block text-center text-sm text-ink py-2 hover:text-brand-blue">
                  Crear cuenta
                </Link>
              </>
            )}
          </div>
        </div>
      )}
    </header>
  );
}

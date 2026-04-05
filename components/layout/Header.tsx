'use client';

import Link from 'next/link';
import { useState, useCallback } from 'react';
import { useRouter } from 'next/navigation';

export default function Header() {
  const [menuOpen, setMenuOpen] = useState(false);
  const router = useRouter();

  const handleSignOut = useCallback(async () => {
    const { createClient } = await import('@/lib/supabase/client');
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push('/');
    router.refresh();
  }, [router]);

  return (
    <header className="bg-white border-b border-gray-200 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6">
        <div className="flex items-center justify-between h-14">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-2">
            <span className="text-xl font-black text-emerald-600 tracking-tight">
              Lleva<span className="text-gray-900">Lleva</span>
            </span>
            <span className="hidden sm:block text-xs text-gray-500 font-medium">.co</span>
          </Link>

          {/* Search bar - desktop */}
          <div className="hidden md:flex flex-1 max-w-lg mx-6">
            <form action="/buscar" className="w-full">
              <input
                type="search"
                name="q"
                placeholder="¿Qué estás buscando?"
                className="w-full px-4 py-2 text-sm border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
              />
            </form>
          </div>

          {/* Nav */}
          <nav className="flex items-center gap-2">
            <Link
              href="/publicar"
              className="hidden sm:inline-flex items-center gap-1.5 bg-emerald-600 text-white text-sm font-semibold px-4 py-2 rounded-full hover:bg-emerald-700 transition-colors"
            >
              <span>+</span> Publicar
            </Link>
            <Link
              href="/auth/login"
              className="text-sm text-gray-600 hover:text-gray-900 px-3 py-2 rounded-lg hover:bg-gray-100 transition-colors"
            >
              Ingresar
            </Link>
            <button
              className="md:hidden p-2 rounded-lg hover:bg-gray-100"
              onClick={() => setMenuOpen(!menuOpen)}
              aria-label="Menú"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
                  d={menuOpen ? 'M6 18L18 6M6 6l12 12' : 'M4 6h16M4 12h16M4 18h16'} />
              </svg>
            </button>
          </nav>
        </div>

        {/* Mobile search */}
        <div className="md:hidden pb-3">
          <form action="/buscar">
            <input
              type="search"
              name="q"
              placeholder="¿Qué estás buscando?"
              className="w-full px-4 py-2 text-sm border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-emerald-500"
            />
          </form>
        </div>
      </div>

      {/* Mobile menu */}
      {menuOpen && (
        <div className="md:hidden border-t border-gray-100 bg-white">
          <div className="px-4 py-3 space-y-2">
            <Link href="/publicar" className="block w-full text-center bg-emerald-600 text-white text-sm font-semibold px-4 py-2.5 rounded-full">
              + Publicar anuncio
            </Link>
            <Link href="/auth/login" className="block text-center text-sm text-gray-700 py-2">
              Ingresar
            </Link>
            <Link href="/auth/register" className="block text-center text-sm text-gray-700 py-2">
              Crear cuenta
            </Link>
            <Link href="/dashboard" className="block text-center text-sm text-gray-700 py-2">
              Mi cuenta
            </Link>
          </div>
        </div>
      )}
    </header>
  );
}

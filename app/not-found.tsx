import type { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'Página no encontrada',
  description: 'La página que buscas no existe o fue removida.',
  robots: { index: false, follow: false },
};

export default function NotFound() {
  return (
    <div className="min-h-[70vh] flex flex-col items-center justify-center px-4 text-center">
      <p className="text-7xl font-bold text-brand-blue mb-4">404</p>
      <h1 className="text-2xl font-semibold text-gray-800 mb-2">Página no encontrada</h1>
      <p className="text-gray-500 mb-8 max-w-md">
        La página que buscas no existe, fue movida o la dirección tiene un error. Vuelve al inicio y sigue explorando.
      </p>
      <div className="flex flex-col sm:flex-row gap-3">
        <Link
          href="/"
          className="px-6 py-3 bg-brand-blue text-white rounded-lg font-medium hover:bg-brand-blue/90 transition-colors"
        >
          Ir al inicio
        </Link>
        <Link
          href="/buscar"
          className="px-6 py-3 border border-brand-blue text-brand-blue rounded-lg font-medium hover:bg-brand-blue/5 transition-colors"
        >
          Buscar anuncios
        </Link>
      </div>
    </div>
  );
}

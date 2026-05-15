'use client';

import { useEffect } from 'react';
import Link from 'next/link';

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error('[AppError]', error);
  }, [error]);

  return (
    <div className="min-h-[70vh] flex flex-col items-center justify-center px-4 text-center">
      <div className="text-5xl mb-4" aria-hidden="true">⚠️</div>
      <h1 className="text-xl font-bold text-ink mb-2">Algo salió mal</h1>
      <p className="text-sm text-ink-2 mb-6 max-w-md">
        Ocurrió un error inesperado. Por favor intenta de nuevo o regresa al inicio.
      </p>
      <div className="flex flex-col sm:flex-row gap-3">
        <button type="button"
          onClick={reset}
          className="px-6 py-2.5 bg-brand-blue text-white rounded-full text-sm font-semibold hover:bg-brand-blue/90 transition-colors"
        >
          Intentar de nuevo
        </button>
        <Link
          href="/"
          className="px-6 py-2.5 border border-line text-ink rounded-full text-sm font-semibold hover:border-brand-blue/40 hover:text-brand-blue transition-colors"
        >
          Ir al inicio
        </Link>
      </div>
      {error.digest && (
        <p className="mt-6 text-xs text-ink-2">Código: {error.digest}</p>
      )}
    </div>
  );
}

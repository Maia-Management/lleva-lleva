'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';

interface Props {
  listingId: string;
  listingSlug: string;
}

export default function EditDeleteButtons({ listingId, listingSlug }: Props) {
  const router = useRouter();
  const [showConfirm, setShowConfirm] = useState(false);
  const [deleting, setDeleting] = useState(false);
  const [error, setError] = useState('');

  async function handleDelete() {
    setDeleting(true);
    setError('');
    try {
      const { createClient } = await import('@/lib/supabase/client');
      const supabase = createClient();

      const { error: deleteError } = await supabase
        .from('listings')
        .update({ status: 'removed' })
        .eq('id', listingId);

      if (deleteError) throw deleteError;

      router.push('/dashboard?deleted=1');
    } catch (err) {
      console.error(err);
      setError('Error al eliminar el anuncio. Intenta de nuevo.');
      setDeleting(false);
    }
  }

  return (
    <>
      <div className="flex items-center gap-2 mb-4 p-3 bg-brand-blue-50 border border-brand-blue/20 rounded-xl">
        <span className="text-xs text-brand-blue font-medium flex-1">✏️ Este es tu anuncio</span>
        <Link
          href={`/listing/${listingSlug}/edit`}
          className="text-xs bg-white border border-gray-200 text-gray-700 font-semibold px-3 py-1.5 rounded-lg hover:border-brand-blue/40 hover:text-brand-blue transition-colors"
        >
          Editar
        </Link>
        <button
          type="button"
          onClick={() => setShowConfirm(true)}
          className="text-xs bg-white border border-red-200 text-red-600 font-semibold px-3 py-1.5 rounded-lg hover:bg-red-50 transition-colors"
        >
          Eliminar
        </button>
      </div>

      {error && (
        <div className="mb-4 bg-red-50 border border-red-200 text-red-700 text-sm rounded-xl px-4 py-3">
          {error}
        </div>
      )}

      {/* Delete confirmation dialog */}
      {showConfirm && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl p-6 max-w-sm w-full shadow-xl">
            <h2 className="font-bold text-gray-900 text-lg mb-2">¿Eliminar este anuncio?</h2>
            <p className="text-sm text-gray-600 mb-6">
              El anuncio será eliminado y ya no aparecerá en las búsquedas. Esta acción no se puede deshacer.
            </p>
            <div className="flex gap-3">
              <button
                type="button"
                onClick={() => setShowConfirm(false)}
                disabled={deleting}
                className="flex-1 bg-gray-100 text-gray-700 font-semibold py-3 rounded-xl text-sm hover:bg-gray-200 transition-colors disabled:opacity-60"
              >
                Cancelar
              </button>
              <button
                type="button"
                onClick={handleDelete}
                disabled={deleting}
                className="flex-1 bg-red-600 text-white font-semibold py-3 rounded-xl text-sm hover:bg-red-700 transition-colors disabled:opacity-60"
              >
                {deleting ? 'Eliminando...' : 'Sí, eliminar'}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

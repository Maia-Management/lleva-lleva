'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { initiateTransaction, markListingAsSold } from '@/app/actions/transactions';
import { formatCOP } from '@/lib/utils';

interface Props {
  listingId: string;
  listingTitle: string;
  sellerId: string;
  listingPrice: number | null;
  isOwner: boolean;
  isAuthenticated: boolean;
  currentStatus: string;
}

export default function TransactionButtons({
  listingId,
  listingTitle,
  sellerId,
  listingPrice,
  isOwner,
  isAuthenticated,
  currentStatus,
}: Props) {
  const router = useRouter();
  const [showModal, setShowModal] = useState(false);
  const [price, setPrice] = useState(listingPrice ? String(Math.round(listingPrice)) : '');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [done, setDone] = useState(false);

  // Don't show buttons if listing is already sold/removed
  if (currentStatus === 'sold' || currentStatus === 'removed' || currentStatus === 'expired') {
    return null;
  }

  async function handleSell() {
    setLoading(true);
    setError('');
    try {
      const result = await markListingAsSold(listingId);
      if ('error' in result) {
        setError(result.error);
      } else {
        setDone(true);
        setShowModal(false);
        router.refresh();
      }
    } finally {
      setLoading(false);
    }
  }

  async function handleBuy() {
    if (!isAuthenticated) {
      router.push('/auth/login?redirectTo=' + encodeURIComponent(window.location.pathname));
      return;
    }
    setLoading(true);
    setError('');
    try {
      const agreedPrice = price ? parseFloat(price.replace(/[^0-9.]/g, '')) : undefined;
      const result = await initiateTransaction(listingId, sellerId, listingTitle, agreedPrice);
      if ('error' in result) {
        setError(result.error);
      } else {
        setDone(true);
        setShowModal(false);
        router.refresh();
      }
    } finally {
      setLoading(false);
    }
  }

  if (done) {
    return (
      <div className="bg-brand-blue-50 border border-brand-blue/20 rounded-xl p-3 mb-4 text-sm text-brand-blue font-medium text-center">
        ✅ {isOwner ? 'Anuncio marcado como vendido' : 'Compra confirmada — ¡recibirás un WhatsApp con el enlace de calificación!'}
      </div>
    );
  }

  return (
    <>
      {/* Seller action */}
      {isOwner && (
        <button
          type="button"
          onClick={() => setShowModal(true)}
          className="w-full mb-3 bg-blue-600 text-white text-sm font-bold py-2.5 rounded-xl hover:bg-blue-700 transition-colors"
        >
          🤝 Marcar como vendido
        </button>
      )}

      {/* Buyer action */}
      {!isOwner && (
        <button
          type="button"
          onClick={() => setShowModal(true)}
          className="w-full mb-3 bg-blue-50 border border-blue-200 text-blue-700 text-sm font-semibold py-2.5 rounded-xl hover:bg-blue-100 transition-colors"
        >
          ✅ Confirmar compra
        </button>
      )}

      {error && (
        <p className="text-xs text-red-600 mb-2 text-center">{error}</p>
      )}

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl p-6 max-w-sm w-full shadow-xl">
            {isOwner ? (
              <>
                <h2 className="font-bold text-gray-900 text-lg mb-1">Marcar como vendido</h2>
                <p className="text-sm text-gray-500 mb-4">
                  El anuncio quedará como &quot;Vendido&quot; y se enviará un WhatsApp de calificación.
                </p>
              </>
            ) : (
              <>
                <h2 className="font-bold text-gray-900 text-lg mb-1">Confirmar compra</h2>
                <p className="text-sm text-gray-500 mb-4">
                  Registra la transacción y recibirás un WhatsApp para dejar tu calificación.
                </p>
                <div className="mb-4">
                  <label className="text-xs font-medium text-gray-600 block mb-1">
                    Precio pactado (opcional)
                  </label>
                  <input
                    type="number"
                    value={price}
                    onChange={(e) => setPrice(e.target.value)}
                    placeholder={listingPrice ? `${Math.round(listingPrice)}` : 'Ej: 150000'}
                    className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue"
                  />
                  {listingPrice && (
                    <p className="text-xs text-gray-400 mt-1">Precio anunciado: {formatCOP(listingPrice)}</p>
                  )}
                </div>
              </>
            )}

            {error && (
              <p className="text-xs text-red-600 mb-3">{error}</p>
            )}

            <div className="flex gap-3">
              <button
                type="button"
                onClick={() => { setShowModal(false); setError(''); }}
                disabled={loading}
                className="flex-1 bg-gray-100 text-gray-700 font-semibold py-3 rounded-xl text-sm hover:bg-gray-200 transition-colors disabled:opacity-60"
              >
                Cancelar
              </button>
              <button
                type="button"
                onClick={isOwner ? handleSell : handleBuy}
                disabled={loading}
                className="flex-1 bg-brand-blue text-white font-semibold py-3 rounded-xl text-sm hover:bg-brand-blue-700 transition-colors disabled:opacity-60"
              >
                {loading ? 'Procesando...' : isOwner ? 'Confirmar venta' : 'Confirmar compra'}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

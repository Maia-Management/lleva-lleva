'use client';

import { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';

const RATING_TAGS = [
  { value: 'fast_response', label: 'Respuesta rápida' },
  { value: 'as_described', label: 'Como en el anuncio' },
  { value: 'trustworthy', label: 'Persona confiable' },
  { value: 'good_price', label: 'Buen precio' },
  { value: 'slow_response', label: 'Respuesta lenta' },
  { value: 'not_as_described', label: 'No como en el anuncio' },
  { value: 'no_show', label: 'No se presentó' },
];

export default function CalificarPage() {
  const params = useParams<{ transactionId: string }>();
  const router = useRouter();
  const transactionId = params.transactionId;

  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [done, setDone] = useState(false);
  const [error, setError] = useState('');

  // Form state
  const [score, setScore] = useState(5);
  const [comment, setComment] = useState('');
  const [selectedTags, setSelectedTags] = useState<string[]>([]);

  // Transaction data
  type TxData = {
    id: string;
    listing_id: string;
    buyer_id: string;
    seller_id: string;
    listing: { title: string; slug: string } | null;
    buyer: { display_name: string } | null;
    seller: { display_name: string } | null;
  };
  const [transaction, setTransaction] = useState<TxData | null>(null);
  const [currentUserId, setCurrentUserId] = useState<string | null>(null);
  const [alreadyRated, setAlreadyRated] = useState(false);

  useEffect(() => {
    const supabase = createClient();

    async function load() {
      const { data: { user } } = await supabase.auth.getUser();

      if (!user) {
        router.push('/auth/login?redirectTo=/calificar/' + transactionId);
        return;
      }
      setCurrentUserId(user.id);

      const { data: tx } = await supabase
        .from('transactions')
        .select('id, listing_id, buyer_id, seller_id, listing:listings(title, slug), buyer:profiles!buyer_id(display_name), seller:profiles!seller_id(display_name)')
        .eq('id', transactionId)
        .single();

      if (!tx) {
        setError('Transacción no encontrada.');
        setLoading(false);
        return;
      }

      // Check if user is a participant
      if (tx.buyer_id !== user.id && tx.seller_id !== user.id) {
        setError('No tienes acceso a esta calificación.');
        setLoading(false);
        return;
      }

      // Check if already rated
      const { data: existing } = await supabase
        .from('ratings')
        .select('id')
        .eq('transaction_id', transactionId)
        .eq('rater_id', user.id)
        .maybeSingle();

      if (existing) {
        setAlreadyRated(true);
      }

      setTransaction(tx as unknown as TxData);
      setLoading(false);
    }

    load();
  }, [transactionId, router]);

  function toggleTag(tag: string) {
    setSelectedTags((prev) =>
      prev.includes(tag) ? prev.filter((t) => t !== tag) : [...prev, tag]
    );
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!transaction || !currentUserId) return;

    setSubmitting(true);
    setError('');

    try {
      const supabase = createClient();
      const isBuyer = transaction.buyer_id === currentUserId;
      const rateeId = isBuyer ? transaction.seller_id : transaction.buyer_id;

      const { error: ratingError } = await supabase.from('ratings').insert({
        transaction_id: transactionId,
        rater_id: currentUserId,
        ratee_id: rateeId,
        listing_id: transaction.listing_id,
        score,
        comment: comment.trim() || null,
        tags: selectedTags,
        is_seller_rating: isBuyer,
      });

      if (ratingError) {
        setError('Error al enviar calificación: ' + ratingError.message);
      } else {
        setDone(true);
      }
    } finally {
      setSubmitting(false);
    }
  }

  if (loading) {
    return (
      <div className="min-h-[60vh] flex items-center justify-center">
        <div className="animate-spin w-8 h-8 border-2 border-brand-blue border-t-transparent rounded-full" />
      </div>
    );
  }

  if (error && !transaction) {
    return (
      <div className="max-w-md mx-auto px-4 py-12 text-center">
        <p className="text-gray-600">{error}</p>
      </div>
    );
  }

  if (alreadyRated || done) {
    return (
      <div className="max-w-md mx-auto px-4 py-12 text-center">
        <div className="text-5xl mb-4">⭐</div>
        <h1 className="text-xl font-bold text-gray-900 mb-2">
          {done ? '¡Gracias por calificar!' : 'Ya calificaste esta transacción'}
        </h1>
        <p className="text-gray-500 text-sm mb-6">
          {done
            ? 'Tu calificación ha sido enviada y ayudará a la comunidad de LlevaLleva.'
            : 'Ya enviaste tu calificación para esta transacción.'}
        </p>
        <button type="button"
          onClick={() => router.push('/dashboard')}
          className="inline-flex items-center gap-2 bg-brand-blue text-white font-semibold px-6 py-3 rounded-full hover:bg-brand-blue-700 transition-colors text-sm"
        >
          Ir al dashboard
        </button>
      </div>
    );
  }

  const isBuyer = transaction?.buyer_id === currentUserId;
  const rateeDisplay = isBuyer ? transaction?.seller?.display_name : transaction?.buyer?.display_name;
  const listingTitle = (transaction?.listing as { title?: string } | null)?.title;

  return (
    <div className="max-w-md mx-auto px-4 py-8">
      <div className="bg-white rounded-2xl border border-gray-200 p-6">
        <h1 className="text-xl font-bold text-gray-900 mb-1">Calificar transacción</h1>
        {listingTitle && (
          <p className="text-sm text-gray-500 mb-1">{listingTitle}</p>
        )}
        {rateeDisplay && (
          <p className="text-sm text-brand-blue font-medium mb-6">
            Calificando a: {rateeDisplay}
          </p>
        )}

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Star score */}
          <div>
            <p id="score-label" className="text-sm font-semibold text-gray-700 block mb-2">Calificación</p>
            <div className="flex gap-2" role="radiogroup" aria-labelledby="score-label">
              {[1, 2, 3, 4, 5].map((s) => (
                <button
                  key={s}
                  type="button"
                  role="radio"
                  aria-checked={score === s}
                  aria-label={`${s} estrellas`}
                  onClick={() => setScore(s)}
                  className={`text-3xl transition-transform hover:scale-110 ${s <= score ? 'opacity-100' : 'opacity-30'}`}
                >
                  ⭐
                </button>
              ))}
            </div>
          </div>

          {/* Tags */}
          <div>
            <p id="tags-label" className="text-sm font-semibold text-gray-700 block mb-2">Etiquetas (opcional)</p>
            <div className="flex flex-wrap gap-2" aria-labelledby="tags-label">
              {RATING_TAGS.map((tag) => (
                <button
                  key={tag.value}
                  type="button"
                  aria-pressed={selectedTags.includes(tag.value)}
                  onClick={() => toggleTag(tag.value)}
                  className={`text-xs px-3 py-1.5 rounded-full border transition-colors ${
                    selectedTags.includes(tag.value)
                      ? 'bg-brand-blue text-white border-brand-blue'
                      : 'bg-white text-gray-600 border-gray-200 hover:border-brand-blue/40'
                  }`}
                >
                  {tag.label}
                </button>
              ))}
            </div>
          </div>

          {/* Comment */}
          <div>
            <label className="text-sm font-semibold text-gray-700 block mb-2" htmlFor="transaction-comment">Comentario (opcional)</label>
            <textarea
              id="transaction-comment"
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              rows={3}
              placeholder="Cuéntanos cómo fue la experiencia..."
              className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue resize-none"
            />
          </div>

          {error && (
            <p className="text-sm text-red-600">{error}</p>
          )}

          <button
            type="submit"
            disabled={submitting}
            className="w-full bg-brand-blue text-white font-bold py-3 rounded-xl hover:bg-brand-blue-700 transition-colors disabled:opacity-60 text-sm"
          >
            {submitting ? 'Enviando...' : 'Enviar calificación'}
          </button>
        </form>
      </div>
    </div>
  );
}

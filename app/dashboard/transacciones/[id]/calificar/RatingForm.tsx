'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

const POSITIVE_TAGS = [
  { value: 'fast_response', label: 'Respuesta rápida' },
  { value: 'as_described', label: 'Como en el anuncio' },
  { value: 'trustworthy', label: 'Persona confiable' },
  { value: 'good_price', label: 'Buen precio' },
] as const;

const NEGATIVE_TAGS = [
  { value: 'slow_response', label: 'Respuesta lenta' },
  { value: 'not_as_described', label: 'No como en el anuncio' },
  { value: 'no_show', label: 'No se presentó' },
] as const;

interface Props {
  transactionId: string;
  raterId: string;
  rateeId: string;
  listingId: string;
  isSellerRating: boolean;
}

export default function RatingForm({ transactionId, raterId, rateeId, listingId, isSellerRating }: Props) {
  const router = useRouter();
  const [score, setScore] = useState(0);
  const [hovered, setHovered] = useState(0);
  const [comment, setComment] = useState('');
  const [selectedTags, setSelectedTags] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  function toggleTag(tag: string) {
    setSelectedTags((prev) =>
      prev.includes(tag) ? prev.filter((t) => t !== tag) : [...prev, tag]
    );
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (score === 0) { setError('Selecciona una calificación de 1 a 5 estrellas.'); return; }
    setLoading(true);
    setError('');

    const { createClient } = await import('@/lib/supabase/client');
    const supabase = createClient();
    const { error } = await supabase.from('ratings').insert({
      transaction_id: transactionId,
      rater_id: raterId,
      ratee_id: rateeId,
      listing_id: listingId,
      score,
      comment: comment.trim() || null,
      tags: selectedTags,
      is_seller_rating: isSellerRating,
    });

    if (error) {
      setError('Error al enviar la calificación. Intenta de nuevo.');
      setLoading(false);
      return;
    }

    router.push('/dashboard?rated=1');
    router.refresh();
  }

  const displayStars = hovered || score;

  return (
    <form onSubmit={handleSubmit} className="bg-white rounded-2xl border border-gray-200 p-6 space-y-5">
      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-xl px-4 py-3">{error}</div>
      )}

      {/* Stars */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-3">¿Cómo fue tu experiencia?</label>
        <div className="flex gap-2">
          {[1, 2, 3, 4, 5].map((star) => (
            <button
              key={star}
              type="button"
              onClick={() => setScore(star)}
              onMouseEnter={() => setHovered(star)}
              onMouseLeave={() => setHovered(0)}
              className="text-3xl transition-transform hover:scale-110 focus:outline-none"
              aria-label={`${star} estrellas`}
            >
              <span className={star <= displayStars ? 'text-brand-yellow' : 'text-gray-200'}>★</span>
            </button>
          ))}
        </div>
        {score > 0 && (
          <p className="text-sm text-gray-500 mt-1">
            {score === 1 ? 'Muy mala experiencia' : score === 2 ? 'Mala experiencia' :
              score === 3 ? 'Regular' : score === 4 ? 'Buena experiencia' : 'Excelente experiencia'}
          </p>
        )}
      </div>

      {/* Tags */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-2">¿Qué resaltarías? (opcional)</label>
        <div className="flex flex-wrap gap-2">
          {[...POSITIVE_TAGS, ...NEGATIVE_TAGS].map((tag) => (
            <button
              key={tag.value}
              type="button"
              onClick={() => toggleTag(tag.value)}
              className={`text-xs px-3 py-1.5 rounded-full border transition-colors ${
                selectedTags.includes(tag.value)
                  ? 'bg-brand-blue border-brand-blue text-white'
                  : 'bg-white border-gray-200 text-gray-600 hover:border-brand-blue/40'
              }`}
            >
              {tag.label}
            </button>
          ))}
        </div>
      </div>

      {/* Comment */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1">Comentario (opcional)</label>
        <textarea
          value={comment}
          onChange={(e) => setComment(e.target.value)}
          rows={3}
          maxLength={500}
          placeholder="Cuéntale a la comunidad sobre tu experiencia..."
          className="w-full px-4 py-3 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue resize-none"
        />
        <p className="text-xs text-gray-400 text-right mt-1">{comment.length}/500</p>
      </div>

      <button
        type="submit"
        disabled={loading || score === 0}
        className="w-full bg-brand-blue text-white font-bold py-3 rounded-xl hover:bg-brand-blue-700 transition-colors disabled:opacity-60 disabled:cursor-not-allowed"
      >
        {loading ? 'Enviando...' : 'Enviar calificación'}
      </button>
    </form>
  );
}

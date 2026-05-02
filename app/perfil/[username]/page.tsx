import { notFound } from 'next/navigation';
import { Metadata } from 'next';
import { createClient } from '@/lib/supabase/server';
import { Listing, Profile, Rating } from '@/types';
import ListingGrid from '@/components/listings/ListingGrid';
import StarRating from '@/components/ui/StarRating';
import { timeAgo } from '@/lib/utils';

interface Props {
  params: Promise<{ username: string }>;
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { username } = await params;
  return {
    title: `@${username} – Lleva Lleva`,
    description: `Perfil de ${username} en Lleva Lleva`,
  };
}

export default async function ProfilePage({ params }: Props) {
  const { username } = await params;
  const supabase = await createClient();

  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('username', username)
    .eq('is_active', true)
    .single();

  if (!profile) notFound();

  const p = profile as Profile;

  const [{ data: listings }, { data: ratings }] = await Promise.all([
    supabase
      .from('listings')
      .select('*, category:categories(*), location:locations(*)')
      .eq('seller_id', p.id)
      .eq('status', 'active')
      .order('published_at', { ascending: false })
      .limit(24),
    supabase
      .from('ratings')
      .select('*, rater:profiles(username, display_name, avatar_url)')
      .eq('ratee_id', p.id)
      .order('created_at', { ascending: false })
      .limit(10),
  ]);

  const RATING_TAG_LABELS: Record<string, string> = {
    fast_response: 'Respuesta rápida',
    as_described: 'Como en el anuncio',
    trustworthy: 'Persona confiable',
    good_price: 'Buen precio',
    slow_response: 'Respuesta lenta',
    not_as_described: 'No como en el anuncio',
    no_show: 'No se presentó',
  };

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 py-6">
      {/* Profile header */}
      <div className="bg-white rounded-2xl border border-gray-200 p-6 mb-6">
        <div className="flex items-start gap-4">
          <div className="w-16 h-16 rounded-full bg-brand-blue-50 flex items-center justify-center text-brand-blue font-black text-2xl flex-shrink-0">
            {p.display_name?.charAt(0).toUpperCase()}
          </div>
          <div className="flex-1 min-w-0">
            <div className="flex flex-wrap items-center gap-2">
              <h1 className="text-xl font-bold text-gray-900">{p.display_name}</h1>
              {p.is_verified && (
                <span className="inline-flex items-center gap-1 bg-brand-blue-50 text-brand-blue text-xs font-semibold px-2 py-0.5 rounded-full">
                  ✓ Verificado
                </span>
              )}
              {p.user_type === 'business' && (
                <span className="bg-blue-50 text-blue-700 text-xs font-semibold px-2 py-0.5 rounded-full">
                  Empresa
                </span>
              )}
            </div>
            <p className="text-sm text-gray-500 mt-0.5">@{p.username}</p>
            {p.business_name && (
              <p className="text-sm text-gray-600 mt-1 font-medium">{p.business_name}</p>
            )}
            {p.bio && (
              <p className="text-sm text-gray-600 mt-2 leading-relaxed">{p.bio}</p>
            )}
            <div className="flex flex-wrap items-center gap-4 mt-3 text-sm text-gray-500">
              {p.city && <span>📍 {p.city}{p.department ? `, ${p.department}` : ''}</span>}
              {p.rating_count > 0 && (
                <StarRating rating={p.rating_avg} count={p.rating_count} size="sm" />
              )}
              <span>📦 {p.total_sales} ventas</span>
              {p.created_at && (
                <span>🗓 Desde {new Date(p.created_at).toLocaleDateString('es-CO', { month: 'long', year: 'numeric' })}</span>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Active listings */}
      <section className="mb-8">
        <h2 className="font-bold text-gray-800 mb-4">
          Anuncios activos
          <span className="font-normal text-sm text-gray-500 ml-2">({listings?.length ?? 0})</span>
        </h2>
        <ListingGrid
          listings={(listings as Listing[]) ?? []}
          emptyMessage="Este usuario no tiene anuncios activos."
        />
      </section>

      {/* Ratings */}
      {ratings && ratings.length > 0 && (
        <section>
          <h2 className="font-bold text-gray-800 mb-4">
            Calificaciones
            <span className="font-normal text-sm text-gray-500 ml-2">({p.rating_count})</span>
          </h2>
          <div className="space-y-3">
            {(ratings as (Rating & { rater: Profile })[]).map((rating) => (
              <div key={rating.id} className="bg-white rounded-xl border border-gray-200 p-4">
                <div className="flex items-start justify-between gap-3">
                  <div className="flex items-center gap-2">
                    <div className="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center text-gray-600 font-bold text-sm flex-shrink-0">
                      {rating.rater?.display_name?.charAt(0).toUpperCase()}
                    </div>
                    <div>
                      <p className="text-sm font-medium text-gray-700">{rating.rater?.display_name}</p>
                      <p className="text-xs text-gray-400">{timeAgo(rating.created_at)}</p>
                    </div>
                  </div>
                  <StarRating rating={rating.score} size="sm" />
                </div>
                {rating.comment && (
                  <p className="text-sm text-gray-600 mt-2 leading-relaxed">{rating.comment}</p>
                )}
                {rating.tags && rating.tags.length > 0 && (
                  <div className="flex flex-wrap gap-1.5 mt-2">
                    {rating.tags.map((tag) => (
                      <span key={tag} className="bg-gray-100 text-gray-500 text-xs px-2 py-0.5 rounded-full">
                        {RATING_TAG_LABELS[tag] ?? tag}
                      </span>
                    ))}
                  </div>
                )}
              </div>
            ))}
          </div>
        </section>
      )}
    </div>
  );
}

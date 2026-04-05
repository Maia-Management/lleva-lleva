import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import PublicarForm from './PublicarForm';

export const metadata = {
  title: 'Publicar anuncio',
  description: 'Publica tu anuncio gratis en LlevaLleva.co',
};

export default async function PublicarPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) redirect('/auth/login?redirectTo=/publicar');

  // Soft-block: check for pending rating
  const { data: profile } = await supabase
    .from('profiles')
    .select('has_pending_rating, pending_rating_transaction_id, display_name')
    .eq('id', user.id)
    .single();

  const [{ data: categories }, { data: locations }] = await Promise.all([
    supabase
      .from('categories')
      .select('id, name_es, slug, parent_id, sort_order')
      .eq('is_active', true)
      .order('sort_order'),
    supabase
      .from('locations')
      .select('id, department, city, slug')
      .eq('is_active', true)
      .order('department')
      .order('city'),
  ]);

  return (
    <div className="max-w-2xl mx-auto px-4 sm:px-6 py-8">
      <h1 className="text-2xl font-bold text-gray-900 mb-2">Publicar anuncio</h1>
      <p className="text-sm text-gray-500 mb-6">Completa los datos para publicar tu anuncio gratis.</p>

      {/* Soft-block warning */}
      {profile?.has_pending_rating && (
        <div className="bg-amber-50 border border-amber-300 rounded-2xl p-5 mb-6">
          <h2 className="font-bold text-amber-800 mb-1">⭐ Tienes una calificación pendiente</h2>
          <p className="text-sm text-amber-700 mb-3">
            Para publicar nuevos anuncios, primero debes calificar tu última transacción. Esto ayuda a mantener la confianza en la plataforma.
          </p>
          {profile.pending_rating_transaction_id && (
            <a
              href={`/dashboard/transacciones/${profile.pending_rating_transaction_id}/calificar`}
              className="inline-flex items-center gap-2 bg-amber-500 text-white text-sm font-semibold px-4 py-2 rounded-full hover:bg-amber-600 transition-colors"
            >
              Calificar ahora →
            </a>
          )}
        </div>
      )}

      <PublicarForm
        userId={user.id}
        categories={categories ?? []}
        locations={locations ?? []}
        blocked={profile?.has_pending_rating ?? false}
      />
    </div>
  );
}

import { redirect } from 'next/navigation';
import { Metadata } from 'next';
import { createClient } from '@/lib/supabase/server';
import Link from 'next/link';
import { Listing, Transaction } from '@/types';
import { formatCOP, timeAgo } from '@/lib/utils';

export const metadata: Metadata = { title: 'Mi cuenta' };

export default async function DashboardPage() {
  let profile = null;
  let listings = null;
  let transactions = null;
  let favorites = null;

  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) redirect('/auth/login?redirectTo=/dashboard');

    const [
      { data: profileData },
      { data: listingsData },
      { data: transactionsData },
      { data: favoritesData },
    ] = await Promise.all([
      supabase.from('profiles').select('*').eq('id', user.id).single(),
      supabase
        .from('listings')
        .select('*, location:locations(*), category:categories(*)')
        .eq('seller_id', user.id)
        .order('created_at', { ascending: false })
        .limit(20),
      supabase
        .from('transactions')
        .select('*, listing:listings(title, slug), buyer:profiles!buyer_id(display_name), seller:profiles!seller_id(display_name)')
        .or(`buyer_id.eq.${user.id},seller_id.eq.${user.id}`)
        .order('created_at', { ascending: false })
        .limit(10),
      supabase
        .from('favorites')
        .select('*, listing:listings(id, title, slug, price, price_type, images, status, location:locations(city, department))')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false })
        .limit(24),
    ]);
    profile = profileData;
    listings = listingsData;
    transactions = transactionsData;
    favorites = favoritesData;
  } catch (err) {
    console.error('[DashboardPage] Supabase error:', err);
    redirect('/auth/login?redirectTo=/dashboard');
  }

  const STATUS_COLORS: Record<string, string> = {
    active: 'bg-brand-blue-50 text-brand-blue',
    draft: 'bg-gray-100 text-gray-600',
    paused: 'bg-yellow-100 text-yellow-700',
    sold: 'bg-blue-100 text-blue-700',
    expired: 'bg-red-100 text-red-600',
    removed: 'bg-red-100 text-red-600',
  };

  const STATUS_LABELS: Record<string, string> = {
    active: 'Activo', draft: 'Borrador', paused: 'Pausado',
    sold: 'Vendido', expired: 'Expirado', removed: 'Eliminado',
  };

  const savedListings = (favorites ?? [])
    .map((f) => f.listing)
    .filter(Boolean) as (Listing & { location?: { city: string; department: string } })[];

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 py-6">
      {/* Welcome */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Mi cuenta</h1>
          <p className="text-sm text-gray-500">Bienvenido, {profile?.display_name ?? 'usuario'}</p>
        </div>
        <div className="flex items-center gap-2">
          <Link
            href="/perfil/editar"
            className="inline-flex items-center gap-1.5 bg-white border border-gray-200 text-gray-600 text-sm font-semibold px-3 py-2 rounded-full hover:border-brand-blue/40 hover:text-brand-blue transition-colors"
          >
            ✏️ Editar perfil
          </Link>
          <Link
            href="/publicar"
            className="inline-flex items-center gap-1.5 bg-brand-blue text-white text-sm font-bold px-4 py-2.5 rounded-full hover:bg-brand-blue-700 transition-colors"
          >
            + Publicar
          </Link>
        </div>
      </div>

      {/* Pending rating alert */}
      {profile?.has_pending_rating && (
        <div className="bg-brand-yellow/10 border border-brand-yellow/40 rounded-2xl p-4 mb-6 flex items-center justify-between gap-4">
          <div>
            <p className="font-semibold text-ink text-sm">⭐ Calificación pendiente</p>
            <p className="text-xs text-brand-yellow-600 mt-0.5">Califica tu última transacción para desbloquear nuevas publicaciones.</p>
          </div>
          {profile.pending_rating_transaction_id && (
            <Link
              href={`/calificar/${profile.pending_rating_transaction_id}`}
              className="flex-shrink-0 bg-brand-yellow text-ink text-xs font-bold px-3 py-2 rounded-full hover:bg-brand-yellow-600 transition-colors"
            >
              Calificar →
            </Link>
          )}
        </div>
      )}

      {/* Stats */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-6">
        {[
          { label: 'Anuncios activos', value: listings?.filter((l: Listing) => l.status === 'active').length ?? 0, icon: '📦' },
          { label: 'Total ventas', value: profile?.total_sales ?? 0, icon: '🤝' },
          { label: 'Calificación', value: profile?.rating_avg ? profile.rating_avg.toFixed(1) : '—', icon: '⭐' },
          { label: 'Guardados', value: favorites?.length ?? 0, icon: '❤️' },
        ].map((stat) => (
          <div key={stat.label} className="bg-white rounded-xl border border-gray-200 p-4">
            <div className="text-2xl mb-1">{stat.icon}</div>
            <p className="text-2xl font-bold text-gray-900">{stat.value}</p>
            <p className="text-xs text-gray-500">{stat.label}</p>
          </div>
        ))}
      </div>

      {/* My listings */}
      <section className="mb-8">
        <h2 className="font-bold text-gray-800 mb-4">Mis anuncios</h2>
        {listings && listings.length > 0 ? (
          <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden">
            <table className="w-full text-sm">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="text-left px-4 py-3 font-semibold text-gray-600">Anuncio</th>
                  <th className="text-left px-4 py-3 font-semibold text-gray-600 hidden sm:table-cell">Precio</th>
                  <th className="text-left px-4 py-3 font-semibold text-gray-600">Estado</th>
                  <th className="text-left px-4 py-3 font-semibold text-gray-600 hidden md:table-cell">Vistas</th>
                  <th className="text-left px-4 py-3 font-semibold text-gray-600 hidden lg:table-cell">Acciones</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {(listings as Listing[]).map((listing) => (
                  <tr key={listing.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3">
                      <Link href={`/listing/${listing.slug}`} className="font-medium text-gray-800 hover:text-brand-blue line-clamp-1">
                        {listing.title}
                      </Link>
                      <p className="text-xs text-gray-400">{timeAgo(listing.created_at)}</p>
                    </td>
                    <td className="px-4 py-3 hidden sm:table-cell text-gray-700">
                      {listing.price ? formatCOP(listing.price) : '—'}
                    </td>
                    <td className="px-4 py-3">
                      <span className={`inline-block text-xs font-semibold px-2.5 py-1 rounded-full ${STATUS_COLORS[listing.status]}`}>
                        {STATUS_LABELS[listing.status]}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-gray-500 hidden md:table-cell">{listing.view_count}</td>
                    <td className="px-4 py-3 hidden lg:table-cell">
                      {listing.status === 'active' && (
                        <Link
                          href={`/listing/${listing.slug}#transaction`}
                          className="text-xs text-blue-600 hover:underline font-medium"
                        >
                          Marcar vendido
                        </Link>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="text-center py-12 bg-white rounded-2xl border border-gray-200">
            <p className="text-gray-400 text-sm mb-4">No tienes anuncios aún.</p>
            <Link href="/publicar" className="inline-flex items-center gap-1.5 bg-brand-blue text-white text-sm font-bold px-5 py-2.5 rounded-full hover:bg-brand-blue-700 transition-colors">
              + Publicar primer anuncio
            </Link>
          </div>
        )}
      </section>

      {/* Saved listings (Guardados) */}
      {savedListings.length > 0 && (
        <section className="mb-8">
          <h2 className="font-bold text-gray-800 mb-4">
            Guardados
            <span className="font-normal text-sm text-gray-500 ml-2">({savedListings.length})</span>
          </h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3">
            {savedListings.map((listing) => (
              <Link
                key={listing.id}
                href={`/listing/${listing.slug}`}
                className="bg-white rounded-xl border border-gray-200 p-3 flex items-start gap-3 hover:border-brand-blue/40 hover:shadow-sm transition-all"
              >
                {listing.images?.[0]?.url ? (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img
                    src={listing.images[0].url}
                    alt={listing.title}
                    className="w-14 h-14 object-cover rounded-lg flex-shrink-0"
                  />
                ) : (
                  <div className="w-14 h-14 bg-gray-100 rounded-lg flex-shrink-0 flex items-center justify-center text-gray-300 text-xl">
                    📦
                  </div>
                )}
                <div className="min-w-0">
                  <p className="text-sm font-medium text-gray-800 line-clamp-2 leading-snug">{listing.title}</p>
                  {listing.price != null && listing.price_type !== 'contact' ? (
                    <p className="text-sm font-bold text-brand-blue mt-0.5">{formatCOP(listing.price)}</p>
                  ) : listing.price_type === 'free' ? (
                    <p className="text-sm font-bold text-brand-blue mt-0.5">Gratis</p>
                  ) : null}
                  {listing.location && (
                    <p className="text-xs text-gray-400 mt-0.5">{listing.location.city}</p>
                  )}
                  {listing.status !== 'active' && (
                    <span className="text-xs text-red-500 font-medium">{STATUS_LABELS[listing.status] ?? listing.status}</span>
                  )}
                </div>
              </Link>
            ))}
          </div>
        </section>
      )}

      {/* Transactions */}
      {transactions && transactions.length > 0 && (
        <section>
          <h2 className="font-bold text-gray-800 mb-4">Transacciones recientes</h2>
          <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden">
            <div className="divide-y divide-gray-100">
              {(transactions as Transaction[]).map((tx) => {
                const isBuyer = tx.buyer_id === user.id;
                const txListing = (tx as unknown as { listing?: { title?: string; slug?: string } }).listing;
                return (
                  <div key={tx.id} className="px-4 py-4 flex items-start justify-between gap-4">
                    <div className="min-w-0">
                      <p className="text-sm font-medium text-gray-800 line-clamp-1">
                        {txListing?.title}
                      </p>
                      <p className="text-xs text-gray-500 mt-0.5">
                        {isBuyer ? 'Compra' : 'Venta'} · {timeAgo(tx.created_at)}
                      </p>
                    </div>
                    <div className="text-right flex-shrink-0">
                      <p className="text-sm font-semibold text-gray-800">
                        {tx.agreed_price ? formatCOP(tx.agreed_price) : '—'}
                      </p>
                      <div className="flex items-center gap-2 justify-end mt-0.5">
                        <span className={`text-xs font-medium ${tx.status === 'completed' ? 'text-brand-blue' : tx.status === 'disputed' ? 'text-red-600' : 'text-gray-500'}`}>
                          {tx.status === 'completed' ? 'Completada' :
                            tx.status === 'initiated' ? 'Iniciada' :
                            tx.status === 'disputed' ? 'Disputada' : tx.status}
                        </span>
                        <Link
                          href={`/calificar/${tx.id}`}
                          className="text-xs text-brand-yellow-600 hover:underline font-medium"
                        >
                          Calificar
                        </Link>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </section>
      )}
    </div>
  );
}

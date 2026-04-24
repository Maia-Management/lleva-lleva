import { redirect } from 'next/navigation';
import { Metadata } from 'next';
import { createClient } from '@/lib/supabase/server';
import Link from 'next/link';
import { Listing, Transaction } from '@/types';
import { formatCOP, timeAgo } from '@/lib/utils';

export const metadata: Metadata = { title: 'Mi cuenta' };

export default async function DashboardPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect('/auth/login?redirectTo=/dashboard');

  const [
    { data: profile },
    { data: listings },
    { data: transactions },
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
  ]);

  const STATUS_COLORS: Record<string, string> = {
    active: 'bg-emerald-100 text-emerald-700',
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

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 py-6">
      {/* Welcome */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Mi cuenta</h1>
          <p className="text-sm text-gray-500">Bienvenido, {profile?.display_name ?? 'usuario'}</p>
        </div>
        <Link
          href="/publicar"
          className="inline-flex items-center gap-1.5 bg-emerald-600 text-white text-sm font-bold px-4 py-2.5 rounded-full hover:bg-emerald-700 transition-colors"
        >
          + Publicar
        </Link>
      </div>

      {/* Pending rating alert */}
      {profile?.has_pending_rating && (
        <div className="bg-amber-50 border border-amber-300 rounded-2xl p-4 mb-6 flex items-center justify-between gap-4">
          <div>
            <p className="font-semibold text-amber-800 text-sm">⭐ Calificación pendiente</p>
            <p className="text-xs text-amber-700 mt-0.5">Califica tu última transacción para desbloquear nuevas publicaciones.</p>
          </div>
          {profile.pending_rating_transaction_id && (
            <Link
              href={`/dashboard/transacciones/${profile.pending_rating_transaction_id}/calificar`}
              className="flex-shrink-0 bg-amber-500 text-white text-xs font-bold px-3 py-2 rounded-full hover:bg-amber-600 transition-colors"
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
          { label: 'Calificaciones', value: profile?.rating_count ?? 0, icon: '📝' },
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
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {(listings as Listing[]).map((listing) => (
                  <tr key={listing.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3">
                      <Link href={`/listing/${listing.slug}`} className="font-medium text-gray-800 hover:text-emerald-700 line-clamp-1">
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
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="text-center py-12 bg-white rounded-2xl border border-gray-200">
            <p className="text-gray-400 text-sm mb-4">No tienes anuncios aún.</p>
            <Link href="/publicar" className="inline-flex items-center gap-1.5 bg-emerald-600 text-white text-sm font-bold px-5 py-2.5 rounded-full hover:bg-emerald-700 transition-colors">
              + Publicar primer anuncio
            </Link>
          </div>
        )}
      </section>

      {/* Transactions */}
      {transactions && transactions.length > 0 && (
        <section>
          <h2 className="font-bold text-gray-800 mb-4">Transacciones recientes</h2>
          <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden">
            <div className="divide-y divide-gray-100">
              {(transactions as Transaction[]).map((tx) => {
                const isBuyer = tx.buyer_id === user.id;
                return (
                  <div key={tx.id} className="px-4 py-4 flex items-start justify-between gap-4">
                    <div className="min-w-0">
                      <p className="text-sm font-medium text-gray-800 line-clamp-1">
                        {(tx as unknown as { listing?: { title?: string } }).listing?.title}
                      </p>
                      <p className="text-xs text-gray-500 mt-0.5">
                        {isBuyer ? 'Compra' : 'Venta'} · {timeAgo(tx.created_at)}
                      </p>
                    </div>
                    <div className="text-right flex-shrink-0">
                      <p className="text-sm font-semibold text-gray-800">
                        {tx.agreed_price ? formatCOP(tx.agreed_price) : '—'}
                      </p>
                      <span className={`text-xs font-medium ${tx.status === 'completed' ? 'text-emerald-600' : tx.status === 'disputed' ? 'text-red-600' : 'text-gray-500'}`}>
                        {tx.status === 'completed' ? 'Completada' :
                          tx.status === 'initiated' ? 'Iniciada' :
                          tx.status === 'disputed' ? 'Disputada' : tx.status}
                      </span>
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

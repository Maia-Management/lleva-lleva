import { redirect, notFound } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import RatingForm from './RatingForm';

interface Props {
  params: Promise<{ id: string }>;
}

export const metadata = { title: 'Calificar transacción' };

export default async function RatingPage({ params }: Props) {
  const { id } = await params;
  const supabase = await createClient();

  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect('/auth/login');

  const { data: transaction } = await supabase
    .from('transactions')
    .select('*, listing:listings(title, slug), buyer:profiles!buyer_id(display_name, username), seller:profiles!seller_id(display_name, username)')
    .eq('id', id)
    .single();

  if (!transaction) notFound();

  const isBuyer = transaction.buyer_id === user.id;
  const isSeller = transaction.seller_id === user.id;

  if (!isBuyer && !isSeller) notFound();

  // Check if already rated
  const { data: existingRating } = await supabase
    .from('ratings')
    .select('id')
    .eq('transaction_id', id)
    .eq('rater_id', user.id)
    .single();

  const rateeId = isBuyer ? transaction.seller_id : transaction.buyer_id;
  const ratee = isBuyer
    ? (transaction as unknown as { seller: { display_name: string } }).seller
    : (transaction as unknown as { buyer: { display_name: string } }).buyer;
  const listing = (transaction as unknown as { listing: { title: string; slug: string } }).listing;

  return (
    <div className="max-w-lg mx-auto px-4 sm:px-6 py-8">
      <h1 className="text-2xl font-bold text-gray-900 mb-2">Calificar transacción</h1>
      <p className="text-sm text-gray-500 mb-6">
        Califica tu experiencia con <strong>{ratee?.display_name}</strong> en la transacción de{' '}
        <strong>{listing?.title}</strong>.
      </p>

      {existingRating ? (
        <div className="bg-brand-blue-50 border border-brand-blue/20 rounded-2xl p-6 text-center">
          <p className="text-brand-blue font-semibold">✓ Ya calificaste esta transacción.</p>
          <p className="text-sm text-brand-blue mt-1">Gracias por ayudar a la comunidad.</p>
        </div>
      ) : (
        <RatingForm
          transactionId={id}
          raterId={user.id}
          rateeId={rateeId}
          listingId={transaction.listing_id}
          isSellerRating={isBuyer}
        />
      )}
    </div>
  );
}

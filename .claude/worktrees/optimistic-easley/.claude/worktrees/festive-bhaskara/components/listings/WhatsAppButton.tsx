'use client';

import { useState } from 'react';
import { buildWhatsAppLink, buildWhatsAppMessage } from '@/lib/utils';
import { useRouter } from 'next/navigation';

interface Props {
  listingId: string;
  listingSlug: string;
  listingTitle: string;
  sellerId: string;
  sellerWhatsapp: string | null;
}

export default function WhatsAppButton({
  listingId,
  listingSlug,
  listingTitle,
  sellerId,
  sellerWhatsapp,
}: Props) {
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  async function handleClick() {
    const { createClient } = await import('@/lib/supabase/client');
    const supabase = createClient();
    setLoading(true);

    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      router.push(`/auth/login?redirectTo=/listing/${listingSlug}`);
      return;
    }

    const message = buildWhatsAppMessage(listingTitle, listingId, listingSlug);
    const waLink = buildWhatsAppLink('573174370575', message);

    // Record contact initiation
    await supabase.from('contact_initiations').insert({
      listing_id: listingId,
      buyer_id: user.id,
      seller_id: sellerId,
      message_template: message,
      wa_link: waLink,
    });

    // Increment message count
    await supabase.rpc('fn_increment_view_count', { listing_id: listingId });

    window.open(waLink, '_blank', 'noopener,noreferrer');
    setLoading(false);
  }

  return (
    <button
      onClick={handleClick}
      disabled={loading}
      className="w-full flex items-center justify-center gap-3 bg-[#25D366] hover:bg-[#1da851] active:bg-[#128c7e] text-white font-bold py-4 px-6 rounded-2xl text-base transition-colors disabled:opacity-70 disabled:cursor-not-allowed shadow-lg shadow-green-200"
    >
      {loading ? (
        <svg className="animate-spin w-5 h-5" fill="none" viewBox="0 0 24 24">
          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z" />
        </svg>
      ) : (
        <svg className="w-6 h-6 fill-current" viewBox="0 0 24 24">
          <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347z" />
          <path d="M12 0C5.373 0 0 5.373 0 12c0 2.125.558 4.122 1.528 5.855L.057 23.57c-.085.351.234.671.587.587l5.815-1.471A11.945 11.945 0 0012 24c6.627 0 12-5.373 12-12S18.627 0 12 0zm0 21.818c-1.939 0-3.748-.537-5.282-1.467l-.378-.225-3.453.874.891-3.355-.245-.389A9.802 9.802 0 012.182 12C2.182 6.573 6.573 2.182 12 2.182S21.818 6.573 21.818 12 17.427 21.818 12 21.818z" />
        </svg>
      )}
      Enviar Mensaje por WhatsApp
    </button>
  );
}

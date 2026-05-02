'use server';

import { createClient } from '@/lib/supabase/server';
import { redirect } from 'next/navigation';

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL ?? 'https://lleva-lleva.com';
const MAIA_BOT_NUMBER = '19034598763';

async function sendWhatsAppMessage(to: string, body: string): Promise<void> {
  const accountSid = process.env.TWILIO_ACCOUNT_SID;
  const authToken = process.env.TWILIO_AUTH_TOKEN;
  const fromRaw = process.env.TWILIO_WHATSAPP_FROM ?? MAIA_BOT_NUMBER;
  const from = fromRaw.startsWith('whatsapp:') ? fromRaw : `whatsapp:+${fromRaw.replace(/\D/g, '')}`;
  const toFormatted = to.startsWith('whatsapp:') ? to : `whatsapp:+${to.replace(/\D/g, '')}`;

  if (!accountSid || !authToken) {
    console.warn('[Twilio] TWILIO_ACCOUNT_SID or TWILIO_AUTH_TOKEN not set — skipping WhatsApp send');
    return;
  }

  try {
    const params = new URLSearchParams({ From: from, To: toFormatted, Body: body });
    const res = await fetch(
      `https://api.twilio.com/2010-04-01/Accounts/${accountSid}/Messages.json`,
      {
        method: 'POST',
        headers: {
          Authorization: `Basic ${Buffer.from(`${accountSid}:${authToken}`).toString('base64')}`,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params.toString(),
      }
    );
    if (!res.ok) {
      const err = await res.text();
      console.error('[Twilio] WhatsApp send failed:', err);
    }
  } catch (err) {
    console.error('[Twilio] Error sending WhatsApp:', err);
  }
}

export async function initiateTransaction(
  listingId: string,
  sellerId: string,
  listingTitle: string,
  agreedPrice?: number
): Promise<{ transactionId: string } | { error: string }> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect('/auth/login');

  // Create transaction — RLS allows buyer (current user) to insert
  const { data: tx, error } = await supabase
    .from('transactions')
    .insert({
      listing_id: listingId,
      buyer_id: user.id,
      seller_id: sellerId,
      agreed_price: agreedPrice ?? null,
      status: 'initiated',
    })
    .select()
    .single();

  if (error) {
    console.error('[Transaction] Insert error:', error);
    return { error: error.message };
  }

  // Fetch buyer + seller phone numbers for WhatsApp notifications
  const { data: profiles } = await supabase
    .from('profiles')
    .select('id, display_name, whatsapp_number')
    .in('id', [user.id, sellerId]);

  const buyer = profiles?.find((p) => p.id === user.id);
  const seller = profiles?.find((p) => p.id === sellerId);

  const ratingUrl = `${SITE_URL}/calificar/${tx.id}`;
  const shortTitle = listingTitle.length > 40 ? listingTitle.slice(0, 40) + '…' : listingTitle;

  // Notify buyer
  if (buyer?.whatsapp_number) {
    const msg =
      `¡Hola ${buyer.display_name}! 👋 Tu compra de "${shortTitle}" ha sido registrada en LlevaLleva.\n\n` +
      `Cuando la transacción se complete, deja tu calificación aquí: ${ratingUrl}\n` +
      `(Pre-cargado con ⭐⭐⭐⭐⭐ y el título del anuncio)`;
    await sendWhatsAppMessage(buyer.whatsapp_number, msg);
  }

  // Notify seller
  if (seller?.whatsapp_number) {
    const msg =
      `¡Hola ${seller.display_name}! 👋 ${buyer?.display_name ?? 'Un comprador'} ha confirmado la compra de "${shortTitle}" en LlevaLleva.\n\n` +
      `Una vez completada la venta, puedes dejar tu calificación aquí: ${ratingUrl}\n` +
      `(Pre-cargado con ⭐⭐⭐⭐⭐)`;
    await sendWhatsAppMessage(seller.whatsapp_number, msg);
  }

  return { transactionId: tx.id };
}

export async function markListingAsSold(
  listingId: string
): Promise<{ success: boolean } | { error: string }> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect('/auth/login');

  const { error } = await supabase
    .from('listings')
    .update({ status: 'sold' })
    .eq('id', listingId)
    .eq('seller_id', user.id);

  if (error) {
    console.error('[MarkAsSold] Error:', error);
    return { error: error.message };
  }

  return { success: true };
}

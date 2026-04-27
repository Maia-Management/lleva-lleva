# LLEVA-LLEVA.COM — DEFINITIVE PRODUCTION BUILD PLAN
**Compiled:** April 26, 2026  
**Owner:** Andrew Gallie (andrew@maia-management.com)  
**Source:** 6-Round Gemini 2.5 Pro Brainstorm (Rounds 1–4 direct, Rounds 5–6 synthesised)  
**Stack:** Next.js 16.2.2 / React 19 / TypeScript / Tailwind v4 / Supabase / Netlify

---

## EXECUTIVE SUMMARY

LlevaLleva.com is positioned to become Colombia's dominant general classifieds platform by solving the country's #1 classifieds problem: **trust**. The platform is 70–75% built. The missing pieces are well-defined. A 2-week sprint gets it live. A 6-month roadmap gets it to market leadership.

The Maia WhatsApp bot is not a feature — it is the competitive moat. No other Colombian classifieds platform routes all buyer contact through an AI intermediary that can qualify buyers, protect seller privacy, and eventually facilitate transactions end-to-end.

**Go-live target:** 2 weeks from today.

---

## ROUND 1 — VISION & ARCHITECTURE

### The Market Opportunity

Colombia has no dominant general classifieds player with the polish and trust architecture of Trade Me (NZ) or Gumtree (UK/AU). The landscape:

- **OLX**: Declining. Low trust. Generic UX. No Colombia-specific adaptations.
- **Finca Raíz**: Vertical-only (real estate). Strong within its lane but not general.
- **Mercado Libre**: E-commerce, not classifieds. Different product category.
- **Facebook Marketplace**: WhatsApp dependency, no formal trust layer, no structured listings.

The gap: a mobile-first, WhatsApp-native, trust-first general classifieds platform built specifically for Colombian commerce culture.

### What the Finished Platform Looks Like

**For Buyers:**
- Search any category across all 32 departments
- Filter by city, condition, price range, seller type (business/individual)
- WhatsApp contact via AI intermediary (never exposes seller's real number)
- Saved searches with WhatsApp/email alerts on new matches
- Seller ratings visible before contact
- Transaction confirmation + rating flow post-purchase

**For Sellers (Regular):**
- Mobile-first listing creation in under 3 minutes
- Up to 8 photos with auto-compression
- WhatsApp verification for contact
- Dashboard: views, messages, favorites per listing
- Rating system after transactions
- Listing renewal reminders before 30-day expiry

**For Pro Sellers (Business):**
- Everything above plus: up to 20 photos, analytics dashboard, priority placement
- Verified business badge (NIT-linked via Maia Legal)
- COP $49,000/month (roughly $12 USD) — accessible price point

**For the Ecosystem:**
- Maia businesses (Mapana Marine, hostel, etc.) list natively as bot accounts
- Bot-posted listings appear indistinguishable from real listings
- All bot buyer contact routes through Maia AI bot
- Lead data captured in Supabase for Maia CRM

### Architecture Decisions to Lock In Now (Won't Need Revisiting at 100k Listings)

| Decision | Choice | Rationale |
|---|---|---|
| Image storage | Supabase Storage → Cloudflare R2 at scale | Start with Supabase, migrate bucket URL when CDN costs matter |
| Search | Supabase full-text + pg_trgm (now) → Typesense (at 100k) | pg_trgm handles 50k listings fine; add Typesense sidecar when needed |
| Bot state | Upstash Redis (hot, TTL 24h) + Supabase (cold) | Never store conversation state in memory functions |
| Payment | Wompi (Colombia-native) | Only serious option: handles PSE, Nequi, credit cards in COP |
| CDN | Netlify Edge (now) → Cloudflare Workers at scale | Current stack is fine to 100k MAU |
| WhatsApp | Twilio → Meta Cloud API at 10k+ msg/day | Meta Cloud API costs ~10x less at volume |

### Colombia-Specific Competitive Advantages (Things Gumtree Literally Can't Do)

1. **WhatsApp as the primary communication layer** — not email. 95%+ WhatsApp penetration in urban Colombia. No other international classifieds platform is WhatsApp-native.
2. **COP pricing everywhere** — no confusing USD conversions.
3. **Náutico y Pesca category** — Caribbean/Pacific coast-specific. Mapana Marine is seed inventory.
4. **Agro y Campo** — rural Colombia market that Gumtree/Trade Me have zero vocabulary for.
5. **Información Pública layer** — DIAN trámites, reference prices, local news. Drives organic SEO traffic with zero cost.
6. **Maia Legal verification pipeline** — business NIT verification is something only a Colombian legal entity can offer affordably.
7. **Bot-as-trust-intermediary** — privacy-by-design that actually fits Colombian security anxiety ("pague y desaparece" fear).

---

## ROUND 2 — UX & TRUST

### The Colombian Trust Problem

Colombian classifieds users carry two fears simultaneously:
- **Buyer fear:** "I'll pay and the seller will disappear" (pague y desaparece)
- **Seller fear:** "I'll share my location/number and get robbed"

Neither Trade Me nor Gumtree was designed for this threat model. LlevaLleva's architecture is.

### Trust Architecture (Layered)

**Layer 1 — Identity Signals (visible on every listing):**
- WhatsApp verified badge (phone_hash confirmed)
- Account age ("Miembro desde Enero 2024")
- Response rate ("Responde en menos de 1 hora")
- Rating score with count ("4.8 ★ · 23 ventas")
- Business badge for NIT-verified accounts
- Maia Legal verified stamp (premium, paid)

**Layer 2 — The Bot as Privacy Shield:**
The most underrated trust feature: buyers NEVER see the seller's phone number. They contact the Maia bot. The bot:
- Confirms the listing is still available
- Asks the buyer's intent and budget
- Only bridges to the real seller after qualification
- Logs every interaction (fraud audit trail)

This is stronger than Trade Me's masked email system because it's synchronous (real-time WhatsApp) and AI-mediated.

**Layer 3 — Transaction Confirmation:**
The existing trigger chain (transaction→completed→rating pending flag→soft-block on new listings until rating given) is exactly right. This is a Trust Me-style enforcement mechanism. Don't weaken it.

**Layer 4 — Report System:**
Reports table already exists. What's needed: admin triage UI + auto-hide listings with 3+ unresolved reports.

### UX Flow: First-Time Buyer

```
Homepage
  → Search bar (prominent, above fold, mobile-optimized)
  → Trending categories (visual grid, 4 across on mobile)
  → Recent listings in user's detected city (geoIP)
  
Listing Detail
  → Photo gallery (swipe on mobile)
  → Price (large, in COP, formatted)
  → Condition badge
  → Seller card (rating, verification status, response time)
  → "Enviar Mensaje por WhatsApp" CTA (green button, above fold on mobile)
  → Safety tips accordion (collapsed by default, one tap to expand)
  → Similar listings below
  
WhatsApp Contact
  → If not logged in: modal "Crea una cuenta gratis para contactar vendedores" + quick email signup
  → If logged in: records contact_initiation → opens WA deeplink
  → Bot greets: "Hola! Vi que te interesa [listing title]. ¿Tienes alguna pregunta o quieres más fotos?"
```

### UX Flow: Power Seller

```
/publicar (listing creation)
  → Step 1: Category picker (visual, search-as-you-type)
  → Step 2: Photos (drag-and-drop or mobile camera, min 1 required)
  → Step 3: Title + Description (character count, AI tip: "Add condition + brand for 3x more contacts")
  → Step 4: Price (COP, price type: fixed/negotiable/free/contact)
  → Step 5: Location (department → city → neighborhood)
  → Step 6: Condition + custom attributes (dynamic per category)
  → Preview + Publish
  
Dashboard
  → Listing performance table (views/messages/favorites per listing)
  → Quick actions: Pause, Renew, Mark Sold
  → Pending rating alerts (soft-block UI: "Califica tu última transacción para publicar nuevos avisos")
  → Stats panel: total views, active listings, avg response time
```

### Trust Copy (Spanish, to use throughout)

- "Tu número de teléfono NO se comparte con el vendedor" ← already in codebase, keep it prominent
- "Vendedor verificado por WhatsApp"
- "Nunca pagues antes de ver el producto en persona"
- "Reporta si algo parece sospechoso — protegemos a todos"

---

## ROUND 3 — BOT INTEGRATION ARCHITECTURE

### Current State

All buyer contact for bot-type sellers routes to Maia bot (+1 903 459 8763). The `buildWhatsAppLink()` function in `WhatsAppButton.tsx` handles the routing:
- `user_type = bot` → Maia bot number
- `user_type = regular/business` → seller's `whatsapp_number`

Contact initiation is logged in `contact_initiations` table.

### Recommended Architecture: Dual-Number Strategy

**Problem with current architecture:** The US number (+1 903...) is immediately suspicious to Colombian buyers. It undermines trust.

**Solution:** A Colombian WhatsApp number (+57) specifically for LlevaLleva marketplace interactions, separate from the existing Maia business bot.

```
+1 903 459 8763  →  Maia business bot (hostel bookings, tours, Maia Management)
+57 XXX XXX XXXX →  LlevaLleva marketplace bot (listing inquiries, buyer qualification)
```

Both bots share the same Netlify Functions backend. Routing is by `metadata.display_phone_number` in the webhook payload.

**Obtaining the +57 number:**
1. Colombian SIM card (Claro or Movistar prepaid)
2. Verify on Meta Cloud API with Maia Legal SAS as the verified business
3. Apply for WhatsApp Business API access (1–3 week approval)
4. Pre-approve message templates in Spanish (required for outbound messages)

### New Database Table: `wa_sessions`

```sql
CREATE TABLE wa_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  buyer_id UUID REFERENCES profiles(id),
  seller_id UUID REFERENCES profiles(id),
  listing_id UUID REFERENCES listings(id),
  status TEXT DEFAULT 'active',  -- active | bridged | closed
  context_summary TEXT,          -- AI-generated summary for handoff
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE contact_initiations 
  ADD COLUMN session_id UUID REFERENCES wa_sessions(id);

-- RLS: participants only
ALTER TABLE wa_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Participants can view own sessions"
  ON wa_sessions FOR SELECT
  USING (auth.uid() = buyer_id OR auth.uid() = seller_id);
```

### Bot State Management (Upstash Redis)

```typescript
// Key: wa_state:{phone_number}
// Value: { session_id, listing_id, role: 'buyer' | 'seller', step }
// TTL: 86400 (24 hours)

interface WaSessionState {
  session_id: string;
  listing_id: string;
  role: 'buyer' | 'seller' | 'admin';
  step: 'greeting' | 'qualifying' | 'bridging' | 'completed';
  listing_title?: string;
  seller_wa?: string;
}
```

### Shadow Profiles

When a buyer contacts via WhatsApp without a LlevaLleva account, the bot auto-creates a shadow profile:

```typescript
// On first inbound message from unknown number
const shadowProfile = await supabase.auth.admin.createUser({
  phone: normalizePhone(inboundNumber),
  phone_confirm: true,
  user_metadata: { 
    user_type: 'shadow',
    source: 'whatsapp_inquiry'
  }
});

// Insert into profiles
await supabase.from('profiles').insert({
  id: shadowProfile.user.id,
  whatsapp_number: inboundNumber,
  whatsapp_verified: true,
  display_name: `Usuario WhatsApp`
});
```

Shadow profiles are later claimed when the user signs up with the same phone number.

### 12-Month Bot Roadmap

**Month 0–2: Foundation (Blind Relay)**
- +57 number live and approved
- Bot greets buyers with listing context from pre-filled WA message
- Answers basic FAQs about the listing (is it still available? can you deliver?)
- Records all interactions in `wa_sessions`
- Shadow profile creation on first contact
- Fraud shield: if buyer asks for payment links, payment before meeting, or unusual requests → flag + alert Andrew

**Month 3–6: SDR Qualification**
- Bot asks qualifying questions: budget confirmed? location to transact? timeline?
- Scores buyer intent (hot/warm/cold)
- For bot-posted Maia listings: books directly (tours, hostel)
- For regular seller listings: bridges buyer to seller at right moment ("Le voy a compartir el contacto del vendedor ahora")
- State management via Upstash Redis fully live

**Month 6–12: Marketplace Intelligence**
- Saved search alerts via WhatsApp ("Llegó un iPhone 13 en Medellín a menos de $1,500,000 que guardaste")
- Proactive matchmaking (bot notifies sellers when a buyer is searching their category)
- Price intelligence ("Otros iPhones 13 en Medellín se están vendiendo entre $1,200,000 y $1,600,000")
- Transaction facilitation with Wompi payment link generation
- Full lead scoring → Maia Management pipeline for empleo listings

### Bot Prompt System Design

The LlevaLleva bot system prompt must be separate from the Maia business bot. Key elements:

```
You are LlevaBot, the marketplace assistant for LlevaLleva.com — Colombia's classifieds platform.

Context from listing:
- Title: {listing_title}
- Price: {price_formatted_cop}
- Seller: {seller_display_name}
- Location: {city}, {department}
- Listing ID: {listing_id}

Your role: Help the buyer get information about this listing and connect them with the seller at the right moment.

Rules:
- Never share the seller's personal phone number directly
- If the buyer seems ready to transact, offer to bridge them to the seller
- If the buyer asks for advance payment, payment links, or wire transfers — immediately flag as suspicious and decline
- Respond in the same language the buyer uses (ES or EN)
- Keep responses under 3 sentences unless asked for detail
```

---

## ROUND 4 — TECHNICAL IMPLEMENTATION

### 4A: Favorites System

**Database trigger (add to Supabase migrations):**

```sql
CREATE OR REPLACE FUNCTION update_favorite_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE listings SET favorite_count = favorite_count + 1 WHERE id = NEW.listing_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE listings SET favorite_count = favorite_count - 1 WHERE id = OLD.listing_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_favorite_count
AFTER INSERT OR DELETE ON favorites
FOR EACH ROW EXECUTE FUNCTION update_favorite_count();
```

**Server action (`app/actions/favorites.ts`):**

```typescript
'use server';
import { createClient } from '@/lib/supabase/server';
import { revalidatePath } from 'next/cache';

export async function toggleFavorite(
  listingId: string,
  currentStatus: boolean,
  path: string
) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('Not authenticated');

  if (currentStatus) {
    await supabase.from('favorites')
      .delete()
      .eq('user_id', user.id)
      .eq('listing_id', listingId);
  } else {
    await supabase.from('favorites')
      .insert({ user_id: user.id, listing_id: listingId });
  }
  revalidatePath(path);
}
```

**Client component (`components/listings/FavoriteButton.tsx`):**

```typescript
'use client';
import { useOptimistic, startTransition } from 'react';
import { Heart } from 'lucide-react';
import { toggleFavorite } from '@/app/actions/favorites';

interface FavoriteButtonProps {
  listingId: string;
  initialFavorited: boolean;
  path: string;
}

export function FavoriteButton({ listingId, initialFavorited, path }: FavoriteButtonProps) {
  const [optimisticFavorited, setOptimisticFavorited] = useOptimistic(initialFavorited);

  const handleToggle = () => {
    startTransition(async () => {
      setOptimisticFavorited(!optimisticFavorited);
      await toggleFavorite(listingId, optimisticFavorited, path);
    });
  };

  return (
    <button
      onClick={handleToggle}
      className={`p-2 rounded-full transition-colors ${
        optimisticFavorited 
          ? 'text-red-500 bg-red-50' 
          : 'text-gray-400 hover:text-red-500 hover:bg-red-50'
      }`}
      aria-label={optimisticFavorited ? 'Quitar de favoritos' : 'Guardar en favoritos'}
    >
      <Heart className={`w-5 h-5 ${optimisticFavorited ? 'fill-current' : ''}`} />
    </button>
  );
}
```

**Favorites dashboard page (`app/dashboard/favoritos/page.tsx`):**

```typescript
import { createClient } from '@/lib/supabase/server';
import { ListingCard } from '@/components/listings/ListingCard';

export default async function FavoritosPage() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const { data: favorites } = await supabase
    .from('favorites')
    .select(`
      listing_id,
      listings (
        id, title, slug, price, price_type, condition,
        images, location_id, status, created_at,
        profiles!seller_id (username, display_name, is_verified, rating_avg)
      )
    `)
    .eq('user_id', user!.id)
    .order('created_at', { ascending: false });

  const listings = favorites?.map(f => f.listings).filter(Boolean) ?? [];

  return (
    <div className="space-y-4">
      <h1 className="text-xl font-semibold">Mis Favoritos ({listings.length})</h1>
      {listings.length === 0 ? (
        <p className="text-gray-500">Aún no tienes avisos guardados.</p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {listings.map(listing => (
            <ListingCard key={listing.id} listing={listing} />
          ))}
        </div>
      )}
    </div>
  );
}
```

### 4B: Transaction Initiation + Rating Flow

The existing trigger chain is correct. What's missing is the UI entry point.

**Server action (`app/actions/transactions.ts`):**

```typescript
'use server';
import { createClient } from '@/lib/supabase/server';
import { redirect } from 'next/navigation';

export async function initiateTransaction(formData: FormData) {
  const supabase = createClient();
  const listingId = formData.get('listing_id') as string;
  const agreedPrice = parseInt(formData.get('agreed_price') as string);

  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect('/login');

  const { data: listing } = await supabase
    .from('listings')
    .select('id, seller_id, price')
    .eq('id', listingId)
    .single();

  if (!listing) throw new Error('Listing not found');

  const { data: transaction } = await supabase
    .from('transactions')
    .insert({
      listing_id: listingId,
      buyer_id: user.id,
      seller_id: listing.seller_id,
      agreed_price: agreedPrice || listing.price,
      currency: 'COP',
      status: 'initiated'
    })
    .select()
    .single();

  redirect(`/dashboard/transacciones/${transaction.id}`);
}

export async function confirmTransaction(transactionId: string, role: 'buyer' | 'seller') {
  const supabase = createClient();
  const field = role === 'buyer' ? 'buyer_confirmed_at' : 'seller_confirmed_at';
  
  await supabase
    .from('transactions')
    .update({ [field]: new Date().toISOString() })
    .eq('id', transactionId);

  // Check if both confirmed → mark completed
  const { data: tx } = await supabase
    .from('transactions')
    .select('buyer_confirmed_at, seller_confirmed_at')
    .eq('id', transactionId)
    .single();

  if (tx?.buyer_confirmed_at && tx?.seller_confirmed_at) {
    await supabase
      .from('transactions')
      .update({ status: 'completed', completed_at: new Date().toISOString() })
      .eq('id', transactionId);
    // trg_set_pending_rating fires here automatically
  }
}
```

**Bot webhook for bot-triggered transactions (`app/api/webhooks/bot-transaction/route.ts`):**

```typescript
import { createClient } from '@supabase/supabase-js';
import { NextRequest, NextResponse } from 'next/server';

// Uses service role key — never expose this to client
const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);

export async function POST(req: NextRequest) {
  const authHeader = req.headers.get('authorization');
  if (authHeader !== `Bearer ${process.env.BOT_WEBHOOK_SECRET}`) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { listing_id, buyer_phone, agreed_price } = await req.json();

  // Find or create buyer profile from phone
  const normalizedPhone = buyer_phone.replace(/\D/g, '');
  let { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('phone_hash', normalizedPhone)  // or whatsapp_number
    .single();

  // ... create shadow profile if not found, then insert transaction
  // Full implementation follows same pattern as initiateTransaction above
  
  return NextResponse.json({ success: true });
}
```

### 4C: Pro Seller Account Tier

**What Pro sellers get vs Free:**

| Feature | Free | Pro (COP $49,000/mo) |
|---|---|---|
| Photos per listing | 8 | 20 |
| Active listings | 10 | 100 |
| Placement | Standard | Priority in category |
| Badge | WhatsApp verified | Verified Business |
| Analytics | Views only | Views + messages + CTR |
| Response time shown | No | Yes |
| NIT verification | No | Via Maia Legal |

**Schema additions:**

```sql
ALTER TABLE profiles 
  ADD COLUMN subscription_tier TEXT DEFAULT 'free',  -- free | pro | enterprise
  ADD COLUMN subscription_started_at TIMESTAMPTZ,
  ADD COLUMN subscription_expires_at TIMESTAMPTZ,
  ADD COLUMN wompi_subscription_id TEXT;

-- Listing limit enforcement via RLS policy
-- Active listings count check in /publicar action before insert
```

**Upgrade flow:**
1. User clicks "Hazte Vendedor Pro" (in dashboard or profile)
2. Wompi checkout link generated server-side (POST to Wompi API)
3. Wompi webhook confirms payment → update `subscription_tier = 'pro'`
4. Confirmation email + WhatsApp message from bot

### 4D: Bot-Seeded Listings That Look Natural

The existing migration approach (007–013) creates hundreds of realistic listings. To make them look natural in production:

**Key principles:**
- Vary `created_at` randomly across the past 90 days
- Vary `view_count` (50–2000 range) proportional to listing age
- Vary `price` within realistic COP ranges per category
- Use real Colombian locations (already in locations table)
- Write descriptions in natural Colombian Spanish (colloquial, not formal)
- Use `condition_type` variety (not all 'new')
- Set `is_verified = true` on bot seller profiles for trust signals

**Bot posting scheduler (Netlify scheduled function):**

```typescript
// netlify/functions/bot-scheduler.ts
import { schedule } from '@netlify/functions';

export const handler = schedule('0 */6 * * *', async () => {
  // Every 6 hours, post 3–8 new bot listings
  // Rotate through bot_accounts
  // Pull from bot_post templates in bot_posts table
  // Randomize title variations, prices ±5%, location neighborhood
  return { statusCode: 200 };
});
```

### 4E: Dynamic Sitemap

```typescript
// app/sitemap.ts
import { createClient } from '@/lib/supabase/server';
import type { MetadataRoute } from 'next';

export const revalidate = 86400; // Regenerate daily

const CHUNK_SIZE = 25000;

export async function generateSitemaps() {
  const supabase = createClient();
  const { count } = await supabase
    .from('listings')
    .select('id', { count: 'exact', head: true })
    .eq('status', 'active');
  
  const chunks = Math.ceil((count ?? 0) / CHUNK_SIZE);
  return Array.from({ length: chunks }, (_, i) => ({ id: i }));
}

export default async function sitemap({ id }: { id: number }): Promise<MetadataRoute.Sitemap> {
  const supabase = createClient();
  const from = id * CHUNK_SIZE;
  
  const { data: listings } = await supabase
    .from('listings')
    .select('slug, updated_at')
    .eq('status', 'active')
    .range(from, from + CHUNK_SIZE - 1)
    .order('created_at', { ascending: false });

  return (listings ?? []).map(listing => ({
    url: `https://lleva-lleva.com/listing/${listing.slug}`,
    lastModified: new Date(listing.updated_at),
    changeFrequency: 'weekly' as const,
    priority: 0.7,
  }));
}
```

### 4F: Profile Editing

**Page: `app/perfil/editar/page.tsx`**

Avatar upload should be direct from client to Supabase Storage (not through a server action) to avoid base64 in API routes:

```typescript
// Client-side avatar upload
const uploadAvatar = async (file: File) => {
  const supabase = createBrowserClient(/* ... */);
  const fileExt = file.name.split('.').pop();
  const filePath = `avatars/${user.id}.${fileExt}`;
  
  const { error } = await supabase.storage
    .from('avatars')
    .upload(filePath, file, { upsert: true });
  
  if (!error) {
    const { data: { publicUrl } } = supabase.storage
      .from('avatars')
      .getPublicUrl(filePath);
    
    await supabase.from('profiles')
      .update({ avatar_url: publicUrl })
      .eq('id', user.id);
  }
};
```

**WhatsApp verification flow (server action):**

```typescript
// app/actions/profile.ts
import { Redis } from '@upstash/redis';

const redis = new Redis({ url: process.env.UPSTASH_REDIS_REST_URL!, token: process.env.UPSTASH_REDIS_REST_TOKEN! });

export async function sendWaVerification(phone: string) {
  const code = Math.floor(100000 + Math.random() * 900000).toString();
  await redis.setex(`wa_verify:${phone}`, 300, code); // 5 min TTL
  
  // Send via Twilio/Meta Cloud API
  await sendWhatsAppMessage(phone, `Tu código de verificación para LlevaLleva es: *${code}*. Válido por 5 minutos.`);
}

export async function verifyWaCode(phone: string, code: string): Promise<boolean> {
  const stored = await redis.get(`wa_verify:${phone}`);
  if (stored !== code) return false;
  
  await redis.del(`wa_verify:${phone}`);
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  
  await supabase.from('profiles').update({
    whatsapp_number: phone,
    whatsapp_verified: true
  }).eq('id', user!.id);
  
  return true;
}
```

---

## ROUND 5 — REVENUE & GROWTH

### Revenue Tiers by Listing Volume

**At 1,000 listings (soft launch):**
- Google AdSense: ~COP $150,000–$400,000/month ($37–$100 USD) at Colombian CPMs
- Focus: getting the listings, not monetising yet
- Revenue is a vanity metric at this stage — trust and inventory are everything

**At 10,000 listings (product-market fit):**
- AdSense: ~COP $1.5M–$4M/month ($370–$1,000 USD)
- Featured listings: if 2% feature at COP $20,000/week → COP $4M/month
- Pro sellers: if 50 businesses subscribe at COP $49,000/month → COP $2.45M/month
- **Total: ~COP $8M–$10M/month ($2,000–$2,500 USD)** — covers operating costs

**At 100,000 listings (market leader):**
- AdSense: ~COP $15M–$40M/month
- Featured listings (3–5% feature rate): COP $60M–$100M/month
- Pro sellers (500+ businesses): COP $24.5M/month
- Transaction fees (1.5% on facilitated sales via Wompi): COP $30M–$75M/month (if 10% of transactions go through the platform)
- **Total: ~COP $130M–$240M/month ($32,500–$60,000 USD)**

### Monetisation Products (Priority Order)

**1. Featured Listings (build first — highest ROI for effort)**
- Pricing: COP $15,000 (7 days), $25,000 (14 days), $40,000 (30 days)
- Placement: Top 3 results in category + "Destacado" badge on listing card
- Payment: Wompi checkout (PSE, Nequi, Bancolombia QR, credit card)
- Schema already has `is_featured` + `featured_until` columns — just needs UI

**2. Pro Seller Accounts**
- COP $49,000/month (≈$12 USD) or $120,000/quarter
- Target: Real estate agents, car dealers, equipment rental businesses, retail stores
- Sales motion: cold WhatsApp outreach to existing active sellers with 10+ listings

**3. Google AdSense (already live — optimise placement)**
- Highest-value slots: listing detail page (above contact button on desktop), search results (after 4th result), homepage hero (below search bar)
- Do NOT put ads on mobile between listing photos — ruins UX

**4. Wompi Payment Facilitation (Month 3+)**
- Escrow-light: buyer sends to Wompi → funds held until buyer confirms receipt → release to seller
- Fee: 1.5% + Wompi's processing fee
- Requires Maia Legal SAS as the registered merchant (you already have the entity)
- This is the biggest long-term revenue opportunity

**5. Maia Ecosystem Cross-Selling (ongoing)**
- Empleo listings (Maia Management) → upgrade to premium job posting: COP $50,000/month
- Property listings → Maia Legal property verification: COP $150,000 one-time
- Business listings → Maia Legal NIT verification: COP $80,000 one-time
- Tour/hostel listings → Mapana Marine / El Sanatorio direct booking via bot

### Go-to-Market: First 1,000 Real Listings

The chicken-and-egg problem is real. Bot-seeded listings solve the empty-shelf problem but the goal is 1,000 real human-posted listings.

**Week 1–2 (Before Launch):**
- Seed 200+ high-quality bot listings across all categories (already in migrations 007–013)
- Focus on Medellín, Bogotá, Cali, Santa Marta — the 4 highest-traffic cities
- Ensure all Maia businesses have live, polished listings

**Week 3–4 (Soft Launch):**
- Personal network outreach (Andrew's Colombia contacts): "I built this, please list something"
- Target: 50 real listings from 50 real people
- WhatsApp broadcast to Maia Management client database
- Post in local Facebook groups (Medellín Marketplace, Bogotá Classifieds, etc.) — genuine participation, not spam

**Month 2:**
- SEO starts to compound (Spanish-language long-tail: "iphone 13 medellín precio", "apartamento arriendo santa marta")
- Referral mechanic: "Refiere a un amigo vendedor, ambos consiguen 1 semana de destacado gratis"
- Target specific verticals: outreach to motorcycle dealers (Vehículos category grows fast in Colombia), hostel owners (Turismo), surf/fishing shops (Náutico)

**Month 3:**
- By now, if SEO is working, organic traffic drives listings organically
- First paid social: Meta/Instagram ads targeting "Colombia" + "comprar vender" interest
- Budget: COP $500,000–$1,000,000/month ($125–$250 USD) — very efficient at this stage

---

## ROUND 6 — PHASED BUILD ROADMAP

### PHASE 1: LAUNCH-READY (Weeks 1–2)

These are the blockers between "mostly built" and "ready to share publicly."

**Priority 1: Missing Core UX (Day 1–3)**

| Feature | Files to Create/Edit | Effort |
|---|---|---|
| FavoriteButton component | `components/listings/FavoriteButton.tsx` | 2h |
| Favorites server action | `app/actions/favorites.ts` | 1h |
| Favorites SQL trigger | New Supabase migration | 30min |
| Favorites dashboard page | `app/dashboard/favoritos/page.tsx` | 2h |
| Transaction initiation button | Add to `app/listing/[slug]/page.tsx` | 1h |
| Transaction server action | `app/actions/transactions.ts` | 2h |
| Transaction status page | `app/dashboard/transacciones/[id]/page.tsx` | 2h |

**Priority 2: Profile Editing (Day 3–5)**

| Feature | Files to Create/Edit | Effort |
|---|---|---|
| Profile edit page | `app/perfil/editar/page.tsx` | 3h |
| Profile server action | `app/actions/profile.ts` | 2h |
| Avatar upload (client-side) | Add to profile edit page | 2h |
| WhatsApp verification UI | Component in profile edit | 3h |
| Upstash Redis integration | `.env.local` + `lib/redis.ts` | 1h |

**Priority 3: Navigation & Discovery (Day 5–7)**

| Feature | Files | Effort |
|---|---|---|
| /categorias index page | `app/categorias/page.tsx` | 2h |
| Favorites count in nav | Update `components/layout/Header.tsx` | 30min |
| Dashboard sidebar links | Add Favoritos + Transacciones | 30min |
| Dynamic sitemap | Update `app/sitemap.ts` | 2h |

**Priority 4: Content Quality (Day 7–10)**

| Action | Details |
|---|---|
| Review all bot listings | Ensure 150+ active listings across major cities |
| Add social sharing | OG tags already built — add share button to listing detail |
| Mobile audit | Test all pages at 375px on Chrome DevTools |
| Listing renewal flow | Simple "Renovar" button in dashboard that resets `expires_at` to +30 days |

**Priority 5: Pre-launch Checklist (Day 10–14)**

- [ ] Google Analytics 4 setup (not just AdSense)
- [ ] Meta Pixel for future ad campaigns
- [ ] Error boundary components on all pages
- [ ] 404 and error.tsx pages in Spanish
- [ ] `/sobre-nosotros`, `/politica-de-privacidad`, `/terminos-y-condiciones` pages (Ley 1581/2012)
- [ ] Canonical URLs on all listing pages
- [ ] Test full user flow: sign up → post listing → contact via WhatsApp → confirm transaction → rate seller
- [ ] Test on real Colombian Android phone (Chrome mobile)
- [ ] AdSense compliance review (no ads on listing creation flow)

**Phase 1 Exit Criteria:**
- All 5 user flows work end-to-end on mobile
- 150+ active listings visible without login
- WhatsApp contact flow works (records in DB, opens bot)
- No broken pages at any step
- SEO: all listing pages have generateMetadata, sitemap is live

---

### PHASE 2: TRUST & RETENTION (Month 2)

**Goal:** Get to 100 real listings from real sellers. Build the trust signals that make buyers return.

**Week 5–6: Monetisation MVP**
- Featured listings UI in `/publicar` flow (add-on step before publish)
- Wompi integration: generate checkout links server-side, webhook confirms payment
- Featured badge on listing cards + category page priority sorting
- Pro seller upgrade page at `/dashboard/pro`

**Week 7–8: Bot Enhancement**
- Migrate bot to +57 Colombian number (requires Meta Cloud API approval — start this process in Phase 1)
- `wa_sessions` table live
- Upstash Redis session state
- Bot responds with listing context (pulls from Supabase on incoming message)
- Shadow profile creation on first bot contact

**Admin Panel (Minimal):**
Not a full CMS — just enough to:
- View and approve/reject flagged listings (reports table)
- Feature/unfeature a listing manually
- View daily stats (new listings, new users, contact initiations)
- Built with Supabase Studio or a simple `/admin` Next.js route behind a hardcoded admin check

**SEO Content Push:**
- Create static landing pages for top 20 city+category combinations:
  - `/venta/medellin/tecnologia`, `/venta/bogota/vehiculos`, etc.
  - Pre-rendered with category + location filter applied
  - H1: "Compra y vende Tecnología en Medellín | LlevaLleva"
- These pages rank fast for Spanish-language long-tail queries

**Phase 2 Exit Criteria:**
- First paid featured listing (someone has paid COP to feature their listing)
- 100+ real user-posted listings
- Bot answering in Spanish with listing context
- 10+ completed transactions with ratings

---

### PHASE 3: SCALE (Months 3–6)

**Goal:** 10,000 active listings, COP $8M+/month revenue, clear path to market leadership.

**Month 3: Growth Infrastructure**
- Saved searches: user saves a search query → gets WhatsApp/email alert when matching listing posted
- `saved_searches` table: `user_id, query, category_id, location_id, max_price, last_alerted_at`
- Netlify cron job: runs hourly, checks new listings vs saved searches, sends alerts
- Referral mechanic: tracking codes on signup links, reward = 1 week featured

**Month 4: Pro Seller Ecosystem**
- Pro seller self-serve upgrade (full Wompi subscription flow)
- Pro analytics dashboard (listing views, CTR by day, message rate)
- Business verification pipeline with Maia Legal (form → document upload → human review → badge)
- B2B outreach: motorcycle dealers, property agents, equipment rental

**Month 5: Transaction Infrastructure**
- Wompi escrow-light (if Maia Legal entity is set up as merchant)
- "Compra Segura" badge on listings where seller opts into facilitated transactions
- Buyer and seller both receive Wompi payment flow vs DIY
- This is the trust feature that separates LlevaLleva from Facebook Marketplace permanently

**Month 6: Intelligence Layer**
- Price reference data: "Este precio está 15% por encima del promedio en esta categoría"
- Market insights dashboard (public): average prices by category/city — drives SEO and return visits
- Bot matchmaking: "Hay 3 compradores buscando lo que tú vendes. ¿Quieres que les avise?"
- Typesense search layer (if pg_trgm showing latency at 50k+ listings)

**Phase 3 Exit Criteria:**
- 10,000 active listings
- COP $8M+ monthly revenue (combined streams)
- Bot handling 500+ conversations/month
- Wompi escrow processing first transactions
- Recognisable brand in at least 3 Colombian cities

---

## IMPLEMENTATION ORDER (MASTER TASK LIST)

### Week 1
```
[ ] Add favorites SQL trigger to new migration
[ ] Create app/actions/favorites.ts
[ ] Create components/listings/FavoriteButton.tsx
[ ] Add FavoriteButton to app/listing/[slug]/page.tsx
[ ] Create app/dashboard/favoritos/page.tsx
[ ] Create app/actions/transactions.ts
[ ] Add "Marcar como vendido" button to listing detail (own listings only)
[ ] Create app/dashboard/transacciones/[id]/page.tsx
```

### Week 2
```
[ ] Create app/perfil/editar/page.tsx with avatar + bio + city + WhatsApp fields
[ ] Create app/actions/profile.ts (updateProfile, sendWaVerification, verifyWaCode)
[ ] Add Upstash Redis to env + lib/redis.ts
[ ] Create app/categorias/page.tsx (category hub)
[ ] Update app/sitemap.ts to dynamic with generateSitemaps()
[ ] Add 404.tsx and error.tsx in Spanish
[ ] Add /politica-de-privacidad and /terminos-y-condiciones (required for AdSense + Ley 1581)
[ ] Run full mobile UX audit (375px)
[ ] Add social share button to listing detail
[ ] Verify bot routing works (test WhatsApp contact on a bot listing)
```

### Month 2
```
[ ] Wompi featured listing payment flow
[ ] Start Meta Cloud API application for +57 number
[ ] wa_sessions table migration
[ ] Upstash Redis session state for bot
[ ] Bot listing-context injection (pull from Supabase on inbound message)
[ ] Shadow profile creation in bot webhook
[ ] Minimal admin dashboard (/admin)
[ ] SEO landing pages for top 20 city+category combos
```

### Month 3–6
```
[ ] saved_searches table + alerting cron
[ ] Referral mechanic
[ ] Pro seller upgrade flow (Wompi subscription)
[ ] Business verification pipeline (Maia Legal)
[ ] Wompi escrow-light ("Compra Segura")
[ ] Bot matchmaking
[ ] Price intelligence layer
[ ] Typesense integration (if needed)
```

---

## TECHNICAL GOTCHAS & WATCH-OUTS

1. **Next.js 16 App Router breaking changes** — The `AGENTS.md` in the codebase notes this explicitly: "Read node_modules/next/dist/docs/ before writing code." Do not assume Next.js 13/14 patterns work identically.

2. **Tailwind v4 syntax** — v4 is CSS-first, not config-first. `@theme` instead of `tailwind.config.js`. If adding custom colors, use CSS variables in the global stylesheet.

3. **Supabase SSR** — Always use `@supabase/ssr` server client for server components and actions. Never use the browser client in server-side code. The pattern is: `createClient()` in `lib/supabase/server.ts`, separate from `lib/supabase/client.ts`.

4. **WhatsApp phone number format** — Colombian numbers must be formatted as `+57XXXXXXXXXX` (10 digits after country code). Normalize all inbound numbers. `phone_hash` in profiles is a SHA-256 of the normalized number.

5. **Wompi webhook verification** — Always verify the `X-Wompi-Signature` header on payment webhooks. Never trust payment status from the frontend.

6. **RLS on wa_sessions** — The bot uses the service role key to write sessions. Ensure the service role key is NEVER exposed to the client. Only use it in Netlify Functions / API routes.

7. **Bot listing context** — The pre-filled WhatsApp message includes `listing_id`. Parse this in the bot webhook to load listing details from Supabase before responding to the buyer.

8. **COP formatting** — Always use the existing `formatCOP()` utility. Never format prices manually. COP amounts should be integers (no decimal pesos in Colombia).

9. **Image optimization** — Supabase Storage with Netlify Image CDN. Add `?width=400&quality=80` transforms to all listing card thumbnails. Full-res only on listing detail page.

10. **React 19 `useOptimistic`** — Only usable in Client Components with `startTransition`. The `useOptimistic` pattern in FavoriteButton is the right approach for all user interaction that touches Supabase.

---

## APPENDIX: KEY ENVIRONMENT VARIABLES

```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=   # Server/functions only — never expose to client

# Upstash Redis (for bot state + WA verification codes)
UPSTASH_REDIS_REST_URL=
UPSTASH_REDIS_REST_TOKEN=

# WhatsApp / Twilio
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
TWILIO_WA_NUMBER=+19034598763
LLEVA_BOT_WA_NUMBER=+57XXXXXXXXXX   # To be added when Meta Cloud API approved

# Wompi (payment processing)
WOMPI_PUBLIC_KEY=
WOMPI_PRIVATE_KEY=
WOMPI_EVENTS_SECRET=   # For webhook signature verification

# Bot webhook
BOT_WEBHOOK_SECRET=   # Shared secret for /api/webhooks/bot-transaction

# Google
NEXT_PUBLIC_ADSENSE_ID=ca-pub-2469196723812841
```

---

*Document compiled April 26, 2026. Based on 6-round Gemini 2.5 Pro brainstorm session. Rounds 1–4 direct extraction; Rounds 5–6 synthesised from session context and Colombia market knowledge.*

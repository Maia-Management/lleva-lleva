import { notFound } from 'next/navigation';
import { Metadata } from 'next';
import { createClient } from '@/lib/supabase/server';
import type { User } from '@supabase/supabase-js';
import { Listing } from '@/types';
import { formatCOP, timeAgo, CONDITION_LABELS, PRICE_TYPE_LABELS } from '@/lib/utils';
import WhatsAppButton from '@/components/listings/WhatsAppButton';
import StarRating from '@/components/ui/StarRating';
import AdBanner from '@/components/ads/AdBanner';
import ListingGallery from '@/components/listings/ListingGallery';
import EditDeleteButtons from './EditDeleteButtons';
import TransactionButtons from './TransactionButtons';
import FavoriteButton from '@/components/listings/FavoriteButton';
import Link from 'next/link';

const AD_SLOT_LISTING_CONTENT = process.env.NEXT_PUBLIC_ADSENSE_SLOT_LISTING_CONTENT ?? '';
const AD_SLOT_LISTING_SIDEBAR = process.env.NEXT_PUBLIC_ADSENSE_SLOT_LISTING_SIDEBAR ?? '';

interface Props {
  params: Promise<{ slug: string }>;
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from('listings')
      .select('title, description, meta_title, meta_description, slug, images')
      .eq('slug', slug)
      .single();

    if (!data) return { title: 'Anuncio no encontrado' };

    const title = data.meta_title ?? data.title;
    const description = data.meta_description ?? data.description?.slice(0, 160);
    const ogImage = (data.images as Array<{ url: string }>)?.[0]?.url ?? 'https://lleva-lleva.com/og-image.png';
    const canonicalUrl = `https://lleva-lleva.com/listing/${data.slug}`;

    return {
      title,
      description,
      alternates: { canonical: canonicalUrl },
      openGraph: {
        title,
        description,
        url: canonicalUrl,
        type: 'website',
        images: [{ url: ogImage, width: 800, height: 600, alt: title }],
      },
      twitter: { card: 'summary_large_image', title, description, images: [ogImage] },
    };
  } catch {
    return { title: 'Anuncio – Lleva Lleva' };
  }
}

export default async function ListingPage({ params }: Props) {
  const { slug } = await params;

  let listing: Listing | null = null;
  let isOwner = false;
  let user: User | null = null;

  try {
    const supabase = await createClient();

    const { data } = await supabase
      .from('listings')
      .select('*, seller:profiles(*), category:categories(*), location:locations(*)')
      .eq('slug', slug)
      .in('status', ['active', 'paused'])
      .single();

    listing = data as Listing | null;

    if (listing) {
      const { data: { user: authUser } } = await supabase.auth.getUser();
      user = authUser;
      isOwner = user?.id === listing.seller_id;
      // Increment view count (fire and forget)
      supabase.rpc('fn_increment_view_count', { listing_id: listing.id });
    }
  } catch (err) {
    console.error('[ListingPage] Supabase error:', err);
  }

  if (!listing) notFound();

  const seller = listing.seller;

  // ── JobPosting schema (Google Jobs) ────────────────────────────────────────
  // Activates for any listing whose category slug contains a job-related keyword.
  // All required JobPosting fields are populated from live listing data so every
  // job listing on the platform becomes independently eligible for Google Jobs.
  const JOB_SLUG_KEYWORDS = ['empleo', 'trabajo', 'oferta', 'vacante', 'job'];
  const categorySlug = (listing.category?.slug ?? '') + (listing.category?.slug_path ?? '');
  const isJobListing = JOB_SLUG_KEYWORDS.some((kw) => categorySlug.toLowerCase().includes(kw));

  const jobPostingSchema = isJobListing
    ? {
        '@context': 'https://schema.org',
        '@type': 'JobPosting',
        title: listing.title,
        description: listing.description,
        datePosted: listing.published_at ?? listing.created_at,
        ...(listing.expires_at ? { validThrough: listing.expires_at } : {}),
        hiringOrganization: {
          '@type': 'Organization',
          name: listing.seller?.business_name ?? listing.seller?.display_name ?? 'Empresa en Lleva Lleva',
          sameAs: `https://lleva-lleva.com/perfil/${listing.seller?.username ?? ''}`,
        },
        jobLocation: listing.is_nationwide
          ? undefined
          : listing.location
          ? {
              '@type': 'Place',
              address: {
                '@type': 'PostalAddress',
                addressLocality: listing.location.city,
                addressRegion: listing.location.department,
                addressCountry: 'CO',
              },
            }
          : undefined,
        ...(listing.is_nationwide
          ? {
              applicantLocationRequirements: { '@type': 'Country', name: 'Colombia' },
              jobLocationType: 'TELECOMMUTE',
            }
          : {}),
        ...(listing.price != null && listing.price_type === 'fixed'
          ? {
              baseSalary: {
                '@type': 'MonetaryAmount',
                currency: listing.currency ?? 'COP',
                value: {
                  '@type': 'QuantitativeValue',
                  value: listing.price,
                  unitText: 'MONTH',
                },
              },
            }
          : {}),
        employmentType: 'OTHER',
        url: `https://lleva-lleva.com/listing/${listing.slug}`,
      }
    : null;
  // ───────────────────────────────────────────────────────────────────────────

  return (
    <div className="max-w-5xl mx-auto px-4 sm:px-6 py-6">
      {/* JobPosting structured data for Google Jobs */}
      {jobPostingSchema && (
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jobPostingSchema) }}
        />
      )}

      {/* Breadcrumb */}
      <nav className="text-xs text-gray-500 mb-4 flex items-center gap-1.5 flex-wrap">
        <Link href="/" className="hover:text-brand-blue">Inicio</Link>
        <span>›</span>
        {listing.category && (
          <>
            <Link href={`/categorias/${listing.category.slug}`} className="hover:text-brand-blue">
              {listing.category.name_es}
            </Link>
            <span>›</span>
          </>
        )}
        <span className="text-gray-700 line-clamp-1">{listing.title}</span>
      </nav>

      {/* Owner actions */}
      {isOwner && (
        <EditDeleteButtons listingId={listing.id} listingSlug={listing.slug} />
      )}

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left: Images + Details */}
        <div className="lg:col-span-2 space-y-4">
          {/* Image gallery */}
          <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden p-3">
            <ListingGallery images={listing.images ?? []} title={listing.title} />
          </div>

          {/* Listing details */}
          <div className="bg-white rounded-2xl border border-gray-200 p-5 space-y-4">
            <div>
              {listing.is_featured && (
                <span className="inline-block bg-brand-red text-white text-xs font-bold px-2 py-0.5 rounded-full mb-2 uppercase tracking-wide">
                  Destacado
                </span>
              )}
              <h1 className="text-xl sm:text-2xl font-bold text-gray-900 leading-snug">
                {listing.title}
              </h1>
              <div className="flex flex-wrap items-center gap-3 mt-2 text-sm text-gray-500">
                {listing.location && (
                  <span>📍 {listing.location.city}, {listing.location.department}</span>
                )}
                {listing.is_nationwide && !listing.location && (
                  <span>🇨🇴 Todo Colombia</span>
                )}
                {listing.published_at && (
                  <span>🕐 {timeAgo(listing.published_at)}</span>
                )}
                <span>👁 {listing.view_count} vistas</span>
              </div>
            </div>

            <div className="border-t border-gray-100 pt-4">
              <h2 className="font-semibold text-gray-700 mb-2">Descripción</h2>
              <p className="text-gray-700 leading-relaxed whitespace-pre-line text-sm">
                {listing.description}
              </p>
            </div>

            {/* Attributes */}
            <div className="border-t border-gray-100 pt-4">
              <h2 className="font-semibold text-gray-700 mb-3">Detalles</h2>
              <div className="grid grid-cols-2 gap-2">
                {listing.condition && (
                  <div className="bg-gray-50 rounded-lg p-3">
                    <p className="text-xs text-gray-500 mb-0.5">Estado</p>
                    <p className="text-sm font-medium">{CONDITION_LABELS[listing.condition]}</p>
                  </div>
                )}
                <div className="bg-gray-50 rounded-lg p-3">
                  <p className="text-xs text-gray-500 mb-0.5">Tipo de precio</p>
                  <p className="text-sm font-medium">{PRICE_TYPE_LABELS[listing.price_type]}</p>
                </div>
                {listing.category && (
                  <div className="bg-gray-50 rounded-lg p-3">
                    <p className="text-xs text-gray-500 mb-0.5">Categoría</p>
                    <p className="text-sm font-medium">{listing.category.name_es}</p>
                  </div>
                )}
                <div className="bg-gray-50 rounded-lg p-3">
                  <p className="text-xs text-gray-500 mb-0.5">Ref.</p>
                  <p className="text-sm font-medium font-mono">LL-{listing.id.slice(0, 8).toUpperCase()}</p>
                </div>
              </div>
            </div>

            {/* Tags */}
            {listing.tags && listing.tags.length > 0 && (
              <div className="border-t border-gray-100 pt-4 flex flex-wrap gap-2">
                {listing.tags.map((tag) => (
                  <span key={tag} className="bg-gray-100 text-gray-600 text-xs px-2.5 py-1 rounded-full">
                    #{tag}
                  </span>
                ))}
              </div>
            )}
          </div>

          {/* Ad banner below listing details */}
          <AdBanner slot={AD_SLOT_LISTING_CONTENT} format="auto" />
        </div>

        {/* Right: Price + Contact */}
        <div className="space-y-4">
          {/* Price card */}
          <div className="bg-white rounded-2xl border border-gray-200 p-5 sticky top-20">
            <div className="mb-4">
              {listing.price_type === 'free' ? (
                <p className="text-3xl font-black text-brand-blue">Gratis</p>
              ) : listing.price_type === 'contact' ? (
                <p className="text-lg font-semibold text-gray-600">Precio a convenir</p>
              ) : listing.price != null ? (
                <>
                  <p className="text-3xl font-black text-gray-900">
                    {formatCOP(listing.price)}
                  </p>
                  {listing.price_type === 'negotiable' && (
                    <p className="text-sm text-gray-500 mt-0.5">Precio negociable</p>
                  )}
                </>
              ) : (
                <p className="text-lg font-semibold text-gray-600">Precio a convenir</p>
              )}
            </div>

            <WhatsAppButton
              listingId={listing.id}
              listingSlug={listing.slug}
              listingTitle={listing.title}
              sellerId={listing.seller_id}
              sellerWhatsapp={seller?.whatsapp_number ?? null}
              sellerUserType={seller?.user_type ?? 'bot'}
            />

            <p className="text-xs text-gray-400 text-center mt-3 mb-3">
              Tu número NO se comparte con el vendedor
            </p>

            <TransactionButtons
              listingId={listing.id}
              listingTitle={listing.title}
              sellerId={listing.seller_id}
              listingPrice={listing.price}
              isOwner={isOwner}
              isAuthenticated={!!user}
              currentStatus={listing.status}
            />

            {/* Favorite button */}
            {!isOwner && (
              <div className="flex justify-center mt-2">
                <div className="flex items-center gap-2 text-sm text-gray-500">
                  <FavoriteButton listingId={listing.id} size="md" />
                  <span>Guardar anuncio</span>
                </div>
              </div>
            )}
          </div>

          {/* Seller card */}
          {seller && (
            <div className="bg-white rounded-2xl border border-gray-200 p-5">
              <h2 className="font-semibold text-gray-700 mb-3 text-sm">Vendedor</h2>
              <Link href={`/perfil/${seller.username}`} className="flex items-center gap-3 hover:opacity-80 transition-opacity">
                <div className="w-12 h-12 rounded-full bg-brand-blue-50 flex items-center justify-center text-brand-blue font-bold text-lg flex-shrink-0">
                  {seller.display_name?.charAt(0).toUpperCase()}
                </div>
                <div>
                  <p className="font-semibold text-gray-800 flex items-center gap-1">
                    {seller.display_name}
                    {seller.is_verified && (
                      <span title="Verificado" className="text-white0">✓</span>
                    )}
                  </p>
                  {seller.business_name && (
                    <p className="text-xs text-gray-500">{seller.business_name}</p>
                  )}
                  {seller.rating_count > 0 && (
                    <div className="mt-1">
                      <StarRating rating={seller.rating_avg} count={seller.rating_count} size="sm" />
                    </div>
                  )}
                  {seller.city && (
                    <p className="text-xs text-gray-400 mt-0.5">📍 {seller.city}</p>
                  )}
                </div>
              </Link>
            </div>
          )}

          {/* Safety tips */}
          <div className="bg-brand-yellow/10 border border-brand-yellow/30 rounded-2xl p-4">
            <h3 className="font-semibold text-ink text-sm mb-2">⚠️ Consejos de seguridad</h3>
            <ul className="text-xs text-brand-yellow-600 space-y-1">
              <li>• Reúnete en lugares públicos y seguros</li>
              <li>• Verifica el artículo antes de pagar</li>
              <li>• Desconfía de precios muy por debajo del mercado</li>
              <li>• No hagas transferencias antes de ver el producto</li>
            </ul>
          </div>

          <AdBanner slot={AD_SLOT_LISTING_SIDEBAR} format="rectangle" />
        </div>
      </div>
    </div>
  );
}

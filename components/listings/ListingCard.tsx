import Link from 'next/link';
import { Listing } from '@/types';
import { formatCOP, timeAgo, CONDITION_LABELS } from '@/lib/utils';
import FavoriteButton from './FavoriteButton';

interface Props {
  listing: Listing;
}

export default function ListingCard({ listing }: Props) {
  const firstImage = listing.images?.[0]?.url ?? null;
  const isPriceVisible = listing.price_type !== 'contact';

  return (
    <Link href={`/listing/${listing.slug}`} className="group block">
      <article className="bg-surface rounded-xl border border-line overflow-hidden hover:border-brand-blue/40 hover:shadow-md transition-all duration-200">
        {/* Image */}
        <div className="relative aspect-[4/3] bg-bg overflow-hidden">
          {firstImage ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img
              src={firstImage}
              alt={listing.title}
              loading="lazy"
              decoding="async"
              width={400}
              height={300}
              className="w-full h-full object-cover"
            />
          ) : (
            <div className="w-full h-full flex items-center justify-center text-line">
              <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1}
                  d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
          )}
          {listing.is_featured && (
            <span className="absolute top-2 left-2 bg-brand-red text-white text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-wide shadow-sm">
              Destacado
            </span>
          )}
          {listing.condition && (
            <span className="absolute bottom-2 right-2 bg-ink/70 backdrop-blur-sm text-white text-[10px] px-2 py-0.5 rounded-full">
              {CONDITION_LABELS[listing.condition]}
            </span>
          )}
          {/* Favorite button overlay — FavoriteButton handles stopPropagation internally */}
          <div className="absolute top-2 right-2">
            <FavoriteButton listingId={listing.id} size="sm" />
          </div>
        </div>

        {/* Content */}
        <div className="p-3">
          <h3 className="text-sm font-semibold text-ink line-clamp-2 leading-snug group-hover:text-brand-blue transition-colors">
            {listing.title}
          </h3>

          <div className="mt-2">
            {isPriceVisible && listing.price != null ? (
              <p className="text-base font-black text-ink">
                <span className="border-b-2 border-brand-yellow pb-0.5">{formatCOP(listing.price)}</span>
                {listing.price_type === 'negotiable' && (
                  <span className="text-xs font-normal text-ink-2 ml-1.5">· Neg.</span>
                )}
              </p>
            ) : listing.price_type === 'free' ? (
              <p className="text-base font-black text-brand-blue">Gratis</p>
            ) : (
              <p className="text-sm text-ink-2 italic">Precio a convenir</p>
            )}
          </div>

          <div className="mt-2 flex items-center justify-between text-xs text-ink-2">
            <span className="truncate">
              {listing.is_nationwide
                ? '🇨🇴 Todo Colombia'
                : listing.location
                ? `${listing.location.city}${listing.location.department ? `, ${listing.location.department}` : ''}`
                : ''}
            </span>
            <span className="flex-shrink-0 ml-2">
              {listing.published_at ? timeAgo(listing.published_at) : ''}
            </span>
          </div>
        </div>
      </article>
    </Link>
  );
}

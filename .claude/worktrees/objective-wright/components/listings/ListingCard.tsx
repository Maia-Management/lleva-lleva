import Link from 'next/link';
import { Listing } from '@/types';
import { formatCOP, timeAgo, CONDITION_LABELS } from '@/lib/utils';

interface Props {
  listing: Listing;
}

export default function ListingCard({ listing }: Props) {
  const firstImage = listing.images?.[0]?.url ?? null;
  const isPriceVisible = listing.price_type !== 'contact';

  return (
    <Link href={`/listing/${listing.slug}`} className="group block">
      <article className="bg-white rounded-xl border border-gray-200 overflow-hidden hover:border-emerald-300 hover:shadow-md transition-all duration-200">
        {/* Image */}
        <div className="relative aspect-[4/3] bg-gray-100 overflow-hidden">
          {firstImage ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img
              src={firstImage}
              alt={listing.title}
              className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
            />
          ) : (
            <div className="w-full h-full flex items-center justify-center text-gray-300">
              <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1}
                  d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
          )}
          {listing.is_featured && (
            <span className="absolute top-2 left-2 bg-amber-400 text-amber-900 text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-wide">
              Destacado
            </span>
          )}
          {listing.condition && (
            <span className="absolute bottom-2 right-2 bg-black/60 text-white text-[10px] px-2 py-0.5 rounded-full">
              {CONDITION_LABELS[listing.condition]}
            </span>
          )}
        </div>

        {/* Content */}
        <div className="p-3">
          <h3 className="text-sm font-semibold text-gray-900 line-clamp-2 leading-snug group-hover:text-emerald-700 transition-colors">
            {listing.title}
          </h3>

          <div className="mt-2">
            {isPriceVisible && listing.price != null ? (
              <p className="text-base font-bold text-emerald-700">
                {formatCOP(listing.price)}
                {listing.price_type === 'negotiable' && (
                  <span className="text-xs font-normal text-gray-500 ml-1">· Neg.</span>
                )}
              </p>
            ) : listing.price_type === 'free' ? (
              <p className="text-base font-bold text-emerald-600">Gratis</p>
            ) : (
              <p className="text-sm text-gray-500 italic">Precio a convenir</p>
            )}
          </div>

          <div className="mt-2 flex items-center justify-between">
            <span className="text-xs text-gray-400">
              {listing.is_nationwide
                ? '🇨🇴 Todo Colombia'
                : listing.location
                ? `${listing.location.city}${listing.location.department ? `, ${listing.location.department}` : ''}`
                : ''}
            </span>
            <span className="text-xs text-gray-400">
              {listing.published_at ? timeAgo(listing.published_at) : ''}
            </span>
          </div>
        </div>
      </article>
    </Link>
  );
}

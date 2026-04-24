import { Listing } from '@/types';
import ListingCard from './ListingCard';
import AdBanner from '@/components/ads/AdBanner';

interface Props {
  listings: Listing[];
  emptyMessage?: string;
  showAds?: boolean;
}

const AD_EVERY = 5;

export default function ListingGrid({ listings, emptyMessage = 'No hay anuncios disponibles.', showAds = false }: Props) {
  if (listings.length === 0) {
    return (
      <div className="text-center py-16 text-gray-400">
        <svg className="w-12 h-12 mx-auto mb-3 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5}
            d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p className="text-sm">{emptyMessage}</p>
      </div>
    );
  }

  const items: React.ReactNode[] = [];
  listings.forEach((listing, i) => {
    items.push(<ListingCard key={listing.id} listing={listing} />);
    if (showAds && (i + 1) % AD_EVERY === 0 && i < listings.length - 1) {
      items.push(
        <div key={`ad-${i}`} className="col-span-2 sm:col-span-3 lg:col-span-4">
          <AdBanner slot="" format="auto" />
        </div>
      );
    }
  });

  return (
    <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3 sm:gap-4">
      {items}
    </div>
  );
}

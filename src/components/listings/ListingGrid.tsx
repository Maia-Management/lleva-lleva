"use client";

import type { Listing } from "@/lib/types";
import { useLocale } from "@/lib/locale-context";
import ListingCard from "./ListingCard";

interface ListingGridProps {
  listings: Listing[];
  emptyMessage?: string;
}

export default function ListingGrid({
  listings,
  emptyMessage,
}: ListingGridProps) {
  const { t } = useLocale();

  if (listings.length === 0) {
    return (
      <div className="text-center py-16">
        <p className="text-navy-600 text-lg">
          {emptyMessage ?? t("listings.empty")}
        </p>
        <p className="text-navy-500 text-sm mt-1">{t("listings.emptyHint")}</p>
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
      {listings.map((listing) => (
        <ListingCard key={listing.id} listing={listing} />
      ))}
    </div>
  );
}

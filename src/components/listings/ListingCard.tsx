"use client";

import Link from "next/link";
import Image from "next/image";
import { MapPin } from "lucide-react";
import {
  formatCityName,
  formatPrice,
  timeAgo,
  getCategoryInfo,
} from "@/lib/constants";
import { useLocale } from "@/lib/locale-context";
import { getCategoryLabel } from "@/lib/i18n";
import Badge from "@/components/ui/Badge";
import type { Listing } from "@/lib/types";

interface ListingCardProps {
  listing: Listing;
}

export default function ListingCard({ listing }: ListingCardProps) {
  const category = getCategoryInfo(listing.category);
  const { t, locale } = useLocale();

  return (
    <Link
      href={`/listings/${listing.id}`}
      className="group block rounded-xl border border-navy-100 bg-white overflow-hidden hover:shadow-lg hover:border-amber-200 transition-all"
    >
      {/* Image */}
      <div className="relative aspect-[4/3] bg-navy-100 overflow-hidden">
        {listing.images.length > 0 ? (
          <Image
            src={listing.images[0]}
            alt={listing.title}
            fill
            className="object-cover group-hover:scale-105 transition-transform duration-300"
            sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 25vw"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center">
            <category.icon className="w-12 h-12 text-navy-300" />
          </div>
        )}
        {listing.is_bumped && (
          <Badge className="absolute top-2 left-2 bg-amber-700 text-white">
            {t("listings.featured")}
          </Badge>
        )}
      </div>

      {/* Content */}
      <div className="p-3">
        <div className="flex items-center gap-2 mb-1">
          <Badge className={category.color}>
            <category.icon className="w-3 h-3" />
            {getCategoryLabel(listing.category, locale)}
          </Badge>
        </div>
        <h3 className="font-semibold text-navy-800 text-sm line-clamp-2 mb-1 group-hover:text-amber-600 transition-colors">
          {listing.title}
        </h3>
        <p className="text-lg font-bold text-amber-600">
          {formatPrice(listing.price)}
        </p>
        <div className="flex items-center gap-1 mt-2 text-xs text-navy-400">
          <MapPin className="w-3 h-3" />
          <span>{formatCityName(listing.city)}</span>
          <span className="mx-1">&middot;</span>
          <span>{timeAgo(listing.created_at)}</span>
        </div>
      </div>
    </Link>
  );
}

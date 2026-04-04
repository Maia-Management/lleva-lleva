"use client";

import Image from "next/image";
import Link from "next/link";
import {
  MapPin,
  Calendar,
  ChevronRight,
  Shield,
  Pencil,
} from "lucide-react";
import { formatPrice, timeAgo, getCategoryInfo } from "@/lib/constants";
import { useLocale } from "@/lib/locale-context";
import { getCategoryLabel } from "@/lib/i18n";
import Badge from "@/components/ui/Badge";
import Button from "@/components/ui/Button";
import WhatsAppButton from "@/components/listings/WhatsAppButton";
import FavoriteButton from "@/components/listings/FavoriteButton";
import ReportButton from "@/components/listings/ReportButton";
import ImageGallery from "@/components/listings/ImageGallery";
import type { Listing } from "@/lib/types";

interface ListingDetailContentProps {
  listing: Listing;
  isOwner: boolean;
}

export default function ListingDetailContent({
  listing,
  isOwner,
}: ListingDetailContentProps) {
  const { t, locale } = useLocale();
  const category = getCategoryInfo(listing.category);

  return (
    <div className="max-w-5xl mx-auto px-4 py-6">
      {/* Breadcrumb */}
      <div className="flex items-center gap-2 text-sm text-navy-400 mb-4">
        <Link
          href="/listings"
          className="hover:text-navy-600 transition-colors"
        >
          {t("detail.listings")}
        </Link>
        <ChevronRight className="w-4 h-4" />
        <Link
          href={`/listings?category=${listing.category}`}
          className="hover:text-navy-600 transition-colors"
        >
          {getCategoryLabel(listing.category, locale)}
        </Link>
        <ChevronRight className="w-4 h-4" />
        <span className="text-navy-600 truncate">{listing.title}</span>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left: Images + Description */}
        <div className="lg:col-span-2 space-y-6">
          <ImageGallery images={listing.images} title={listing.title} />

          <div>
            <h2 className="text-sm font-semibold text-navy-800 mb-2">
              {t("detail.description")}
            </h2>
            <p className="text-sm text-navy-600 whitespace-pre-wrap">
              {listing.description}
            </p>
          </div>
        </div>

        {/* Right: Info + Actions */}
        <div className="space-y-4">
          <div className="bg-white rounded-xl border border-navy-100 p-5 space-y-4">
            <Badge className={category.color}>
              <category.icon className="w-3 h-3" />
              {getCategoryLabel(listing.category, locale)}
            </Badge>

            <h1 className="text-xl font-bold text-navy-800">
              {listing.title}
            </h1>

            <p className="text-2xl font-bold text-amber-600">
              {formatPrice(listing.price)}
            </p>

            <div className="flex items-center gap-4 text-sm text-navy-500">
              <span className="flex items-center gap-1">
                <MapPin className="w-4 h-4" />
                {listing.city}
              </span>
              <span className="flex items-center gap-1">
                <Calendar className="w-4 h-4" />
                {timeAgo(listing.created_at)}
              </span>
            </div>

            {!isOwner && (
              <WhatsAppButton
                phone={listing.whatsapp_number}
                title={listing.title}
              />
            )}

            {isOwner && (
              <div className="flex gap-2">
                <Link href={`/listings/${listing.id}/edit`} className="flex-1">
                  <Button variant="outline" className="w-full">
                    <Pencil className="w-4 h-4" />
                    {t("detail.edit")}
                  </Button>
                </Link>
              </div>
            )}
          </div>

          {/* Seller info */}
          {listing.profiles && (
            <div className="bg-white rounded-xl border border-navy-100 p-5">
              <h3 className="text-sm font-semibold text-navy-800 mb-3">
                {t("detail.seller")}
              </h3>
              <Link
                href={`/profile/${listing.user_id}`}
                className="flex items-center gap-3 hover:bg-navy-50 -mx-2 px-2 py-2 rounded-lg transition-colors"
              >
                <div className="w-10 h-10 rounded-full bg-amber-100 flex items-center justify-center">
                  <span className="text-amber-700 font-semibold text-sm">
                    {(
                      listing.profiles.full_name?.[0] ?? "U"
                    ).toUpperCase()}
                  </span>
                </div>
                <div>
                  <p className="text-sm font-medium text-navy-800">
                    {listing.profiles.full_name ?? t("profile.user")}
                  </p>
                  {listing.profiles.is_verified && (
                    <span className="flex items-center gap-1 text-xs text-emerald-600">
                      <Shield className="w-3 h-3" />
                      {t("detail.verified")}
                    </span>
                  )}
                </div>
              </Link>
            </div>
          )}

          {/* Actions */}
          <div className="flex gap-2">
            <FavoriteButton listingId={listing.id} />
            <ReportButton listingId={listing.id} />
          </div>
        </div>
      </div>
    </div>
  );
}

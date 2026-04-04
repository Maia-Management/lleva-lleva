"use client";

import { Shield, MapPin, Calendar } from "lucide-react";
import { useLocale } from "@/lib/locale-context";
import ListingGrid from "@/components/listings/ListingGrid";
import type { Listing, Profile } from "@/lib/types";

interface PublicProfileContentProps {
  profile: Profile;
  listings: Listing[];
}

export default function PublicProfileContent({
  profile,
  listings,
}: PublicProfileContentProps) {
  const { t, locale } = useLocale();

  return (
    <div className="max-w-5xl mx-auto px-4 py-8">
      {/* Profile header */}
      <div className="bg-white rounded-xl border border-navy-100 p-6 mb-8">
        <div className="flex items-center gap-4">
          <div className="w-16 h-16 rounded-full bg-amber-100 flex items-center justify-center">
            <span className="text-2xl font-bold text-amber-700">
              {(profile.full_name?.[0] ?? "U").toUpperCase()}
            </span>
          </div>
          <div>
            <h1 className="text-xl font-bold text-navy-800">
              {profile.full_name ?? t("profile.user")}
            </h1>
            <div className="flex items-center gap-3 mt-1 text-sm text-navy-500">
              {profile.is_verified && (
                <span className="flex items-center gap-1 text-emerald-600">
                  <Shield className="w-4 h-4" />
                  {t("detail.verified")}
                </span>
              )}
              {profile.city && (
                <span className="flex items-center gap-1">
                  <MapPin className="w-4 h-4" />
                  {profile.city}
                </span>
              )}
              <span className="flex items-center gap-1">
                <Calendar className="w-4 h-4" />
                {t("profile.since")}{" "}
                {new Date(profile.created_at).toLocaleDateString(
                  locale === "en" ? "en-US" : "es-CO",
                  { month: "long", year: "numeric" }
                )}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Listings */}
      <h2 className="text-lg font-semibold text-navy-800 mb-4">
        {t("profile.listingsOf")} {profile.full_name ?? t("profile.user")}
      </h2>
      <ListingGrid listings={listings} />
    </div>
  );
}

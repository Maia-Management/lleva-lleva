import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import ListingGrid from "@/components/listings/ListingGrid";
import TranslatedText from "@/components/ui/TranslatedText";
import { LISTING_SELECT, mapListing } from "@/lib/listing-data";
import type { Listing } from "@/lib/types";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Favoritos",
};

export default async function FavoritesPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/auth/login?redirect=/favorites");

  const { data: favorites } = await supabase
    .from("favorites")
    .select("listing_id")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false });

  const favoriteIds = favorites?.map((favorite) => favorite.listing_id) ?? [];
  const { data: listingRows } = favoriteIds.length
    ? await supabase
        .from("listings")
        .select(LISTING_SELECT)
        .in("id", favoriteIds)
        .eq("status", "active")
    : { data: [] };

  const listingById = new Map(
    (listingRows ?? []).map((row) => {
      const listing = mapListing(row);
      return [listing.id, listing];
    }),
  );
  const listings = favoriteIds
    .map((id) => listingById.get(id))
    .filter((listing): listing is Listing => !!listing);

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <TranslatedText
        tKey="favorites.title"
        as="h1"
        className="text-2xl font-bold text-navy-800 mb-6"
      />
      <ListingGrid listings={listings} />
    </div>
  );
}

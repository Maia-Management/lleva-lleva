import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import ListingGrid from "@/components/listings/ListingGrid";
import TranslatedText from "@/components/ui/TranslatedText";
import type { Listing } from "@/lib/types";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Favoritos — Lleva Lleva",
};

export default async function FavoritesPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/auth/login?redirect=/favorites");

  const { data: favorites } = await supabase
    .from("favorites")
    .select("listing_id, listings(*, profiles(*))")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false });

  const listings =
    favorites?.flatMap((f) => f.listings ?? []) as Listing[] ?? [];

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

import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import ListingGrid from "@/components/listings/ListingGrid";
import ProfileEditor from "@/components/profile/ProfileEditor";
import TranslatedText from "@/components/ui/TranslatedText";
import { LISTING_SELECT, mapListing } from "@/lib/listing-data";
import type { Listing, Profile } from "@/lib/types";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Mi Perfil",
};

export default async function MyProfilePage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/auth/login?redirect=/profile");

  const { data: profile } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .single();

  const { data: listings } = await supabase
    .from("listings")
    .select(LISTING_SELECT)
    .eq("seller_id", user.id)
    .order("created_at", { ascending: false });

  return (
    <div className="max-w-5xl mx-auto px-4 py-8">
      <TranslatedText tKey="profile.myProfile" as="h1" className="text-2xl font-bold text-navy-800 mb-6" />

      {/* Profile editor */}
      <ProfileEditor profile={profile as Profile} />

      {/* My listings */}
      <div className="mt-10">
        <div className="flex items-center justify-between mb-4">
          <TranslatedText tKey="profile.myListings" as="h2" className="text-lg font-semibold text-navy-800" />
          <Link
            href="/listings/new"
            className="text-sm font-medium text-amber-600 hover:text-amber-700"
          >
            <TranslatedText tKey="profile.newListing" />
          </Link>
        </div>
        <ListingGrid
          listings={((listings ?? []).map(mapListing) as Listing[]) ?? []}
          emptyMessage={undefined}
        />
      </div>
    </div>
  );
}

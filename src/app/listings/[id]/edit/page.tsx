import { notFound, redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { LISTING_SELECT, mapListing } from "@/lib/listing-data";
import ListingForm from "@/components/listings/ListingForm";
import TranslatedText from "@/components/ui/TranslatedText";
import type { CategoryOption, LocationOption } from "@/lib/types";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Editar anuncio",
};

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export default async function EditListingPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/auth/login?redirect=/listings/" + id + "/edit");

  const listingPromise = UUID_PATTERN.test(id)
    ? supabase.from("listings").select(LISTING_SELECT).eq("id", id).single()
    : supabase.from("listings").select(LISTING_SELECT).eq("slug", id).single();
  const [listingResult, categoriesResult, locationsResult] = await Promise.all([
    listingPromise,
    supabase
      .from("categories")
      .select("id, parent_id, name_es, name_en, slug, slug_path, sort_order")
      .eq("is_active", true)
      .order("slug_path", { ascending: true }),
    supabase
      .from("locations")
      .select("id, department, city, slug, is_nationwide")
      .eq("is_active", true)
      .order("is_nationwide", { ascending: false })
      .order("city", { ascending: true }),
  ]);
  const listing = listingResult.data ? mapListing(listingResult.data) : null;

  if (!listing) notFound();
  if (listing.seller_id !== user.id) redirect(`/listings/${listing.slug ?? id}`);

  const categories = (categoriesResult.data ?? []) as CategoryOption[];
  const locations = (locationsResult.data ?? []) as LocationOption[];

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <TranslatedText
        tKey="form.editTitle"
        as="h1"
        className="text-2xl font-bold text-navy-800 mb-6"
      />
      <ListingForm
        listing={listing}
        userId={user.id}
        categories={categories}
        locations={locations}
      />
    </div>
  );
}

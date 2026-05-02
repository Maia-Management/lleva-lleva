import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import ListingDetailContent from "@/components/listings/ListingDetailContent";
import {
  LISTING_SELECT,
  mapListing,
  normalizeListingImages,
} from "@/lib/listing-data";
import type { Listing } from "@/lib/types";
import type { Metadata } from "next";

const uuidPattern =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

function applyListingIdentifierFilter<T extends { eq: (column: string, value: string) => T }>(
  query: T,
  id: string,
) {
  return uuidPattern.test(id) ? query.eq("id", id) : query.eq("slug", id);
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const { id } = await params;
  const supabase = await createClient();
  const query = supabase
    .from("listings")
    .select("title, slug, description, images");
  const { data: listing } = await applyListingIdentifierFilter(query, id).single();

  if (!listing) return { title: "Lleva Lleva" };
  const images = normalizeListingImages(listing.images);

  return {
    title: listing.title,
    description: listing.description.slice(0, 160),
    openGraph: {
      title: listing.title,
      description: listing.description.slice(0, 160),
      url: `/listings/${listing.slug ?? id}`,
      images: images[0] ? [images[0]] : [],
    },
    alternates: {
      canonical: `/listings/${listing.slug ?? id}`,
    },
  };
}

export default async function ListingDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const supabase = await createClient();

  const query = supabase
    .from("listings")
    .select(LISTING_SELECT);
  const { data: listing } = await applyListingIdentifierFilter(query, id).single();

  if (!listing) notFound();

  const typedListing = mapListing(listing) as Listing;

  const {
    data: { user },
  } = await supabase.auth.getUser();
  const isOwner = user?.id === typedListing.user_id;

  return (
    <ListingDetailContent listing={typedListing} isOwner={isOwner} />
  );
}

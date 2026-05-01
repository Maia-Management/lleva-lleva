import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import ListingDetailContent from "@/components/listings/ListingDetailContent";
import type { Listing } from "@/lib/types";
import type { Metadata } from "next";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const { id } = await params;
  const supabase = await createClient();
  const { data: listing } = await supabase
    .from("listings")
    .select("title, description, images, city")
    .eq("id", id)
    .single();

  if (!listing) return { title: "Lleva Lleva" };

  return {
    title: listing.title,
    description: listing.description.slice(0, 160),
    openGraph: {
      title: listing.title,
      description: listing.description.slice(0, 160),
      images: listing.images?.[0] ? [listing.images[0]] : [],
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

  const { data: listing } = await supabase
    .from("listings")
    .select("*, profiles(*)")
    .eq("id", id)
    .single();

  if (!listing) notFound();

  const typedListing = listing as Listing;

  const {
    data: { user },
  } = await supabase.auth.getUser();
  const isOwner = user?.id === typedListing.user_id;

  return (
    <ListingDetailContent listing={typedListing} isOwner={isOwner} />
  );
}

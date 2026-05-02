import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import PublicProfileContent from "@/components/profile/PublicProfileContent";
import { LISTING_SELECT, mapListing } from "@/lib/listing-data";
import type { Listing, Profile } from "@/lib/types";
import type { Metadata } from "next";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const { id } = await params;
  const supabase = await createClient();
  const { data: profile } = await supabase
    .from("profiles")
    .select("display_name, username")
    .eq("id", id)
    .single();

  return {
    title: profile?.display_name ?? profile?.username ?? "Usuario",
  };
}

export default async function PublicProfilePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const supabase = await createClient();

  const { data: profile } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", id)
    .single();

  if (!profile) notFound();

  const { data: listings } = await supabase
    .from("listings")
    .select(LISTING_SELECT)
    .eq("seller_id", id)
    .eq("status", "active")
    .order("created_at", { ascending: false });

  return (
    <PublicProfileContent
      profile={profile as Profile}
      listings={((listings ?? []).map(mapListing) as Listing[]) ?? []}
    />
  );
}

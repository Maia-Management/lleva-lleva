import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import PublicProfileContent from "@/components/profile/PublicProfileContent";
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
    .select("full_name")
    .eq("id", id)
    .single();

  return {
    title: profile?.full_name ?? "Usuario",
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
    .select("*")
    .eq("user_id", id)
    .eq("status", "active")
    .order("created_at", { ascending: false });

  return (
    <PublicProfileContent
      profile={profile as Profile}
      listings={(listings as Listing[]) ?? []}
    />
  );
}

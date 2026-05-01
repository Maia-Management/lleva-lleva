import { notFound, redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import ListingForm from "@/components/listings/ListingForm";
import TranslatedText from "@/components/ui/TranslatedText";
import type { Listing } from "@/lib/types";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Editar anuncio",
};

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

  const { data: listing } = await supabase
    .from("listings")
    .select("*")
    .eq("id", id)
    .single();

  if (!listing) notFound();
  if (listing.user_id !== user.id) redirect(`/listings/${id}`);

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <TranslatedText
        tKey="form.editTitle"
        as="h1"
        className="text-2xl font-bold text-navy-800 mb-6"
      />
      <ListingForm listing={listing as Listing} userId={user.id} />
    </div>
  );
}

import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import ListingForm from "@/components/listings/ListingForm";
import TranslatedText from "@/components/ui/TranslatedText";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Publicar anuncio — Lleva Lleva",
};

export default async function NewListingPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/auth/login?redirect=/listings/new");

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <TranslatedText
        tKey="form.createTitle"
        as="h1"
        className="text-2xl font-bold text-navy-800 mb-6"
      />
      <ListingForm userId={user.id} />
    </div>
  );
}

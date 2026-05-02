import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import ListingForm from "@/components/listings/ListingForm";
import TranslatedText from "@/components/ui/TranslatedText";
import type { CategoryOption, LocationOption } from "@/lib/types";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Publicar anuncio",
};

export default async function NewListingPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/auth/login?redirect=/listings/new");

  const [categoriesResult, locationsResult] = await Promise.all([
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
  const categories = (categoriesResult.data ?? []) as CategoryOption[];
  const locations = (locationsResult.data ?? []) as LocationOption[];

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <TranslatedText
        tKey="form.createTitle"
        as="h1"
        className="text-2xl font-bold text-navy-800 mb-6"
      />
      <ListingForm
        userId={user.id}
        categories={categories}
        locations={locations}
      />
    </div>
  );
}

import { Suspense } from "react";
import { createClient } from "@/lib/supabase/server";
import ListingGrid from "@/components/listings/ListingGrid";
import SearchBar from "@/components/listings/SearchBar";
import CategoryFilter from "@/components/listings/CategoryFilter";
import CityFilter from "@/components/listings/CityFilter";
import TranslatedText from "@/components/ui/TranslatedText";
import type { Listing } from "@/lib/types";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Explorar anuncios — Lleva Lleva",
  description: "Encuentra lo que buscas en tu ciudad. Clasificados gratuitos.",
};

async function ListingsContent({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}) {
  const params = await searchParams;
  const category = typeof params.category === "string" ? params.category : "";
  const city = typeof params.city === "string" ? params.city : "";
  const query = typeof params.q === "string" ? params.q : "";

  const supabase = await createClient();

  let dbQuery = supabase
    .from("listings")
    .select("*, profiles(*)")
    .eq("status", "active")
    .order("is_bumped", { ascending: false })
    .order("created_at", { ascending: false })
    .limit(40);

  if (category) dbQuery = dbQuery.eq("category", category);
  if (city) dbQuery = dbQuery.eq("city", city);
  if (query) dbQuery = dbQuery.textSearch("fts", query, { type: "websearch" });

  const { data: listings } = await dbQuery;

  return <ListingGrid listings={(listings as Listing[]) ?? []} />;
}

export default function ListingsPage({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}) {
  return (
    <div className="max-w-7xl mx-auto px-4 py-6">
      <TranslatedText
        tKey="listings.title"
        as="h1"
        className="text-2xl font-bold text-navy-800 mb-6"
      />

      {/* Filters */}
      <Suspense>
        <div className="space-y-4 mb-6">
          <div className="flex flex-col sm:flex-row gap-3">
            <div className="flex-1">
              <SearchBar />
            </div>
            <CityFilter />
          </div>
          <CategoryFilter />
        </div>
      </Suspense>

      {/* Results */}
      <Suspense
        fallback={
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
            {Array.from({ length: 8 }).map((_, i) => (
              <div
                key={i}
                className="rounded-xl border border-navy-100 overflow-hidden animate-pulse"
              >
                <div className="aspect-[4/3] bg-navy-100" />
                <div className="p-3 space-y-2">
                  <div className="h-4 bg-navy-100 rounded w-1/3" />
                  <div className="h-4 bg-navy-100 rounded w-2/3" />
                  <div className="h-5 bg-navy-100 rounded w-1/4" />
                </div>
              </div>
            ))}
          </div>
        }
      >
        <ListingsContent searchParams={searchParams} />
      </Suspense>
    </div>
  );
}

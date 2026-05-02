import { Suspense } from "react";
import { createClient } from "@/lib/supabase/server";
import ListingGrid from "@/components/listings/ListingGrid";
import SearchBar from "@/components/listings/SearchBar";
import CategoryFilter from "@/components/listings/CategoryFilter";
import CityFilter from "@/components/listings/CityFilter";
import TranslatedText from "@/components/ui/TranslatedText";
import {
  filterListings,
  LISTING_SELECT,
  mapListing,
} from "@/lib/listing-data";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Explorar anuncios",
  description:
    "Explora clasificados gratuitos en Colombia por ciudad, categoría y búsqueda. Encuentra productos, servicios, vivienda, empleo y oportunidades locales.",
  alternates: {
    canonical: "/listings",
  },
  openGraph: {
    title: "Explorar anuncios — Lleva Lleva",
    description:
      "Busca clasificados gratuitos en Colombia por ciudad, categoría y palabra clave.",
    url: "/listings",
    images: [
      {
        url: "/og-image.svg",
        width: 1200,
        height: 630,
        alt: "Lleva Lleva clasificados gratis en Colombia",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "Explorar anuncios — Lleva Lleva",
    description:
      "Busca clasificados gratuitos en Colombia por ciudad, categoría y palabra clave.",
    images: ["/og-image.svg"],
  },
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

  const { data } = await supabase
    .from("listings")
    .select(LISTING_SELECT)
    .eq("status", "active")
    .order("created_at", { ascending: false })
    .limit(200);

  const listings = filterListings((data ?? []).map(mapListing), {
    category,
    city,
    query,
  }).slice(0, 24);

  return <ListingGrid listings={listings} />;
}

export default async function ListingsPage({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}) {
  const results = await ListingsContent({ searchParams });

  return (
    <div className="max-w-7xl mx-auto px-4 py-6">
      <TranslatedText
        tKey="listings.title"
        as="h1"
        className="text-2xl font-bold text-navy-800 mb-6"
      />
      <div className="max-w-3xl space-y-3 text-sm leading-6 text-navy-600 mb-6">
        <p>
          Explora anuncios activos de vendedores locales en Colombia. Puedes
          filtrar por ciudad, categoría o palabra clave para encontrar
          productos, servicios, vivienda, empleo, vehículos, eventos y
          oportunidades de comunidad cerca de ti.
        </p>
        <p>
          Cada anuncio está pensado para contacto directo y negociación clara.
          Revisa fotos, precio, descripción y ubicación antes de escribir por
          WhatsApp, y usa los consejos de seguridad si vas a reunirte en
          persona.
        </p>
      </div>

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
      {results}
    </div>
  );
}

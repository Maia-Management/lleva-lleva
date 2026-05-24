import { MetadataRoute } from 'next';
import { createClient } from '@/lib/supabase/server';
import { fallbackRecentListings } from '@/lib/fallback-listings';

const BASE_URL = 'https://lleva-lleva.com';

// Top-level category slugs (matches supabase/migrations/002_categories_seed.sql).
// Hardcoded so the sitemap always lists them, even when the DB is unreachable
// at build time.
const TOP_LEVEL_CATEGORY_SLUGS = [
  'vehiculos',
  'inmuebles',
  'tecnologia',
  'hogar-y-jardin',
  'servicios',
  'empleo',
  'nautico-y-pesca',
  'moda-y-belleza',
  'turismo-y-hospedaje',
  'educacion-y-formacion',
  'mascotas-y-animales',
  'deportes-y-fitness',
  'negocios-e-industria',
  'agro-y-campo',
  'comunidad',
  'informacion-publica',
];

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  // Static routes
  const staticRoutes: MetadataRoute.Sitemap = [
    { url: BASE_URL, lastModified: new Date(), changeFrequency: 'weekly', priority: 1.0 },
    { url: `${BASE_URL}/publicar`, lastModified: new Date(), changeFrequency: 'weekly', priority: 0.9 },
    { url: `${BASE_URL}/buscar`, lastModified: new Date(), changeFrequency: 'weekly', priority: 0.9 },
    { url: `${BASE_URL}/cuanto-vale`, lastModified: new Date(), changeFrequency: 'weekly', priority: 0.9 },
    { url: `${BASE_URL}/categorias`, lastModified: new Date(), changeFrequency: 'weekly', priority: 0.9 },
    { url: `${BASE_URL}/como-funciona`, lastModified: new Date(), changeFrequency: 'monthly', priority: 0.8 },
    { url: `${BASE_URL}/ayuda`, lastModified: new Date(), changeFrequency: 'monthly', priority: 0.7 },
    { url: `${BASE_URL}/sobre-nosotros`, lastModified: new Date(), changeFrequency: 'monthly', priority: 0.7 },
    { url: `${BASE_URL}/contacto`, lastModified: new Date(), changeFrequency: 'monthly', priority: 0.7 },
    { url: `${BASE_URL}/seguridad`, lastModified: new Date(), changeFrequency: 'monthly', priority: 0.6 },
    { url: `${BASE_URL}/reportar`, lastModified: new Date(), changeFrequency: 'monthly', priority: 0.5 },
    { url: `${BASE_URL}/terminos`, lastModified: new Date(), changeFrequency: 'yearly', priority: 0.3 },
    { url: `${BASE_URL}/privacidad`, lastModified: new Date(), changeFrequency: 'yearly', priority: 0.3 },
  ];

  const hardcodedCategoryRoutes: MetadataRoute.Sitemap = TOP_LEVEL_CATEGORY_SLUGS.map((slug) => ({
    url: `${BASE_URL}/categorias/${slug}`,
    lastModified: new Date(),
    changeFrequency: 'weekly' as const,
    priority: 0.8,
  }));

  const fallbackListingRoutes: MetadataRoute.Sitemap = fallbackRecentListings.map((listing) => ({
    url: `${BASE_URL}/listing/${listing.slug}`,
    lastModified: new Date(listing.updated_at),
    changeFrequency: 'weekly' as const,
    priority: 0.6,
  }));

  try {
    const supabase = await createClient();

    // Fetch all category slugs (top-level + sub-categories)
    const { data: categories } = await supabase
      .from('categories')
      .select('slug, updated_at')
      .eq('is_active', true);

    const dbCategoryRoutes: MetadataRoute.Sitemap = (categories ?? []).map((cat) => ({
      url: `${BASE_URL}/categorias/${cat.slug}`,
      lastModified: new Date(),
      changeFrequency: 'weekly' as const,
      priority: 0.8,
    }));

    // Fetch active listing slugs (capped at 5000 for performance)
    const { data: listings } = await supabase
      .from('listings')
      .select('slug, updated_at')
      .eq('status', 'active')
      .order('updated_at', { ascending: false })
      .limit(5000);

    const dbListingRoutes: MetadataRoute.Sitemap = (listings ?? []).map((l) => ({
      url: `${BASE_URL}/listing/${l.slug}`,
      lastModified: l.updated_at ? new Date(l.updated_at) : new Date(),
      changeFrequency: 'daily' as const,
      priority: 0.6,
    }));

    // Merge hardcoded + DB-fetched category routes, dedup by URL
    const seen = new Set<string>();
    const mergedCategoryRoutes = [...hardcodedCategoryRoutes, ...dbCategoryRoutes].filter((r) => {
      if (seen.has(r.url)) return false;
      seen.add(r.url);
      return true;
    });

    const listingSeen = new Set<string>();
    const listingRoutes = [...dbListingRoutes, ...fallbackListingRoutes].filter((r) => {
      if (listingSeen.has(r.url)) return false;
      listingSeen.add(r.url);
      return true;
    });

    return [...staticRoutes, ...mergedCategoryRoutes, ...listingRoutes];
  } catch {
    // If DB is unreachable (e.g. during static build), return static + hardcoded category routes
    return [...staticRoutes, ...hardcodedCategoryRoutes, ...fallbackListingRoutes];
  }
}

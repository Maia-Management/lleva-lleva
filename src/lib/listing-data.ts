import { getCategoryInfo } from "@/lib/constants";
import type { Category, Listing, PriceType, Profile } from "@/lib/types";

export const LISTING_SELECT = `
  id,
  seller_id,
  category_id,
  location_id,
  is_nationwide,
  title,
  slug,
  description,
  price,
  price_type,
  currency,
  condition,
  images,
  attributes,
  tags,
  status,
  view_count,
  message_count,
  favorite_count,
  published_at,
  created_at,
  updated_at,
  category_ref:categories!listings_category_id_fkey (
    slug,
    name_es,
    name_en,
    slug_path
  ),
  location_ref:locations!listings_location_id_fkey (
    city,
    department,
    slug,
    is_nationwide
  ),
  profiles:profiles!listings_seller_id_fkey (
    id,
    username,
    display_name,
    avatar_url,
    user_type,
    bio,
    is_verified,
    city,
    department,
    whatsapp_number,
    rating_avg,
    rating_count,
    created_at,
    updated_at
  )
`;

type ImageRecord = {
  url?: string;
  alt?: string;
  order?: number;
};

type CategoryRef = {
  slug?: string | null;
  name_es?: string | null;
  name_en?: string | null;
  slug_path?: string | null;
} | null;

type LocationRef = {
  city?: string | null;
  department?: string | null;
  slug?: string | null;
  is_nationwide?: boolean | null;
} | null;

type ProfileRef = {
  id: string;
  username?: string | null;
  display_name?: string | null;
  avatar_url?: string | null;
  user_type?: Profile["user_type"] | null;
  bio?: string | null;
  is_verified?: boolean | null;
  city?: string | null;
  department?: string | null;
  whatsapp_number?: string | null;
  rating_avg?: number | string | null;
  rating_count?: number | null;
  created_at?: string | null;
  updated_at?: string | null;
} | null;

type ListingRow = {
  id: string;
  seller_id: string;
  category_id?: string | null;
  location_id?: string | null;
  is_nationwide?: boolean | null;
  title: string;
  slug?: string | null;
  description: string;
  price?: number | string | null;
  price_type?: PriceType | null;
  currency?: string | null;
  images?: unknown;
  status?: Listing["status"] | null;
  published_at?: string | null;
  created_at: string;
  updated_at?: string | null;
  category_ref?: CategoryRef | CategoryRef[];
  location_ref?: LocationRef | LocationRef[];
  profiles?: ProfileRef | ProfileRef[];
};

function first<T>(value: T | T[] | null | undefined): T | null {
  if (Array.isArray(value)) return value[0] ?? null;
  return value ?? null;
}

function toNumber(value: number | string | null | undefined): number {
  if (typeof value === "number") return value;
  if (typeof value === "string") return Number(value) || 0;
  return 0;
}

function parseImageValue(value: unknown): Array<ImageRecord | string> {
  if (!value) return [];
  if (Array.isArray(value)) return value as Array<ImageRecord | string>;
  if (typeof value === "string") {
    try {
      const parsed = JSON.parse(value);
      return Array.isArray(parsed) ? parsed : [];
    } catch {
      return [];
    }
  }
  return [];
}

export function normalizeListingImages(value: unknown): string[] {
  return parseImageValue(value)
    .sort((a, b) => {
      const orderA = typeof a === "string" ? 0 : (a.order ?? 0);
      const orderB = typeof b === "string" ? 0 : (b.order ?? 0);
      return orderA - orderB;
    })
    .map((image) => (typeof image === "string" ? image : image.url)?.trim())
    .filter((url): url is string => !!url);
}

export function normalizeQuery(value: string): string {
  return value
    .toLocaleLowerCase("es-CO")
    .normalize("NFD")
    .replace(/\p{Diacritic}/gu, "");
}

export function mapListing(row: ListingRow): Listing {
  const category = first(row.category_ref);
  const location = first(row.location_ref);
  const profile = first(row.profiles);
  const rootCategory = (category?.slug_path?.split("/")[0] ??
    category?.slug ??
    "comunidad") as Category;
  const categoryInfo = getCategoryInfo(rootCategory);
  const displayCity =
    location?.city ??
    profile?.city ??
    (row.is_nationwide || location?.is_nationwide ? "Todo Colombia" : "Santa Marta");
  const displayName = profile?.display_name ?? profile?.username ?? null;

  const mappedProfile: Profile | undefined = profile
    ? {
        id: profile.id,
        username: profile.username ?? null,
        display_name: displayName,
        full_name: displayName,
        whatsapp_number: profile.whatsapp_number ?? null,
        city: profile.city ?? null,
        department: profile.department ?? null,
        avatar_url: profile.avatar_url ?? null,
        user_type: profile.user_type ?? "regular",
        bio: profile.bio ?? null,
        is_verified: !!profile.is_verified,
        rating_avg: toNumber(profile.rating_avg),
        rating_count: profile.rating_count ?? 0,
        created_at: profile.created_at ?? row.created_at,
        updated_at: profile.updated_at ?? row.updated_at ?? row.created_at,
      }
    : undefined;

  return {
    id: row.id,
    seller_id: row.seller_id,
    user_id: row.seller_id,
    category_id: row.category_id ?? null,
    location_id: row.location_id ?? null,
    title: row.title,
    slug: row.slug ?? row.id,
    description: row.description,
    price: row.price === null || row.price === undefined ? null : toNumber(row.price),
    price_type: row.price_type ?? "fixed",
    currency: row.currency ?? "COP",
    category: rootCategory,
    category_slug: category?.slug ?? rootCategory,
    category_label: category?.name_es ?? categoryInfo.labelEs,
    category_path: category?.slug_path ?? rootCategory,
    city: displayCity,
    department: location?.department ?? profile?.department ?? null,
    is_nationwide: !!(row.is_nationwide || location?.is_nationwide),
    whatsapp_number: profile?.whatsapp_number ?? "",
    images: normalizeListingImages(row.images),
    status: row.status ?? "active",
    is_bumped: false,
    is_highlighted: false,
    published_at: row.published_at ?? null,
    created_at: row.created_at,
    updated_at: row.updated_at ?? row.created_at,
    profiles: mappedProfile,
  };
}

export function filterListings(
  listings: Listing[],
  filters: { category?: string; city?: string; query?: string },
) {
  const category = filters.category?.trim();
  const city = filters.city?.trim();
  const query = filters.query?.trim();
  const normalizedQuery = query ? normalizeQuery(query) : "";

  return listings.filter((listing) => {
    if (
      category &&
      listing.category !== category &&
      listing.category_slug !== category &&
      !listing.category_path.startsWith(`${category}/`)
    ) {
      return false;
    }

    if (city && listing.city !== city) return false;

    if (normalizedQuery) {
      const haystack = normalizeQuery(
        [
          listing.title,
          listing.description,
          listing.category_label,
          listing.city,
          listing.profiles?.display_name,
          listing.profiles?.username,
        ]
          .filter(Boolean)
          .join(" "),
      );
      return haystack.includes(normalizedQuery);
    }

    return true;
  });
}

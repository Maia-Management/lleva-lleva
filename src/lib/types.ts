export type Category =
  | "vehiculos"
  | "inmuebles"
  | "tecnologia"
  | "hogar-y-jardin"
  | "servicios"
  | "empleo"
  | "nautico-y-pesca"
  | "moda-y-belleza"
  | "turismo-y-hospedaje"
  | "educacion-y-formacion"
  | "mascotas-y-animales"
  | "deportes-y-fitness"
  | "negocios-e-industria"
  | "agro-y-campo"
  | "comunidad"
  | "informacion-publica";

export type ListingStatus =
  | "draft"
  | "active"
  | "paused"
  | "sold"
  | "expired"
  | "removed";

export type ReportReason = "scam" | "inappropriate" | "spam" | "other";

export type ReportStatus = "pending" | "reviewed" | "resolved" | "dismissed";

export type PriceType = "fixed" | "negotiable" | "free" | "contact";
export type UserType = "regular" | "business" | "bot";

export interface CategoryOption {
  id: string;
  parent_id: string | null;
  name_es: string;
  name_en: string | null;
  slug: string;
  slug_path: string;
  sort_order: number | null;
}

export interface LocationOption {
  id: string;
  department: string;
  city: string;
  slug: string;
  is_nationwide: boolean;
}

export interface Profile {
  id: string;
  username: string | null;
  display_name: string | null;
  full_name: string | null;
  whatsapp_number: string | null;
  city: string | null;
  department: string | null;
  avatar_url: string | null;
  user_type: UserType;
  bio: string | null;
  is_verified: boolean;
  rating_avg: number;
  rating_count: number;
  created_at: string;
  updated_at: string;
}

export interface Listing {
  id: string;
  seller_id: string;
  user_id: string;
  category_id: string | null;
  location_id: string | null;
  title: string;
  slug: string;
  description: string;
  price: number | null;
  price_type: PriceType;
  currency: string;
  category: Category;
  category_slug: string;
  category_label: string;
  category_path: string;
  city: string;
  department: string | null;
  is_nationwide: boolean;
  whatsapp_number: string;
  images: string[];
  status: ListingStatus;
  is_bumped: boolean;
  is_highlighted: boolean;
  published_at: string | null;
  created_at: string;
  updated_at: string;
  profiles?: Profile;
}

export interface Report {
  id: string;
  listing_id: string;
  reporter_id: string;
  reason: string;
  status: ReportStatus;
  created_at: string;
}

export interface Favorite {
  id: string;
  user_id: string;
  listing_id: string;
  created_at: string;
}

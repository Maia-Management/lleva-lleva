export type Category =
  | "buy_sell"
  | "jobs"
  | "housing"
  | "services"
  | "vehicles"
  | "events"
  | "community";

export type ListingStatus = "active" | "sold" | "expired" | "flagged";

export type ReportReason = "scam" | "inappropriate" | "spam" | "other";

export type ReportStatus = "pending" | "reviewed" | "resolved";

export interface Profile {
  id: string;
  full_name: string | null;
  phone: string | null;
  whatsapp_number: string | null;
  city: string | null;
  avatar_url: string | null;
  is_verified: boolean;
  created_at: string;
  updated_at: string;
}

export interface Listing {
  id: string;
  user_id: string;
  title: string;
  description: string;
  price: number | null;
  category: Category;
  city: string;
  whatsapp_number: string;
  images: string[];
  status: ListingStatus;
  is_bumped: boolean;
  is_highlighted: boolean;
  created_at: string;
  updated_at: string;
  profiles?: Profile;
}

export interface Report {
  id: string;
  listing_id: string;
  reporter_id: string;
  reason: ReportReason;
  description: string | null;
  status: ReportStatus;
  created_at: string;
}

export interface Favorite {
  id: string;
  user_id: string;
  listing_id: string;
  created_at: string;
}

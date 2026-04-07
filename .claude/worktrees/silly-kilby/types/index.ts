export type UserType = 'regular' | 'business' | 'bot';
export type ListingStatus = 'draft' | 'active' | 'paused' | 'sold' | 'expired' | 'removed';
export type PriceType = 'fixed' | 'negotiable' | 'free' | 'contact';
export type ConditionType = 'new' | 'like_new' | 'good' | 'fair' | 'for_parts';
export type TransactionStatus = 'initiated' | 'seller_confirmed' | 'buyer_confirmed' | 'completed' | 'disputed' | 'cancelled';
export type RatingTag = 'fast_response' | 'as_described' | 'trustworthy' | 'good_price' | 'slow_response' | 'not_as_described' | 'no_show';

export interface Profile {
  id: string;
  username: string;
  display_name: string;
  avatar_url: string | null;
  user_type: UserType;
  bio: string | null;
  business_name: string | null;
  business_nit: string | null;
  is_verified: boolean;
  verified_at: string | null;
  city: string | null;
  department: string | null;
  rating_avg: number;
  rating_count: number;
  total_sales: number;
  total_purchases: number;
  whatsapp_number: string | null;
  whatsapp_verified: boolean;
  has_pending_rating: boolean;
  pending_rating_transaction_id: string | null;
  phone_hash: string | null;
  email_verified: boolean;
  is_active: boolean;
  last_seen_at: string | null;
  created_at: string;
  updated_at: string;
}

export interface Category {
  id: string;
  parent_id: string | null;
  name_es: string;
  name_en: string | null;
  slug: string;
  slug_path: string;
  icon: string | null;
  sort_order: number;
  is_active: boolean;
  listing_count: number;
  created_at: string;
  children?: Category[];
}

export interface Location {
  id: string;
  department: string;
  city: string;
  neighborhood: string | null;
  latitude: number | null;
  longitude: number | null;
  slug: string;
  population: number | null;
  is_active: boolean;
}

export interface ListingImage {
  url: string;
  alt?: string;
  order: number;
}

export interface Listing {
  id: string;
  seller_id: string;
  category_id: string;
  location_id: string | null;
  title: string;
  slug: string;
  description: string;
  description_html: string | null;
  price: number | null;
  price_type: PriceType;
  currency: string;
  condition: ConditionType | null;
  images: ListingImage[];
  attributes: Record<string, unknown>;
  tags: string[];
  status: ListingStatus;
  view_count: number;
  message_count: number;
  favorite_count: number;
  is_featured: boolean;
  featured_until: string | null;
  meta_title: string | null;
  meta_description: string | null;
  published_at: string | null;
  expires_at: string | null;
  is_nationwide: boolean;
  created_at: string;
  updated_at: string;
  // Joins
  seller?: Profile;
  category?: Category;
  location?: Location;
}

export interface Favorite {
  id: string;
  user_id: string;
  listing_id: string;
  created_at: string;
}

export interface ContactInitiation {
  id: string;
  listing_id: string;
  buyer_id: string;
  seller_id: string;
  message_template: string;
  wa_link: string;
  created_at: string;
}

export interface Transaction {
  id: string;
  listing_id: string;
  buyer_id: string;
  seller_id: string;
  agreed_price: number | null;
  currency: string;
  status: TransactionStatus;
  buyer_confirmed_at: string | null;
  seller_confirmed_at: string | null;
  completed_at: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface Rating {
  id: string;
  transaction_id: string;
  rater_id: string;
  ratee_id: string;
  listing_id: string;
  score: number;
  comment: string | null;
  tags: RatingTag[];
  is_seller_rating: boolean;
  created_at: string;
}

export interface Report {
  id: string;
  reporter_id: string;
  listing_id: string | null;
  profile_id: string | null;
  reason: string;
  detail: string | null;
  status: string;
  created_at: string;
}

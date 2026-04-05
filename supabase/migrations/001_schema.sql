-- ============================================================
-- LlevaLleva Database Schema - Migration 001
-- ============================================================

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "unaccent";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- ============================================================
-- ENUMS
-- ============================================================

CREATE TYPE user_type AS ENUM ('regular', 'business', 'bot');
CREATE TYPE listing_status AS ENUM ('draft', 'active', 'paused', 'sold', 'expired', 'removed');
CREATE TYPE price_type AS ENUM ('fixed', 'negotiable', 'free', 'contact');
CREATE TYPE condition_type AS ENUM ('new', 'like_new', 'good', 'fair', 'for_parts');
CREATE TYPE transaction_status AS ENUM ('initiated', 'seller_confirmed', 'buyer_confirmed', 'completed', 'disputed', 'cancelled');
CREATE TYPE rating_tag AS ENUM ('fast_response', 'as_described', 'trustworthy', 'good_price', 'slow_response', 'not_as_described', 'no_show');

-- ============================================================
-- PROFILES
-- ============================================================

CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  avatar_url TEXT,
  user_type user_type NOT NULL DEFAULT 'regular',
  bio TEXT,
  business_name TEXT,
  business_nit TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  verified_at TIMESTAMPTZ,
  city TEXT,
  department TEXT,
  rating_avg NUMERIC(3,2) DEFAULT 0,
  rating_count INTEGER DEFAULT 0,
  total_sales INTEGER DEFAULT 0,
  total_purchases INTEGER DEFAULT 0,
  whatsapp_number TEXT,
  whatsapp_verified BOOLEAN DEFAULT FALSE,
  has_pending_rating BOOLEAN DEFAULT FALSE,
  pending_rating_transaction_id UUID,
  phone_hash TEXT,
  email_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  last_seen_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_profiles_username ON profiles(username);
CREATE INDEX idx_profiles_user_type ON profiles(user_type);
CREATE INDEX idx_profiles_city ON profiles(city);

-- ============================================================
-- CATEGORIES
-- ============================================================

CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id UUID REFERENCES categories(id),
  name_es TEXT NOT NULL,
  name_en TEXT,
  slug TEXT UNIQUE NOT NULL,
  slug_path TEXT NOT NULL,
  icon TEXT,
  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  listing_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_categories_parent_id ON categories(parent_id);
CREATE INDEX idx_categories_slug ON categories(slug);
CREATE INDEX idx_categories_slug_path ON categories(slug_path);

-- ============================================================
-- LOCATIONS
-- ============================================================

CREATE TABLE locations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  department TEXT NOT NULL,
  city TEXT NOT NULL,
  neighborhood TEXT,
  latitude NUMERIC(10,7),
  longitude NUMERIC(10,7),
  slug TEXT UNIQUE NOT NULL,
  population INTEGER,
  is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_locations_department ON locations(department);
CREATE INDEX idx_locations_city ON locations(city);
CREATE INDEX idx_locations_slug ON locations(slug);

-- ============================================================
-- LISTINGS
-- ============================================================

CREATE TABLE listings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  seller_id UUID NOT NULL REFERENCES profiles(id),
  category_id UUID NOT NULL REFERENCES categories(id),
  location_id UUID REFERENCES locations(id),
  title TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT NOT NULL,
  description_html TEXT,
  price NUMERIC(15,2),
  price_type price_type DEFAULT 'fixed',
  currency TEXT DEFAULT 'COP',
  condition condition_type,
  images JSONB DEFAULT '[]',
  attributes JSONB DEFAULT '{}',
  tags TEXT[] DEFAULT '{}',
  status listing_status DEFAULT 'draft',
  view_count INTEGER DEFAULT 0,
  message_count INTEGER DEFAULT 0,
  favorite_count INTEGER DEFAULT 0,
  is_featured BOOLEAN DEFAULT FALSE,
  featured_until TIMESTAMPTZ,
  meta_title TEXT,
  meta_description TEXT,
  published_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Full-text search index (Spanish)
CREATE INDEX idx_listings_fts ON listings
  USING GIN(to_tsvector('spanish', coalesce(title,'') || ' ' || coalesce(description,'')));

CREATE INDEX idx_listings_seller_id ON listings(seller_id);
CREATE INDEX idx_listings_category_id ON listings(category_id);
CREATE INDEX idx_listings_location_id ON listings(location_id);
CREATE INDEX idx_listings_status ON listings(status);
CREATE INDEX idx_listings_price ON listings(price);
CREATE INDEX idx_listings_tags ON listings USING GIN(tags);
CREATE INDEX idx_listings_created_at ON listings(created_at DESC);
CREATE INDEX idx_listings_is_featured ON listings(is_featured) WHERE is_featured = TRUE;
CREATE INDEX idx_listings_slug ON listings(slug);

-- ============================================================
-- FAVORITES
-- ============================================================

CREATE TABLE favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  listing_id UUID NOT NULL REFERENCES listings(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, listing_id)
);

CREATE INDEX idx_favorites_user_id ON favorites(user_id);
CREATE INDEX idx_favorites_listing_id ON favorites(listing_id);

-- ============================================================
-- CONTACT INITIATIONS
-- ============================================================

CREATE TABLE contact_initiations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  listing_id UUID NOT NULL REFERENCES listings(id) ON DELETE CASCADE,
  buyer_id UUID NOT NULL REFERENCES profiles(id),
  seller_id UUID NOT NULL REFERENCES profiles(id),
  message_template TEXT NOT NULL,
  wa_link TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_contact_listing_id ON contact_initiations(listing_id);
CREATE INDEX idx_contact_buyer_id ON contact_initiations(buyer_id);
CREATE INDEX idx_contact_seller_id ON contact_initiations(seller_id);

-- ============================================================
-- TRANSACTIONS
-- ============================================================

CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  listing_id UUID NOT NULL REFERENCES listings(id),
  buyer_id UUID NOT NULL REFERENCES profiles(id),
  seller_id UUID NOT NULL REFERENCES profiles(id),
  agreed_price NUMERIC(15,2),
  currency TEXT DEFAULT 'COP',
  status transaction_status DEFAULT 'initiated',
  buyer_confirmed_at TIMESTAMPTZ,
  seller_confirmed_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_transactions_listing_id ON transactions(listing_id);
CREATE INDEX idx_transactions_buyer_id ON transactions(buyer_id);
CREATE INDEX idx_transactions_seller_id ON transactions(seller_id);
CREATE INDEX idx_transactions_status ON transactions(status);

-- ============================================================
-- RATINGS
-- ============================================================

CREATE TABLE ratings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  transaction_id UUID NOT NULL REFERENCES transactions(id),
  rater_id UUID NOT NULL REFERENCES profiles(id),
  ratee_id UUID NOT NULL REFERENCES profiles(id),
  listing_id UUID NOT NULL REFERENCES listings(id),
  score INTEGER NOT NULL CHECK (score BETWEEN 1 AND 5),
  comment TEXT,
  tags rating_tag[] DEFAULT '{}',
  is_seller_rating BOOLEAN NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(transaction_id, rater_id)
);

CREATE INDEX idx_ratings_ratee_id ON ratings(ratee_id);
CREATE INDEX idx_ratings_transaction_id ON ratings(transaction_id);

-- ============================================================
-- BOT ACCOUNTS & POSTS
-- ============================================================

CREATE TABLE bot_accounts (
  id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  bot_name TEXT NOT NULL,
  source_url TEXT,
  data_category TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  last_post_at TIMESTAMPTZ,
  post_interval_hours INTEGER DEFAULT 24,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE bot_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bot_id UUID NOT NULL REFERENCES bot_accounts(id),
  listing_id UUID REFERENCES listings(id),
  source_data JSONB,
  published_at TIMESTAMPTZ DEFAULT now(),
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_bot_posts_bot_id ON bot_posts(bot_id);

-- ============================================================
-- REPORTS
-- ============================================================

CREATE TABLE reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_id UUID NOT NULL REFERENCES profiles(id),
  listing_id UUID REFERENCES listings(id),
  profile_id UUID REFERENCES profiles(id),
  reason TEXT NOT NULL,
  detail TEXT,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_reports_listing_id ON reports(listing_id);
CREATE INDEX idx_reports_status ON reports(status);

-- ============================================================
-- TRIGGERS
-- ============================================================

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION fn_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_listings_updated_at
  BEFORE UPDATE ON listings
  FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

CREATE TRIGGER trg_transactions_updated_at
  BEFORE UPDATE ON transactions
  FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

CREATE TRIGGER trg_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

-- Rating soft-block: set pending rating
CREATE OR REPLACE FUNCTION fn_set_pending_rating()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
    -- Flag both parties
    UPDATE profiles
    SET has_pending_rating = TRUE,
        pending_rating_transaction_id = NEW.id
    WHERE id IN (NEW.buyer_id, NEW.seller_id);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_set_pending_rating
  AFTER UPDATE ON transactions
  FOR EACH ROW EXECUTE FUNCTION fn_set_pending_rating();

-- Rating soft-block: clear when rating submitted
CREATE OR REPLACE FUNCTION fn_clear_pending_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE profiles
  SET has_pending_rating = FALSE,
      pending_rating_transaction_id = NULL
  WHERE id = NEW.rater_id
    AND pending_rating_transaction_id = NEW.transaction_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_clear_pending_rating
  AFTER INSERT ON ratings
  FOR EACH ROW EXECUTE FUNCTION fn_clear_pending_rating();

-- Recalculate rating average
CREATE OR REPLACE FUNCTION fn_recalc_rating_avg()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE profiles
  SET rating_avg = (
    SELECT COALESCE(AVG(score)::NUMERIC(3,2), 0)
    FROM ratings
    WHERE ratee_id = NEW.ratee_id
  ),
  rating_count = (
    SELECT COUNT(*) FROM ratings WHERE ratee_id = NEW.ratee_id
  )
  WHERE id = NEW.ratee_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_recalc_rating_avg
  AFTER INSERT ON ratings
  FOR EACH ROW EXECUTE FUNCTION fn_recalc_rating_avg();

-- Increment listing view count
CREATE OR REPLACE FUNCTION fn_increment_view_count(listing_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE listings SET view_count = view_count + 1 WHERE id = listing_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_initiations ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- Profiles: public read, own write
CREATE POLICY "profiles_public_read" ON profiles
  FOR SELECT USING (true);

CREATE POLICY "profiles_own_insert" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "profiles_own_update" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Listings: active = public read; draft/own = own
CREATE POLICY "listings_public_active" ON listings
  FOR SELECT USING (status = 'active' OR seller_id = auth.uid());

CREATE POLICY "listings_own_insert" ON listings
  FOR INSERT WITH CHECK (auth.uid() = seller_id);

CREATE POLICY "listings_own_update" ON listings
  FOR UPDATE USING (auth.uid() = seller_id);

CREATE POLICY "listings_own_delete" ON listings
  FOR DELETE USING (auth.uid() = seller_id);

-- Favorites
CREATE POLICY "favorites_own" ON favorites
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Contact initiations
CREATE POLICY "contact_initiations_own" ON contact_initiations
  FOR INSERT WITH CHECK (auth.uid() = buyer_id);

CREATE POLICY "contact_initiations_read" ON contact_initiations
  FOR SELECT USING (auth.uid() = buyer_id OR auth.uid() = seller_id);

-- Transactions
CREATE POLICY "transactions_participants" ON transactions
  USING (auth.uid() = buyer_id OR auth.uid() = seller_id);

CREATE POLICY "transactions_insert" ON transactions
  FOR INSERT WITH CHECK (auth.uid() = buyer_id);

-- Ratings
CREATE POLICY "ratings_public_read" ON ratings
  FOR SELECT USING (true);

CREATE POLICY "ratings_own_insert" ON ratings
  FOR INSERT WITH CHECK (auth.uid() = rater_id);

-- Reports
CREATE POLICY "reports_own_insert" ON reports
  FOR INSERT WITH CHECK (auth.uid() = reporter_id);

-- Categories and locations: public read
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "categories_public_read" ON categories FOR SELECT USING (true);
CREATE POLICY "locations_public_read" ON locations FOR SELECT USING (true);

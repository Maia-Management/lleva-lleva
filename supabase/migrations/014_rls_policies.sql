-- =============================================================
-- LlevaLleva Migration 014 — Row Level Security policies
-- Adopted from the standalone rls_migration_fixed.sql at repo root.
-- That standalone file had two defects this migration repairs:
--   1. Section 13 was missing entirely (skipped 11 → 14).
--   2. Lines 360-372 were orphan policy bodies with no
--      `CREATE POLICY <name> ON <table>` headers — un-runnable.
--
-- This migration is fully idempotent: every policy is dropped
-- first, every CREATE POLICY is well-formed. Safe to re-run.
--
-- Access model:
--   anon          → public read of active listings, profiles,
--                   categories, locations, ratings
--   authenticated → post own listings, manage own data,
--                   submit ratings / reports
--   owner         → edit and delete own listings and profile data
--   admin         → full moderation (auth.app_metadata.role = 'admin')
--   service_role  → bypasses RLS entirely (CRM bot, seed scripts)
-- =============================================================

-- =============================================================
-- SECTION 0: Admin helper function
-- is_admin() reads app_metadata.role = 'admin' from the JWT.
-- service_role bypasses RLS and is unaffected.
-- =============================================================

CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(
    (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin',
    FALSE
  );
$$;

-- =============================================================
-- SECTION 1: Enable RLS on every table (idempotent)
-- =============================================================

ALTER TABLE profiles            ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories          ENABLE ROW LEVEL SECURITY;
ALTER TABLE locations           ENABLE ROW LEVEL SECURITY;
ALTER TABLE listings            ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites           ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_initiations ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions        ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings             ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports             ENABLE ROW LEVEL SECURITY;

-- =============================================================
-- SECTION 2: Drop existing policies (clean slate)
-- DROP IF EXISTS makes first-run a no-op.
-- =============================================================

-- profiles
DROP POLICY IF EXISTS "profiles_public_read"              ON profiles;
DROP POLICY IF EXISTS "profiles_own_insert"               ON profiles;
DROP POLICY IF EXISTS "profiles_own_update"               ON profiles;
DROP POLICY IF EXISTS "profiles_select_public"            ON profiles;
DROP POLICY IF EXISTS "profiles_insert_own"               ON profiles;
DROP POLICY IF EXISTS "profiles_update_own"               ON profiles;
DROP POLICY IF EXISTS "profiles_delete_admin"             ON profiles;

-- categories
DROP POLICY IF EXISTS "categories_public_read"            ON categories;
DROP POLICY IF EXISTS "categories_select_public"          ON categories;
DROP POLICY IF EXISTS "categories_insert_admin"           ON categories;
DROP POLICY IF EXISTS "categories_update_admin"           ON categories;
DROP POLICY IF EXISTS "categories_delete_admin"           ON categories;

-- locations
DROP POLICY IF EXISTS "locations_public_read"             ON locations;
DROP POLICY IF EXISTS "locations_select_public"           ON locations;
DROP POLICY IF EXISTS "locations_insert_admin"            ON locations;
DROP POLICY IF EXISTS "locations_update_admin"            ON locations;
DROP POLICY IF EXISTS "locations_delete_admin"            ON locations;

-- listings
DROP POLICY IF EXISTS "listings_public_active"            ON listings;
DROP POLICY IF EXISTS "listings_own_insert"               ON listings;
DROP POLICY IF EXISTS "listings_own_update"               ON listings;
DROP POLICY IF EXISTS "listings_own_delete"               ON listings;
DROP POLICY IF EXISTS "listings_select"                   ON listings;
DROP POLICY IF EXISTS "listings_insert_own"               ON listings;
DROP POLICY IF EXISTS "listings_update_own"               ON listings;
DROP POLICY IF EXISTS "listings_delete_own"               ON listings;

-- favorites
DROP POLICY IF EXISTS "favorites_own"                     ON favorites;
DROP POLICY IF EXISTS "favorites_select_own"              ON favorites;
DROP POLICY IF EXISTS "favorites_insert_own"              ON favorites;
DROP POLICY IF EXISTS "favorites_delete_own"              ON favorites;

-- contact_initiations
DROP POLICY IF EXISTS "contact_initiations_own"                  ON contact_initiations;
DROP POLICY IF EXISTS "contact_initiations_read"                 ON contact_initiations;
DROP POLICY IF EXISTS "contact_initiations_select_participants"  ON contact_initiations;
DROP POLICY IF EXISTS "contact_initiations_insert_buyer"         ON contact_initiations;

-- transactions
DROP POLICY IF EXISTS "transactions_participants"         ON transactions;
DROP POLICY IF EXISTS "transactions_insert"               ON transactions;
DROP POLICY IF EXISTS "transactions_select_participants"  ON transactions;
DROP POLICY IF EXISTS "transactions_insert_buyer"         ON transactions;
DROP POLICY IF EXISTS "transactions_update_participants"  ON transactions;
DROP POLICY IF EXISTS "transactions_delete_admin"         ON transactions;

-- ratings
DROP POLICY IF EXISTS "ratings_public_read"               ON ratings;
DROP POLICY IF EXISTS "ratings_own_insert"                ON ratings;
DROP POLICY IF EXISTS "ratings_select_public"             ON ratings;
DROP POLICY IF EXISTS "ratings_insert_own"                ON ratings;
DROP POLICY IF EXISTS "ratings_delete_admin"              ON ratings;

-- reports
DROP POLICY IF EXISTS "reports_own_insert"                ON reports;
DROP POLICY IF EXISTS "reports_select_admin"              ON reports;
DROP POLICY IF EXISTS "reports_insert_auth"               ON reports;
DROP POLICY IF EXISTS "reports_update_admin"              ON reports;
DROP POLICY IF EXISTS "reports_delete_admin"              ON reports;

-- =============================================================
-- SECTION 3: PROFILES
-- Inactive profiles are hidden from public; visible to owner + admin.
-- =============================================================

CREATE POLICY "profiles_select_public" ON profiles
  FOR SELECT
  USING (is_active = TRUE OR auth.uid() = id OR is_admin());

CREATE POLICY "profiles_insert_own" ON profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "profiles_update_own" ON profiles
  FOR UPDATE
  USING  (auth.uid() = id OR is_admin())
  WITH CHECK (auth.uid() = id OR is_admin());

CREATE POLICY "profiles_delete_admin" ON profiles
  FOR DELETE
  USING (is_admin());

-- =============================================================
-- SECTION 4: CATEGORIES (reference data — admin write)
-- =============================================================

CREATE POLICY "categories_select_public" ON categories
  FOR SELECT
  USING (is_active = TRUE OR is_admin());

CREATE POLICY "categories_insert_admin" ON categories
  FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "categories_update_admin" ON categories
  FOR UPDATE
  USING (is_admin());

CREATE POLICY "categories_delete_admin" ON categories
  FOR DELETE
  USING (is_admin());

-- =============================================================
-- SECTION 5: LOCATIONS (same model as categories)
-- =============================================================

CREATE POLICY "locations_select_public" ON locations
  FOR SELECT
  USING (is_active = TRUE OR is_admin());

CREATE POLICY "locations_insert_admin" ON locations
  FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "locations_update_admin" ON locations
  FOR UPDATE
  USING (is_admin());

CREATE POLICY "locations_delete_admin" ON locations
  FOR DELETE
  USING (is_admin());

-- =============================================================
-- SECTION 6: LISTINGS
-- USING + WITH CHECK on UPDATE prevents seller_id hijacking.
-- =============================================================

CREATE POLICY "listings_select" ON listings
  FOR SELECT
  USING (
    status = 'active'
    OR auth.uid() = seller_id
    OR is_admin()
  );

CREATE POLICY "listings_insert_own" ON listings
  FOR INSERT
  WITH CHECK (auth.uid() = seller_id AND auth.uid() IS NOT NULL);

CREATE POLICY "listings_update_own" ON listings
  FOR UPDATE
  USING  (auth.uid() = seller_id OR is_admin())
  WITH CHECK (auth.uid() = seller_id OR is_admin());

CREATE POLICY "listings_delete_own" ON listings
  FOR DELETE
  USING (auth.uid() = seller_id OR is_admin());

-- =============================================================
-- SECTION 7: FAVORITES (fully private)
-- =============================================================

CREATE POLICY "favorites_select_own" ON favorites
  FOR SELECT
  USING (auth.uid() = user_id OR is_admin());

CREATE POLICY "favorites_insert_own" ON favorites
  FOR INSERT
  WITH CHECK (auth.uid() = user_id AND auth.uid() IS NOT NULL);

CREATE POLICY "favorites_delete_own" ON favorites
  FOR DELETE
  USING (auth.uid() = user_id OR is_admin());

-- =============================================================
-- SECTION 8: CONTACT INITIATIONS (CRM data — auth-only, immutable)
-- =============================================================

CREATE POLICY "contact_initiations_select_participants" ON contact_initiations
  FOR SELECT
  USING (
    auth.uid() = buyer_id
    OR auth.uid() = seller_id
    OR is_admin()
  );

CREATE POLICY "contact_initiations_insert_buyer" ON contact_initiations
  FOR INSERT
  WITH CHECK (auth.uid() = buyer_id AND auth.uid() IS NOT NULL);

-- No UPDATE — contact records are immutable. service_role bypasses.

-- =============================================================
-- SECTION 9: TRANSACTIONS (private to participants)
-- =============================================================

CREATE POLICY "transactions_select_participants" ON transactions
  FOR SELECT
  USING (
    auth.uid() = buyer_id
    OR auth.uid() = seller_id
    OR is_admin()
  );

CREATE POLICY "transactions_insert_buyer" ON transactions
  FOR INSERT
  WITH CHECK (auth.uid() = buyer_id AND auth.uid() IS NOT NULL);

CREATE POLICY "transactions_update_participants" ON transactions
  FOR UPDATE
  USING  (auth.uid() = buyer_id OR auth.uid() = seller_id OR is_admin())
  WITH CHECK (auth.uid() = buyer_id OR auth.uid() = seller_id OR is_admin());

CREATE POLICY "transactions_delete_admin" ON transactions
  FOR DELETE
  USING (is_admin());

-- =============================================================
-- SECTION 10: RATINGS (public read; immutable; admin delete)
-- =============================================================

CREATE POLICY "ratings_select_public" ON ratings
  FOR SELECT
  USING (TRUE);

CREATE POLICY "ratings_insert_own" ON ratings
  FOR INSERT
  WITH CHECK (auth.uid() = rater_id AND auth.uid() IS NOT NULL);

CREATE POLICY "ratings_delete_admin" ON ratings
  FOR DELETE
  USING (is_admin());

-- =============================================================
-- SECTION 11: REPORTS (admin-only read)
-- =============================================================

CREATE POLICY "reports_select_admin" ON reports
  FOR SELECT
  USING (is_admin());

CREATE POLICY "reports_insert_auth" ON reports
  FOR INSERT
  WITH CHECK (auth.uid() = reporter_id AND auth.uid() IS NOT NULL);

CREATE POLICY "reports_update_admin" ON reports
  FOR UPDATE
  USING (is_admin());

CREATE POLICY "reports_delete_admin" ON reports
  FOR DELETE
  USING (is_admin());

-- =============================================================
-- SECTION 12: fn_increment_view_count — SECURITY DEFINER
-- Called from server components with anon key on every listing view.
-- Anon cannot UPDATE listings under RLS, so we run as definer
-- (postgres) for this one narrow operation. search_path pinned
-- to prevent search_path injection.
-- =============================================================

CREATE OR REPLACE FUNCTION fn_increment_view_count(listing_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE listings
  SET view_count = view_count + 1
  WHERE id = listing_id;
END;
$$;

GRANT EXECUTE ON FUNCTION fn_increment_view_count(UUID) TO anon, authenticated;

-- =============================================================
-- SECTION 13: Schema grants (belt-and-suspenders)
-- =============================================================

GRANT USAGE ON SCHEMA public TO anon, authenticated;

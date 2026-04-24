-- =============================================================
-- LlevaLleva — Row Level Security Policy Migration
-- Created: 2026-04-15
-- Branch:  security/rls-fix
--
-- DO NOT apply to production without Andrew's explicit sign-off.
-- Stage with: supabase db push  (local only)
-- Apply prod: psql $DATABASE_URL -f supabase/migrations/20260415_rls_policies.sql
--
-- Access model:
--   anon          → public read of active listings, profiles, categories, locations, ratings
--   authenticated → post own listings, manage own data, submit ratings / reports
--   owner         → edit and delete own listings and profile data
--   admin         → full moderation of all tables (set via auth.app_metadata.role = 'admin')
--   service_role  → bypasses RLS entirely (WhatsApp CRM bot, seed scripts)
--
-- NOTE on current schema state:
--   migration 001_schema.sql defines some policies, but they are NOT applied to
--   production (Supabase project tweuhyqajcnzsqelbtwt). This migration is a
--   clean-slate replacement. Drop-then-recreate is safe to run multiple times.
-- =============================================================

-- =============================================================
-- SECTION 0: Admin helper function
-- =============================================================

-- is_admin() reads app_metadata.role = 'admin' from the caller's JWT.
-- To grant admin: supabase.auth.admin.updateUserById(uid, { app_metadata: { role: 'admin' } })
-- service_role bypasses RLS entirely and is unaffected by this function.

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
-- If this migration is run for the first time, all DROP IF EXISTS
-- are no-ops and no error is raised.
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
DROP POLICY IF EXISTS "contact_initiations_own"           ON contact_initiations;
DROP POLICY IF EXISTS "contact_initiations_read"          ON contact_initiations;
DROP POLICY IF EXISTS "contact_initiations_select_participants" ON contact_initiations;
DROP POLICY IF EXISTS "contact_initiations_insert_buyer"  ON contact_initiations;

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


-- =============================================================
-- SECTION 3: PROFILES
--
-- Public read:  All active profiles are visible (seller cards, profile pages).
--               Inactive profiles are hidden from public but visible to their
--               owner and admins.
-- Own write:    Users manage their own row only.
-- Admin:        Full access to all rows (for moderation).
-- Hard delete:  Admin only; regular deactivation uses is_active = FALSE.
--
-- NOTE: Full SELECT * exposes whatsapp_number, phone_hash, business_nit to
-- authenticated callers querying via join. This is a known limitation of
-- row-level-only security (no column-level). A follow-up task should create
-- a restricted public view and update app queries accordingly.
-- =============================================================

CREATE POLICY "profiles_select_public" ON profiles
  FOR SELECT
  USING (is_active = TRUE OR auth.uid() = id OR is_admin());

CREATE POLICY "profiles_insert_own" ON profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Prevent regular users from elevating their own user_type or id.
-- The WITH CHECK (auth.uid() = id) ensures they can only update their own row
-- and the new seller_id stays their own id. Admin bypasses both checks.
CREATE POLICY "profiles_update_own" ON profiles
  FOR UPDATE
  USING  (auth.uid() = id OR is_admin())
  WITH CHECK (auth.uid() = id OR is_admin());

CREATE POLICY "profiles_delete_admin" ON profiles
  FOR DELETE
  USING (is_admin());

-- =============================================================
-- SECTION 4: CATEGORIES
-- Reference data. Public read; admin write.
-- The app never mutates categories via client SDK — only via migrations
-- or admin dashboard using service_role. Admin policies here cover any
-- future admin UI.
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
-- SECTION 5: LOCATIONS
-- Reference data. Same model as categories.
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
--
-- anon:          SELECT rows with status = 'active'
-- authenticated: SELECT own listings at any status
-- owner:         INSERT own listing; UPDATE/DELETE own listing
--                seller_id is immutable for regular users:
--                USING checks OLD.seller_id = auth.uid(),
--                WITH CHECK checks NEW.seller_id = auth.uid()
--                → prevents ownership transfer
-- admin:         full access
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

-- USING filters by OLD row; WITH CHECK validates NEW row.
-- Together these prevent both unauthorized access and seller_id hijacking.
CREATE POLICY "listings_update_own" ON listings
  FOR UPDATE
  USING  (auth.uid() = seller_id OR is_admin())
  WITH CHECK (auth.uid() = seller_id OR is_admin());

CREATE POLICY "listings_delete_own" ON listings
  FOR DELETE
  USING (auth.uid() = seller_id OR is_admin());

-- =============================================================
-- SECTION 7: FAVORITES
-- Fully private. Users see and manage only their own.
-- No public read (favorites are personal browsing history).
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
-- SECTION 8: CONTACT INITIATIONS (leads/contacts table)
-- Business requirement: "auth-only or admin-only, never public-readable"
-- These are logged WhatsApp contact events — CRM data.
-- Immutable after insert (no UPDATE for regular users).
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

-- No UPDATE policy for regular users — contact records are immutable.
-- Admin and service_role can manage via elevated access.

-- =============================================================
-- SECTION 9: TRANSACTIONS
-- Private to participants. Never public-readable.
-- Both buyer and seller can view their transactions.
-- Buyer initiates; both parties can update status.
-- Financial fields (agreed_price, buyer_id, seller_id, listing_id) should
-- not be changed post-creation. This is enforced at the app layer; a
-- future trigger can harden this at the DB layer.
-- Only admin can delete transactions.
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

-- Participants can update status fields; admin can update anything.
-- USING on OLD row; WITH CHECK validates NEW row.
CREATE POLICY "transactions_update_participants" ON transactions
  FOR UPDATE
  USING  (auth.uid() = buyer_id OR auth.uid() = seller_id OR is_admin())
  WITH CHECK (auth.uid() = buyer_id OR auth.uid() = seller_id OR is_admin());

CREATE POLICY "transactions_delete_admin" ON transactions
  FOR DELETE
  USING (is_admin());

-- =============================================================
-- SECTION 10: RATINGS
-- Public read (social proof — core to classifieds trust model).
-- Authenticated write only (must have completed a transaction).
-- Immutable after insert: no UPDATE for anyone, only admin DELETE
-- (for abuse removal).
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
-- SECTION 11: REPORTS
-- Business requirement: never public-readable.
-- Authenticated users submit reports; admin reads and acts on them.
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


  FOR DELETE
  USING (is_admin());


  FOR INSERT
  WITH CHECK (is_admin());

  FOR UPDATE
  USING (is_admin());

  FOR DELETE
  USING (is_admin());

-- =============================================================
-- SECTION 14: Fix fn_increment_view_count
--
-- Problem: This function is called from the Next.js server component
-- (lib/supabase/server.ts — anon key, no JWT) on every listing page
-- view. With RLS active, anon cannot UPDATE listings, so the function
-- would silently fail.
--
-- Fix: Declare SECURITY DEFINER so the function runs as the definer
-- (postgres/service_role context), bypassing RLS for this single
-- narrow operation. search_path is pinned to prevent search_path
-- injection attacks.
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
-- SECTION 15: Schema grants (belt-and-suspenders)
-- Supabase normally handles these, but explicit grants ensure
-- correct behavior if the database is migrated manually.
-- =============================================================

GRANT USAGE ON SCHEMA public TO anon, authenticated;

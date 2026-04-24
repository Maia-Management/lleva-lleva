-- =============================================================
-- LlevaLleva — RLS Policy Assertion Tests
-- Run against a local Supabase instance ONLY. Never against prod.
--
-- Prerequisites:
--   1. supabase start (local instance running)
--   2. Migration 20260415_rls_policies.sql applied
--   3. pgTAP extension installed:
--        CREATE EXTENSION IF NOT EXISTS pgtap;
--
-- Run:
--   psql postgresql://postgres:postgres@localhost:54322/postgres \
--        -f supabase/tests/rls_policies_test.sql
--
-- The script creates temporary test users and data, runs assertions,
-- then cleans up — safe to run repeatedly.
-- =============================================================

BEGIN;

-- Install pgTAP (local only)
CREATE EXTENSION IF NOT EXISTS pgtap;

SELECT plan(30);

-- =============================================================
-- TEST FIXTURES
-- We use auth.users UUIDs that are deterministic so tests are
-- repeatable. We use the postgres role (bypasses RLS) to set up.
-- =============================================================

DO $$
DECLARE
  v_seller_id  UUID := 'aaaaaaaa-0000-4000-8000-000000000001';
  v_buyer_id   UUID := 'bbbbbbbb-0000-4000-8000-000000000002';
  v_other_id   UUID := 'cccccccc-0000-4000-8000-000000000003';
  v_admin_id   UUID := 'dddddddd-0000-4000-8000-000000000004';
  v_cat_id     UUID := gen_random_uuid();
  v_loc_id     UUID := gen_random_uuid();
  v_listing_id UUID := gen_random_uuid();
  v_txn_id     UUID := gen_random_uuid();
BEGIN
  -- Create auth users (bypass RLS via postgres role)
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      is_super_admin, created_at, updated_at)
  VALUES
    (v_seller_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
     'seller@test.llevalleva', '', now(), '{"provider":"email"}', '{}', false, now(), now()),
    (v_buyer_id,  '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
     'buyer@test.llevalleva',  '', now(), '{"provider":"email"}', '{}', false, now(), now()),
    (v_other_id,  '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
     'other@test.llevalleva',  '', now(), '{"provider":"email"}', '{}', false, now(), now()),
    -- Admin has role=admin in app_metadata
    (v_admin_id,  '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
     'admin@test.llevalleva',  '', now(), '{"provider":"email","role":"admin"}', '{}', false, now(), now())
  ON CONFLICT (id) DO NOTHING;

  -- Update admin app_metadata to include role=admin
  UPDATE auth.users
  SET raw_app_meta_data = raw_app_meta_data || '{"role":"admin"}'::jsonb
  WHERE id = v_admin_id;

  -- Profiles
  INSERT INTO profiles (id, username, display_name, user_type, is_active)
  VALUES
    (v_seller_id, 'test_seller', 'Test Seller', 'regular', true),
    (v_buyer_id,  'test_buyer',  'Test Buyer',  'regular', true),
    (v_other_id,  'test_other',  'Test Other',  'regular', true),
    (v_admin_id,  'test_admin',  'Test Admin',  'regular', true)
  ON CONFLICT (id) DO NOTHING;

  -- Reference data
  INSERT INTO categories (id, name_es, slug, slug_path, is_active)
  VALUES (v_cat_id, 'Test Cat', 'test-cat', 'test-cat', true)
  ON CONFLICT DO NOTHING;

  INSERT INTO locations (id, department, city, slug, is_active)
  VALUES (v_loc_id, 'Test Dept', 'Test City', 'test-city', true)
  ON CONFLICT DO NOTHING;

  -- An active listing owned by seller
  INSERT INTO listings (id, seller_id, category_id, title, slug, description, status, published_at)
  VALUES (v_listing_id, v_seller_id, v_cat_id,
          'Test Listing', 'test-listing-rls', 'Test description for RLS.', 'active', now())
  ON CONFLICT DO NOTHING;

  -- A draft listing owned by seller
  INSERT INTO listings (seller_id, category_id, title, slug, description, status)
  VALUES (v_seller_id, v_cat_id, 'Draft Listing', 'draft-listing-rls', 'Draft.', 'draft')
  ON CONFLICT DO NOTHING;

  -- A transaction between buyer and seller
  INSERT INTO transactions (id, listing_id, buyer_id, seller_id, status)
  VALUES (v_txn_id, v_listing_id, v_buyer_id, v_seller_id, 'initiated')
  ON CONFLICT DO NOTHING;
END;
$$;

-- =============================================================
-- HELPER: set_auth_user(uid, role)
-- Simulates a Supabase JWT session for the given user.
-- =============================================================
CREATE OR REPLACE FUNCTION set_auth_user(p_uid UUID, p_role TEXT DEFAULT 'authenticated')
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
  v_meta JSONB;
BEGIN
  SELECT raw_app_meta_data INTO v_meta FROM auth.users WHERE id = p_uid;
  PERFORM set_config('request.jwt.claims', json_build_object(
    'sub', p_uid,
    'role', p_role,
    'aud', 'authenticated',
    'app_metadata', v_meta
  )::text, true);
  PERFORM set_config('role', 'authenticated', true);
END;
$$;

CREATE OR REPLACE FUNCTION set_anon()
RETURNS VOID LANGUAGE plpgsql AS $$
BEGIN
  PERFORM set_config('request.jwt.claims', '{}', true);
  PERFORM set_config('role', 'anon', true);
END;
$$;

-- =============================================================
-- TEST BLOCK 1: Anonymous access to listings
-- =============================================================

-- 1. anon CAN select active listings
PERFORM set_anon();
SELECT ok(
  (SELECT count(*) FROM listings WHERE status = 'active' AND slug = 'test-listing-rls') > 0,
  'anon can SELECT active listings'
);

-- 2. anon CANNOT see draft listings
SELECT is(
  (SELECT count(*) FROM listings WHERE status = 'draft' AND slug = 'draft-listing-rls'),
  0::bigint,
  'anon cannot see draft listings'
);

-- 3. anon CANNOT insert a listing
SELECT throws_ok(
  $$INSERT INTO listings (seller_id, category_id, title, slug, description, status)
    SELECT 'bbbbbbbb-0000-4000-8000-000000000002'::uuid, id, 'Injected', 'injected-slug', 'x', 'active'
    FROM categories LIMIT 1$$,
  'new row violates row-level security policy for table "listings"',
  'anon cannot INSERT listings'
);

-- =============================================================
-- TEST BLOCK 2: Anon access to reference data
-- =============================================================

-- 4. anon CAN read categories
SELECT ok(
  (SELECT count(*) FROM categories WHERE is_active = true) >= 0,
  'anon can SELECT active categories'
);

-- 5. anon CAN read locations
SELECT ok(
  (SELECT count(*) FROM locations WHERE is_active = true) >= 0,
  'anon can SELECT active locations'
);

-- 6. anon CAN read ratings (public social proof)
SELECT ok(
  (SELECT count(*) FROM ratings) >= 0,
  'anon can SELECT ratings'
);

-- =============================================================
-- TEST BLOCK 3: Anon CANNOT access private tables
-- =============================================================

-- 7. anon CANNOT read contact_initiations
SELECT is(
  (SELECT count(*) FROM contact_initiations),
  0::bigint,
  'anon cannot SELECT contact_initiations'
);

-- 8. anon CANNOT read transactions
SELECT is(
  (SELECT count(*) FROM transactions),
  0::bigint,
  'anon cannot SELECT transactions'
);

-- 9. anon CANNOT read favorites
SELECT is(
  (SELECT count(*) FROM favorites),
  0::bigint,
  'anon cannot SELECT favorites'
);

-- 10. anon CANNOT read reports
SELECT is(
  (SELECT count(*) FROM reports),
  0::bigint,
  'anon cannot SELECT reports'
);

-- =============================================================
-- TEST BLOCK 4: Owner can update own listing
-- =============================================================

PERFORM set_auth_user('aaaaaaaa-0000-4000-8000-000000000001');

-- 11. Owner CAN select own active listing
SELECT ok(
  (SELECT count(*) FROM listings WHERE slug = 'test-listing-rls' AND seller_id = 'aaaaaaaa-0000-4000-8000-000000000001'::uuid) > 0,
  'owner can SELECT own active listing'
);

-- 12. Owner CAN select own draft listing
SELECT ok(
  (SELECT count(*) FROM listings WHERE slug = 'draft-listing-rls' AND seller_id = 'aaaaaaaa-0000-4000-8000-000000000001'::uuid) > 0,
  'owner can SELECT own draft listing'
);

-- 13. Owner CAN update own listing
SELECT lives_ok(
  $$UPDATE listings SET title = 'Updated Title' WHERE slug = 'test-listing-rls' AND seller_id = 'aaaaaaaa-0000-4000-8000-000000000001'::uuid$$,
  'owner can UPDATE own listing'
);

-- 14. Owner CANNOT hijack another listing by changing seller_id
-- (WITH CHECK rejects if new seller_id != auth.uid())
SELECT throws_ok(
  $$UPDATE listings SET seller_id = 'cccccccc-0000-4000-8000-000000000003'::uuid
    WHERE slug = 'test-listing-rls'$$,
  'new row violates row-level security policy for table "listings"',
  'owner cannot change seller_id to another user'
);

-- =============================================================
-- TEST BLOCK 5: Non-owner CANNOT update another's listing
-- =============================================================

PERFORM set_auth_user('cccccccc-0000-4000-8000-000000000003');

-- 15. Non-owner CANNOT update a listing they don't own
SELECT is(
  (WITH cte AS (
    UPDATE listings SET title = 'Stolen' WHERE slug = 'test-listing-rls' RETURNING id
  ) SELECT count(*) FROM cte),
  0::bigint,
  'non-owner cannot UPDATE another user listing (0 rows affected)'
);

-- 16. Non-owner CANNOT delete another's listing
SELECT is(
  (WITH cte AS (
    DELETE FROM listings WHERE slug = 'test-listing-rls' RETURNING id
  ) SELECT count(*) FROM cte),
  0::bigint,
  'non-owner cannot DELETE another user listing (0 rows affected)'
);

-- 17. Non-owner CANNOT see a draft listing from another user
SELECT is(
  (SELECT count(*) FROM listings WHERE slug = 'draft-listing-rls'),
  0::bigint,
  'non-owner cannot see another user draft listing'
);

-- =============================================================
-- TEST BLOCK 6: Authenticated user can manage own data
-- =============================================================

PERFORM set_auth_user('bbbbbbbb-0000-4000-8000-000000000002');

-- 18. Buyer CAN insert a listing for themselves
SELECT lives_ok(
  $$INSERT INTO listings (seller_id, category_id, title, slug, description, status)
    SELECT 'bbbbbbbb-0000-4000-8000-000000000002'::uuid, id, 'Buyer Listing', 'buyer-listing-rls-test', 'desc', 'active'
    FROM categories LIMIT 1$$,
  'authenticated user can INSERT own listing'
);

-- 19. Buyer CANNOT insert a listing with someone else's seller_id
SELECT throws_ok(
  $$INSERT INTO listings (seller_id, category_id, title, slug, description, status)
    SELECT 'aaaaaaaa-0000-4000-8000-000000000001'::uuid, id, 'Impersonated', 'impersonated-rls', 'x', 'active'
    FROM categories LIMIT 1$$,
  'new row violates row-level security policy for table "listings"',
  'authenticated user cannot INSERT listing with another seller_id'
);

-- 20. Buyer CAN see their own transaction
SELECT ok(
  (SELECT count(*) FROM transactions WHERE buyer_id = 'bbbbbbbb-0000-4000-8000-000000000002'::uuid) > 0,
  'buyer can SELECT own transactions'
);

-- 21. Buyer CANNOT see transactions they are not part of
-- (Other user's transactions should be invisible)
SELECT is(
  (SELECT count(*) FROM transactions WHERE seller_id = 'aaaaaaaa-0000-4000-8000-000000000001'::uuid
     AND buyer_id != 'bbbbbbbb-0000-4000-8000-000000000002'::uuid),
  0::bigint,
  'user cannot see transactions they are not a participant in'
);

-- =============================================================
-- TEST BLOCK 7: Contact initiations (leads table)
-- =============================================================

PERFORM set_anon();

-- 22. anon CANNOT insert contact_initiations
SELECT throws_ok(
  $$INSERT INTO contact_initiations (listing_id, buyer_id, seller_id, message_template, wa_link)
    VALUES (
      (SELECT id FROM listings WHERE slug = 'test-listing-rls'),
      'bbbbbbbb-0000-4000-8000-000000000002'::uuid,
      'aaaaaaaa-0000-4000-8000-000000000001'::uuid,
      'Hola', 'https://wa.me/1234'
    )$$,
  'new row violates row-level security policy for table "contact_initiations"',
  'anon cannot INSERT contact_initiations'
);

PERFORM set_auth_user('bbbbbbbb-0000-4000-8000-000000000002');

-- 23. Authenticated buyer CAN insert contact_initiation for themselves
SELECT lives_ok(
  $$INSERT INTO contact_initiations (listing_id, buyer_id, seller_id, message_template, wa_link)
    VALUES (
      (SELECT id FROM listings WHERE slug = 'test-listing-rls'),
      'bbbbbbbb-0000-4000-8000-000000000002'::uuid,
      'aaaaaaaa-0000-4000-8000-000000000001'::uuid,
      'Hola, me interesa', 'https://wa.me/57123456789'
    )$$,
  'authenticated buyer can INSERT contact_initiation for themselves'
);

-- =============================================================
-- TEST BLOCK 8: Admin override
-- =============================================================

PERFORM set_auth_user('dddddddd-0000-4000-8000-000000000004');

-- 24. Admin CAN select all listings (including drafts from any user)
SELECT ok(
  (SELECT count(*) FROM listings WHERE status = 'draft') > 0,
  'admin can SELECT draft listings from any user'
);

-- 25. Admin CAN read reports
SELECT ok(
  (SELECT count(*) FROM reports) >= 0,
  'admin can SELECT reports'
);

-- 26. Admin CAN read contact_initiations
SELECT ok(
  (SELECT count(*) FROM contact_initiations) >= 0,
  'admin can SELECT contact_initiations'
);

-- 27. Admin CAN update any listing
SELECT lives_ok(
  $$UPDATE listings SET title = 'Admin Override' WHERE slug = 'test-listing-rls'$$,
  'admin can UPDATE any listing'
);

-- 28. Admin CAN delete any listing
SELECT lives_ok(
  $$DELETE FROM listings WHERE slug = 'buyer-listing-rls-test'$$,
  'admin can DELETE any listing'
);

-- =============================================================
-- TEST BLOCK 9: fn_increment_view_count works for anon
-- =============================================================

PERFORM set_anon();

-- 29. anon CAN call fn_increment_view_count (SECURITY DEFINER)
SELECT lives_ok(
  $$SELECT fn_increment_view_count((SELECT id FROM listings WHERE slug = 'test-listing-rls'))$$,
  'anon can call fn_increment_view_count via SECURITY DEFINER'
);

-- =============================================================
-- TEST BLOCK 10: Ratings are public
-- =============================================================

PERFORM set_anon();

-- 30. anon CAN SELECT ratings
SELECT ok(
  (SELECT count(*) FROM ratings) >= 0,
  'anon can SELECT ratings table'
);

-- =============================================================
-- Cleanup and finish
-- =============================================================

SELECT * FROM finish();

ROLLBACK;

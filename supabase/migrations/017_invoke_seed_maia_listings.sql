-- =============================================================
-- LlevaLleva Migration 017 — Invoke seed_maia_listings()
--
-- Migration 006 defined the function seed_maia_listings(UUID)
-- but never called it, so its 15 ecosystem listings were
-- never inserted. This migration calls it.
--
-- The function uses raw INSERTs with no ON CONFLICT, so calling
-- it a second time would explode on the slug uniqueness constraint.
-- We guard by checking for the first listing's slug — if present,
-- the seed has already run and we skip.
--
-- Admin UUID: Maia Management bot (a1b2c3d4-…006), the
-- umbrella ecosystem entity. All 15 listings end up owned by
-- this single profile (Maia Realty real-estate, Mapaná Marine
-- equipment, etc., all show as Maia Management). That is a
-- cosmetic limitation of how 006 was authored — it predates
-- the per-entity bot profiles in 008/010. A future migration
-- may want to re-assign seller_id per brand.
--
-- Depends on: 006_maia_ecosystem_listings.sql,
--             008_seed_business_profiles.sql,
--             002_categories_seed.sql, 003_locations_seed.sql.
-- =============================================================

DO $$
DECLARE
  v_admin       UUID := 'a1b2c3d4-0001-0001-0001-000000000006'; -- Maia Management bot
  v_probe_slug  TEXT := 'apartamento-premium-el-prado-barranquilla-01';
  v_admin_exists BOOLEAN;
  v_already_run  BOOLEAN;
BEGIN

  SELECT EXISTS (SELECT 1 FROM profiles WHERE id = v_admin)
    INTO v_admin_exists;

  IF NOT v_admin_exists THEN
    RAISE EXCEPTION 'migration 017: admin UUID % missing from profiles — apply 008 first', v_admin;
  END IF;

  SELECT EXISTS (SELECT 1 FROM listings WHERE slug = v_probe_slug)
    INTO v_already_run;

  IF v_already_run THEN
    RAISE NOTICE 'migration 017: seed_maia_listings already executed (probe slug present) — skipping';
    RETURN;
  END IF;

  PERFORM seed_maia_listings(v_admin);
  RAISE NOTICE 'migration 017: seed_maia_listings(%) executed', v_admin;

END $$;

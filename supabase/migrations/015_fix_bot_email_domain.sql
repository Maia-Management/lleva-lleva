-- =============================================================
-- LlevaLleva Migration 015 — Correct bot email domain
--
-- Migrations 007, 008 and 010 seed bot accounts with emails
-- under @llevalleva.co (and @internal.llevalleva.co).
-- That domain does not exist. The correct apex is lleva-lleva.com.
--
-- These bot accounts have NULL encrypted_password and never
-- sign in by email, so the change is purely cosmetic — but
-- it removes a confusing inconsistency.
--
-- This migration is the live-DB fixup. The migration source
-- files are also updated so fresh seeds use the right domain
-- from the start.
--
-- Idempotent: running it again on already-corrected rows is a no-op.
-- =============================================================

UPDATE auth.users
   SET email = REPLACE(
                 REPLACE(email, '@internal.llevalleva.co', '@internal.lleva-lleva.com'),
                 '@llevalleva.co', '@lleva-lleva.com'
               ),
       updated_at = now()
 WHERE email LIKE '%@llevalleva.co'
    OR email LIKE '%@internal.llevalleva.co';

DO $$
DECLARE
  v_remaining INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_remaining
    FROM auth.users
   WHERE email LIKE '%@llevalleva.co'
      OR email LIKE '%@internal.llevalleva.co';

  IF v_remaining > 0 THEN
    RAISE WARNING 'migration 015: % auth.users rows still on llevalleva.co domain', v_remaining;
  ELSE
    RAISE NOTICE 'migration 015: bot email domain corrected to lleva-lleva.com';
  END IF;
END $$;

-- Replace the old public launch URL in listing descriptions.
-- Keep public listing copy on the canonical custom domain.

DO $$
DECLARE
  old_domain text := 'lleva' || 'lleva.co';
  canonical_domain text := 'lleva-lleva.com';
BEGIN
  UPDATE public.listings
  SET description = replace(
    replace(description, 'www.' || old_domain, 'www.' || canonical_domain),
    old_domain,
    canonical_domain
  )
  WHERE description LIKE '%' || old_domain || '%';
END $$;

# LlevaLleva — RLS Security Review & Fix

**Date:** 2026-04-15  
**Branch:** `security/rls-fix`  
**Author:** Claude Code (review this before merge)  
**Status:** STAGED — do NOT apply to production until Andrew signs off

---

## 1. Current State (as of 2026-04-15)

### What the migration file says vs. what production has

`supabase/migrations/001_schema.sql` defines `ENABLE ROW LEVEL SECURITY` and a basic policy set. However, the task brief states that **RLS is currently DISABLED on all tables in the production Supabase project** (`tweuhyqajcnzsqelbtwt.supabase.co`). This means the policies in `001_schema.sql` have never been applied to production, or were disabled after the fact.

**Risk level:** Critical (P0). Any caller with the anon key can `SELECT`, `INSERT`, `UPDATE`, or `DELETE` any row in any table.

### Tables identified and their RLS state

| Table                | RLS in 001_schema | RLS in production (reported) | Policies in 001_schema |
|---------------------|-------------------|------------------------------|------------------------|
| `profiles`          | Enabled           | Disabled                     | public read, own insert/update |
| `categories`        | Enabled           | Disabled                     | public read only |
| `locations`         | Enabled           | Disabled                     | public read only |
| `listings`          | Enabled           | Disabled                     | public active, own CRUD |
| `favorites`         | Enabled           | Disabled                     | own only |
| `contact_initiations` | Enabled         | Disabled                     | participants only |
| `transactions`      | Enabled           | Disabled                     | participants only |
| `ratings`           | Enabled           | Disabled                     | public read, own insert |
| `reports`           | Enabled           | Disabled                     | own insert only |
| `bot_accounts`      | **Not enabled**   | Disabled                     | None |
| `bot_posts`         | **Not enabled**   | Disabled                     | None |

---

## 2. Policy Model (implemented in `20260415_rls_policies.sql`)

### Access matrix

| Table                | anon (no login) | authenticated user | owner | admin |
|---------------------|-----------------|-------------------|-------|-------|
| `profiles`          | SELECT (active only) | SELECT all active | UPDATE own | full |
| `categories`        | SELECT (active only) | SELECT | — | full |
| `locations`         | SELECT (active only) | SELECT | — | full |
| `listings`          | SELECT active only | SELECT own (any status) | INSERT / UPDATE / DELETE own | full |
| `favorites`         | None | — | SELECT / INSERT / DELETE own | SELECT |
| `contact_initiations` | None | INSERT own as buyer | SELECT own side | full |
| `transactions`      | None | INSERT as buyer | SELECT / UPDATE own | full |
| `ratings`           | SELECT | INSERT own | — | DELETE |
| `reports`           | None | INSERT own | — | full |
| `bot_accounts`      | SELECT (active) | — | — | full |
| `bot_posts`         | None | — | — | full |

**service_role** bypasses RLS entirely — no policy changes needed for the WhatsApp CRM bot.

### Admin role mechanism

Admins are identified by `app_metadata.role = 'admin'` in the Supabase JWT. To grant admin:

```javascript
// Server-side, using service_role key
const { error } = await supabase.auth.admin.updateUserById(userId, {
  app_metadata: { role: 'admin' }
});
```

This can only be set via the Auth Admin API (requires service_role key) — regular users cannot self-elevate.

### Key security guarantees

1. **Anonymous users cannot write anything** — all INSERT/UPDATE/DELETE require authentication.
2. **Listings are owner-only editable** — `seller_id` is immutable (USING + WITH CHECK both enforce `auth.uid() = seller_id`).
3. **Leads/contacts are never public** — `contact_initiations`, `transactions`, `favorites` return 0 rows to anon.
4. **Reports are admin-only readable** — no report data leaks to the public or the reported user.
5. **Ratings are public** — intentional, core trust signal for classifieds.
6. **Bot tables are admin/service_role only** — no public write access.

---

## 3. Bugs Fixed in This Migration

### Bug 1: `bot_accounts` and `bot_posts` had no RLS
These tables were created in `001_schema.sql` but had no `ENABLE ROW LEVEL SECURITY` and no policies. Any caller with the anon key could insert rows into `bot_accounts` (tied to `profiles`) or `bot_posts`.

### Bug 2: `fn_increment_view_count` silently fails under RLS
The listing view counter is incremented server-side from the Next.js server component using the anon key. With RLS active, `UPDATE listings` requires `seller_id = auth.uid()` — the anon user has no uid, so the UPDATE would silently do nothing (0 rows updated).

**Fix:** `fn_increment_view_count` is now `SECURITY DEFINER` with `search_path = public`. It runs as the definer role, bypassing RLS for this single narrow operation. This is safe because the function only touches `view_count` — it has no parameters other than the listing UUID, which is public knowledge.

### Bug 3: No admin moderation path
The original policies had no admin override. Any moderation action (remove a listing, ban a user) would require direct database access via service_role. The new migration adds `is_admin()` checks to all tables.

### Bug 4: Transactions `USING`-only policy allowed unbounded UPDATE
The original `transactions_participants` policy used `USING (auth.uid() = buyer_id OR auth.uid() = seller_id)` without a `FOR` clause. In Postgres, a policy without `FOR` applies to ALL operations — meaning both buyer and seller could DELETE transactions. The new migration separates SELECT, INSERT, UPDATE with explicit `FOR` clauses and restricts DELETE to admin-only.

---

## 4. Known Limitations (not fixed in this PR)

### Column-level exposure on `profiles`
PostgreSQL RLS operates at the row level only. The `profiles` table contains sensitive columns (`phone_hash`, `business_nit`, `whatsapp_number`, `pending_rating_transaction_id`) that are exposed to any authenticated user who can join profiles through a listing query.

**Current exposure:** `SELECT * FROM listings JOIN profiles ON seller_id = profiles.id` returns all profile fields to anon users (for active listings). This is because the existing app code does `.select("*, seller:profiles(*)")`.

**Correct fix:** Create a `profiles_public` view that selects only non-sensitive columns, and update all app queries to join via the view. This requires code changes across multiple pages and is out of scope for this migration — tracked as a separate security task (see Section 5).

---

## 5. Adjacent Security Issues Found

These are **not fixed in this PR** — flagged for separate follow-up:

1. **`middleware.ts` exports `proxy` instead of `middleware`**
   - File: `middleware.ts` line 6
   - The Next.js middleware export MUST be named `middleware`. The current export `async function proxy(...)` means the middleware is **not active**. Routes `/publicar` and `/dashboard` rely on server-component redirects for auth protection, but there is no edge-level gate.
   - Impact: Medium — the server component redirects work, but middleware is an expected defense-in-depth layer that silently isn't running.

2. **`seed-production.mjs` hardcodes the production Supabase URL**
   - File: `seed-production.mjs` line 10: `const SUPABASE_URL = 'https://tweuhyqajcnzsqelbtwt.supabase.co';`
   - The URL itself is not secret (it's in env vars as `NEXT_PUBLIC_SUPABASE_URL`), but hardcoding it removes the flexibility to change projects and makes the script fragile. Low severity, but should use `process.env.SUPABASE_URL`.

3. **No `.env.example` file**
   - Developers cloning the repo have no reference for required env vars. Missing vars (like `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`) cause silent auth failures.

4. **`profiles.whatsapp_number` exposed via joins**
   - Part of the column-level issue above. WhatsApp numbers are stored for seller contact — they should only be readable by the owner or admin, not by joining profiles to any listing query.
   - A malicious user could dump all seller WhatsApp numbers via: `SELECT seller:profiles(whatsapp_number) FROM listings WHERE status='active'`

5. **No rate limiting on `fn_increment_view_count`**
   - Anyone can increment view counts on any listing repeatedly. Should be mitigated with rate limiting at the API gateway (Supabase's built-in rate limits, or Cloudflare).

6. **`transactions_update_participants` allows financial field mutation**
   - The current UPDATE policy allows participants to modify `agreed_price`, `buyer_id`, `seller_id`, `listing_id`. Only status fields should be mutable after creation. Enforcement should be via a DB trigger that rejects changes to immutable fields.

---

## 6. Testing Plan

### Run locally (before applying to prod)

```bash
# 1. Start local Supabase
supabase start

# 2. Apply the migration
supabase db push
# or: psql postgresql://postgres:postgres@localhost:54322/postgres \
#     -f supabase/migrations/20260415_rls_policies.sql

# 3. Run pgTAP tests
psql postgresql://postgres:postgres@localhost:54322/postgres \
  -f supabase/tests/rls_policies_test.sql
```

### Expected output: 30/30 tests passing

### Manual smoke tests after applying

1. Open the site as a logged-out user → listings load ✓
2. Try to POST to `/rest/v1/listings` with anon key via curl → 403 ✓
3. Log in, create a listing → succeeds ✓
4. Try to update someone else's listing via curl with your token → 0 rows updated ✓
5. Open a listing page → view count increments ✓

### curl test snippets

```bash
SUPABASE_URL="https://tweuhyqajcnzsqelbtwt.supabase.co"
ANON_KEY="<your-anon-key>"

# Should return [] (empty array) — anon cannot see contact_initiations
curl "$SUPABASE_URL/rest/v1/contact_initiations?select=*" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $ANON_KEY"

# Should return [] — anon cannot see transactions
curl "$SUPABASE_URL/rest/v1/transactions?select=*" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $ANON_KEY"

# Should return 403 — anon cannot insert
curl -X POST "$SUPABASE_URL/rest/v1/listings" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"seller_id":"00000000-0000-0000-0000-000000000000","title":"test"}'
```

---

## 7. Exact Apply Command (production)

**Do NOT run until Andrew confirms.**

```bash
# Option A — via Supabase CLI (recommended, uses project linking)
supabase db push --db-url "postgresql://postgres.<project-ref>:<password>@aws-0-us-east-1.pooler.supabase.com:6543/postgres"

# Option B — via direct psql
psql "postgresql://postgres.<project-ref>:<password>@db.tweuhyqajcnzsqelbtwt.supabase.co:5432/postgres" \
  -f supabase/migrations/20260415_rls_policies.sql

# Option C — paste into Supabase Dashboard > SQL Editor
# (Copy the file contents and run it in the dashboard SQL editor)
```

**After applying:**
1. Run the manual curl smoke tests above against production.
2. Test the website end-to-end (browse listings, create a listing, check dashboard).
3. Verify the WhatsApp CRM bot can still create listings (uses service_role → bypasses RLS).
4. Monitor Supabase logs for any unexpected `RLS policy violation` errors for 24 hours.

---

## 8. Files Changed

| File | Type | Description |
|------|------|-------------|
| `supabase/migrations/20260415_rls_policies.sql` | New | Full RLS policy set, clean-slate migration |
| `supabase/tests/rls_policies_test.sql` | New | 30 pgTAP assertions covering all access scenarios |
| `RLS_SECURITY_SUMMARY.md` | New | This file |

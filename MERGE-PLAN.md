# Lleva Lleva Branch Unification Plan

Branch created for this planning work: `unified/merge-plan`

## Current State

- `origin/master` is the current working branch and contains the Phase 1-3 work.
- `origin/main` is a separate Codex restructure that moved the app into a `src/` directory layout.
- `git merge-base --all origin/master origin/main` returns no common ancestor. These are unrelated histories, not a normal divergence from a shared base.
- `origin/master` has 27 commits.
- `origin/main` has 21 commits.
- The current local worktree has pre-existing tracked deletions under `.claude/worktrees/`. Do not include those deletions in any merge or planning commit unless a separate cleanup task explicitly approves it.

## Log Comparison Summary

`origin/main` unique head sequence:

- `68a725b` Prepare LlevaLleva listings for launch
- `9a77170` fix: polish Lleva Lleva accessibility and SEO
- `2a8b978` route publish CTAs through login (#11)
- `8fe83c3` fix root loading layout shift (#10)
- `5f39370` fix mobile footer layout shift (#9)
- `41d7336` Merge pull request #8 from `codex/lleva-root-no-store-final`
- `8dcc191` Bypass Lleva root durable cache
- `9718292` Merge pull request #7 from `codex/lleva-footer-content-visibility`
- `aa4d393` Defer offscreen Lleva footer rendering
- `f8241f2` Merge pull request #6 from `codex/lleva-footer-layout-stability`
- `434df56` Stabilize Lleva mobile footer layout
- `335c16f` Merge pull request #5 from `codex/lleva-root-cache-control`
- `55dc2e2` Bust Lleva root HTML cache
- `917dc5d` Merge pull request #4 from `codex/lleva-skip-auth-without-session`
- `7c5b8fe` Skip navbar auth for anonymous visitors
- `090442c` Merge pull request #3 from `codex/lleva-defer-navbar-auth`
- `9e57a9a` Defer navbar auth loading
- `136d151` Fix Lleva page quality metadata (#2)
- `37ba0d7` Audit and harden Lleva Lleva
- `f10c98d` Add AdSense verification meta tag to metadata
- `4717e57` Initial commit: Lleva Lleva MVP

`origin/master` unique head sequence:

- `189fd9d` seo: add hreflang, robots meta, and JobPosting schema
- `3ca64f7` SEO: fix domain llevalleva.co in robots.ts + sitemap.ts; add static public/robots.txt fallback
- `113958c` Add cross-links: Maia ecosystem footer links + Work with us CTA
- `730578b` feat: fix middleware, categorias index, favorites, transaction initiation, dynamic sitemap, profile edit
- `30f8f3f` fix: correct domain from llevalleva.co to lleva-lleva.com in robots, sitemap, and layout
- `c5706ce` fix: WhatsApp contact routing + middleware default export
- `5185540` feat: floating WA button on all pages, fix WA CTA numbers
- `4d9613e` feat: add password reset page, sitemap, robots, gitignore fix
- `770b5e5` fix: WA number, consent banner, OG image, email addresses
- `19c8f83` fix: apply UX/CSS patches from batch audit
- `39fd293` fix: update WhatsApp button to AI bot number
- `ac2c370` fix: UX improvements - empty state, reduced motion, accessibility
- `52f4432` Merge branch 'master' of https://github.com/MaiaManagement/llevalleva
- `2d67fd8` Add ads.txt for Google AdSense compliance
- `f7aa317` Add ads.txt for Google AdSense compliance
- `7c2b573` fix: rename proxy.ts to middleware.ts, remove hardcoded service key, fix sitemap domain
- `c903495` Add sitemap.ts and robots.txt
- `c6cf880` Add AdSense ad placements across site and move script to head
- `6303f6b` Fix category page 404s by correcting slugs to match production database
- `6881715` Add Google AdSense ad unit placements across site

## Net-New Files From `main/src/`

These files exist in `origin/main:src/` and are missing from `origin/master` even after stripping the leading `src/` path. Treat these as the main net-new feature inventory from the Codex restructure:

- `src/app/about/page.tsx`
- `src/app/auth/callback/route.ts`
- `src/app/auth/login/LoginClient.tsx`
- `src/app/favorites/page.tsx`
- `src/app/listings/[id]/edit/page.tsx`
- `src/app/listings/[id]/page.tsx`
- `src/app/listings/new/page.tsx`
- `src/app/listings/page.tsx`
- `src/app/not-found.tsx`
- `src/app/privacy/page.tsx`
- `src/app/profile/[id]/page.tsx`
- `src/app/profile/page.tsx`
- `src/app/safety/page.tsx`
- `src/app/terms/page.tsx`
- `src/components/home/HomeContent.tsx`
- `src/components/layout/LanguageToggle.tsx`
- `src/components/layout/Navbar.tsx`
- `src/components/listings/CategoryFilter.tsx`
- `src/components/listings/CityFilter.tsx`
- `src/components/listings/DeleteListingButton.tsx`
- `src/components/listings/ImageGallery.tsx`
- `src/components/listings/ListingDetailContent.tsx`
- `src/components/listings/ListingForm.tsx`
- `src/components/listings/ReportButton.tsx`
- `src/components/listings/SearchBar.tsx`
- `src/components/profile/ProfileEditor.tsx`
- `src/components/profile/PublicProfileContent.tsx`
- `src/components/static/ContentPage.tsx`
- `src/components/ui/Badge.tsx`
- `src/components/ui/Button.tsx`
- `src/components/ui/Input.tsx`
- `src/components/ui/Modal.tsx`
- `src/components/ui/NotFoundContent.tsx`
- `src/components/ui/TranslatedText.tsx`
- `src/lib/constants.ts`
- `src/lib/i18n.ts`
- `src/lib/listing-data.ts`
- `src/lib/locale-context.tsx`
- `src/lib/types.ts`

Additional `origin/main:src/` files have root-layout equivalents on `origin/master` and need manual merging, not blind copying:

- `src/app/auth/login/page.tsx`
- `src/app/favicon.ico`
- `src/app/globals.css`
- `src/app/layout.tsx`
- `src/app/page.tsx`
- `src/app/robots.ts`
- `src/app/sitemap.ts`
- `src/components/layout/Footer.tsx`
- `src/components/listings/FavoriteButton.tsx`
- `src/components/listings/ListingCard.tsx`
- `src/components/listings/ListingGrid.tsx`
- `src/components/listings/WhatsAppButton.tsx`
- `src/lib/supabase/client.ts`
- `src/lib/supabase/server.ts`

## Main Structural Differences To Reconcile

- `master` uses root-level `app/`, `components/`, `lib/`, and `types/`.
- `main` uses `src/app/`, `src/components/`, and `src/lib/`.
- `master` has richer Phase 1-3 app surface: dashboard, publish flow, transactions, categories, profile edit, Spanish routes, sitemap/robots fixes, WhatsApp routing, AdSense, RLS and seed migrations.
- `main` has a cleaner `src/` architecture, app shell components, listing detail/form components, profile editor, i18n/locale context, static content helpers, stronger `next.config.ts` headers, root no-store cache headers, launch images, and recent performance/SEO polish commits.
- `master` package uses `next-intl`; `main` removes `next-intl`, adds `lucide-react`, changes `next build` to `next build --webpack`, adds `postcss`, and pins an override for Next/PostCSS.
- `main` has `next.config.ts` security headers, Supabase image remote patterns, `/index.html` redirect, and root no-store headers. `master` currently has a minimal Next config.

## Safe Unification Steps

1. Stop new work on `main` and `master` during the integration window.
2. Create backup refs without rewriting either branch:
   - `git tag backup/lleva-master-before-unify origin/master`
   - `git tag backup/lleva-main-before-unify origin/main`
   - Push both tags.
3. Work in a fresh clean clone or worktree. Do not use the current dirty local worktree for integration because of the existing `.claude/worktrees` deletion state.
4. Create the integration branch from `origin/master` because it is the declared working branch with Phase 1-3:
   - `git switch -c unified/src-integration origin/master`
5. Make a dedicated cleanup decision before code integration:
   - If `.claude/worktrees/` and `.netlify/` artifacts are not intended source, remove them in one explicit cleanup commit on the integration branch.
   - If they are needed for historical debugging, leave them untouched and add ignore rules for generated future artifacts only.
6. Migrate the master layout to `src/` with `git mv`, preserving history:
   - `git mv app src/app`
   - `git mv components src/components`
   - `git mv lib src/lib`
   - Move `types/` only if imports expect it under `src/`; otherwise keep it root-level.
   - Run `npm install`, `npm run lint`, and `npm run build` after this move before adding any `main` files.
7. Bring over `main` config improvements manually:
   - Merge `next.config.ts` security headers, Supabase image patterns, `/index.html` redirect, and root no-store cache headers.
   - Merge `package.json` additions deliberately: `lucide-react`, `postcss`, `next build --webpack`, and the Next/PostCSS override only if required by the current installed Next version.
   - Preserve `next-intl` if master still uses it after the layout move; remove it only after a search confirms it is unused.
8. Port net-new `main/src` features listed above into the migrated `src/` tree.
   - Keep master route names where they are already public and indexed.
   - Add redirects or compatibility pages where `main` introduced different routes such as `/listings/*` while master uses `/listing/*`, `/publicar`, `/perfil`, etc.
9. Manually merge files with master equivalents:
   - `src/app/layout.tsx`, `src/app/page.tsx`, `src/app/globals.css`
   - `src/app/robots.ts`, `src/app/sitemap.ts`
   - `src/components/layout/Footer.tsx`
   - `src/components/listings/FavoriteButton.tsx`, `ListingCard.tsx`, `ListingGrid.tsx`, `WhatsAppButton.tsx`
   - `src/lib/supabase/client.ts`, `src/lib/supabase/server.ts`
   Preserve master production fixes first, then port main improvements where they do not regress public routes.
10. Reconcile Supabase and data files conservatively:
   - Keep master migrations `001` through `013` and transaction/RLS work.
   - Compare `origin/main:supabase-schema.sql` against master migrations and port only missing schema elements in a new migration.
   - Do not replace migration history wholesale.
11. Add `main` public assets that are not present on master:
   - `public/images/*.jpg` launch/listing images
   - `public/og-image.svg`
   - `public/favicon.svg`
   Confirm image usage from the ported components before committing large assets.
12. Run verification before any PR:
   - `npm install`
   - `npm run lint`
   - `npm run build`
   - Local smoke test key routes: `/`, `/categorias`, `/categorias/[slug]`, `/listing/[slug]`, `/publicar`, `/dashboard`, `/perfil/[username]`, `/auth/login`, `/auth/register`, `/auth/reset-password`, `/buscar`, `/contacto`, `/privacidad`, `/terminos`
   - Smoke test any newly retained `main` routes: `/listings`, `/favorites`, `/profile`, `/safety`, `/about`, `/privacy`, `/terms`
13. Open a PR from `unified/src-integration` into `master`.
14. After the PR merges, unify branch policy without force-pushing:
   - Either change the GitHub default branch to `master` and mark `main` as archived/deprecated in a README note, or
   - Open a normal PR from updated `master` into `main` so both branch tips converge through a regular merge commit.
   - Do not force-push and do not delete `main` or `master`.

## Commands Used For This Plan

```powershell
git fetch --prune
git switch -c unified/merge-plan
git merge-base --all origin/master origin/main
git log --oneline --decorate --left-right --cherry-pick origin/master...origin/main -n 80
git rev-list --count origin/master
git rev-list --count origin/main
git ls-tree -r --name-only origin/main -- src
git ls-tree -r --name-only origin/master
```

## Do Not Do

- Do not run `git merge origin/main --allow-unrelated-histories` directly on `master`.
- Do not stage the current `.claude/worktrees` tracked deletions as part of unification.
- Do not force-push either branch.
- Do not delete `main`, `master`, or historical refs.

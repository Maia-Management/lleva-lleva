# LlevaLleva — Finish Plan 2026-06-28

**Operator:** Claude (specialist session, Opus 4.7 per `feedback_opus_4_7_is_fine_2026_06_22` directive)
**Branch:** `llevalleva-finish-2026-06-28` off `master` (HEAD `116f6c8` ftfy mojibake sweep)
**Scope discipline:** Hygiene-only — site is **PAUSED TO PUBLIC** per Andrew. **DO NOT** reactivate brand for public, **DO NOT** touch the paywall/monetization spec (see [Boundaries](#boundaries)).

---

## 1 — What was already done (prior work, NOT to redo)

| Date | Commit / Doc | What it shipped |
|---|---|---|
| 2026-06-27 | `30c678e` | Stripped `X-Powered-By: Next.js` at Netlify edge (re-injected by `@netlify/plugin-nextjs`) |
| 2026-06-27 | `116f6c8` | ftfy mojibake sweep — 5 files; cp1252 round-trip corruption (smart quotes, em-dashes, ellipses, arrows) |
| 2026-06-25 | `fdb18da` | `/images/placeholder.jpg` added |
| 2026-06-22 | `f0a5097` | Footer ecosystem extended (The Maia Group umbrella + Botánicas + Be Vida) |
| 2026-06-21 | (Drive) `LLEVA-LLEVA-TRIPLE-AUDIT-2026-06-21.md` | 7-PR perfection pass authored — only **escrow_disputes RLS** is a blocker; rest deferred until post-Sanatorio (30 jul) |
| 2026-06-20 | (Drive) `LLEVA-LLEVA-MONETIZATION-SPEC-2026-06-20.md` | Wompi paid features (Featured $5k / Urgent $20k / Power $20k bundle) — **status: SPEC — do NOT deploy** |
| 2026-06-04 | (Drive) `BRAND-BIBLE-lleva-lleva-v3-2026-06-04-AM.md` | Brand canon |

Today's pass is downstream of all of the above and does NOT duplicate any of it.

---

## 2 — What we found in this pass

### Live-site walk (lleva-lleva.com, mobile 390×844)
- ✅ Home renders cleanly. 0 console errors/warnings. 9/9 images lazy-loaded. 1 H1. 2 JSON-LDs (Org + WebSite). Mobile sticky header with search. Cookie banner present (Ley 1581).
- ✅ Headers good: HSTS, CSP, X-Content-Type-Options, Referrer-Policy, Permissions-Policy, X-Frame-Options. **`X-Powered-By: Next.js` NOT leaked** (the 06-27 fix is holding live).
- ✅ Robots.txt blocks GPTBot, ChatGPT-User, Google-Extended, CCBot, anthropic-ai, Claude-Web, ClaudeBot, FacebookBot, Omgilibot. Allows /, blocks /auth and /dashboard.
- ✅ Sitemap.xml renders.
- ✅ WhatsApp float → `wa.me/19034598763` (ecosystem bot number — correct per CLAUDE.md).
- ✅ Footer ecosystem includes Maia Botánicas (validates the Botánicas product-lineage memory — Asa Sando + Maison Yumi sold through this surface).
- ✅ Listing page has JobPosting JSON-LD when category is job-related.
- ✅ `/seguridad` (33k chars), `/privacidad`, `/terminos` all render with title + description + breadcrumb.
- ✅ `/buscar?q=…` returns proper "Resultados para "…"" page.

### Hygiene bugs found (real, fix-now)
- **H1 — `/cuanto-vale` page title is doubled.** Live title is `Calculadora de precios para vender en Colombia | LlevaLleva | Lleva Lleva`. Source: `app/cuanto-vale/page.tsx:6` includes a manual `| LlevaLleva` suffix, but `app/layout.tsx:13` already applies the template `"%s | Lleva Lleva"`. Result: brand suffix appended twice.
- **H2 — JSON-LD claims Venezuela coverage.** `app/layout.tsx:106-107` WebSite JSON-LD says `"Clasificados generales en Colombia y Venezuela"` and `inLanguage: ["es-CO", "es-VE"]`. The site does not serve Venezuela (no .ve TLD, no VE listings, footer says "Hecho en Colombia", `addressCountry: "CO"`). False signal to crawlers.
- **H3 — Bogus `en` hreflang.** `app/layout.tsx:25-28` declares `en` and `x-default` both pointing to the Spanish URL. Google guidance: `en` hreflang must point to an actual English page; pointing it at a Spanish page is a misuse and risks confusing Search localization. Site is Spanish-only — keep `es` + `x-default`, drop `en`.
- **H4 — Mixed HTML-entity encoding in footer.** `components/layout/Footer.tsx:36,68` uses `Informaci&oacute;n p&uacute;blica` and `Maia Bot&aacute;nicas`. JSX renders entity refs (live HTML shows correct accented chars), but the source is inconsistent with line 23–27 (`Vehículos`, `Tecnología` as Unicode literals) and the 2026-06-27 ftfy mojibake sweep normalized everything to Unicode literals. Just file hygiene + consistency.

### Lower-priority cosmetic findings (not in this PR)
- Home page has two `<AdBanner slot="" />` calls (`app/page.tsx:145,254`) — the component coerces empty slot to `"auto"` so they don't crash, but they signal placeholders that were never wired to real AdSense slot ids. Out of scope (touching AdSense wiring on a paused site is the wrong moment).
- Listing `og:image` falls back to the site logo when the listing has no images. The current 16 visible listings are all El-Sanatorio "SE BUSCA" / hiring posts seeded without images, so every share-preview is the LlevaLleva logo. Fixing this is a *data* problem (seed those listings with images), not a code problem.
- Generic listing meta description (`"Consulta este anuncio en Lleva Lleva, el clasificado colombiano…"`) is the fallback when Supabase doesn't return a `meta_description`. Same data caveat.
- `/favicon.svg` returns 404 on the live site even though `public/favicon.svg` exists (Next.js prefers `app/favicon.ico`). Nothing currently references `/favicon.svg` in HTML, so harmless — leave for a later cleanup.

### Verified NON-issues (false positives I chased and dropped)
- **"`Vehiculos` missing accent in title."** Live title is `Vehiculos – Clasificados Colombia`. Looked like an accent-strip bug, but `app/categorias/[slug]/page.tsx:31` uses `data.name_es` from Supabase when available — the unaccented form means the **`categories` row for `vehiculos` has `name_es='Vehiculos'`** (data layer), not a code bug. Out of scope for hygiene. (For comparison: the home category grid uses a hard-coded `TOP_CATEGORIES` array in `app/page.tsx:15` with correct accents, and footer uses correct accents too.)
- **`/cuanto-vale` H1 "cobrarpor" with no space.** Source uses `¿Cuánto debería cobrar<br />por esto?`. Visually a line break (correct). The missing space was a `textContent` extraction artifact in my probe — not a real bug.
- **`/categorias/vehiculos` H1 "Vehiculos(2 anuncios)" no space.** Same — `<span className="ml-2">` adds visual margin; `textContent` collapses it. Not a real bug.

---

## 3 — Boundaries (what NOT to touch)

Per CLAUDE.md, the user's prompt, and the recent Drive canon:

- **Don't reactivate the brand for public.** Site is paused — keep the existing footer + cookie banner + WhatsApp posture, don't add launch CTAs, press kits, or "we're live" copy.
- **Don't touch the monetization paywall.** `LLEVA-LLEVA-MONETIZATION-SPEC-2026-06-20.md` is explicitly *do-not-deploy* until after El Sanatorio launch (30 jul). No `listing_boosts` table, no Wompi-charge flow, no Featured/Urgent badges in this PR.
- **Wompi-only.** Stripe is reserved to HireViaMaia (carve-out under `maia-management/marketplace/` per CLAUDE.md). No Stripe in LlevaLleva. Verified — `Grep Stripe` over the repo returns zero matches. ✓
- **Don't replace WhatsApp CTA numbers with personal numbers.** Bot number `wa.me/19034598763` is the only public CTA. ✓
- **Next.js 16 caution.** `AGENTS.md` warns this repo runs Next.js 16.2.6 + React 19.2.4 with API shifts vs older docs. Hygiene fixes in this pass touch only `Metadata` literals and JSON-LD constants — both stable across Next 13→16.
- **Don't redo the 7-PR perfection-pass work.** It's authored but parked. The only blocker noted there is the `escrow_disputes` RLS policy, which lives in the paywall code that's not deployed — irrelevant to this hygiene pass.

---

## 4 — Fix list (hygiene-only, applied in this PR)

| # | File | Change |
|---|---|---|
| F1 | `app/cuanto-vale/page.tsx` | Drop manual `| LlevaLleva` suffix from `metadata.title` — the layout template adds it |
| F2 | `app/layout.tsx` | WebSite JSON-LD: drop Venezuela mention from `description`; `inLanguage` → `["es-CO"]` only |
| F3 | `app/layout.tsx` | `alternates.languages`: drop `en` entry, keep `es` + `x-default` |
| F4 | `components/layout/Footer.tsx` | Replace `&oacute;` / `&aacute;` HTML entities with Unicode literals (`ó`, `á`) to match the rest of the file |
| F5 | `robots.txt` (repo root) | Delete. The dynamic `app/robots.ts` is the authoritative source and is what gets served from `/robots.txt`. The repo-root file is a leftover from before the dynamic route existed — it's never served and only confuses editors. (`public/robots.txt` was already deleted in a prior pass; this is the last stale copy.) Originally flagged as P0-4 in `AUDIT-2026-05-15.md`. |

That's the entire surface area for this PR. Total expected diff: ~12 lines across 3 files + 1 file deletion. Zero behavior change visible to users; cleaner crawler signals; consistent encoding.

### Other still-open items from `AUDIT-2026-05-15.md` (verified status today)

| Audit item | Status 2026-06-28 |
|---|---|
| P0-1 `GEMINI_API_KEY` not documented | ✅ Fixed (`d719629` 2026-06-01, README + `.env.example`) |
| P0-2 `/api/price-check` Netlify-only | ✅ Fixed (`app/api/price-check/route.ts` appears in build output) |
| P0-3 Duplicate WebSite JSON-LD on home | ✅ Fixed (`app/page.tsx` no longer emits its own JSON-LD) |
| P0-4 Conflicting robots.txt | ⚙️ This PR — F5 removes the last stale copy |
| P1-1 `ajsgallie@gmail.com` in `consent-banner.js` | ✅ Fixed (no longer in `public/`) |
| P1-2 Twitter handle inconsistency (`@MaiaGroupCO` vs `@llevalleva`) | ⏸️ Deferred — see Question 7 |
| P1-3 Venezuela in JSON-LD | ⚙️ This PR — F2 |
| P1-4 Empty AdBanner slots | ⏸️ Out of scope (paused site — fix at un-pause with real slot ids) |
| P1-5 Stale 2024 financial data | ✅ Fixed (`2855292` 2026-04-XX, "refresh Información Pública to 2026 values") |
| P1-6 "Próximamente" placeholder pages | ✅ Fixed (no matches in `app/`) |
| P1-7 Root metadata description undersells categories | ⏸️ Copy decision for Andrew — see Question 8 |

---

## 5 — Clarifying questions for Andrew (deferred decisions)

These would change the scope of a *next* pass — not blocking this PR:

1. **Brand-reactivation timing.** When LlevaLleva un-pauses, do we want the home hero to mention "ahora en vivo" / "open beta" copy, or stay on the current evergreen "Compra y vende en toda Colombia"? (Affects `app/page.tsx`.)
2. **`categories.name_es` data fix.** The Supabase categories rows have unaccented `name_es` (`Vehiculos`, `Nautico y Pesca`, etc. — inferred from live titles). Should a seed-migration normalize those to accented form? This is a one-off SQL update, not a code change.
3. **Product/Offer JSON-LD for non-job listings.** The 2026-21 competitive scan flags this as table-stakes for classifieds sites in 2026. Building it well needs choices per vertical (Product+Offer for goods, RealEstateListing for inmuebles, Vehicle for vehículos) — worth its own scoped PR after un-pause. Want me to design that?
4. **Seed listings without images.** All current "SE BUSCA: …" El-Sanatorio listings share the generic LlevaLleva logo as their `og:image` because the seed has no `images[]`. Should the seed pull a representative photo per listing (so WhatsApp/FB shares look real), or leave the logo until un-pause? (Data, not code.)
5. **PWA install.** The 7-PR audit ships a PWA manifest + push (`PR7`). Status today: not in `master`. Do we want PWA install + push as a separate pass before un-pause, or roll it in with the monetization phase?
6. **`maia_consent` localStorage key.** The cookie banner stores consent under `maia_consent`. Is the same key used across the ecosystem (Sushi Pop, El Sanatorio, etc.) so a user who consents once is recognized everywhere? Out of scope for this PR but worth confirming.
7. **Twitter card handles.** `app/layout.tsx:58-59` uses `twitter.site = '@MaiaGroupCO'` and `creator = '@llevalleva'`. `app/cuanto-vale/page.tsx:38-39` uses `@llevalleva` for both. Twitter convention allows site≠creator (site = publisher org, creator = author/brand), so this isn't *strictly* a bug, but the layout/page disagreement looks accidental. Which is canonical — does `@MaiaGroupCO` actually exist as a handle, or should everything normalize to `@llevalleva`? (Did not change — needs a real decision, not a guess.)
8. **Homepage metadata description undersells 16 categories.** `app/layout.tsx:17` and `app/page.tsx:10` both list 4 of 16 categories ("Vehículos, inmuebles, tecnología, náutico y más"). Want the snippet expanded to mention empleo/servicios/mascotas/agro so those searches surface, or keep tight? (Copy decision.)

---

## 6 — Verification plan for this PR

After the 4 fixes:

- `npm run lint` clean
- `npm run build` succeeds (Next.js 16 + webpack — package.json:5)
- Re-walk live site after deploy: re-check title on `/cuanto-vale`, re-check JSON-LD on home, re-check hreflang, re-check footer rendered text on `/`
- Two consecutive clean passes (per the loop directive) before opening PR

---

## 7 — Out-of-scope research deliverables shipped alongside

Two read-only research docs land beside this plan for the team's reference (NOT part of the code fix):

- `LLEVALLEVA-COMPETITIVE-BENCHMARK-2026-06-28.md` — fresh 2026 classifieds-platform scan (Mercado Libre, OLX, Facebook Marketplace, Metrocuadrado, Fincaraíz, TuCarro, CarroYa, Computrabajo, Vivanuncios, Domus). Covers the 2026 hygiene/quality bar a small site is measured against and what to steal vs. avoid. Citations inline.
- `LLEVALLEVA-DRIVE-INVENTORY-2026-06-28.md` — Drive-mirror map of every LlevaLleva / Botánicas / Asa Sando / Maison Yumi doc found on `G:\My Drive\…`. Surfaces the existing canon (BRAND-BIBLE v3, TRIPLE-AUDIT, MONETIZATION-SPEC, BOTANICAS-AUDIT 06-24) and notes that `09-PRODUCT-LINES/ASA-SANDO/` and `MAISON-YUMI/` are empty stubs while the real content lives in `_ARCHIVE-2026/2026-06-20-finish-mode-purge/maia-group-orphan-dirs/`.

---

*End plan.*

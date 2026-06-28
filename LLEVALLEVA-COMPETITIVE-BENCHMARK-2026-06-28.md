# LlevaLleva Competitive Benchmark — Colombian & LatAm Classifieds Platforms (2026)

*Research-only competitive scan for `lleva-lleva.com`, a small/mid general-classifieds site covering vehicles, real estate, tech, marine, services, jobs. Payment standard: Wompi-only per Maia ecosystem rule. Compiled 2026-06-28.*

---

## Mercado Libre Colombia — the dominant compounding giant

ML is the undisputed #1 e-commerce/fintech player in Colombia and LatAm, growing 45% YoY in Q4 2025 and 49% YoY in Q1 2026, explicitly via market-share gains ([BusinessWire Feb 2026](https://www.businesswire.com/news/home/20260224265595/en/)). Its **Clasificados** vertical (vehicles, real estate, services) runs on a **fixed monthly fee, no per-sale commission** model — and is the *only* place ML exposes seller contact info directly, not mediating the deal ([ML newsroom](https://news.mercadolibre.com/en/classified-ads-on-mercado-libre)). Trust moat: **Compra Protegida** escrow via Mercado Pago, plus a daily-recalculated color-coded seller reputation. Payments run through Mercado Pago (cards, PSE covering Nequi/Daviplata, Efecty cash).

- **Steal:** fixed-fee no-commission model for high-value verticals; lightweight daily reputation signal; clean category auto-suggest at posting.
- **Don't copy:** Compra Protegida escrow and the fintech wallet — capital, fraud-ops and compliance a small site can't float.

## OLX Colombia — the asset-light listings portal (closest analog)

OLX (Prosus/Adevinta) is active but secondary to ML and Facebook. Strategically it **retreated from the transactional model** — Prosus shut down OLX Autos transactional ops (incl. LatAm) ~2023 and reverted to a no-commission, no-payment listings portal ([Tekedia](https://www.tekedia.com/prosus-olx-buys-frances-la-centrale-in-e1-1bn-deal-taking-aim-at-rivals-in-europes-e-commerce-race/)). Globally healthy (FY2025 +18% revenue), and in 2025-2026 it shipped **GenAI posting forms (35-55% faster posting)** and **CompassGPT** conversational real-estate search ([Wikipedia: OLX](https://en.wikipedia.org/wiki/OLX)). No escrow, no integrated payments — direct in-app messaging that masks personal contact; fraud is handled by user education only.

- **Steal:** frictionless free-post flow (email + category + photos); in-app messaging that hides personal contact; ad-promotion as the monetization lever; location-based "near me" browsing; AI-assisted posting forms.
- **Don't copy:** the hands-off education-only fraud posture (steady scam reputation); a buggy native app — a small site is better with a fast PWA. The OLX Autos retreat is the cautionary tale: don't take on payment/inventory risk you can't underwrite.

## Facebook Marketplace — the volume leader with a trust hole

The de facto default for Colombian C2C (used goods, furniture, vehicles), 1B+ global monthly users. Structural weakness in Colombia: **no escrow, no integrated local payment.** Scammers move buyers Messenger → **WhatsApp**, then request an *adelanto/depósito* before delivery and vanish ([El País CO](https://www.elpais.com.co/tecnologia/estafas-en-facebook-marketplace-estas-son-las-modalidades-de-robo-mas-comunes-en-colombia-0447.html)). 2025-2026: Meta is layering AI — auto-generated listings, photo-based price suggestions, AI auto-replies, seller-profile summaries ([TechCrunch Nov 2025](https://techcrunch.com/2025/11/13/facebook-marketplace-gets-new-collaborative-and-social-features-meta-ai-integrations/)).

- **Steal:** photo-first frictionless listing, AI-assisted listing creation, seller-profile trust signals — and the WhatsApp handoff, but made *safe*.
- **Don't copy:** the deposit-before-delivery gap. A small site's wedge is exactly the safe, Wompi-backed contact rail Marketplace lacks.

## Real estate: Metrocuadrado, Fincaraíz, Tu Inmueble

**Ownership correction worth noting:** Metrocuadrado and CarroYa are now owned by **Grupo Aval's ADL Digital Lab** (acquired from El Tiempo Nov 2022, ~US$120M), *not* El Tiempo. **Fincaraíz** (Frontier Digital Ventures) is the #1 specialist portal — ~38.7M visits H1 2025, claims +100% traffic / +300% leads vs nearest rival ([Fincaraíz blog](https://fincaraiz.com.co/blog/noticias-fincaraiz/fincaraiz-el-portal-inmobiliario-lider-en-2025/)). **Tu Inmueble** is now effectively a legacy ML real-estate surface, not a standalone competitor. Vertical leaders win on **estrato filtering** (uniquely Colombian, table-stakes), m²/rooms/baths filters, map + GPS "near me" with price clustering, list/map toggle, compare-up-to-4, and "Inmueble Verificado" badges.

## Vehicles: TuCarro, CarroYa

**TuCarro** (owned by/merged into Mercado Libre) dominates — 1,000+ dealers, **Tour Virtual 360**, physical Bogotá Experience Center with plate/chassis verification, financing via Mezubo/Sufi-Bancolombia/Santander, no seller commission. **CarroYa** (Grupo Aval/ADL) is a strong #2 repositioned as a "garaje digital," differentiated by a **bank-quote financing simulator** across Grupo Aval banks. Filters that matter: brand, model, year, mileage, transmission, fuel, doors.

- **Steal:** structured vehicle filters; seller-uploaded phone video (not 360 rigs); trust/verification labels.
- **Don't copy:** 360 capture rigs and physical Experience Centers; in-house financing rails (these exist because ML and Grupo Aval *own banks*); CARFAX-grade history integrations.

## Jobs: Computrabajo

The dominant Colombian job board and largest Spanish-language network in LatAm (~8.8-13.8M monthly visits, ~120k listings) ([Jobboard Finder](https://www.jobboardfinder.com/jobboard-computrabajo-colombia)). Features: CV/profile, granular filters, **company review ratings + verification stamps**, salary-vs-market transparency, alert-driven push retention; freemium employer model with gated CV-database access.

- **Steal:** employer review + verification badges, salary transparency, job alerts/push, generous free tier with paid-visibility upsell.
- **Don't copy:** heavy mandatory-profile friction before applying; the stale-listing problem — keep inventory fresh.

## Vivanuncios — a cautionary tale, not a model

Effectively **defunct in Colombia.** Adevinta sold it to Navent (Sep 2022); it was narrowed to a Mexico-only real-estate brand under Inmuebles24. The `vivanuncios.com.co` domain lapsed and was repurposed into an unrelated betting site ([Adevinta release](https://adevinta.com/press-releases/adevinta-asa-ade-adevinta-sells-mexican-online-classifieds-businesses-segundamano-and-vivanuncios-to-navent-group/)). Lesson: defend your domain/brand and don't over-dilute across verticals/markets — the withdrawal leaves exactly the local-niche gap a focused site can fill.

## Domus.la — the supply-side signal

Not a portal — a **B2B real-estate CRM** that auto-syndicates one listing to Fincaraíz/Metrocuadrado/ML at once. Takeaway: professional inventory enters portals via bulk feeds, not one-by-one. A small portal that can ingest a Domus-style feed will attract dealer/agency inventory.

---

## The 2026 hygiene / quality bar (what a small site is measured against)

**TS = table stakes; NH = nice-to-have.**

| Area | Table stakes (2026) | Nice-to-have |
|---|---|---|
| **Structured data/SEO** | JSON-LD on each *leaf* listing — `Product`/`Offer`/`AggregateOffer`, `JobPosting` (both still rich-result-eligible); canonical URLs; XML sitemap of listings ([Google](https://developers.google.com/search/docs/appearance/structured-data/job-posting)) | Indexing API at high volume |
| **Images** | WebP default; responsive `srcset`; `width`/`height` to avoid CLS; lazy-load below fold, eager + `fetchpriority=high` on LCP image; LCP ≤2.5s / INP ≤200ms / CLS ≤0.1 ([SitePoint](https://www.sitepoint.com/image-optimization-for-core-web-vitals-in-2026-what-actually-moves-the-needle/)) | AVIF with fallback |
| **Anti-scam** | Visible report/flag flow on every listing; basic moderation; on-site scam guidance (overpayment, off-platform payment, advance-deposit) | Listing auto-moderation |
| **Verification** | Phone OTP at signup ([Regula](https://regulaforensics.com/blog/marketplace-identity-verification/)) | Gov-ID + selfie checks; verified-seller badges |
| **Payments** | WhatsApp-contact-only with explicit safety messaging is acceptable locally — OR **Wompi** (cards/PSE/Nequi/Bancolombia). Note Wompi is a *gateway, not escrow* ([Wompi docs](https://docs.wompi.co/en/docs/colombia/metodos-de-pago/)) | On-platform escrow/buyer protection |
| **Mobile/PWA** | Mobile-first responsive, HTTPS, fast first load | Full PWA installability (manifest, service worker, offline shell) |
| **Policy (legally required)** | Ley 1581/Decreto 1377: public privacy policy; prior express consent; honor access (10 days)/deletion (15 days); **register databases with SIC RNBD**; ToS. Penalties up to ~2,000 SMMLV ([Secure Privacy](https://secureprivacy.ai/blog/colombia-data-protection-law)) | — |

**Strategic bottom line:** The vertical leaders win on **fintech bundling and scale** (Mercado Libre and Grupo Aval literally own banks). LlevaLleva cannot and should not match that. Its defensible wedge is the gap Facebook Marketplace structurally leaves open: **local trust + a safe Wompi-backed contact flow layered on the WhatsApp handoff buyers already prefer**, plus the cheap, high-ROI mechanics every leader shares — structured per-vertical filters (incl. estrato), map/GPS "near me," verified-listing badges, frictionless photo-first posting, saved searches/favorites, and a "featured listing" boost as primary revenue. Avoid escrow, in-house financing, 360-capture rigs, and physical experience centers — all capital/scale traps.

---

## How LlevaLleva tracks against the 2026 hygiene bar (snapshot 2026-06-28)

| Area | LlevaLleva status | Gap (where applicable) |
|---|---|---|
| JSON-LD on listings | ✅ JobPosting for job categories; ❌ no Product/Offer for the other 14 categories | Add per-vertical schema (deferred — own PR) |
| Canonical URLs | ✅ Per-page canonical present | — |
| Sitemap | ✅ `/sitemap.xml` served, dynamic via `app/sitemap.ts` | — |
| Images | ✅ All 9 home-page images lazy-loaded; ✅ Supabase storage CDN; OG fallback to site logo when listing has no image | Switch storage to WebP-by-default; add `fetchpriority=high` to LCP image |
| Anti-scam | ✅ Safety tips card on every listing page; ✅ `/seguridad` page (33k chars); ✅ `/reportar` flow exists | OK |
| Verification | ⚠️ Supabase Auth (email/password); no phone OTP visible | Phone OTP at signup |
| Payments | ✅ Wompi-only ecosystem rule preserved (zero Stripe references in repo) | Wompi paid-listings spec exists but parked until post-Sanatorio |
| Mobile/PWA | ✅ Mobile-first responsive; HTTPS; HSTS preload; CSP | No PWA manifest / service worker yet (Drive PR7 has it parked) |
| Policy | ✅ `/privacidad`, `/terminos`, cookie banner (Ley 1581), `privacy@maia-management.com` contact | Confirm SIC RNBD database registration status (operational, not code) |

---

*End competitive benchmark.*

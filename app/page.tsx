import type { Metadata } from 'next';
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import ListingGrid from "@/components/listings/ListingGrid";
import AdBanner from "@/components/ads/AdBanner";
import { Listing } from "@/types";

export const metadata: Metadata = {
  title: 'Lleva Lleva – Clasificados Colombia',
  description: 'El clasificado colombiano. Compra, vende y conecta con personas de tu región. Vehículos, inmuebles, tecnología, náutico y más en lleva-lleva.com.',
};

const TOP_CATEGORIES = [
  { slug: "vehiculos", name: "Vehículos", icon: "🚗" },
  { slug: "inmuebles", name: "Inmuebles", icon: "🏠" },
  { slug: "tecnologia", name: "Tecnología", icon: "💻" },
  { slug: "nautico-y-pesca", name: "Náutico y Pesca", icon: "⛵" },
  { slug: "servicios", name: "Servicios", icon: "🛠️" },
  { slug: "hogar-y-jardin", name: "Hogar y Jardín", icon: "🏡" },
  { slug: "moda-y-belleza", name: "Moda y Belleza", icon: "👗" },
  { slug: "turismo-y-hospedaje", name: "Turismo", icon: "🌴" },
  { slug: "educacion-y-formacion", name: "Educación", icon: "📚" },
  { slug: "mascotas-y-animales", name: "Mascotas", icon: "🐾" },
  { slug: "deportes-y-fitness", name: "Deportes", icon: "⚽" },
  { slug: "empleo", name: "Empleo", icon: "💼" },
  { slug: "agro-y-campo", name: "Agro y Campo", icon: "🌾" },
  { slug: "negocios-e-industria", name: "Negocios", icon: "🏭" },
  { slug: "comunidad", name: "Comunidad", icon: "🤝" },
  { slug: "informacion-publica", name: "Info Pública", icon: "📢" },
];

const PUBLIC_INFO = [
  {
    icon: "📋",
    title: "Trámites DIAN",
    desc: "RUT, NIT, declaraciones y más",
    slug: "tramites",
  },
  {
    icon: "💰",
    title: "Precios de Referencia",
    desc: "Vehículos, inmuebles, servicios",
    slug: "precios-referencia",
  },
  {
    icon: "⚖️",
    title: "Tasas y Tarifas",
    desc: "Tasas legales vigentes Colombia",
    slug: "tasas",
  },
  {
    icon: "📰",
    title: "Noticias Locales",
    desc: "Lo más reciente de tu ciudad",
    slug: "noticias",
  },
];

export default async function HomePage() {
  const supabase = await createClient();

  const { data: featuredListings } = await supabase
    .from("listings")
    .select("*, seller:profiles(*), category:categories(*), location:locations(*)")
    .eq("status", "active")
    .eq("is_featured", true)
    .order("published_at", { ascending: false })
    .limit(8);

  const { data: recentListings } = await supabase
    .from("listings")
    .select("*, seller:profiles(*), category:categories(*), location:locations(*)")
    .eq("status", "active")
    .order("published_at", { ascending: false })
    .limit(16);

  return (
    <div>
      {/* Hero — solid Colombian blue with a subtle horizon glow.
          Yellow on the headline accent + yellow CTA carry the Colombian identity
          without the saturated emerald look. */}
      <section className="relative bg-brand-blue text-white overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-brand-blue via-brand-blue to-ink" aria-hidden="true" />
        <div className="absolute -top-24 -right-24 w-72 h-72 rounded-full bg-brand-yellow/10 blur-3xl" aria-hidden="true" />
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 py-14 sm:py-20">
          <div className="max-w-2xl">
            <h1 className="text-3xl sm:text-5xl font-black leading-[1.05] mb-4 tracking-tight">
              Compra y vende en<br />
              <span className="text-brand-yellow">toda Colombia</span>
            </h1>
            <p className="text-white/80 text-base sm:text-lg mb-8 max-w-xl leading-relaxed">
              El clasificado colombiano de confianza. Conectamos compradores y vendedores en tu región.
            </p>
            <div className="flex flex-col sm:flex-row gap-3">
              <Link
                href="/publicar"
                className="inline-flex items-center justify-center gap-2 bg-brand-yellow text-ink font-bold px-6 py-3 rounded-full hover:bg-brand-yellow-600 transition-colors text-sm sm:text-base shadow-lg shadow-black/10"
              >
                + Publicar gratis
              </Link>
              <Link
                href="/categorias/vehiculos"
                className="inline-flex items-center justify-center gap-2 border-2 border-white/30 text-white font-semibold px-6 py-3 rounded-full hover:bg-white/10 hover:border-white/50 transition-colors text-sm sm:text-base"
              >
                Ver anuncios
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Category Grid */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 py-8">
        <h2 className="text-lg font-bold text-ink mb-4">Explorar categorías</h2>
        <div className="grid grid-cols-4 sm:grid-cols-6 lg:grid-cols-8 gap-2 sm:gap-3">
          {TOP_CATEGORIES.map((cat) => (
            <Link
              key={cat.slug}
              href={`/categorias/${cat.slug}`}
              className="flex flex-col items-center gap-1.5 p-2 sm:p-3 bg-surface rounded-xl border border-line hover:border-brand-blue/40 hover:bg-brand-blue-50/40 hover:shadow-sm transition-all text-center group"
            >
              <span className="text-2xl sm:text-3xl">{cat.icon}</span>
              <span className="text-[10px] sm:text-xs font-medium text-ink-2 group-hover:text-brand-blue leading-tight">
                {cat.name}
              </span>
            </Link>
          ))}
        </div>
      </section>

      {/* Ad between category grid and featured listings */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-2">
        <AdBanner slot="" format="horizontal" />
      </div>

      {/* Featured listings */}
      {featuredListings && featuredListings.length > 0 && (
        <section className="max-w-7xl mx-auto px-4 sm:px-6 py-4">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-bold text-ink flex items-center gap-2">
              <span className="inline-block w-1.5 h-5 rounded-full bg-brand-red" aria-hidden="true" />
              Anuncios destacados
            </h2>
          </div>
          <ListingGrid listings={featuredListings as Listing[]} showAds />
        </section>
      )}

      {/* Ad banner between featured and recent listings */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-2">
        <AdBanner slot={process.env.NEXT_PUBLIC_ADSENSE_SLOT_HOMEPAGE_BANNER ?? ''} format="horizontal" />
      </div>

      {/* Recent listings */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 py-4">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-bold text-ink flex items-center gap-2">
            <span className="inline-block w-1.5 h-5 rounded-full bg-brand-blue" aria-hidden="true" />
            Anuncios recientes
          </h2>
        </div>
        <ListingGrid
          listings={(recentListings as Listing[]) ?? []}
          emptyMessage="Sé el primero en publicar un anuncio en LlevaLleva."
          showAds
        />
        {/* Ad banner below recent listings */}
        <div className="mt-6">
          <AdBanner slot={process.env.NEXT_PUBLIC_ADSENSE_SLOT_HOMEPAGE_FEED ?? ''} format="auto" />
        </div>
      </section>

      {/* ¿Cuánto vale? Tool Card */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 py-6">
        <Link
          href="/cuanto-vale"
          className="group flex flex-col sm:flex-row items-start sm:items-center gap-4 bg-gradient-to-br from-emerald-50 to-blue-50 border border-emerald-200 hover:border-emerald-400 rounded-2xl p-5 sm:p-6 transition-all hover:shadow-md"
        >
          <div
            className="flex-shrink-0 w-12 h-12 rounded-xl flex items-center justify-center text-2xl"
            style={{ background: 'linear-gradient(135deg, #FCD116 0%, #003893 60%, #CE1126 100%)' }}
            aria-hidden="true"
          >
            💰
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-xs font-bold text-emerald-700 uppercase tracking-wider mb-1">
              Herramienta gratuita
            </p>
            <h2 className="text-base sm:text-lg font-black text-gray-900 leading-tight mb-1">
              ¿Cuánto debería cobrar por esto?
            </h2>
            <p className="text-sm text-gray-500 leading-snug">
              Consulta precios reales de Mercado Libre, OLX y Facebook Marketplace Colombia en segundos.
            </p>
          </div>
          <span className="hidden sm:inline-flex items-center gap-1 text-emerald-700 font-semibold text-sm flex-shrink-0 group-hover:gap-2 transition-all">
            Consultar precios <span aria-hidden="true">→</span>
          </span>
        </Link>
      </section>

      {/* Public Info Section */}
      <section className="bg-surface border-t border-b border-line mt-8">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 py-8">
          <h2 className="text-lg font-bold text-ink mb-2">Información Pública</h2>
          <p className="text-sm text-ink-2/80 mb-5">
            Consulta precios de referencia, trámites y noticias actualizadas de Colombia.
          </p>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
            {PUBLIC_INFO.map((item) => (
              <Link
                key={item.slug}
                href={`/info/info-publica/${item.slug}`}
                className="flex flex-col gap-2 p-4 bg-bg rounded-xl border border-line hover:bg-brand-blue-50/60 hover:border-brand-blue/30 transition-all"
              >
                <span className="text-2xl">{item.icon}</span>
                <div>
                  <p className="font-semibold text-sm text-ink">{item.title}</p>
                  <p className="text-xs text-ink-2/70 mt-0.5">{item.desc}</p>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* Ad below public info section */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-4">
        <AdBanner slot="" format="auto" />
      </div>

      {/* Trust section */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 py-12">
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-6 text-center">
          <div className="p-6">
            <div className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-brand-blue-50 text-brand-blue mb-3 text-2xl" aria-hidden="true">🔒</div>
            <h3 className="font-bold text-ink mb-1">Seguro y confiable</h3>
            <p className="text-sm text-ink-2/80">Sistema de calificaciones verificadas para compradores y vendedores.</p>
          </div>
          <div className="p-6">
            <div className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-brand-blue-50 text-brand-blue mb-3 text-2xl" aria-hidden="true">💬</div>
            <h3 className="font-bold text-ink mb-1">Contacto directo</h3>
            <p className="text-sm text-ink-2/80">Conecta directamente por WhatsApp con el vendedor, sin intermediarios.</p>
          </div>
          <div className="p-6">
            <div className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-brand-blue-50 mb-3 text-2xl" aria-hidden="true">🇨🇴</div>
            <h3 className="font-bold text-ink mb-1">Hecho en Colombia</h3>
            <p className="text-sm text-ink-2/80">Plataforma diseñada para el mercado colombiano, en español.</p>
          </div>
        </div>
      </section>
    </div>
  );
}

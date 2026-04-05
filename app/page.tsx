import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import ListingGrid from "@/components/listings/ListingGrid";
import { Listing } from "@/types";

const TOP_CATEGORIES = [
  { slug: "vehiculos", name: "Vehículos", icon: "🚗" },
  { slug: "inmuebles", name: "Inmuebles", icon: "🏠" },
  { slug: "tecnologia", name: "Tecnología", icon: "💻" },
  { slug: "nautico", name: "Náutico y Pesca", icon: "⛵" },
  { slug: "servicios", name: "Servicios", icon: "🛠️" },
  { slug: "hogar", name: "Hogar y Jardín", icon: "🏡" },
  { slug: "moda", name: "Moda y Belleza", icon: "👗" },
  { slug: "turismo", name: "Turismo", icon: "🌴" },
  { slug: "educacion", name: "Educación", icon: "📚" },
  { slug: "mascotas", name: "Mascotas", icon: "🐾" },
  { slug: "deportes", name: "Deportes", icon: "⚽" },
  { slug: "empleo", name: "Empleo", icon: "💼" },
  { slug: "agro", name: "Agro y Campo", icon: "🌾" },
  { slug: "negocios", name: "Negocios", icon: "🏭" },
  { slug: "comunidad", name: "Comunidad", icon: "🤝" },
  { slug: "info-publica", name: "Info Pública", icon: "📢" },
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
      {/* Hero */}
      <section className="bg-gradient-to-br from-emerald-600 to-emerald-800 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 py-12 sm:py-16">
          <div className="max-w-2xl">
            <h1 className="text-3xl sm:text-4xl font-black leading-tight mb-3">
              Compra y vende en<br />
              <span className="text-emerald-200">toda Colombia</span>
            </h1>
            <p className="text-emerald-100 text-base sm:text-lg mb-8">
              El clasificado colombiano de confianza. Conectamos compradores y vendedores en tu región.
            </p>
            <div className="flex flex-col sm:flex-row gap-3">
              <Link
                href="/publicar"
                className="inline-flex items-center justify-center gap-2 bg-white text-emerald-700 font-bold px-6 py-3 rounded-full hover:bg-emerald-50 transition-colors text-sm sm:text-base"
              >
                + Publicar gratis
              </Link>
              <Link
                href="/categorias/vehiculos"
                className="inline-flex items-center justify-center gap-2 border-2 border-white/40 text-white font-semibold px-6 py-3 rounded-full hover:bg-white/10 transition-colors text-sm sm:text-base"
              >
                Ver anuncios
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Category Grid */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 py-8">
        <h2 className="text-lg font-bold text-gray-800 mb-4">Explorar categorías</h2>
        <div className="grid grid-cols-4 sm:grid-cols-6 lg:grid-cols-8 gap-2 sm:gap-3">
          {TOP_CATEGORIES.map((cat) => (
            <Link
              key={cat.slug}
              href={`/categorias/${cat.slug}`}
              className="flex flex-col items-center gap-1.5 p-2 sm:p-3 bg-white rounded-xl border border-gray-200 hover:border-emerald-300 hover:shadow-sm transition-all text-center group"
            >
              <span className="text-2xl sm:text-3xl">{cat.icon}</span>
              <span className="text-[10px] sm:text-xs font-medium text-gray-600 group-hover:text-emerald-700 leading-tight">
                {cat.name}
              </span>
            </Link>
          ))}
        </div>
      </section>

      {/* Featured listings */}
      {featuredListings && featuredListings.length > 0 && (
        <section className="max-w-7xl mx-auto px-4 sm:px-6 py-4">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-bold text-gray-800">⭐ Anuncios destacados</h2>
          </div>
          <ListingGrid listings={featuredListings as Listing[]} />
        </section>
      )}

      {/* Recent listings */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 py-4">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-bold text-gray-800">Anuncios recientes</h2>
        </div>
        <ListingGrid
          listings={(recentListings as Listing[]) ?? []}
          emptyMessage="Sé el primero en publicar un anuncio en LlevaLleva."
        />
      </section>

      {/* Public Info Section */}
      <section className="bg-white border-t border-b border-gray-200 mt-8">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 py-8">
          <h2 className="text-lg font-bold text-gray-800 mb-2">Información Pública</h2>
          <p className="text-sm text-gray-500 mb-5">
            Consulta precios de referencia, trámites y noticias actualizadas de Colombia.
          </p>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
            {PUBLIC_INFO.map((item) => (
              <Link
                key={item.slug}
                href={`/info/info-publica/${item.slug}`}
                className="flex flex-col gap-2 p-4 bg-gray-50 rounded-xl hover:bg-emerald-50 hover:border-emerald-200 border border-gray-200 transition-all"
              >
                <span className="text-2xl">{item.icon}</span>
                <div>
                  <p className="font-semibold text-sm text-gray-800">{item.title}</p>
                  <p className="text-xs text-gray-500 mt-0.5">{item.desc}</p>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* Trust section */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 py-12">
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-6 text-center">
          <div className="p-6">
            <div className="text-3xl mb-3">🔒</div>
            <h3 className="font-bold text-gray-800 mb-1">Seguro y confiable</h3>
            <p className="text-sm text-gray-500">Sistema de calificaciones verificadas para compradores y vendedores.</p>
          </div>
          <div className="p-6">
            <div className="text-3xl mb-3">💬</div>
            <h3 className="font-bold text-gray-800 mb-1">Contacto directo</h3>
            <p className="text-sm text-gray-500">Conecta directamente por WhatsApp con el vendedor, sin intermediarios.</p>
          </div>
          <div className="p-6">
            <div className="text-3xl mb-3">🇨🇴</div>
            <h3 className="font-bold text-gray-800 mb-1">Hecho en Colombia</h3>
            <p className="text-sm text-gray-500">Plataforma diseñada para el mercado colombiano, en español.</p>
          </div>
        </div>
      </section>
    </div>
  );
}

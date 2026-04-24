import { notFound } from 'next/navigation';
import { Metadata } from 'next';
import { createClient } from '@/lib/supabase/server';
import { Listing, Category } from '@/types';
import ListingGrid from '@/components/listings/ListingGrid';
import AdBanner from '@/components/ads/AdBanner';
import Link from 'next/link';

interface Props {
  params: Promise<{ slug: string }>;
  searchParams: Promise<{ ciudad?: string; orden?: string; precio_min?: string; precio_max?: string; page?: string }>;
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const supabase = await createClient();
  const { data } = await supabase.from('categories').select('name_es').eq('slug', slug).single();
  return {
    title: data ? `${data.name_es} – Clasificados Colombia` : 'Categoría',
    description: `Encuentra los mejores anuncios de ${data?.name_es ?? ''} en LlevaLleva.co`,
  };
}

export default async function CategoryPage({ params, searchParams }: Props) {
  const { slug } = await params;
  const sp = await searchParams;
  const supabase = await createClient();

  // Fetch category (may be parent or child)
  const { data: category } = await supabase
    .from('categories')
    .select('*, parent:categories(id, name_es, slug)')
    .eq('slug', slug)
    .single();

  if (!category) notFound();

  // Fetch subcategories if this is a parent
  const { data: subcategories } = await supabase
    .from('categories')
    .select('*')
    .eq('parent_id', category.id)
    .eq('is_active', true)
    .order('sort_order');

  // Gather all category IDs for the query (this cat + all children)
  const catIds = [category.id, ...(subcategories?.map((s: Category) => s.id) ?? [])];

  // Build listing query
  let query = supabase
    .from('listings')
    .select('*, seller:profiles(*), category:categories(*), location:locations(*)')
    .in('category_id', catIds)
    .eq('status', 'active');

  if (sp.ciudad) {
    query = query.eq('location.city', sp.ciudad);
  }
  if (sp.precio_min) {
    query = query.gte('price', parseInt(sp.precio_min));
  }
  if (sp.precio_max) {
    query = query.lte('price', parseInt(sp.precio_max));
  }

  const orden = sp.orden ?? 'recientes';
  if (orden === 'precio_asc') query = query.order('price', { ascending: true });
  else if (orden === 'precio_desc') query = query.order('price', { ascending: false });
  else query = query.order('published_at', { ascending: false });

  const page = parseInt(sp.page ?? '1');
  const perPage = 24;
  query = query.range((page - 1) * perPage, page * perPage - 1);

  const { data: listings } = await query;

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 py-6">
      {/* Breadcrumb */}
      <nav className="text-xs text-gray-500 mb-4 flex items-center gap-1.5">
        <Link href="/" className="hover:text-emerald-600">Inicio</Link>
        <span>›</span>
        <span className="text-gray-700">{category.name_es}</span>
      </nav>

      <div className="flex flex-col lg:flex-row gap-6">
        {/* Sidebar */}
        <aside className="lg:w-56 flex-shrink-0">
          <div className="bg-white rounded-2xl border border-gray-200 p-4 space-y-4">
            <div>
              <h2 className="font-bold text-gray-800 text-sm mb-3 flex items-center gap-2">
                <span className="text-lg">{category.icon ?? '📦'}</span>
                {category.name_es}
              </h2>
              {subcategories && subcategories.length > 0 && (
                <ul className="space-y-1">
                  <li>
                    <Link
                      href={`/categorias/${category.slug}`}
                      className="block text-sm py-1 px-2 rounded-lg font-semibold text-emerald-700 bg-emerald-50"
                    >
                      Todo en {category.name_es}
                    </Link>
                  </li>
                  {subcategories.map((sub: Category) => (
                    <li key={sub.id}>
                      <Link
                        href={`/categorias/${sub.slug}`}
                        className="block text-sm py-1 px-2 rounded-lg text-gray-600 hover:bg-gray-50 hover:text-gray-900 transition-colors"
                      >
                        {sub.name_es}
                      </Link>
                    </li>
                  ))}
                </ul>
              )}
            </div>

            {/* Filters */}
            <div className="border-t border-gray-100 pt-4">
              <h3 className="font-semibold text-gray-700 text-xs uppercase tracking-wide mb-3">Filtros</h3>
              <form className="space-y-3">
                <div>
                  <label className="block text-xs text-gray-500 mb-1">Ordenar por</label>
                  <select
                    name="orden"
                    defaultValue={orden}
                    className="w-full text-sm border border-gray-200 rounded-lg px-2.5 py-1.5 focus:outline-none focus:ring-2 focus:ring-emerald-500"
                  >
                    <option value="recientes">Más recientes</option>
                    <option value="precio_asc">Precio: menor a mayor</option>
                    <option value="precio_desc">Precio: mayor a menor</option>
                  </select>
                </div>
                <div>
                  <label className="block text-xs text-gray-500 mb-1">Precio mínimo (COP)</label>
                  <input
                    type="number"
                    name="precio_min"
                    defaultValue={sp.precio_min}
                    placeholder="0"
                    className="w-full text-sm border border-gray-200 rounded-lg px-2.5 py-1.5 focus:outline-none focus:ring-2 focus:ring-emerald-500"
                  />
                </div>
                <div>
                  <label className="block text-xs text-gray-500 mb-1">Precio máximo (COP)</label>
                  <input
                    type="number"
                    name="precio_max"
                    defaultValue={sp.precio_max}
                    placeholder="Sin límite"
                    className="w-full text-sm border border-gray-200 rounded-lg px-2.5 py-1.5 focus:outline-none focus:ring-2 focus:ring-emerald-500"
                  />
                </div>
                <button
                  type="submit"
                  className="w-full bg-emerald-600 text-white text-sm font-semibold py-2 rounded-lg hover:bg-emerald-700 transition-colors"
                >
                  Aplicar filtros
                </button>
              </form>
            </div>

            {/* Sidebar ad */}
            <div className="border-t border-gray-100 pt-4">
              <AdBanner slot={process.env.NEXT_PUBLIC_ADSENSE_SLOT_CATEGORY ?? ''} format="rectangle" />
            </div>
          </div>
        </aside>

        {/* Listings */}
        <div className="flex-1">
          <div className="flex items-center justify-between mb-4">
            <h1 className="font-bold text-gray-800">
              {category.name_es}
              <span className="font-normal text-sm text-gray-500 ml-2">
                ({listings?.length ?? 0} anuncios)
              </span>
            </h1>
          </div>

          <ListingGrid
            listings={(listings as Listing[]) ?? []}
            emptyMessage={`No hay anuncios en ${category.name_es} por el momento. ¡Sé el primero en publicar!`}
            showAds
          />

          {/* Ad banner below listings */}
          <div className="mt-6">
            <AdBanner slot="" format="auto" />
          </div>

          {/* Pagination */}
          {(listings?.length ?? 0) === perPage && (
            <div className="flex justify-center mt-8">
              <Link
                href={`?${new URLSearchParams({ ...sp, page: String(page + 1) })}`}
                className="bg-white border border-gray-200 text-gray-700 text-sm font-medium px-6 py-2.5 rounded-full hover:border-emerald-300 hover:text-emerald-700 transition-colors"
              >
                Ver más anuncios →
              </Link>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

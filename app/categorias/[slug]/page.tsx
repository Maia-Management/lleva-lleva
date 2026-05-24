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

function labelFromSlug(slug: string) {
  return slug
    .split('-')
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(' ');
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  let name = labelFromSlug(slug);
  let canonicalUrl = `https://lleva-lleva.com/categorias/${slug}`;

  try {
    const supabase = await createClient();
    const { data } = await supabase.from('categories').select('name_es, slug').eq('slug', slug).single();
    if (data) {
      name = data.name_es;
      canonicalUrl = `https://lleva-lleva.com/categorias/${data.slug}`;
    }
  } catch {
    // Keep complete metadata even if the database lookup is unavailable.
  }

  const title = `${name} – Clasificados Colombia`;
  const description = `Encuentra anuncios de ${name} en Lleva Lleva, el clasificado colombiano para comprar y vender en tu región.`;

  return {
    title,
    description,
    alternates: { canonical: canonicalUrl },
    openGraph: { title, description, url: canonicalUrl, type: 'website' },
  };
}

export default async function CategoryPage({ params, searchParams }: Props) {
  const { slug } = await params;
  const sp = await searchParams;
  const orden = sp.orden ?? 'recientes';
  const page = parseInt(sp.page ?? '1');
  const perPage = 24;

  let category: (Category & { parent?: { id: string; name_es: string; slug: string } | null }) | null = null;
  let subcategories: Category[] | null = null;
  let listings: Listing[] | null = null;

  try {
    const supabase = await createClient();

    const { data: cat } = await supabase
      .from('categories')
      .select('*, parent:categories(id, name_es, slug)')
      .eq('slug', slug)
      .single();
    category = cat;

    if (cat) {
      const { data: subs } = await supabase
        .from('categories')
        .select('*')
        .eq('parent_id', cat.id)
        .eq('is_active', true)
        .order('sort_order');
      subcategories = subs;

      const catIds = [cat.id, ...(subs?.map((s: Category) => s.id) ?? [])];
      let query = supabase
        .from('listings')
        .select('*, seller:profiles(*), category:categories(*), location:locations(*)')
        .in('category_id', catIds)
        .eq('status', 'active');

      if (sp.ciudad) query = query.eq('location.city', sp.ciudad);
      if (sp.precio_min) query = query.gte('price', parseInt(sp.precio_min));
      if (sp.precio_max) query = query.lte('price', parseInt(sp.precio_max));

      if (orden === 'precio_asc') query = query.order('price', { ascending: true });
      else if (orden === 'precio_desc') query = query.order('price', { ascending: false });
      else query = query.order('published_at', { ascending: false });

      query = query.range((page - 1) * perPage, page * perPage - 1);
      const { data: lists } = await query;
      listings = lists;
    }
  } catch (err) {
    console.error('[CategoryPage] Supabase error:', err);
  }

  if (!category) notFound();

  const categoryUrl = `https://lleva-lleva.com/categorias/${category.slug}`;

  const breadcrumbSchema = {
    '@context': 'https://schema.org',
    '@type': 'BreadcrumbList',
    itemListElement: [
      {
        '@type': 'ListItem',
        position: 1,
        name: 'Inicio',
        item: 'https://lleva-lleva.com',
      },
      {
        '@type': 'ListItem',
        position: 2,
        name: 'Categorías',
        item: 'https://lleva-lleva.com/categorias',
      },
      ...(category.parent
        ? [
            {
              '@type': 'ListItem',
              position: 3,
              name: category.parent.name_es,
              item: `https://lleva-lleva.com/categorias/${category.parent.slug}`,
            },
            {
              '@type': 'ListItem',
              position: 4,
              name: category.name_es,
              item: categoryUrl,
            },
          ]
        : [
            {
              '@type': 'ListItem',
              position: 3,
              name: category.name_es,
              item: categoryUrl,
            },
          ]),
    ],
  };

  const itemListSchema =
    listings && listings.length > 0
      ? {
          '@context': 'https://schema.org',
          '@type': 'ItemList',
          name: `${category.name_es} – Clasificados Colombia`,
          itemListOrder: 'https://schema.org/ItemListUnordered',
          numberOfItems: listings.length,
          itemListElement: listings.slice(0, 24).map((l, i) => ({
            '@type': 'ListItem',
            position: (page - 1) * perPage + i + 1,
            url: `https://lleva-lleva.com/listing/${l.slug}`,
            name: l.title,
          })),
        }
      : null;

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 py-6">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }}
      />
      {itemListSchema && (
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(itemListSchema) }}
        />
      )}

      {/* Breadcrumb */}
      <nav className="text-xs text-gray-500 mb-4 flex items-center gap-1.5">
        <Link href="/" className="hover:text-brand-blue">Inicio</Link>
        <span>›</span>
        <span className="text-gray-700">{category.name_es}</span>
      </nav>

      <div className="flex flex-col lg:flex-row gap-6">
        {/* Sidebar */}
        <aside className="lg:w-56 flex-shrink-0">
          <div className="bg-white rounded-2xl border border-gray-200 p-4 space-y-4">
            <div>
              <p className="font-bold text-gray-800 text-sm mb-3 flex items-center gap-2">
                <span className="text-lg">{category.icon ?? '📦'}</span>
                {category.name_es}
              </p>
              {subcategories && subcategories.length > 0 && (
                <ul className="space-y-1">
                  <li>
                    <Link
                      href={`/categorias/${category.slug}`}
                      className="block text-sm py-1 px-2 rounded-lg font-semibold text-brand-blue bg-brand-blue-50"
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
              <p className="font-semibold text-gray-700 text-xs uppercase tracking-wide mb-3">Filtros</p>
              <form className="space-y-3">
                <div>
                  <label className="block text-xs text-gray-500 mb-1" htmlFor="orden">Ordenar por</label>
                  <select
                    id="orden"
                    name="orden"
                    defaultValue={orden}
                    className="w-full text-sm border border-gray-200 rounded-lg px-2.5 py-1.5 focus:outline-none focus:ring-2 focus:ring-brand-blue"
                  >
                    <option value="recientes">Más recientes</option>
                    <option value="precio_asc">Precio: menor a mayor</option>
                    <option value="precio_desc">Precio: mayor a menor</option>
                  </select>
                </div>
                <div>
                  <label className="block text-xs text-gray-500 mb-1" htmlFor="precio_min">Precio mínimo (COP)</label>
                  <input
                    id="precio_min"
                    type="number"
                    name="precio_min"
                    defaultValue={sp.precio_min}
                    placeholder="0"
                    className="w-full text-sm border border-gray-200 rounded-lg px-2.5 py-1.5 focus:outline-none focus:ring-2 focus:ring-brand-blue"
                  />
                </div>
                <div>
                  <label className="block text-xs text-gray-500 mb-1" htmlFor="precio_max">Precio máximo (COP)</label>
                  <input
                    id="precio_max"
                    type="number"
                    name="precio_max"
                    defaultValue={sp.precio_max}
                    placeholder="Sin límite"
                    className="w-full text-sm border border-gray-200 rounded-lg px-2.5 py-1.5 focus:outline-none focus:ring-2 focus:ring-brand-blue"
                  />
                </div>
                <button
                  type="submit"
                  className="w-full bg-brand-blue text-white text-sm font-semibold py-2 rounded-lg hover:bg-brand-blue-700 transition-colors"
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
                className="bg-white border border-gray-200 text-gray-700 text-sm font-medium px-6 py-2.5 rounded-full hover:border-brand-blue/40 hover:text-brand-blue transition-colors"
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

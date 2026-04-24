import { Metadata } from 'next';
import { Suspense } from 'react';
import { createClient } from '@/lib/supabase/server';
import { Listing, Category } from '@/types';
import ListingGrid from '@/components/listings/ListingGrid';
import SearchFilters from './SearchFilters';
import Link from 'next/link';

interface Props {
  searchParams: Promise<{
    q?: string;
    categoria?: string;
    ciudad?: string;
    condicion?: string;
    precio_min?: string;
    precio_max?: string;
    orden?: string;
    page?: string;
  }>;
}

export async function generateMetadata({ searchParams }: Props): Promise<Metadata> {
  const sp = await searchParams;
  const query = sp.q?.trim();
  return {
    title: query ? `"${query}" – Buscar en LlevaLleva` : 'Buscar anuncios – LlevaLleva',
    description: `Encuentra ${query ?? 'lo que buscas'} en LlevaLleva.co – Clasificados de Colombia`,
  };
}

export default async function BuscarPage({ searchParams }: Props) {
  const sp = await searchParams;
  const supabase = await createClient();

  const q = sp.q?.trim() ?? '';
  const page = Math.max(1, parseInt(sp.page ?? '1'));
  const perPage = 24;

  // Fetch filter data
  const [{ data: categories }, { data: locations }] = await Promise.all([
    supabase
      .from('categories')
      .select('id, name_es, slug, parent_id, sort_order')
      .eq('is_active', true)
      .order('sort_order'),
    supabase
      .from('locations')
      .select('city, department')
      .eq('is_active', true)
      .order('department')
      .order('city'),
  ]);

  // Build the listings query
  let query = supabase
    .from('listings')
    .select('*, seller:profiles(*), category:categories(*), location:locations(*)')
    .eq('status', 'active');

  // Full-text search: search title and description
  if (q) {
    query = query.or(`title.ilike.%${q}%,description.ilike.%${q}%`);
  }

  // Category filter by slug
  if (sp.categoria) {
    const { data: cat } = await supabase
      .from('categories')
      .select('id')
      .eq('slug', sp.categoria)
      .single();
    if (cat) {
      // Also include subcategories
      const { data: subcats } = await supabase
        .from('categories')
        .select('id')
        .eq('parent_id', cat.id);
      const ids = [cat.id, ...(subcats?.map((s: { id: string }) => s.id) ?? [])];
      query = query.in('category_id', ids);
    }
  }

  // City filter - match city name (case-insensitive via slug comparison)
  if (sp.ciudad) {
    // Ciudad param is slugified city name; find the matching city
    const citySlug = sp.ciudad.toLowerCase();
    const matchedLoc = (locations as Array<{ city: string; department: string }>)?.find(
      (l: { city: string; department: string }) => l.city.toLowerCase().replace(/\s+/g, '-') === citySlug
    );
    if (matchedLoc) {
      query = query.eq('location.city', matchedLoc.city);
    }
  }

  // Condition filter
  if (sp.condicion) {
    query = query.eq('condition', sp.condicion);
  }

  // Price filters
  if (sp.precio_min) {
    query = query.gte('price', parseInt(sp.precio_min));
  }
  if (sp.precio_max) {
    query = query.lte('price', parseInt(sp.precio_max));
  }

  // Sort
  const orden = sp.orden ?? 'recientes';
  if (orden === 'precio_asc') query = query.order('price', { ascending: true });
  else if (orden === 'precio_desc') query = query.order('price', { ascending: false });
  else query = query.order('published_at', { ascending: false });

  // Pagination
  query = query.range((page - 1) * perPage, page * perPage - 1);

  const { data: listings } = await query;

  const hasResults = (listings?.length ?? 0) > 0;
  const hasFilters = !!(q || sp.categoria || sp.ciudad || sp.condicion || sp.precio_min || sp.precio_max);

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 py-6">
      {/* Breadcrumb */}
      <nav className="text-xs text-gray-500 mb-4 flex items-center gap-1.5">
        <Link href="/" className="hover:text-emerald-600">Inicio</Link>
        <span>›</span>
        <span className="text-gray-700">Buscar</span>
        {q && (
          <>
            <span>›</span>
            <span className="text-gray-700">&ldquo;{q}&rdquo;</span>
          </>
        )}
      </nav>

      <div className="mb-6">
        <h1 className="text-xl font-bold text-gray-900 mb-4">
          {q ? (
            <>Resultados para <span className="text-emerald-600">&ldquo;{q}&rdquo;</span></>
          ) : (
            'Buscar anuncios'
          )}
        </h1>

        <Suspense>
          <SearchFilters
            categories={(categories as Category[]) ?? []}
            locations={(locations as Array<{ city: string; department: string }>) ?? []}
          />
        </Suspense>
      </div>

      {/* Results count */}
      <div className="flex items-center justify-between mb-4">
        <p className="text-sm text-gray-500">
          {hasResults
            ? `${listings!.length === perPage ? `${perPage}+` : listings!.length} anuncio${listings!.length !== 1 ? 's' : ''} encontrado${listings!.length !== 1 ? 's' : ''}`
            : hasFilters
            ? 'Sin resultados para esta búsqueda'
            : 'Todos los anuncios'}
        </p>

        {/* Sort */}
        <form method="get" action="/buscar">
          {/* Preserve existing params */}
          {q && <input type="hidden" name="q" value={q} />}
          {sp.categoria && <input type="hidden" name="categoria" value={sp.categoria} />}
          {sp.ciudad && <input type="hidden" name="ciudad" value={sp.ciudad} />}
          {sp.condicion && <input type="hidden" name="condicion" value={sp.condicion} />}
          {sp.precio_min && <input type="hidden" name="precio_min" value={sp.precio_min} />}
          {sp.precio_max && <input type="hidden" name="precio_max" value={sp.precio_max} />}
          <select
            name="orden"
            defaultValue={orden}
            onChange={(e) => (e.target.form as HTMLFormElement).submit()}
            className="text-sm border border-gray-200 rounded-lg px-2.5 py-1.5 focus:outline-none focus:ring-2 focus:ring-emerald-500 bg-white"
          >
            <option value="recientes">Más recientes</option>
            <option value="precio_asc">Precio: menor a mayor</option>
            <option value="precio_desc">Precio: mayor a menor</option>
          </select>
        </form>
      </div>

      {/* Listing grid */}
      {hasResults ? (
        <>
          <ListingGrid listings={(listings as Listing[])} showAds />

          {/* Pagination */}
          {listings!.length === perPage && (
            <div className="flex justify-center mt-8">
              <Link
                href={`/buscar?${new URLSearchParams({ ...sp, page: String(page + 1) })}`}
                className="bg-white border border-gray-200 text-gray-700 text-sm font-medium px-6 py-2.5 rounded-full hover:border-emerald-300 hover:text-emerald-700 transition-colors"
              >
                Ver más resultados →
              </Link>
            </div>
          )}
        </>
      ) : (
        <div className="text-center py-16 text-gray-500">
          <div className="text-5xl mb-4">🔍</div>
          <p className="font-semibold text-gray-700 mb-2">
            {hasFilters ? 'No encontramos resultados' : 'Empieza tu búsqueda'}
          </p>
          <p className="text-sm">
            {hasFilters
              ? 'Intenta con otras palabras o quita algunos filtros'
              : 'Escribe lo que buscas arriba o explora por categorías'}
          </p>
          {hasFilters && (
            <Link
              href="/buscar"
              className="inline-block mt-4 text-emerald-600 text-sm hover:underline"
            >
              Limpiar filtros
            </Link>
          )}
          <div className="mt-6">
            <Link
              href="/"
              className="inline-flex items-center gap-2 bg-emerald-600 text-white text-sm font-semibold px-5 py-2.5 rounded-full hover:bg-emerald-700 transition-colors"
            >
              Ver todos los anuncios
            </Link>
          </div>
        </div>
      )}
    </div>
  );
}

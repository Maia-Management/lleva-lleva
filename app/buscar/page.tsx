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
  const title = query ? `"${query}" – Buscar en Lleva Lleva` : 'Buscar anuncios – Lleva Lleva';
  const description = `Encuentra ${query ?? 'lo que buscas'} en Lleva Lleva – Clasificados de Colombia`;
  return {
    title,
    description,
    alternates: {
      canonical: query
        ? `https://lleva-lleva.com/buscar?q=${encodeURIComponent(query)}`
        : 'https://lleva-lleva.com/buscar',
    },
    robots: query ? { index: false, follow: true } : { index: true, follow: true },
  };
}

export default async function BuscarPage({ searchParams }: Props) {
  const sp = await searchParams;
  const q = sp.q?.trim() ?? '';
  const page = Math.max(1, parseInt(sp.page ?? '1'));
  const perPage = 24;
  const orden = sp.orden ?? 'recientes';
  const hasFilters = !!(q || sp.categoria || sp.ciudad || sp.condicion || sp.precio_min || sp.precio_max);

  let listings: Listing[] | null = null;
  let categories: Category[] | null = null;
  let locations: Array<{ city: string; department: string }> | null = null;

  try {
    const supabase = await createClient();

    // Fetch filter data
    const [{ data: cats }, { data: locs }] = await Promise.all([
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
    categories = cats as Category[];
    locations = locs as Array<{ city: string; department: string }>;

    // Build the listings query
    let query = supabase
      .from('listings')
      .select('*, seller:profiles(*), category:categories(*), location:locations(*)')
      .eq('status', 'active');

    if (q) {
      query = query.or(`title.ilike.%${q}%,description.ilike.%${q}%`);
    }

    if (sp.categoria) {
      const { data: cat } = await supabase
        .from('categories')
        .select('id')
        .eq('slug', sp.categoria)
        .single();
      if (cat) {
        const { data: subcats } = await supabase
          .from('categories')
          .select('id')
          .eq('parent_id', cat.id);
        const ids = [cat.id, ...(subcats?.map((s: { id: string }) => s.id) ?? [])];
        query = query.in('category_id', ids);
      }
    }

    if (sp.ciudad) {
      const citySlug = sp.ciudad.toLowerCase();
      const matchedLoc = locations?.find(
        (l) => l.city.toLowerCase().replace(/\s+/g, '-') === citySlug
      );
      if (matchedLoc) {
        query = query.eq('location.city', matchedLoc.city);
      }
    }

    if (sp.condicion) query = query.eq('condition', sp.condicion);
    if (sp.precio_min) query = query.gte('price', parseInt(sp.precio_min));
    if (sp.precio_max) query = query.lte('price', parseInt(sp.precio_max));

    if (orden === 'precio_asc') query = query.order('price', { ascending: true });
    else if (orden === 'precio_desc') query = query.order('price', { ascending: false });
    else query = query.order('published_at', { ascending: false });

    query = query.range((page - 1) * perPage, page * perPage - 1);

    const { data } = await query;
    listings = data as Listing[];
  } catch (err) {
    console.error('[BuscarPage] Supabase error:', err);
  }

  const hasResults = (listings?.length ?? 0) > 0;

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 py-6">
      {/* Breadcrumb */}
      <nav className="text-xs text-ink-2/70 mb-4 flex items-center gap-1.5" aria-label="Breadcrumb">
        <Link href="/" className="hover:text-brand-blue">Inicio</Link>
        <span aria-hidden="true">›</span>
        <span className="text-ink">Buscar</span>
        {q && (
          <>
            <span aria-hidden="true">›</span>
            <span className="text-ink">&ldquo;{q}&rdquo;</span>
          </>
        )}
      </nav>

      <div className="mb-6">
        <h1 className="text-xl font-bold text-ink mb-4">
          {q ? (
            <>Resultados para <span className="text-brand-blue">&ldquo;{q}&rdquo;</span></>
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
        <p className="text-sm text-ink-2/80">
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
            aria-label="Ordenar resultados"
            className="text-sm border border-line rounded-lg px-2.5 py-1.5 focus:outline-none focus:ring-2 focus:ring-brand-blue bg-surface text-ink"
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
                className="bg-surface border border-line text-ink text-sm font-medium px-6 py-2.5 rounded-full hover:border-brand-blue/40 hover:text-brand-blue transition-colors"
              >
                Ver más resultados →
              </Link>
            </div>
          )}
        </>
      ) : (
        <div className="text-center py-16 text-ink-2/80">
          <div className="text-5xl mb-4" aria-hidden="true">🔍</div>
          <p className="font-semibold text-ink mb-2">
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
              className="inline-block mt-4 text-brand-blue text-sm hover:underline font-medium"
            >
              Limpiar filtros
            </Link>
          )}
          <div className="mt-6">
            <Link
              href="/"
              className="inline-flex items-center gap-2 bg-brand-yellow text-ink text-sm font-bold px-5 py-2.5 rounded-full hover:bg-brand-yellow-600 transition-colors shadow-sm"
            >
              Ver todos los anuncios
            </Link>
          </div>
        </div>
      )}
    </div>
  );
}

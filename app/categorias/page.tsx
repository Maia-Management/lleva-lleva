import { Metadata } from 'next';
import { createClient } from '@/lib/supabase/server';
import { Category } from '@/types';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'Categorías – LlevaLleva.co',
  description: 'Explora todas las categorías de clasificados en LlevaLleva.co: vehículos, inmuebles, tecnología, empleos, servicios y mucho más.',
};

export default async function CategoriasPage() {
  const supabase = await createClient();

  const { data: categories } = await supabase
    .from('categories')
    .select('*')
    .is('parent_id', null)
    .eq('is_active', true)
    .order('sort_order');

  const cats = (categories as Category[]) ?? [];

  return (
    <div className="max-w-5xl mx-auto px-4 sm:px-6 py-8">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-2xl sm:text-3xl font-bold text-gray-900">Categorías</h1>
        <p className="text-gray-500 mt-1 text-sm">Encuentra lo que buscas en {cats.length} categorías</p>
      </div>

      {/* Category grid */}
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3">
        {cats.map((cat) => (
          <Link
            key={cat.id}
            href={`/categorias/${cat.slug}`}
            className="group flex flex-col items-center gap-3 bg-white border border-gray-200 rounded-2xl p-5 hover:border-brand-blue/40 hover:shadow-md transition-all duration-200 text-center"
          >
            <span className="text-4xl leading-none" role="img" aria-label={cat.name_es}>
              {cat.icon ?? '📦'}
            </span>
            <div>
              <p className="text-sm font-semibold text-gray-800 group-hover:text-brand-blue transition-colors leading-tight">
                {cat.name_es}
              </p>
              {cat.listing_count > 0 && (
                <p className="text-xs text-gray-400 mt-0.5">
                  {cat.listing_count.toLocaleString('es-CO')} anuncios
                </p>
              )}
            </div>
          </Link>
        ))}
      </div>

      {/* Browse all link */}
      <div className="mt-10 text-center">
        <Link
          href="/buscar"
          className="inline-flex items-center gap-2 bg-brand-blue text-white font-semibold px-6 py-3 rounded-full hover:bg-brand-blue-700 transition-colors text-sm"
        >
          🔍 Ver todos los anuncios
        </Link>
      </div>
    </div>
  );
}

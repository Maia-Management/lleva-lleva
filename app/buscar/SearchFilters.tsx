'use client';

import { useRouter, useSearchParams } from 'next/navigation';
import { useCallback, useEffect, useState } from 'react';

interface Category {
  id: string;
  name_es: string;
  slug: string;
  parent_id: string | null;
}

interface Location {
  city: string;
  department: string;
}

interface Props {
  categories: Category[];
  locations: Location[];
}

function useDebounce<T>(value: T, delay: number): T {
  const [debounced, setDebounced] = useState(value);
  useEffect(() => {
    const timer = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);
  return debounced;
}

export default function SearchFilters({ categories, locations }: Props) {
  const router = useRouter();
  const searchParams = useSearchParams();

  const [q, setQ] = useState(searchParams.get('q') ?? '');
  const [categoria, setCategoria] = useState(searchParams.get('categoria') ?? '');
  const [ciudad, setCiudad] = useState(searchParams.get('ciudad') ?? '');
  const [condicion, setCondicion] = useState(searchParams.get('condicion') ?? '');
  const [precioMin, setPrecioMin] = useState(searchParams.get('precio_min') ?? '');
  const [precioMax, setPrecioMax] = useState(searchParams.get('precio_max') ?? '');

  const debouncedQ = useDebounce(q, 300);

  const buildParams = useCallback(
    (overrides: Record<string, string> = {}) => {
      const params = new URLSearchParams();
      const vals: Record<string, string> = {
        q: debouncedQ,
        categoria,
        ciudad,
        condicion,
        precio_min: precioMin,
        precio_max: precioMax,
        ...overrides,
      };
      Object.entries(vals).forEach(([k, v]) => {
        if (v) params.set(k, v);
      });
      return params.toString();
    },
    [debouncedQ, categoria, ciudad, condicion, precioMin, precioMax]
  );

  // Push URL update when debounced query changes
  useEffect(() => {
    const qs = buildParams({ q: debouncedQ });
    router.push(`/buscar${qs ? `?${qs}` : ''}`, { scroll: false });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [debouncedQ, categoria, ciudad, condicion, precioMin, precioMax]);

  const parentCats = categories.filter((c) => !c.parent_id);
  const childCats = (parentId: string) => categories.filter((c) => c.parent_id === parentId);

  const uniqueDepts = [...new Set(locations.map((l) => l.department))].sort();
  const citiesByDept = (dept: string) =>
    locations.filter((l) => l.department === dept).map((l) => l.city).sort();

  return (
    <div className="space-y-4">
      {/* Search input */}
      <div className="relative">
        <svg
          className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-ink-2/60 pointer-events-none"
          fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
            d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
        <input
          type="search"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          placeholder="¿Qué estás buscando?"
          aria-label="Buscar"
          className="w-full pl-10 pr-4 py-3 bg-surface border border-line rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue placeholder:text-ink-2/60 text-ink"
          autoFocus
        />
      </div>

      {/* Filters row — 2 cols on mobile, 4 on desktop */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
        {/* Category */}
        <select
          value={categoria}
          onChange={(e) => setCategoria(e.target.value)}
          aria-label="Categoría"
          className="w-full px-3 py-2.5 border border-line rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue bg-surface text-ink"
        >
          <option value="">Todas las categorías</option>
          {parentCats.map((parent) => {
            const children = childCats(parent.id);
            return children.length > 0 ? (
              <optgroup key={parent.id} label={parent.name_es}>
                {children.map((child) => (
                  <option key={child.id} value={child.slug}>{child.name_es}</option>
                ))}
              </optgroup>
            ) : (
              <option key={parent.id} value={parent.slug}>{parent.name_es}</option>
            );
          })}
        </select>

        {/* City */}
        <select
          value={ciudad}
          onChange={(e) => setCiudad(e.target.value)}
          aria-label="Ciudad"
          className="w-full px-3 py-2.5 border border-line rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue bg-surface text-ink"
        >
          <option value="">Todas las ciudades</option>
          {uniqueDepts.map((dept) => (
            <optgroup key={dept} label={dept}>
              {citiesByDept(dept).map((city) => (
                <option key={city} value={city.toLowerCase().replace(/\s+/g, '-')}>{city}</option>
              ))}
            </optgroup>
          ))}
        </select>

        {/* Condition */}
        <select
          value={condicion}
          onChange={(e) => setCondicion(e.target.value)}
          aria-label="Estado"
          className="w-full px-3 py-2.5 border border-line rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue bg-surface text-ink"
        >
          <option value="">Cualquier estado</option>
          <option value="new">Nuevo</option>
          <option value="like_new">Como nuevo</option>
          <option value="good">Buen estado</option>
          <option value="fair">Estado regular</option>
          <option value="for_parts">Para repuestos</option>
        </select>

        {/* Price range */}
        <div className="flex items-center gap-1.5">
          <input
            type="number"
            value={precioMin}
            onChange={(e) => setPrecioMin(e.target.value)}
            placeholder="Min COP"
            aria-label="Precio mínimo"
            min="0"
            className="w-full px-3 py-2.5 bg-surface border border-line rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue text-ink placeholder:text-ink-2/60"
          />
          <span className="text-ink-2/60 text-xs flex-shrink-0" aria-hidden="true">–</span>
          <input
            type="number"
            value={precioMax}
            onChange={(e) => setPrecioMax(e.target.value)}
            placeholder="Max"
            aria-label="Precio máximo"
            min="0"
            className="w-full px-3 py-2.5 bg-surface border border-line rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue text-ink placeholder:text-ink-2/60"
          />
        </div>
      </div>

      {/* Active filter chips */}
      {(q || categoria || ciudad || condicion || precioMin || precioMax) && (
        <div className="flex flex-wrap gap-2">
          {q && (
            <span className="inline-flex items-center gap-1 bg-brand-blue-50 text-brand-blue text-xs px-3 py-1 rounded-full border border-brand-blue/20 font-medium">
              &ldquo;{q}&rdquo;
              <button onClick={() => setQ('')} aria-label={`Quitar búsqueda "${q}"`} className="ml-1 hover:text-brand-blue-700">×</button>
            </span>
          )}
          {categoria && (
            <span className="inline-flex items-center gap-1 bg-bg text-ink text-xs px-3 py-1 rounded-full border border-line">
              {categories.find((c) => c.slug === categoria)?.name_es ?? categoria}
              <button onClick={() => setCategoria('')} aria-label="Quitar categoría" className="ml-1 hover:text-brand-blue">×</button>
            </span>
          )}
          {ciudad && (
            <span className="inline-flex items-center gap-1 bg-bg text-ink text-xs px-3 py-1 rounded-full border border-line">
              📍 {ciudad}
              <button onClick={() => setCiudad('')} aria-label="Quitar ciudad" className="ml-1 hover:text-brand-blue">×</button>
            </span>
          )}
          {condicion && (
            <span className="inline-flex items-center gap-1 bg-bg text-ink text-xs px-3 py-1 rounded-full border border-line">
              {condicion === 'new' ? 'Nuevo' : condicion === 'like_new' ? 'Como nuevo' :
               condicion === 'good' ? 'Buen estado' : condicion === 'fair' ? 'Estado regular' : 'Para repuestos'}
              <button onClick={() => setCondicion('')} aria-label="Quitar estado" className="ml-1 hover:text-brand-blue">×</button>
            </span>
          )}
          {(precioMin || precioMax) && (
            <span className="inline-flex items-center gap-1 bg-bg text-ink text-xs px-3 py-1 rounded-full border border-line">
              ${precioMin || '0'} – ${precioMax || '∞'}
              <button onClick={() => { setPrecioMin(''); setPrecioMax(''); }} aria-label="Quitar rango de precio" className="ml-1 hover:text-brand-blue">×</button>
            </span>
          )}
          <button
            onClick={() => { setQ(''); setCategoria(''); setCiudad(''); setCondicion(''); setPrecioMin(''); setPrecioMax(''); }}
            className="text-xs text-ink-2/80 hover:text-brand-blue px-2 py-1 hover:underline font-medium"
          >
            Limpiar todo
          </button>
        </div>
      )}
    </div>
  );
}

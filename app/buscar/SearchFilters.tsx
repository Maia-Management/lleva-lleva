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
          className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none"
          fill="none" stroke="currentColor" viewBox="0 0 24 24"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
            d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
        <input
          type="search"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          placeholder="¿Qué estás buscando?"
          className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
          autoFocus
        />
      </div>

      {/* Filters row */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
        {/* Category */}
        <select
          value={categoria}
          onChange={(e) => setCategoria(e.target.value)}
          className="w-full px-3 py-2.5 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 bg-white"
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
          className="w-full px-3 py-2.5 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 bg-white"
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
          className="w-full px-3 py-2.5 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 bg-white"
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
            min="0"
            className="w-full px-3 py-2.5 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
          />
          <span className="text-gray-400 text-xs flex-shrink-0">–</span>
          <input
            type="number"
            value={precioMax}
            onChange={(e) => setPrecioMax(e.target.value)}
            placeholder="Max"
            min="0"
            className="w-full px-3 py-2.5 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
          />
        </div>
      </div>

      {/* Active filter chips */}
      {(q || categoria || ciudad || condicion || precioMin || precioMax) && (
        <div className="flex flex-wrap gap-2">
          {q && (
            <span className="inline-flex items-center gap-1 bg-emerald-50 text-emerald-700 text-xs px-3 py-1 rounded-full border border-emerald-200">
              &ldquo;{q}&rdquo;
              <button onClick={() => setQ('')} className="ml-1 hover:text-emerald-900">×</button>
            </span>
          )}
          {categoria && (
            <span className="inline-flex items-center gap-1 bg-gray-100 text-gray-700 text-xs px-3 py-1 rounded-full">
              {categories.find((c) => c.slug === categoria)?.name_es ?? categoria}
              <button onClick={() => setCategoria('')} className="ml-1 hover:text-gray-900">×</button>
            </span>
          )}
          {ciudad && (
            <span className="inline-flex items-center gap-1 bg-gray-100 text-gray-700 text-xs px-3 py-1 rounded-full">
              📍 {ciudad}
              <button onClick={() => setCiudad('')} className="ml-1 hover:text-gray-900">×</button>
            </span>
          )}
          {condicion && (
            <span className="inline-flex items-center gap-1 bg-gray-100 text-gray-700 text-xs px-3 py-1 rounded-full">
              {condicion === 'new' ? 'Nuevo' : condicion === 'like_new' ? 'Como nuevo' :
               condicion === 'good' ? 'Buen estado' : condicion === 'fair' ? 'Estado regular' : 'Para repuestos'}
              <button onClick={() => setCondicion('')} className="ml-1 hover:text-gray-900">×</button>
            </span>
          )}
          {(precioMin || precioMax) && (
            <span className="inline-flex items-center gap-1 bg-gray-100 text-gray-700 text-xs px-3 py-1 rounded-full">
              ${precioMin || '0'} – ${precioMax || '∞'}
              <button onClick={() => { setPrecioMin(''); setPrecioMax(''); }} className="ml-1 hover:text-gray-900">×</button>
            </span>
          )}
          <button
            onClick={() => { setQ(''); setCategoria(''); setCiudad(''); setCondicion(''); setPrecioMin(''); setPrecioMax(''); }}
            className="text-xs text-gray-500 hover:text-gray-700 px-2 py-1 hover:underline"
          >
            Limpiar todo
          </button>
        </div>
      )}
    </div>
  );
}

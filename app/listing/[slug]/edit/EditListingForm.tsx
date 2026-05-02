'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Listing } from '@/types';

interface Category { id: string; name_es: string; slug: string; parent_id: string | null; sort_order: number; }
interface Location { id: string; department: string; city: string; slug: string; }

interface Props {
  listing: Listing;
  categories: Category[];
  locations: Location[];
}

export default function EditListingForm({ listing, categories, locations }: Props) {
  const router = useRouter();

  const [form, setForm] = useState({
    title: listing.title,
    category_id: listing.category_id,
    location_id: listing.location_id ?? '',
    description: listing.description,
    price: listing.price != null ? String(listing.price) : '',
    price_type: listing.price_type,
    condition: listing.condition ?? ('' as '' | 'new' | 'like_new' | 'good' | 'fair' | 'for_parts'),
    is_nationwide: listing.is_nationwide ?? false,
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const parentCats = categories.filter((c) => !c.parent_id);
  const childCats = (parentId: string) => categories.filter((c) => c.parent_id === parentId);
  const groupedLocations = locations.reduce<Record<string, Location[]>>((acc, loc) => {
    (acc[loc.department] ||= []).push(loc);
    return acc;
  }, {});

  function handleChange(e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) {
    const { name, value, type } = e.target;
    const checked = (e.target as HTMLInputElement).checked;
    setForm((f) => ({ ...f, [name]: type === 'checkbox' ? checked : value }));
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const { createClient } = await import('@/lib/supabase/client');
      const supabase = createClient();

      const updates = {
        title: form.title.trim(),
        category_id: form.category_id,
        location_id: form.is_nationwide ? null : (form.location_id || null),
        is_nationwide: form.is_nationwide,
        description: form.description.trim(),
        price: form.price_type !== 'free' && form.price_type !== 'contact' && form.price
          ? parseFloat(form.price.replace(/\D/g, ''))
          : null,
        price_type: form.price_type,
        condition: form.condition || null,
        updated_at: new Date().toISOString(),
      };

      const { error: updateError } = await supabase
        .from('listings')
        .update(updates)
        .eq('id', listing.id);

      if (updateError) throw updateError;

      router.push(`/listing/${listing.slug}?updated=1`);
    } catch (err) {
      console.error(err);
      setError('Error al guardar los cambios. Intenta de nuevo.');
      setLoading(false);
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-xl px-4 py-3">{error}</div>
      )}

      {/* Title */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1">Título del anuncio *</label>
        <input
          name="title"
          type="text"
          required
          maxLength={120}
          value={form.title}
          onChange={handleChange}
          className="w-full px-4 py-3 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue"
        />
      </div>

      {/* Category */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1">Categoría *</label>
        <select
          name="category_id"
          required
          value={form.category_id}
          onChange={handleChange}
          className="w-full px-4 py-3 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue bg-white"
        >
          <option value="">Selecciona una categoría</option>
          {parentCats.map((parent) => {
            const children = childCats(parent.id);
            return children.length > 0 ? (
              <optgroup key={parent.id} label={parent.name_es}>
                {children.map((child) => (
                  <option key={child.id} value={child.id}>{child.name_es}</option>
                ))}
              </optgroup>
            ) : (
              <option key={parent.id} value={parent.id}>{parent.name_es}</option>
            );
          })}
        </select>
      </div>

      {/* Location */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1">
          Ciudad
          {form.is_nationwide && (
            <span className="ml-2 text-xs font-normal text-brand-blue">(no aplica — anuncio nacional)</span>
          )}
        </label>
        <select
          name="location_id"
          value={form.is_nationwide ? '' : form.location_id}
          onChange={handleChange}
          disabled={form.is_nationwide}
          className="w-full px-4 py-3 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue bg-white disabled:bg-gray-50 disabled:text-gray-400"
        >
          <option value="">Selecciona una ciudad</option>
          {Object.entries(groupedLocations).sort().map(([dept, locs]) => (
            <optgroup key={dept} label={dept}>
              {locs.map((loc) => (
                <option key={loc.id} value={loc.id}>{loc.city}</option>
              ))}
            </optgroup>
          ))}
        </select>
      </div>

      {/* Nationwide toggle */}
      <div className="flex items-start gap-3">
        <input
          id="is_nationwide"
          name="is_nationwide"
          type="checkbox"
          checked={form.is_nationwide}
          onChange={handleChange}
          className="mt-0.5 h-4 w-4 rounded border-gray-300 text-brand-blue focus:ring-brand-blue"
        />
        <label htmlFor="is_nationwide" className="text-sm font-semibold text-gray-700 cursor-pointer">
          Disponible en todo Colombia 🇨🇴
        </label>
      </div>

      {/* Description */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1">Descripción *</label>
        <textarea
          name="description"
          required
          rows={5}
          minLength={30}
          maxLength={3000}
          value={form.description}
          onChange={handleChange}
          className="w-full px-4 py-3 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue resize-none"
        />
        <p className="text-xs text-gray-400 text-right mt-1">{form.description.length}/3000</p>
      </div>

      {/* Price type + price */}
      <div className="grid grid-cols-2 gap-3">
        <div>
          <label className="block text-sm font-semibold text-gray-700 mb-1">Tipo de precio *</label>
          <select
            name="price_type"
            value={form.price_type}
            onChange={handleChange}
            className="w-full px-3 py-3 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue bg-white"
          >
            <option value="fixed">Precio fijo</option>
            <option value="negotiable">Negociable</option>
            <option value="free">Gratis</option>
            <option value="contact">A convenir</option>
          </select>
        </div>
        {(form.price_type === 'fixed' || form.price_type === 'negotiable') && (
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1">Precio (COP) *</label>
            <input
              name="price"
              type="number"
              required
              min="0"
              value={form.price}
              onChange={handleChange}
              className="w-full px-3 py-3 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue"
            />
          </div>
        )}
      </div>

      {/* Condition */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1">Estado del producto</label>
        <select
          name="condition"
          value={form.condition}
          onChange={handleChange}
          className="w-full px-4 py-3 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue bg-white"
        >
          <option value="">No aplica (servicio)</option>
          <option value="new">Nuevo</option>
          <option value="like_new">Como nuevo</option>
          <option value="good">Buen estado</option>
          <option value="fair">Estado regular</option>
          <option value="for_parts">Para repuestos</option>
        </select>
      </div>

      <div className="flex gap-3 pt-2">
        <button
          type="button"
          onClick={() => router.push(`/listing/${listing.slug}`)}
          className="flex-1 bg-gray-100 text-gray-700 font-semibold py-3 rounded-xl text-sm hover:bg-gray-200 transition-colors"
        >
          Cancelar
        </button>
        <button
          type="submit"
          disabled={loading}
          className="flex-1 bg-brand-blue text-white font-bold py-3 rounded-xl text-sm hover:bg-brand-blue-700 transition-colors disabled:opacity-60 disabled:cursor-not-allowed"
        >
          {loading ? 'Guardando...' : 'Guardar cambios'}
        </button>
      </div>
    </form>
  );
}

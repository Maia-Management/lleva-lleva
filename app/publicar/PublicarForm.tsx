'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { generateListingSlug } from '@/lib/utils';
import ImageUploader, { UploadedImage } from '@/components/listings/ImageUploader';

interface Category { id: string; name_es: string; slug: string; parent_id: string | null; sort_order: number; }
interface Location { id: string; department: string; city: string; slug: string; }

interface Props {
  userId: string;
  categories: Category[];
  locations: Location[];
  blocked: boolean;
}

export default function PublicarForm({ userId, categories, locations, blocked }: Props) {
  const router = useRouter();

  const [form, setForm] = useState({
    title: '',
    category_id: '',
    location_id: '',
    description: '',
    price: '',
    price_type: 'fixed' as 'fixed' | 'negotiable' | 'free' | 'contact',
    condition: '' as '' | 'new' | 'like_new' | 'good' | 'fair' | 'for_parts',
    whatsapp: '',
    is_nationwide: false,
  });
  const [images, setImages] = useState<UploadedImage[]>([]);
  const [loading, setLoading] = useState(false);
  const [uploadProgress, setUploadProgress] = useState('');
  const [error, setError] = useState('');

  const parentCats = categories.filter((c) => !c.parent_id);

  const childCats = (parentId: string) =>
    categories.filter((c) => c.parent_id === parentId);

  const groupedLocations = locations.reduce<Record<string, Location[]>>((acc, loc) => {
    (acc[loc.department] ||= []).push(loc);
    return acc;
  }, {});

  function handleChange(e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) {
    const { name, value, type } = e.target;
    const checked = (e.target as HTMLInputElement).checked;
    setForm((f) => ({ ...f, [name]: type === 'checkbox' ? checked : value }));
  }

  async function uploadImages(listingId: string): Promise<Array<{ url: string; alt?: string; order: number }>> {
    const { createClient } = await import('@/lib/supabase/client');
    const supabase = createClient();
    const uploaded: Array<{ url: string; alt?: string; order: number }> = [];

    for (let i = 0; i < images.length; i++) {
      const img = images[i];
      setUploadProgress(`Subiendo imagen ${i + 1} de ${images.length}...`);

      const ext = img.file.name.split('.').pop()?.toLowerCase() ?? 'jpg';
      const path = `${userId}/${listingId}/${i + 1}.${ext}`;

      const { error: uploadError } = await supabase.storage
        .from('listing-images')
        .upload(path, img.file, {
          contentType: img.file.type,
          upsert: true,
        });

      if (uploadError) {
        console.error('Upload error:', uploadError);
        continue;
      }

      const { data: urlData } = supabase.storage
        .from('listing-images')
        .getPublicUrl(path);

      if (urlData?.publicUrl) {
        uploaded.push({ url: urlData.publicUrl, order: i });
      }
    }

    return uploaded;
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (blocked) return;
    setLoading(true);
    setError('');
    setUploadProgress('');

    try {
      const { createClient } = await import('@/lib/supabase/client');
      const supabase = createClient();
      const listingId = crypto.randomUUID();
      const slug = generateListingSlug(form.title, listingId);

      // Upload images first
      let uploadedImages: Array<{ url: string; alt?: string; order: number }> = [];
      if (images.length > 0) {
        uploadedImages = await uploadImages(listingId);
      }

      setUploadProgress('Publicando anuncio...');

      const listingData = {
        id: listingId,
        seller_id: userId,
        category_id: form.category_id,
        location_id: form.is_nationwide ? null : (form.location_id || null),
        is_nationwide: form.is_nationwide,
        title: form.title.trim(),
        slug,
        description: form.description.trim(),
        price: form.price_type !== 'free' && form.price_type !== 'contact' && form.price
          ? parseFloat(form.price.replace(/\D/g, ''))
          : null,
        price_type: form.price_type,
        condition: form.condition || null,
        images: uploadedImages,
        status: 'active' as const,
        published_at: new Date().toISOString(),
      };

      const { data: listing, error: listingError } = await supabase
        .from('listings')
        .insert(listingData)
        .select('slug')
        .single();

      if (listingError) throw listingError;

      // Update WhatsApp if provided
      if (form.whatsapp) {
        await supabase
          .from('profiles')
          .update({ whatsapp_number: form.whatsapp.replace(/\D/g, '') })
          .eq('id', userId);
      }

      router.push(`/listing/${listing.slug}?published=1`);
    } catch (err) {
      setError('Error al publicar el anuncio. Intenta de nuevo.');
      console.error(err);
      setLoading(false);
      setUploadProgress('');
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
          placeholder="Ej: Toyota Hilux 2020 – Full equipo"
          className="w-full px-4 py-3 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue"
        />
      </div>

      {/* Images */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-2">
          Fotos <span className="font-normal text-gray-400">(hasta 5, recomendado)</span>
        </label>
        <ImageUploader images={images} onChange={setImages} />
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
        <div>
          <label htmlFor="is_nationwide" className="text-sm font-semibold text-gray-700 cursor-pointer">
            Disponible en todo Colombia 🇨🇴
          </label>
          <p className="text-xs text-gray-400 mt-0.5">
            Tu anuncio aparecerá en búsquedas de cualquier ciudad. Ideal para servicios nacionales, empleos con reubicación o cursos online.
          </p>
        </div>
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
          placeholder="Describe en detalle lo que ofreces: características, estado, motivo de venta..."
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
              placeholder="Ej: 2500000"
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

      {/* WhatsApp */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1">
          Tu número de WhatsApp
        </label>
        <div className="flex items-center border border-gray-300 rounded-xl overflow-hidden focus-within:ring-2 focus-within:ring-brand-blue">
          <span className="px-3 py-3 bg-gray-50 text-gray-500 text-sm border-r border-gray-300">+57</span>
          <input
            name="whatsapp"
            type="tel"
            value={form.whatsapp}
            onChange={handleChange}
            placeholder="3001234567"
            className="flex-1 px-3 py-3 text-sm focus:outline-none"
          />
        </div>
        <p className="text-xs text-gray-400 mt-1">
          Tu número NO será visible públicamente — solo se usa para el botón de WhatsApp.
        </p>
      </div>

      {uploadProgress && (
        <div className="bg-brand-blue-50 border border-brand-blue/20 text-brand-blue text-sm rounded-xl px-4 py-3 flex items-center gap-2">
          <svg className="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
          </svg>
          {uploadProgress}
        </div>
      )}

      <button
        type="submit"
        disabled={loading || blocked}
        className="w-full bg-brand-blue text-white font-bold py-4 rounded-xl text-base hover:bg-brand-blue-700 transition-colors disabled:opacity-60 disabled:cursor-not-allowed"
      >
        {loading ? uploadProgress || 'Publicando...' : blocked ? 'Califica primero para publicar' : 'Publicar anuncio gratis'}
      </button>
    </form>
  );
}

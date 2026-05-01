'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';
import { Profile, Location } from '@/types';

interface Props {
  profile: Profile;
  locations: Location[];
}

export default function ProfileEditForm({ profile, locations }: Props) {
  const router = useRouter();
  const [displayName, setDisplayName] = useState(profile.display_name ?? '');
  const [bio, setBio] = useState(profile.bio ?? '');
  const [whatsapp, setWhatsapp] = useState(profile.whatsapp_number ?? '');
  const [city, setCity] = useState(profile.city ?? '');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);

  // Get unique cities for dropdown
  const cityOptions = Array.from(
    new Map(
      locations
        .filter((l) => l.is_active)
        .map((l) => [`${l.city}|||${l.department}`, l])
    ).values()
  ).sort((a, b) => a.city.localeCompare(b.city, 'es'));

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!displayName.trim()) {
      setError('El nombre es obligatorio.');
      return;
    }

    setSaving(true);
    setError('');
    setSuccess(false);

    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();

      if (!user) {
        router.push('/auth/login');
        return;
      }

      // Parse city/department from combined value
      const [selectedCity, selectedDept] = city.split('|||');

      const { error: updateError } = await supabase
        .from('profiles')
        .update({
          display_name: displayName.trim(),
          bio: bio.trim() || null,
          whatsapp_number: whatsapp.trim() || null,
          city: selectedCity || null,
          department: selectedDept || null,
        })
        .eq('id', user.id);

      if (updateError) {
        setError(updateError.message);
      } else {
        setSuccess(true);
        router.refresh();
      }
    } finally {
      setSaving(false);
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      {success && (
        <div className="bg-brand-blue-50 border border-brand-blue/20 text-brand-blue text-sm rounded-xl px-4 py-3">
          ✅ Perfil actualizado correctamente.
        </div>
      )}
      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-xl px-4 py-3">
          {error}
        </div>
      )}

      {/* Display name */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1">
          Nombre para mostrar <span className="text-red-500">*</span>
        </label>
        <input
          type="text"
          value={displayName}
          onChange={(e) => setDisplayName(e.target.value)}
          required
          maxLength={80}
          className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue"
          placeholder="Tu nombre o nombre de negocio"
        />
      </div>

      {/* Bio */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1">Bio</label>
        <textarea
          value={bio}
          onChange={(e) => setBio(e.target.value)}
          rows={3}
          maxLength={300}
          className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue resize-none"
          placeholder="Cuéntanos un poco sobre ti…"
        />
        <p className="text-xs text-gray-400 mt-1">{bio.length}/300</p>
      </div>

      {/* City */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1">Ciudad</label>
        <select
          value={city}
          onChange={(e) => setCity(e.target.value)}
          className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue bg-white"
        >
          <option value="">Selecciona tu ciudad</option>
          {cityOptions.map((loc) => (
            <option key={loc.slug} value={`${loc.city}|||${loc.department}`}>
              {loc.city}, {loc.department}
            </option>
          ))}
        </select>
      </div>

      {/* WhatsApp */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1">
          Número de WhatsApp
        </label>
        <div className="relative">
          <span className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-sm">+</span>
          <input
            type="tel"
            value={whatsapp}
            onChange={(e) => setWhatsapp(e.target.value.replace(/\D/g, ''))}
            className="w-full border border-gray-200 rounded-xl pl-7 pr-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue"
            placeholder="573001234567"
            maxLength={15}
          />
        </div>
        <p className="text-xs text-gray-400 mt-1">
          Incluye código de país. Ej: 573001234567 (Colombia)
        </p>
      </div>

      <div className="flex gap-3 pt-2">
        <button
          type="button"
          onClick={() => router.back()}
          disabled={saving}
          className="flex-1 bg-gray-100 text-gray-700 font-semibold py-3 rounded-xl text-sm hover:bg-gray-200 transition-colors disabled:opacity-60"
        >
          Cancelar
        </button>
        <button
          type="submit"
          disabled={saving}
          className="flex-1 bg-brand-blue text-white font-semibold py-3 rounded-xl text-sm hover:bg-brand-blue-700 transition-colors disabled:opacity-60"
        >
          {saving ? 'Guardando...' : 'Guardar cambios'}
        </button>
      </div>
    </form>
  );
}

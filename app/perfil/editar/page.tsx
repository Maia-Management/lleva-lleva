import { redirect } from 'next/navigation';
import { Metadata } from 'next';
import { createClient } from '@/lib/supabase/server';
import { Profile, Location } from '@/types';
import Link from 'next/link';
import ProfileEditForm from './ProfileEditForm';

export const metadata: Metadata = { title: 'Editar perfil – LlevaLleva.co' };

export default async function EditProfilePage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect('/auth/login?redirectTo=/perfil/editar');

  const [{ data: profile }, { data: locations }] = await Promise.all([
    supabase.from('profiles').select('*').eq('id', user.id).single(),
    supabase.from('locations').select('*').eq('is_active', true).order('department').order('city').limit(500),
  ]);

  if (!profile) redirect('/auth/login');

  return (
    <div className="max-w-lg mx-auto px-4 sm:px-6 py-8">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <Link href="/dashboard" className="text-gray-400 hover:text-gray-600 transition-colors">
          ←
        </Link>
        <div>
          <h1 className="text-xl font-bold text-gray-900">Editar perfil</h1>
          <p className="text-xs text-gray-500">@{profile.username}</p>
        </div>
      </div>

      <div className="bg-white rounded-2xl border border-gray-200 p-6">
        <ProfileEditForm
          profile={profile as Profile}
          locations={(locations as Location[]) ?? []}
        />
      </div>
    </div>
  );
}

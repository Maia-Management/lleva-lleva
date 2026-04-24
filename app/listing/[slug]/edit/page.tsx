import { notFound, redirect } from 'next/navigation';
import { Metadata } from 'next';
import { createClient } from '@/lib/supabase/server';
import { Listing } from '@/types';
import EditListingForm from './EditListingForm';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'Editar anuncio',
};

interface Props {
  params: Promise<{ slug: string }>;
}

export default async function EditListingPage({ params }: Props) {
  const { slug } = await params;
  const supabase = await createClient();

  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect(`/auth/login?redirectTo=/listing/${slug}/edit`);

  const { data } = await supabase
    .from('listings')
    .select('*, category:categories(*), location:locations(*)')
    .eq('slug', slug)
    .in('status', ['active', 'paused', 'draft'])
    .single();

  if (!data) notFound();

  const listing = data as Listing;

  // Only the owner can edit
  if (listing.seller_id !== user.id) {
    redirect(`/listing/${slug}`);
  }

  const [{ data: categories }, { data: locations }] = await Promise.all([
    supabase
      .from('categories')
      .select('id, name_es, slug, parent_id, sort_order')
      .eq('is_active', true)
      .order('sort_order'),
    supabase
      .from('locations')
      .select('id, department, city, slug')
      .eq('is_active', true)
      .order('department')
      .order('city'),
  ]);

  return (
    <div className="max-w-2xl mx-auto px-4 sm:px-6 py-8">
      <nav className="text-xs text-gray-500 mb-4 flex items-center gap-1.5">
        <Link href="/" className="hover:text-emerald-600">Inicio</Link>
        <span>›</span>
        <Link href={`/listing/${slug}`} className="hover:text-emerald-600 line-clamp-1 max-w-xs">
          {listing.title}
        </Link>
        <span>›</span>
        <span className="text-gray-700">Editar</span>
      </nav>

      <h1 className="text-2xl font-bold text-gray-900 mb-2">Editar anuncio</h1>
      <p className="text-sm text-gray-500 mb-6">
        Modifica los datos de tu anuncio. Los cambios se aplicarán de inmediato.
      </p>

      <EditListingForm
        listing={listing}
        categories={categories ?? []}
        locations={locations ?? []}
      />
    </div>
  );
}

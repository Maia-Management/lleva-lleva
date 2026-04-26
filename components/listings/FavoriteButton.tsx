'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';

interface Props {
  listingId: string;
  size?: 'sm' | 'md';
}

export default function FavoriteButton({ listingId, size = 'md' }: Props) {
  const [isFav, setIsFav] = useState(false);
  const [userId, setUserId] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [mounted, setMounted] = useState(false);
  const router = useRouter();

  useEffect(() => {
    setMounted(true);
    const supabase = createClient();
    supabase.auth.getUser().then(({ data: { user } }) => {
      setUserId(user?.id ?? null);
      if (user) {
        supabase
          .from('favorites')
          .select('id')
          .eq('user_id', user.id)
          .eq('listing_id', listingId)
          .maybeSingle()
          .then(({ data }) => setIsFav(!!data));
      }
    });
  }, [listingId]);

  if (!mounted) return null;

  async function toggle(e: React.MouseEvent) {
    e.preventDefault();
    e.stopPropagation();

    if (!userId) {
      router.push('/auth/login?redirectTo=' + encodeURIComponent(window.location.pathname));
      return;
    }

    const supabase = createClient();
    setLoading(true);
    try {
      if (isFav) {
        await supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('listing_id', listingId);
        setIsFav(false);
      } else {
        await supabase
          .from('favorites')
          .insert({ user_id: userId, listing_id: listingId });
        setIsFav(true);
      }
    } finally {
      setLoading(false);
    }
  }

  const iconSize = size === 'sm' ? 'w-7 h-7 text-sm' : 'w-9 h-9 text-base';

  return (
    <button
      type="button"
      onClick={toggle}
      disabled={loading}
      aria-label={isFav ? 'Quitar de guardados' : 'Guardar anuncio'}
      className={`${iconSize} flex items-center justify-center rounded-full transition-all duration-150 disabled:opacity-60
        ${isFav
          ? 'bg-red-50 text-red-500 hover:bg-red-100'
          : 'bg-white/80 text-gray-400 hover:text-red-400 hover:bg-white'
        } backdrop-blur-sm shadow-sm border border-white/60`}
    >
      {isFav ? '❤️' : '🤍'}
    </button>
  );
}

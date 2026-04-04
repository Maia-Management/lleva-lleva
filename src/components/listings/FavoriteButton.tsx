"use client";

import { useState, useEffect } from "react";
import { Heart } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { useLocale } from "@/lib/locale-context";
import Button from "@/components/ui/Button";

interface FavoriteButtonProps {
  listingId: string;
}

export default function FavoriteButton({ listingId }: FavoriteButtonProps) {
  const [isFavorite, setIsFavorite] = useState(false);
  const [loading, setLoading] = useState(false);
  const supabase = createClient();
  const { t } = useLocale();

  useEffect(() => {
    const check = async () => {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) return;

      const { data } = await supabase
        .from("favorites")
        .select("id")
        .eq("user_id", user.id)
        .eq("listing_id", listingId)
        .maybeSingle();

      setIsFavorite(!!data);
    };
    check();
  }, [listingId, supabase]);

  const toggle = async () => {
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      window.location.href = `/auth/login?redirect=/listings/${listingId}`;
      return;
    }

    setLoading(true);
    if (isFavorite) {
      await supabase
        .from("favorites")
        .delete()
        .eq("user_id", user.id)
        .eq("listing_id", listingId);
      setIsFavorite(false);
    } else {
      await supabase
        .from("favorites")
        .insert({ user_id: user.id, listing_id: listingId });
      setIsFavorite(true);
    }
    setLoading(false);
  };

  return (
    <Button
      variant="outline"
      onClick={toggle}
      loading={loading}
      className="flex-1"
    >
      <Heart
        className={`w-4 h-4 ${isFavorite ? "fill-red-500 text-red-500" : ""}`}
      />
      {isFavorite ? t("detail.saved") : t("detail.save")}
    </Button>
  );
}

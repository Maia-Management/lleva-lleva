"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Trash2 } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { useLocale } from "@/lib/locale-context";
import Button from "@/components/ui/Button";

interface DeleteListingButtonProps {
  listingId: string;
}

export default function DeleteListingButton({
  listingId,
}: DeleteListingButtonProps) {
  const [confirming, setConfirming] = useState(false);
  const [deleting, setDeleting] = useState(false);
  const router = useRouter();
  const supabase = createClient();
  const { t } = useLocale();

  const handleDelete = async () => {
    setDeleting(true);
    await supabase.from("listings").delete().eq("id", listingId);
    router.push("/profile");
    router.refresh();
  };

  if (confirming) {
    return (
      <div className="flex gap-2">
        <Button
          variant="ghost"
          size="sm"
          onClick={() => setConfirming(false)}
        >
          {t("delete.cancel")}
        </Button>
        <Button
          variant="primary"
          size="sm"
          loading={deleting}
          onClick={handleDelete}
          className="bg-red-500 hover:bg-red-600"
        >
          <Trash2 className="w-4 h-4" />
          {t("delete.confirm")}
        </Button>
      </div>
    );
  }

  return (
    <Button
      variant="ghost"
      size="sm"
      onClick={() => setConfirming(true)}
      aria-label="Eliminar anuncio"
    >
      <Trash2 className="w-4 h-4 text-red-500" />
    </Button>
  );
}

"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { useLocale } from "@/lib/locale-context";
import Button from "@/components/ui/Button";
import Input from "@/components/ui/Input";
import { CITIES, formatCityName } from "@/lib/constants";
import type { Profile } from "@/lib/types";

interface ProfileEditorProps {
  profile: Profile;
}

export default function ProfileEditor({ profile }: ProfileEditorProps) {
  const [name, setName] = useState(profile.full_name ?? "");
  const [city, setCity] = useState(profile.city ?? "Santa Marta");
  const [whatsapp, setWhatsapp] = useState(profile.whatsapp_number ?? "");
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const router = useRouter();
  const supabase = createClient();
  const { t } = useLocale();

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);

    await supabase
      .from("profiles")
      .update({
        full_name: name.trim(),
        city,
        whatsapp_number: whatsapp.replace(/\D/g, ""),
      })
      .eq("id", profile.id);

    setSaving(false);
    setSaved(true);
    setTimeout(() => setSaved(false), 2000);
    router.refresh();
  };

  return (
    <form
      onSubmit={handleSave}
      className="bg-white rounded-xl border border-navy-100 p-6 space-y-4"
    >
      <Input
        id="profile-name"
        label={t("profile.name")}
        value={name}
        onChange={(e) => setName(e.target.value)}
        placeholder={t("profile.namePlaceholder")}
      />
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label
            htmlFor="profile-city"
            className="block text-sm font-medium text-navy-700 mb-1"
          >
            {t("form.city")}
          </label>
          <select
            id="profile-city"
            value={city}
            onChange={(e) => setCity(e.target.value)}
            className="w-full rounded-lg border border-navy-200 bg-white px-3 py-2 text-sm text-navy-700 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
          >
            {CITIES.map((c) => (
              <option key={c} value={c}>
                {formatCityName(c)}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label
            htmlFor="profile-whatsapp"
            className="block text-sm font-medium text-navy-700 mb-1"
          >
            WhatsApp
          </label>
          <div className="flex">
            <span className="inline-flex items-center px-3 rounded-l-lg border border-r-0 border-navy-200 bg-navy-50 text-sm text-navy-500">
              +57
            </span>
            <input
              id="profile-whatsapp"
              type="tel"
              value={whatsapp}
              onChange={(e) => setWhatsapp(e.target.value.replace(/\D/g, ""))}
              placeholder="300 123 4567"
              maxLength={10}
              className="flex-1 rounded-r-lg border border-navy-200 px-3 py-2 text-sm text-navy-800 placeholder:text-navy-400 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
            />
          </div>
        </div>
      </div>
      <div className="flex items-center gap-3">
        <Button type="submit" loading={saving}>
          {t("profile.save")}
        </Button>
        {saved && (
          <span className="text-sm text-emerald-600">{t("profile.saved")}</span>
        )}
      </div>
    </form>
  );
}

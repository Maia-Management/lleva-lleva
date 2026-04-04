"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { MapPin } from "lucide-react";
import { CITIES } from "@/lib/constants";
import { useLocale } from "@/lib/locale-context";

export default function CityFilter() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const current = searchParams.get("city") ?? "";
  const { t } = useLocale();

  const handleChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const params = new URLSearchParams(searchParams.toString());
    if (e.target.value) {
      params.set("city", e.target.value);
    } else {
      params.delete("city");
    }
    router.push(`/listings?${params.toString()}`);
  };

  return (
    <div className="relative">
      <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-navy-400 pointer-events-none" />
      <select
        value={current}
        onChange={handleChange}
        className="pl-9 pr-8 py-2.5 rounded-lg border border-navy-200 bg-white text-sm text-navy-700 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20 appearance-none cursor-pointer"
      >
        <option value="">{t("listings.allCities")}</option>
        {CITIES.map((city) => (
          <option key={city} value={city}>
            {city}
          </option>
        ))}
      </select>
    </div>
  );
}

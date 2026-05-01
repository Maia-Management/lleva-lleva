"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { CATEGORIES } from "@/lib/constants";
import { useLocale } from "@/lib/locale-context";
import { getCategoryLabel } from "@/lib/i18n";

export default function CategoryFilter() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const current = searchParams.get("category") ?? "";
  const { t, locale } = useLocale();

  const handleChange = (category: string) => {
    const params = new URLSearchParams(searchParams.toString());
    if (category) {
      params.set("category", category);
    } else {
      params.delete("category");
    }
    router.push(`/listings?${params.toString()}`);
  };

  return (
    <div className="flex flex-wrap gap-2">
      <button
        type="button"
        onClick={() => handleChange("")}
        aria-pressed={!current}
        className={`px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${
          !current
            ? "bg-amber-700 text-white"
            : "bg-navy-100 text-navy-600 hover:bg-navy-200"
        }`}
      >
        {t("listings.all")}
      </button>
      {CATEGORIES.map((cat) => {
        const Icon = cat.icon;
        return (
          <button
            key={cat.value}
            type="button"
            onClick={() => handleChange(cat.value)}
            aria-pressed={current === cat.value}
            className={`flex items-center gap-1 px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${
              current === cat.value
                ? "bg-amber-700 text-white"
                : "bg-navy-100 text-navy-600 hover:bg-navy-200"
            }`}
          >
            <Icon className="w-3 h-3" />
            {getCategoryLabel(cat.value, locale)}
          </button>
        );
      })}
    </div>
  );
}

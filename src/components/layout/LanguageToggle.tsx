"use client";

import { useLocale } from "@/lib/locale-context";
import { Globe } from "lucide-react";

export default function LanguageToggle() {
  const { locale, setLocale } = useLocale();

  return (
    <button
      onClick={() => setLocale(locale === "es" ? "en" : "es")}
      className="flex items-center gap-1.5 px-2 py-1 rounded-lg text-xs font-medium text-navy-600 hover:bg-navy-100 transition-colors"
      title={locale === "es" ? "Switch to English" : "Cambiar a español"}
    >
      <Globe className="w-4 h-4" />
      <span className="uppercase">{locale === "es" ? "EN" : "ES"}</span>
    </button>
  );
}

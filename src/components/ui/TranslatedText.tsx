"use client";

import { useLocale } from "@/lib/locale-context";
import type { TranslationKey } from "@/lib/i18n";

interface TranslatedTextProps {
  tKey: TranslationKey;
  as?: "h1" | "h2" | "h3" | "p" | "span";
  className?: string;
}

export default function TranslatedText({
  tKey,
  as: Tag = "span",
  className,
}: TranslatedTextProps) {
  const { t } = useLocale();
  return <Tag className={className}>{t(tKey)}</Tag>;
}

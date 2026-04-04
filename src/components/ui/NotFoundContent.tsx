"use client";

import Link from "next/link";
import { useLocale } from "@/lib/locale-context";
import Button from "@/components/ui/Button";

export default function NotFoundContent() {
  const { t } = useLocale();

  return (
    <div className="flex items-center justify-center min-h-[60vh] px-4">
      <div className="text-center">
        <h1 className="text-6xl font-extrabold text-amber-500 mb-4">404</h1>
        <h2 className="text-xl font-bold text-navy-800 mb-2">
          {t("notFound.title")}
        </h2>
        <p className="text-navy-500 mb-6">{t("notFound.desc")}</p>
        <Link href="/">
          <Button>{t("notFound.home")}</Button>
        </Link>
      </div>
    </div>
  );
}

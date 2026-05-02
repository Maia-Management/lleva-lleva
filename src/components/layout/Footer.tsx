"use client";

import Link from "next/link";
import { CATEGORIES } from "@/lib/constants";
import { useLocale } from "@/lib/locale-context";
import { getCategoryLabel } from "@/lib/i18n";

export default function Footer() {
  const { t, locale } = useLocale();

  return (
    <footer className="bg-navy-800 text-navy-300 min-h-[840px] md:min-h-0">
      <div className="max-w-7xl mx-auto px-4 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          {/* Brand */}
          <div>
            <div className="flex items-center gap-1 mb-3">
              <span className="text-xl font-extrabold text-amber-500">
                Lleva
              </span>
              <span className="text-xl font-extrabold text-white">Lleva</span>
            </div>
            <p className="text-sm text-navy-400">{t("footer.tagline")}</p>
          </div>

          {/* Categories */}
          <div>
            <p className="text-sm font-semibold text-white mb-3">
              {t("footer.categories")}
            </p>
            <ul className="space-y-2">
              {CATEGORIES.map((cat) => (
                <li key={cat.value}>
                  <Link
                    href={`/listings?category=${cat.value}`}
                    prefetch={false}
                    className="text-sm text-navy-400 hover:text-white transition-colors"
                  >
                    {getCategoryLabel(cat.value, locale)}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Info */}
          <div>
            <p className="text-sm font-semibold text-white mb-3">
              {t("footer.info")}
            </p>
            <ul className="space-y-2">
              <li>
                <Link
                  href="/about"
                  className="text-sm text-navy-400 hover:text-white transition-colors"
                >
                  {t("footer.about")}
                </Link>
              </li>
              <li>
                <Link
                  href="/safety"
                  className="text-sm text-navy-400 hover:text-white transition-colors"
                >
                  {t("footer.safety")}
                </Link>
              </li>
              <li>
                <Link
                  href="/terms"
                  className="text-sm text-navy-400 hover:text-white transition-colors"
                >
                  {t("footer.terms")}
                </Link>
              </li>
              <li>
                <Link
                  href="/privacy"
                  className="text-sm text-navy-400 hover:text-white transition-colors"
                >
                  {t("footer.privacy")}
                </Link>
              </li>
            </ul>
          </div>

          {/* Contact */}
          <div>
            <p className="text-sm font-semibold text-white mb-3">
              {t("footer.contact")}
            </p>
            <p className="text-sm text-navy-400">Santa Marta, Colombia</p>
            <p className="text-sm text-navy-400 mt-1">hola@lleva-lleva.com</p>
          </div>
        </div>

        <div className="border-t border-navy-700 mt-8 pt-6 text-center">
          <p className="text-xs text-navy-400">
            &copy; {new Date().getFullYear()} {t("footer.copy")}
          </p>
        </div>
      </div>
    </footer>
  );
}

"use client";

import Link from "next/link";
import { Search, Shield, MessageCircle, ArrowRight } from "lucide-react";
import { CATEGORIES } from "@/lib/constants";
import { useLocale } from "@/lib/locale-context";
import { getCategoryLabel } from "@/lib/i18n";
import Button from "@/components/ui/Button";

export default function HomeContent() {
  const { t, locale } = useLocale();

  return (
    <>
      {/* Hero */}
      <section className="bg-gradient-to-br from-amber-50 via-white to-emerald-50 py-16 md:py-24">
        <div className="max-w-7xl mx-auto px-4 text-center">
          <h1 className="text-4xl md:text-6xl font-extrabold text-navy-800 mb-4">
            {t("hero.title1")}
            <span className="text-amber-600">{t("hero.title2")}</span>
          </h1>
          <p className="text-lg md:text-xl text-navy-500 max-w-2xl mx-auto mb-8">
            {t("hero.subtitle")}
          </p>
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <Link href="/listings">
              <Button size="lg">
                <Search className="w-5 h-5" />
                {t("hero.explore")}
              </Button>
            </Link>
            <Link href="/listings/new" prefetch={false}>
              <Button variant="outline" size="lg">
                {t("hero.postFree")}
                <ArrowRight className="w-5 h-5" />
              </Button>
            </Link>
          </div>
        </div>
      </section>

      {/* Categories */}
      <section className="py-12 md:py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4">
          <h2 className="text-2xl font-bold text-navy-800 mb-8 text-center">
            {t("categories.title")}
          </h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
            {CATEGORIES.map((category) => {
              const Icon = category.icon;
              return (
                <Link
                  key={category.value}
                  href={`/listings?category=${category.value}`}
                  prefetch={false}
                  className="group flex flex-col items-center gap-3 p-6 rounded-xl border border-navy-100 hover:border-amber-300 hover:shadow-md transition-all"
                >
                  <div
                    className={`w-12 h-12 rounded-xl flex items-center justify-center ${category.color} group-hover:scale-110 transition-transform`}
                  >
                    <Icon className="w-6 h-6" />
                  </div>
                  <span className="text-sm font-medium text-navy-700">
                    {getCategoryLabel(category.value, locale)}
                  </span>
                </Link>
              );
            })}
          </div>
        </div>
      </section>

      {/* How it works */}
      <section className="py-12 md:py-16 bg-navy-50">
        <div className="max-w-7xl mx-auto px-4">
          <h2 className="text-2xl font-bold text-navy-800 mb-10 text-center">
            {t("how.title")}
          </h2>
          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center">
              <div className="w-14 h-14 rounded-2xl bg-amber-100 flex items-center justify-center mx-auto mb-4">
                <Search className="w-7 h-7 text-amber-600" />
              </div>
              <h3 className="font-semibold text-navy-800 mb-2">
                {t("how.step1.title")}
              </h3>
              <p className="text-sm text-navy-500">{t("how.step1.desc")}</p>
            </div>
            <div className="text-center">
              <div className="w-14 h-14 rounded-2xl bg-emerald-100 flex items-center justify-center mx-auto mb-4">
                <MessageCircle className="w-7 h-7 text-emerald-600" />
              </div>
              <h3 className="font-semibold text-navy-800 mb-2">
                {t("how.step2.title")}
              </h3>
              <p className="text-sm text-navy-500">{t("how.step2.desc")}</p>
            </div>
            <div className="text-center">
              <div className="w-14 h-14 rounded-2xl bg-blue-100 flex items-center justify-center mx-auto mb-4">
                <Shield className="w-7 h-7 text-blue-600" />
              </div>
              <h3 className="font-semibold text-navy-800 mb-2">
                {t("how.step3.title")}
              </h3>
              <p className="text-sm text-navy-500">{t("how.step3.desc")}</p>
            </div>
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="py-12 md:py-16 bg-gradient-to-r from-amber-700 to-amber-800">
        <div className="max-w-3xl mx-auto px-4 text-center">
          <h2 className="text-2xl md:text-3xl font-bold text-white mb-4">
            {t("cta.title")}
          </h2>
          <p className="text-white mb-6">{t("cta.subtitle")}</p>
          <Link href="/listings/new" prefetch={false}>
            <Button variant="secondary" size="lg">
              {t("cta.button")}
              <ArrowRight className="w-5 h-5" />
            </Button>
          </Link>
        </div>
      </section>
    </>
  );
}

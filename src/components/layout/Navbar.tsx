"use client";

import Link from "next/link";
import { useState, useEffect, useRef } from "react";
import { Menu, X, Plus, User, LogOut, Heart } from "lucide-react";
import { useLocale } from "@/lib/locale-context";
import type {
  SupabaseClient,
  User as SupabaseUser,
} from "@supabase/supabase-js";
import Button from "@/components/ui/Button";
import LanguageToggle from "./LanguageToggle";

type IdleWindow = typeof window & {
  requestIdleCallback?: (
    callback: () => void,
    options?: { timeout?: number },
  ) => number;
  cancelIdleCallback?: (handle: number) => void;
};

export default function Navbar() {
  const [user, setUser] = useState<SupabaseUser | null>(null);
  const [menuOpen, setMenuOpen] = useState(false);
  const supabaseRef = useRef<SupabaseClient | null>(null);
  const { t } = useLocale();

  useEffect(() => {
    let active = true;
    let idleHandle: number | null = null;
    let timeoutHandle: ReturnType<typeof setTimeout> | null = null;
    let unsubscribe: (() => void) | null = null;
    const browserWindow = window as IdleWindow;

    const loadAuth = async () => {
      const { createClient } = await import("@/lib/supabase/client");
      if (!active) return;

      const supabase = createClient();
      supabaseRef.current = supabase;

      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!active) return;
      setUser(user);

      const {
        data: { subscription },
      } = supabase.auth.onAuthStateChange((_event, session) => {
        if (active) setUser(session?.user ?? null);
      });
      unsubscribe = () => subscription.unsubscribe();
    };

    if (browserWindow.requestIdleCallback) {
      idleHandle = browserWindow.requestIdleCallback(
        () => {
          void loadAuth();
        },
        { timeout: 2500 },
      );
    } else {
      timeoutHandle = setTimeout(() => {
        void loadAuth();
      }, 1200);
    }

    return () => {
      active = false;
      if (idleHandle !== null) browserWindow.cancelIdleCallback?.(idleHandle);
      if (timeoutHandle !== null) clearTimeout(timeoutHandle);
      unsubscribe?.();
    };
  }, []);

  const handleSignOut = async () => {
    const supabase =
      supabaseRef.current ??
      (await import("@/lib/supabase/client")).createClient();
    await supabase.auth.signOut();
    setUser(null);
    setMenuOpen(false);
  };

  return (
    <header className="sticky top-0 z-50 bg-white border-b border-navy-100 shadow-sm">
      <nav className="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
        {/* Logo */}
        <Link href="/" className="flex items-center gap-2">
          <span className="text-2xl font-extrabold text-amber-600 tracking-tight">
            Lleva
          </span>
          <span className="text-2xl font-extrabold text-navy-800 tracking-tight">
            Lleva
          </span>
        </Link>

        {/* Desktop nav */}
        <div className="hidden md:flex items-center gap-4">
          <Link
            href="/listings"
            prefetch={false}
            className="text-sm font-medium text-navy-600 hover:text-navy-800 transition-colors"
          >
            {t("nav.explore")}
          </Link>
          {user ? (
            <>
              <Link
                href="/favorites"
                className="text-sm font-medium text-navy-600 hover:text-navy-800 transition-colors flex items-center gap-1"
              >
                <Heart className="w-4 h-4" />
                {t("nav.favorites")}
              </Link>
              <Link href="/listings/new" prefetch={false}>
                <Button size="sm">
                  <Plus className="w-4 h-4" />
                  {t("nav.publish")}
                </Button>
              </Link>
              <div className="relative">
                <button
                  onClick={() => setMenuOpen(!menuOpen)}
                  aria-label={t("nav.myProfile")}
                  className="flex items-center gap-2 p-2 rounded-lg hover:bg-navy-50 transition-colors"
                >
                  <div className="w-8 h-8 rounded-full bg-amber-100 flex items-center justify-center">
                    <User className="w-4 h-4 text-amber-700" />
                  </div>
                </button>
                {menuOpen && (
                  <div className="absolute right-0 top-12 w-48 bg-white rounded-xl shadow-lg border border-navy-100 py-2">
                    <Link
                      href="/profile"
                      onClick={() => setMenuOpen(false)}
                      className="flex items-center gap-2 px-4 py-2 text-sm text-navy-700 hover:bg-navy-50"
                    >
                      <User className="w-4 h-4" />
                      {t("nav.myProfile")}
                    </Link>
                    <button
                      onClick={handleSignOut}
                      className="w-full flex items-center gap-2 px-4 py-2 text-sm text-red-600 hover:bg-red-50"
                    >
                      <LogOut className="w-4 h-4" />
                      {t("nav.signOut")}
                    </button>
                  </div>
                )}
              </div>
            </>
          ) : (
            <Link href="/auth/login">
              <Button size="sm">{t("nav.signIn")}</Button>
            </Link>
          )}
          <LanguageToggle />
        </div>

        {/* Mobile hamburger */}
        <div className="flex md:hidden items-center gap-2">
          <LanguageToggle />
          <button
            aria-label={menuOpen ? "Cerrar menu" : "Abrir menu"}
            aria-expanded={menuOpen}
            className="p-2 rounded-lg hover:bg-navy-50"
            onClick={() => setMenuOpen(!menuOpen)}
          >
            {menuOpen ? (
              <X className="w-6 h-6 text-navy-700" />
            ) : (
              <Menu className="w-6 h-6 text-navy-700" />
            )}
          </button>
        </div>
      </nav>

      {/* Mobile menu */}
      {menuOpen && (
        <div className="md:hidden border-t border-navy-100 bg-white px-4 py-4 space-y-3">
          <Link
            href="/listings"
            prefetch={false}
            onClick={() => setMenuOpen(false)}
            className="block text-sm font-medium text-navy-700 py-2"
          >
            {t("nav.explore")}
          </Link>
          {user ? (
            <>
              <Link
                href="/favorites"
                onClick={() => setMenuOpen(false)}
                className="block text-sm font-medium text-navy-700 py-2"
              >
                {t("nav.favorites")}
              </Link>
              <Link
                href="/listings/new"
                prefetch={false}
                onClick={() => setMenuOpen(false)}
                className="block"
              >
                <Button className="w-full">
                  <Plus className="w-4 h-4" />
                  {t("nav.publish")}
                </Button>
              </Link>
              <Link
                href="/profile"
                onClick={() => setMenuOpen(false)}
                className="block text-sm font-medium text-navy-700 py-2"
              >
                {t("nav.myProfile")}
              </Link>
              <button
                onClick={handleSignOut}
                className="text-sm font-medium text-red-600 py-2"
              >
                {t("nav.signOut")}
              </button>
            </>
          ) : (
            <Link href="/auth/login" onClick={() => setMenuOpen(false)}>
              <Button className="w-full">{t("nav.signIn")}</Button>
            </Link>
          )}
        </div>
      )}
    </header>
  );
}

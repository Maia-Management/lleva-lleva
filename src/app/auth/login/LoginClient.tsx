"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Phone } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { useLocale } from "@/lib/locale-context";
import Button from "@/components/ui/Button";
import Input from "@/components/ui/Input";

interface LoginClientProps {
  redirect?: string;
}

export default function LoginClient({ redirect = "/" }: LoginClientProps) {
  const [phone, setPhone] = useState("");
  const [otp, setOtp] = useState("");
  const [step, setStep] = useState<"phone" | "otp">("phone");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const router = useRouter();
  const supabase = createClient();
  const { t } = useLocale();

  const formatPhone = (value: string) => {
    const digits = value.replace(/\D/g, "");
    if (!digits.startsWith("57") && digits.length <= 10) {
      return `+57${digits}`;
    }
    return `+${digits}`;
  };

  const handleSendOTP = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    const formattedPhone = formatPhone(phone);
    const { error } = await supabase.auth.signInWithOtp({
      phone: formattedPhone,
    });

    if (error) {
      setError(error.message);
    } else {
      setStep("otp");
    }
    setLoading(false);
  };

  const handleVerifyOTP = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    const formattedPhone = formatPhone(phone);
    const { error } = await supabase.auth.verifyOtp({
      phone: formattedPhone,
      token: otp,
      type: "sms",
    });

    if (error) {
      setError(error.message);
    } else {
      router.push(redirect);
      router.refresh();
    }
    setLoading(false);
  };

  return (
    <div className="min-h-[70vh] flex items-center justify-center px-4 py-12">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <div className="w-16 h-16 bg-amber-100 rounded-2xl flex items-center justify-center mx-auto mb-4">
            <Phone className="w-8 h-8 text-amber-600" />
          </div>
          <h1 className="text-2xl font-bold text-navy-800">
            Ingresa para publicar y guardar anuncios
          </h1>
          <p className="text-sm text-navy-500 mt-3 leading-6">
            Usa tu numero de celular colombiano para acceder a Lleva Lleva,
            publicar clasificados gratis, guardar anuncios favoritos y gestionar
            tus conversaciones con vendedores locales.
          </p>
          <p className="text-sm text-navy-500 mt-3 leading-6">
            El ingreso por codigo SMS ayuda a reducir cuentas falsas y mantiene
            el proceso simple para compradores, vendedores y pequenos negocios
            que necesitan volver rapido a sus anuncios.
          </p>
          <p className="text-sm font-semibold text-navy-700 mt-4">
            {step === "phone" ? t("auth.loginTitle") : t("auth.verifyTitle")}
          </p>
          <p className="text-sm text-navy-500 mt-1">
            {step === "phone"
              ? t("auth.phoneHint")
              : `${t("auth.codeSent")} +57${phone.replace(/\D/g, "")}`}
          </p>
        </div>

        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-lg p-3 mb-4">
            {error}
          </div>
        )}

        {step === "phone" ? (
          <form onSubmit={handleSendOTP} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-navy-700 mb-1">
                {t("auth.phoneLabel")}
              </label>
              <div className="flex">
                <span className="inline-flex items-center px-3 rounded-l-lg border border-r-0 border-navy-200 bg-navy-50 text-sm text-navy-500">
                  +57
                </span>
                <input
                  type="tel"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value.replace(/\D/g, ""))}
                  placeholder={t("auth.phonePlaceholder")}
                  maxLength={10}
                  className="flex-1 rounded-r-lg border border-navy-200 px-3 py-2 text-sm text-navy-800 placeholder:text-navy-400 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
                  required
                />
              </div>
            </div>
            <Button type="submit" loading={loading} className="w-full">
              {t("auth.sendCode")}
            </Button>
          </form>
        ) : (
          <form onSubmit={handleVerifyOTP} className="space-y-4">
            <Input
              label={t("auth.codeLabel")}
              type="text"
              value={otp}
              onChange={(e) => setOtp(e.target.value.replace(/\D/g, ""))}
              placeholder="123456"
              maxLength={6}
              required
            />
            <Button type="submit" loading={loading} className="w-full">
              {t("auth.verify")}
            </Button>
            <button
              type="button"
              onClick={() => {
                setStep("phone");
                setOtp("");
              }}
              className="w-full text-sm text-navy-500 hover:text-navy-700"
            >
              {t("auth.changeNumber")}
            </button>
          </form>
        )}

        <p className="text-center text-xs text-navy-400 mt-6">
          {t("auth.terms")}{" "}
          <Link href="/terms" className="underline">
            {t("auth.termsLink")}
          </Link>
        </p>
      </div>
    </div>
  );
}

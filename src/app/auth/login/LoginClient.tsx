"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import Button from "@/components/ui/Button";
import Input from "@/components/ui/Input";

export default function LoginClient() {
  const [phone, setPhone] = useState("");
  const [otp, setOtp] = useState("");
  const [step, setStep] = useState<"phone" | "otp">("phone");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const router = useRouter();

  const getRedirectPath = () => {
    if (typeof window === "undefined") return "/";
    return new URLSearchParams(window.location.search).get("redirect") || "/";
  };

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
    const { createClient } = await import("@/lib/supabase/client");
    const supabase = createClient();
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
    const { createClient } = await import("@/lib/supabase/client");
    const supabase = createClient();
    const { error } = await supabase.auth.verifyOtp({
      phone: formattedPhone,
      token: otp,
      type: "sms",
    });

    if (error) {
      setError(error.message);
    } else {
      router.push(getRedirectPath());
      router.refresh();
    }
    setLoading(false);
  };

  return (
    <>
      <div className="text-center mb-8">
        <p className="text-sm font-semibold text-navy-700">
          {step === "phone" ? "Acceso con SMS" : "Confirma tu código"}
        </p>
        <p className="text-sm text-navy-500 mt-1">
          {step === "phone"
            ? "Te enviaremos un código para entrar sin contraseña."
            : `Código enviado a +57${phone.replace(/\D/g, "")}`}
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
            <label
              htmlFor="login-phone"
              className="block text-sm font-medium text-navy-700 mb-1"
            >
              Celular colombiano
            </label>
            <div className="flex">
              <span className="inline-flex items-center px-3 rounded-l-lg border border-r-0 border-navy-200 bg-navy-50 text-sm text-navy-500">
                +57
              </span>
              <input
                id="login-phone"
                type="tel"
                value={phone}
                onChange={(e) => setPhone(e.target.value.replace(/\D/g, ""))}
                placeholder="300 123 4567"
                maxLength={10}
                className="flex-1 rounded-r-lg border border-navy-200 px-3 py-2 text-sm text-navy-800 placeholder:text-navy-400 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
                required
              />
            </div>
          </div>
          <Button type="submit" loading={loading} className="w-full">
            Enviar código
          </Button>
        </form>
      ) : (
        <form onSubmit={handleVerifyOTP} className="space-y-4">
          <Input
            id="login-code"
            label="Código SMS"
            type="text"
            value={otp}
            onChange={(e) => setOtp(e.target.value.replace(/\D/g, ""))}
            placeholder="123456"
            maxLength={6}
            required
          />
          <Button type="submit" loading={loading} className="w-full">
            Ingresar
          </Button>
          <button
            type="button"
            onClick={() => {
              setStep("phone");
              setOtp("");
            }}
            className="w-full text-sm text-navy-500 hover:text-navy-700"
          >
            Cambiar número
          </button>
        </form>
      )}

      <p className="text-center text-xs text-navy-600 mt-6">
        Al continuar aceptas los{" "}
        <Link href="/terms" className="font-medium text-navy-700 underline">
          términos de uso
        </Link>
      </p>
    </>
  );
}

import type { Metadata } from "next";
import { Phone } from "lucide-react";
import LoginClient from "./LoginClient";

export const metadata: Metadata = {
  title: "Ingresar o publicar anuncios",
  description:
    "Accede a Lleva Lleva con tu celular para publicar clasificados gratis, guardar anuncios favoritos y gestionar tus publicaciones en Colombia.",
  alternates: {
    canonical: "/auth/login",
  },
  openGraph: {
    title: "Ingresar o publicar anuncios | Lleva Lleva",
    description:
      "Accede con tu celular para publicar, guardar y gestionar clasificados gratis en Colombia.",
    url: "/auth/login",
    images: [
      {
        url: "/og-image.svg",
        width: 1200,
        height: 630,
        alt: "Lleva Lleva clasificados gratis en Colombia",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "Ingresar o publicar anuncios | Lleva Lleva",
    description:
      "Accede con tu celular para publicar, guardar y gestionar clasificados gratis en Colombia.",
    images: ["/og-image.svg"],
  },
};

export default function LoginPage() {
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
            Usa tu celular colombiano para publicar clasificados gratis,
            guardar favoritos y mantener conversaciones locales con mas
            confianza.
          </p>
        </div>

        <LoginClient />
      </div>
    </div>
  );
}

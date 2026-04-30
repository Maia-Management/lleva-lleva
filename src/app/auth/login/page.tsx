import type { Metadata } from "next";
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

type LoginPageProps = {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
};

export default async function LoginPage({ searchParams }: LoginPageProps) {
  const params = await searchParams;
  const redirect = typeof params.redirect === "string" ? params.redirect : "/";

  return <LoginClient redirect={redirect} />;
}

import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import Navbar from "@/components/layout/Navbar";
import Footer from "@/components/layout/Footer";
import { LocaleProvider } from "@/lib/locale-context";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
});

export const metadata: Metadata = {
  metadataBase: new URL("https://lleva-lleva.com"),
  title: {
    default: "Lleva Lleva — Clasificados gratis en Colombia",
    template: "%s | Lleva Lleva",
  },
  description:
    "Compra, vende e intercambia en tu ciudad. Clasificados gratuitos para Colombia. La alternativa confiable a Facebook Marketplace.",
  keywords: [
    "clasificados",
    "colombia",
    "compra venta",
    "santa marta",
    "gratis",
    "usado",
  ],
  openGraph: {
    title: "Lleva Lleva — Clasificados gratis en Colombia",
    description:
      "Compra, vende e intercambia en tu ciudad. Clasificados gratuitos para Colombia.",
    url: "https://lleva-lleva.com",
    siteName: "Lleva Lleva",
    locale: "es_CO",
    type: "website",
  },
  alternates: {
    canonical: "/",
  },
  robots: {
    index: true,
    follow: true,
  },
  icons: {
    icon: "/favicon.svg",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es" className={`${inter.variable} h-full antialiased`}>
      <body className="min-h-full flex flex-col font-sans">
        <LocaleProvider>
          <Navbar />
          <main className="flex-1">{children}</main>
          <Footer />
        </LocaleProvider>
      </body>
    </html>
  );
}

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
  title: "Lleva Lleva — Clasificados Gratis en Colombia",
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
    title: "Lleva Lleva — Clasificados Gratis en Colombia",
    description:
      "Compra, vende e intercambia en tu ciudad. Clasificados gratuitos para Colombia.",
    locale: "es_CO",
    type: "website",
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

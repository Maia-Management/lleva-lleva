import type { Metadata } from "next";
import "./globals.css";
import Navbar from "@/components/layout/Navbar";
import Footer from "@/components/layout/Footer";
import { LocaleProvider } from "@/lib/locale-context";

const siteDescription =
  "Compra, vende e intercambia en tu ciudad. Clasificados gratuitos para Colombia. La alternativa confiable a Facebook Marketplace.";

export const metadata: Metadata = {
  metadataBase: new URL("https://lleva-lleva.com"),
  title: {
    default: "Lleva Lleva — Clasificados gratis en Colombia",
    template: "%s | Lleva Lleva",
  },
  description: siteDescription,
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
    description: siteDescription,
    url: "https://lleva-lleva.com",
    siteName: "Lleva Lleva",
    images: [
      {
        url: "/og-image.svg",
        width: 1200,
        height: 630,
        alt: "Lleva Lleva clasificados gratis en Colombia",
      },
    ],
    locale: "es_CO",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "Lleva Lleva — Clasificados gratis en Colombia",
    description: siteDescription,
    images: ["/og-image.svg"],
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
    <html lang="es" className="h-full antialiased">
      <body
        className="min-h-full flex flex-col font-sans"
        data-cache-version="20260430-lleva-public-nav"
      >
        <LocaleProvider>
          <Navbar />
          <main className="flex-1">{children}</main>
          <Footer />
        </LocaleProvider>
      </body>
    </html>
  );
}

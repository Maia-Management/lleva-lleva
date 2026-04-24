import type { Metadata } from "next";
import { Geist } from "next/font/google";
import "./globals.css";
import Header from "@/components/layout/Header";
import Footer from "@/components/layout/Footer";
import Script from "next/script";

const geist = Geist({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: {
    default: "LlevaLleva.co – Clasificados Colombia",
    template: "%s | LlevaLleva.co",
  },
  description:
    "El clasificado colombiano. Compra, vende y conecta con personas de tu región. Vehículos, inmuebles, tecnología, náutico y más.",
  keywords: ["clasificados", "colombia", "comprar", "vender", "barranquilla", "bogota", "medellin"],
  openGraph: {
    siteName: "LlevaLleva.co",
    locale: "es_CO",
    type: "website",
  },
  other: {
    "google-adsense-account": "ca-pub-2469196723812841",
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es">
      <head>
        <script
          async
          src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-2469196723812841"
          crossOrigin="anonymous"
        />
      </head>
      <body className={`${geist.className} bg-gray-50 min-h-screen flex flex-col antialiased`}>
        <Script src="/consent-banner.js" strategy="afterInteractive" />
        <Header 
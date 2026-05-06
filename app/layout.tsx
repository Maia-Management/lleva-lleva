import type { Metadata } from "next";
import { Geist } from "next/font/google";
import "./globals.css";
import Header from "@/components/layout/Header";
import Footer from "@/components/layout/Footer";
import Script from "next/script";

const geist = Geist({ subsets: ["latin"] });

export const metadata: Metadata = {
  metadataBase: new URL("https://lleva-lleva.com"),
  title: {
    default: "Lleva Lleva – Clasificados Colombia",
    template: "%s | Lleva Lleva",
  },
  description:
    "El clasificado colombiano. Compra, vende y conecta con personas de tu región. Vehículos, inmuebles, tecnología, náutico y más.",
  keywords: ["clasificados", "colombia", "comprar", "vender", "barranquilla", "bogota", "medellin"],
  authors: [{ name: "Lleva Lleva", url: "https://lleva-lleva.com" }],
  creator: "Lleva Lleva",
  publisher: "Lleva Lleva",
  alternates: {
    canonical: "https://lleva-lleva.com",
    languages: {
      "es": "https://lleva-lleva.com",
      "en": "https://lleva-lleva.com",
      "x-default": "https://lleva-lleva.com",
    },
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-image-preview": "large",
      "max-snippet": -1,
      "max-video-preview": -1,
    },
  },
  openGraph: {
    siteName: "Lleva Lleva",
    locale: "es_CO",
    type: "website",
    title: "Lleva Lleva – Clasificados Colombia",
    description: "El clasificado colombiano. Compra, vende y conecta con personas de tu región. Vehículos, inmuebles, tecnología, náutico y más.",
    url: "https://lleva-lleva.com",
    images: [
      {
        url: "https://lleva-lleva.com/og-image.png",
        width: 1200,
        height: 630,
        alt: "Lleva Lleva — Clasificados Colombia",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    site: "@llevalleva",
    creator: "@llevalleva",
    title: "Lleva Lleva – Clasificados Colombia",
    description: "El clasificado colombiano. Compra, vende y conecta con personas de tu región.",
    images: ["https://lleva-lleva.com/og-image.png"],
  },
  other: {
    "google-adsense-account": "ca-pub-2469196723812841",
  },
};

const organizationJsonLd = {
  "@context": "https://schema.org",
  "@type": "Organization",
  name: "Lleva Lleva",
  url: "https://lleva-lleva.com",
  logo: "https://lleva-lleva.com/og-image.png",
  description:
    "El clasificado colombiano. Compra, vende y conecta con personas de tu región. Vehículos, inmuebles, tecnología, náutico y más.",
  email: "hola@lleva-lleva.com",
  telephone: "+19034598763",
  address: {
    "@type": "PostalAddress",
    streetAddress: "Calle 24 #3-99, Edificio Banco de Bogotá, Suite 1102, Nivel 11",
    addressLocality: "Santa Marta",
    addressRegion: "Magdalena",
    addressCountry: "CO",
  },
  contactPoint: [
    {
      "@type": "ContactPoint",
      contactType: "customer support",
      email: "hola@lleva-lleva.com",
      telephone: "+19034598763",
      areaServed: "CO",
      availableLanguage: ["Spanish", "English"],
    },
  ],
  areaServed: { "@type": "Country", name: "Colombia" },
};

const websiteJsonLd = {
  "@context": "https://schema.org",
  "@type": "WebSite",
  name: "Lleva Lleva",
  url: "https://lleva-lleva.com",
  description:
    "Clasificados generales en Colombia y Venezuela — compra, vende y encuentra lo que necesitas",
  inLanguage: ["es-CO", "es-VE"],
  potentialAction: {
    "@type": "SearchAction",
    target: "https://lleva-lleva.com/buscar?q={search_term_string}",
    "query-input": "required name=search_term_string",
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
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationJsonLd) }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(websiteJsonLd) }}
        />
      </head>
      <body className={`${geist.className} bg-gray-50 min-h-screen flex flex-col antialiased`}>
        <Script src="/consent-banner.js" strategy="afterInteractive" />
        {/* Google Analytics 4 — set NEXT_PUBLIC_GA_MEASUREMENT_ID in production env to activate */}
        {process.env.NEXT_PUBLIC_GA_MEASUREMENT_ID && (
          <>
            <Script
              src={`https://www.googletagmanager.com/gtag/js?id=${process.env.NEXT_PUBLIC_GA_MEASUREMENT_ID}`}
              strategy="afterInteractive"
            />
            <Script id="ga4-init" strategy="afterInteractive">{`
              window.dataLayer = window.dataLayer || [];
              function gtag(){dataLayer.push(arguments);}
              gtag('js', new Date());
              gtag('config', '${process.env.NEXT_PUBLIC_GA_MEASUREMENT_ID}', { anonymize_ip: true });
            `}</Script>
          </>
        )}
        <Header />
        <main className="flex-1">{children}</main>
        <Footer />
        {/* Floating Contact Button — links to /contacto (no US number shown to Colombian users) */}
        <a
          href="/contacto"
          className="contact-float"
          aria-label="Contactar soporte"
          style={{
            position: 'fixed',
            bottom: '24px',
            right: '24px',
            backgroundColor: '#003893',
            borderRadius: '50%',
            width: '56px',
            height: '56px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            boxShadow: '0 4px 12px rgba(0,0,0,0.25)',
            zIndex: 9999,
            textDecoration: 'none',
          }}
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
          </svg>
        </a>
      </body>
    </html>
  );
}

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
    site: "@MaiaGroupCO",
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
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationJsonLd) }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(websiteJsonLd) }}
        />
      </head>
      <body className={`${geist.className} bg-gray-50 min-h-screen flex flex-col antialiased`}>
        <Script src="/consent-banner.js" strategy="beforeInteractive" />
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
        {/* Floating WhatsApp button for Maia */}
        <a
          href="https://wa.me/19034598763"
          target="_blank"
          rel="noopener noreferrer"
          className="whatsapp-float"
          aria-label="Chatear por WhatsApp"
          style={{
            position: 'fixed',
            bottom: '24px',
            right: '24px',
            backgroundColor: '#25D366',
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
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="30" height="30" fill="white" aria-hidden="true">
            <path d="M.057 24l1.687-6.163a11.867 11.867 0 0 1-1.587-5.946C.16 5.335 5.495 0 12.05 0a11.817 11.817 0 0 1 8.413 3.488 11.824 11.824 0 0 1 3.48 8.414c-.003 6.557-5.338 11.892-11.893 11.892a11.9 11.9 0 0 1-5.688-1.448L.057 24zm6.597-3.807c1.676.995 3.276 1.591 5.392 1.592 5.448 0 9.886-4.434 9.889-9.885.002-5.462-4.415-9.89-9.881-9.892-5.452 0-9.887 4.434-9.889 9.884a9.86 9.86 0 0 0 1.51 5.26l-.999 3.648 3.978-1.607zm11.387-5.464c-.074-.124-.272-.198-.57-.347-.297-.149-1.758-.868-2.031-.967-.272-.099-.47-.149-.669.149-.198.297-.768.967-.941 1.165-.173.198-.347.223-.644.074-.297-.149-1.255-.462-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.297-.347.446-.521.151-.172.2-.296.3-.495.099-.198.05-.372-.025-.521-.075-.149-.669-1.611-.916-2.206-.242-.579-.487-.501-.669-.51l-.57-.01c-.198 0-.52.074-.792.372s-1.04 1.016-1.04 2.479 1.065 2.876 1.213 3.074c.149.198 2.095 3.2 5.076 4.487.709.306 1.263.489 1.694.626.712.226 1.36.194 1.872.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.29.173-1.414z"/>
          </svg>
        </a>
      </body>
    </html>
  );
}


import { Metadata } from 'next';
import Link from 'next/link';
import PriceChecker from './PriceChecker';

export const metadata: Metadata = {
  // The root layout's metadata.title.template appends " | Lleva Lleva", so don't
  // repeat the brand suffix here — would render as "… | LlevaLleva | Lleva Lleva".
  title: 'Calculadora de precios para vender en Colombia',
  description:
    '¿Cuánto vale tu artículo? Consulta precios reales de Mercado Libre Colombia, OLX, Facebook Marketplace y más. Gratis, en segundos.',
  keywords: [
    'cuánto vale mi artículo Colombia',
    'precio de venta Mercado Libre Colombia',
    'calculadora precios Colombia',
    'cuánto cobrar por artículo usado',
    'precio justo Colombia OLX',
    'cuánto vale en Colombia',
  ],
  openGraph: {
    title: '¿Cuánto vale? – Calculadora de precios Colombia | LlevaLleva',
    description:
      'Descubre el precio justo para lo que quieres vender. Datos reales de los marketplaces colombianos.',
    url: 'https://lleva-lleva.com/cuanto-vale',
    siteName: 'LlevaLleva',
    locale: 'es_CO',
    type: 'website',
    images: [
      {
        url: 'https://lleva-lleva.com/og-image.png',
        width: 1200,
        height: 630,
        alt: '¿Cuánto vale? — Calculadora de precios Colombia',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    site: '@llevalleva',
    creator: '@llevalleva',
    title: '¿Cuánto vale? – Calculadora de precios Colombia',
    description:
      'Descubre el precio justo para lo que quieres vender. Datos reales de los marketplaces colombianos.',
    images: ['https://lleva-lleva.com/og-image.png'],
  },
  alternates: {
    canonical: 'https://lleva-lleva.com/cuanto-vale',
  },
};

export default function CuantoValePage() {
  return (
    <div className="max-w-2xl mx-auto px-4 sm:px-6 py-10 sm:py-14">
      {/* Breadcrumb */}
      <nav
        className="text-xs text-gray-500 mb-6 flex items-center gap-1.5"
        aria-label="Breadcrumb"
      >
        <Link href="/" className="hover:text-emerald-600 transition-colors">
          Inicio
        </Link>
        <span aria-hidden="true">›</span>
        <span className="text-gray-700">¿Cuánto vale?</span>
      </nav>

      {/* Page header */}
      <header className="mb-8 text-center">
        <div className="inline-flex items-center gap-1.5 text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200 px-3 py-1 rounded-full mb-4">
          <span aria-hidden="true">🇨🇴</span>
          Precios reales de Colombia
        </div>
        <h1 className="text-3xl sm:text-4xl font-black text-gray-900 leading-tight mb-3">
          ¿Cuánto debería cobrar
          <br />
          por esto?
        </h1>
        <p className="text-gray-500 text-sm sm:text-base max-w-md mx-auto leading-relaxed">
          Describe lo que quieres vender y Gemini buscará precios actuales en{' '}
          <span className="font-semibold text-gray-700">
            Mercado Libre, OLX, Facebook Marketplace
          </span>{' '}
          y más.
        </p>
      </header>

      {/* Price checker widget */}
      <PriceChecker />

      {/* Disclaimer */}
      <p className="text-center text-xs text-gray-600 mt-8 leading-relaxed">
        Los precios son estimaciones basadas en anuncios públicos. Los
        resultados pueden variar según el estado del artículo, la ciudad y la
        demanda actual.
      </p>
    </div>
  );
}

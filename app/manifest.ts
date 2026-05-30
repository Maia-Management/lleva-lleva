import type { MetadataRoute } from 'next';

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: 'Lleva Lleva — Clasificados Colombia',
    short_name: 'LlevaLleva',
    description:
      'El clasificado colombiano. Compra, vende y conecta con personas de tu región.',
    start_url: '/',
    display: 'standalone',
    background_color: '#1A1A2E',
    theme_color: '#FF6B35',
    lang: 'es-CO',
    icons: [
      {
        src: '/icon.svg',
        sizes: 'any',
        type: 'image/svg+xml',
        purpose: 'any',
      },
      {
        src: '/favicon.ico',
        sizes: '32x32',
        type: 'image/x-icon',
      },
    ],
  };
}

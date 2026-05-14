import type { Metadata } from 'next';
import type { ReactNode } from 'react';

export const metadata: Metadata = {
  title: 'Crear cuenta',
  description: 'Crea una cuenta gratis en Lleva Lleva para publicar y gestionar anuncios en Colombia.',
  alternates: { canonical: 'https://lleva-lleva.com/auth/register' },
};

export default function RegisterLayout({ children }: { children: ReactNode }) {
  return children;
}

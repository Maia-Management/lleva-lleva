import type { Metadata } from 'next';
import type { ReactNode } from 'react';

export const metadata: Metadata = {
  title: 'Nueva contraseña',
  description: 'Crea una nueva contraseña para recuperar el acceso a tu cuenta de Lleva Lleva.',
  alternates: { canonical: 'https://lleva-lleva.com/auth/actualizar-password' },
};

export default function UpdatePasswordLayout({ children }: { children: ReactNode }) {
  return children;
}

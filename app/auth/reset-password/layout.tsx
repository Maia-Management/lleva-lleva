import type { Metadata } from 'next';
import type { ReactNode } from 'react';

export const metadata: Metadata = {
  title: 'Restablecer contraseña',
  description: 'Solicita un enlace seguro para restablecer la contraseña de tu cuenta de Lleva Lleva.',
  alternates: { canonical: 'https://lleva-lleva.com/auth/reset-password' },
};

export default function ResetPasswordLayout({ children }: { children: ReactNode }) {
  return children;
}

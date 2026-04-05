import { Suspense } from 'react';
import LoginForm from './LoginForm';

export const metadata = { title: 'Ingresar' };

export default function LoginPage() {
  return (
    <Suspense fallback={<div className="min-h-[70vh] flex items-center justify-center"><div className="animate-spin w-6 h-6 border-2 border-emerald-500 border-t-transparent rounded-full" /></div>}>
      <LoginForm />
    </Suspense>
  );
}

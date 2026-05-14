'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';

export default function ActualizarPasswordPage() {
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [checking, setChecking] = useState(true);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const router = useRouter();

  useEffect(() => {
    const supabase = createClient();
    // Fallback: if no recovery event fires within 3 s, check once more then redirect
    const fallbackTimer = setTimeout(() => {
      supabase.auth.getSession().then(({ data: { session } }) => {
        if (!session) {
          router.replace('/auth/login?error=link-expirado');
        } else {
          setChecking(false);
        }
      });
    }, 3000);

    // If there's already a valid session (e.g. page refresh after auth), show form immediately
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session) {
        setChecking(false);
        return;
      }
    });

    // Listen for the PASSWORD_RECOVERY event emitted when the email link token is exchanged
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event, session) => {
      if (event === 'PASSWORD_RECOVERY') {
        clearTimeout(fallbackTimer);
        setChecking(false);
      } else if (event === 'SIGNED_IN' && session) {
        // Already signed in — allow access so the user can change their password
        clearTimeout(fallbackTimer);
        setChecking(false);
      } else if (
        event !== 'INITIAL_SESSION' &&
        event !== 'TOKEN_REFRESHED' &&
        !session
      ) {
        // Any other event without a session means the link is invalid/expired
        clearTimeout(fallbackTimer);
        router.replace('/auth/login?error=link-expirado');
      }
    });

    return () => {
      subscription.unsubscribe();
      clearTimeout(fallbackTimer);
    };
  }, [router]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError('');

    if (password.length < 8) {
      setError('La contraseña debe tener al menos 8 caracteres.');
      return;
    }

    if (password !== confirmPassword) {
      setError('Las contraseñas no coinciden. Verifica e intenta de nuevo.');
      return;
    }

    setLoading(true);

    const supabase = createClient();
    const { error: updateError } = await supabase.auth.updateUser({ password });

    if (updateError) {
      const msg = updateError.message.toLowerCase();
      if (
        msg.includes('expired') ||
        msg.includes('invalid') ||
        msg.includes('jwt') ||
        msg.includes('token')
      ) {
        setError(
          'El enlace de recuperación ha expirado. Solicita uno nuevo desde la pantalla de inicio de sesión.'
        );
      } else if (msg.includes('same password') || msg.includes('different')) {
        setError('La nueva contraseña debe ser diferente a la anterior.');
      } else {
        setError('No se pudo actualizar la contraseña. Intenta de nuevo.');
      }
      setLoading(false);
      return;
    }

    setSuccess(true);
    setTimeout(() => router.push('/dashboard'), 2000);
  }

  // Loading spinner while we verify the recovery token
  if (checking) {
    return (
      <div className="min-h-[70vh] flex items-center justify-center">
        <div className="animate-spin w-6 h-6 border-2 border-brand-blue border-t-transparent rounded-full" />
      </div>
    );
  }

  return (
    <div className="min-h-[70vh] flex items-center justify-center px-4">
      <div className="w-full max-w-sm">

        {/* Logo + heading */}
        <div className="text-center mb-8">
          <Link href="/" className="inline-block">
            <span className="text-3xl font-black text-brand-blue">
              Lleva<span className="text-gray-900">Lleva</span>
            </span>
            <span className="text-gray-600">.com</span>
          </Link>
          <h1 className="text-xl font-bold text-gray-800 mt-4">Nueva contraseña</h1>
          <p className="text-sm text-gray-500 mt-1">
            Elige una contraseña segura para tu cuenta.
          </p>
        </div>

        {/* Success state */}
        {success ? (
          <div className="bg-white rounded-2xl border border-gray-200 p-6 text-center">
            <div className="text-4xl mb-3">✅</div>
            <h2 className="font-bold text-gray-900 mb-2">¡Contraseña actualizada!</h2>
            <p className="text-gray-600 text-sm">Redirigiendo a tu panel…</p>
          </div>
        ) : (
          /* Update-password form */
          <form
            onSubmit={handleSubmit}
            className="bg-white rounded-2xl border border-gray-200 p-6 space-y-4"
          >
            {error && (
              <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-xl px-4 py-3">
                {error}
              </div>
            )}

            <div>
              <label htmlFor="password" className="block text-sm font-medium text-gray-700 mb-1">
                Nueva contraseña
              </label>
              <input
                id="password"
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Mínimo 8 caracteres"
                minLength={8}
                className="w-full px-4 py-2.5 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue focus:border-transparent"
              />
            </div>

            <div>
              <label htmlFor="confirmPassword" className="block text-sm font-medium text-gray-700 mb-1">
                Confirmar contraseña
              </label>
              <input
                id="confirmPassword"
                type="password"
                required
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                placeholder="Repite tu contraseña"
                className="w-full px-4 py-2.5 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-brand-blue focus:border-transparent"
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-brand-blue text-white font-bold py-3 rounded-xl hover:bg-brand-blue-700 transition-colors disabled:opacity-60 disabled:cursor-not-allowed"
            >
              {loading ? 'Actualizando…' : 'Actualizar contraseña'}
            </button>

            <div className="text-center">
              <Link
                href="/auth/login"
                className="text-xs text-gray-500 hover:text-brand-blue"
              >
                ← Volver al inicio de sesión
              </Link>
            </div>
          </form>
        )}
      </div>
    </div>
  );
}

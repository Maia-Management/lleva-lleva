import { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'Reportar un Problema',
  description: 'Reporta anuncios fraudulentos, contenido prohibido o problemas en Lleva Lleva.',
  alternates: { canonical: 'https://lleva-lleva.com/reportar' },
};

export default function ReportarPage() {
  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 py-12">
      <div className="mb-8">
        <Link href="/" className="text-sm text-brand-blue underline underline-offset-2">← Volver al inicio</Link>
      </div>

      <div className="mb-10">
        <h1 className="text-3xl font-black text-gray-900 mb-3">Reportar un Problema</h1>
        <p className="text-gray-600 text-lg">
          Tu reporte nos ayuda a mantener LlevaLleva seguro para toda la comunidad.
          Revisamos cada reporte de forma manual.
        </p>
      </div>

      <div className="bg-brand-yellow/10 border border-brand-yellow/30 rounded-2xl p-5 mb-8">
        <p className="text-ink text-sm">
          <strong>Nota:</strong> Si eres víctima de un delito (robo, estafa, extorsión), además de
          reportarnos, te recomendamos presentar una denuncia ante la Fiscalía General de la Nación
          o la DIJIN de la Policía Nacional.
        </p>
      </div>

      <div className="grid gap-4 mb-10">
        <h2 className="font-bold text-gray-900">¿Qué puedes reportar?</h2>
        {[
          { icon: '🔫', label: 'Artículos prohibidos o ilegales' },
          { icon: '💰', label: 'Anuncio fraudulento o estafa' },
          { icon: '👤', label: 'Comportamiento abusivo de un usuario' },
          { icon: '🐾', label: 'Venta ilegal de animales o especies protegidas' },
          { icon: '🚫', label: 'Contenido inapropiado o discriminatorio' },
          { icon: '🔄', label: 'Anuncio duplicado o spam' },
          { icon: '📋', label: 'Información engañosa o falsa en el anuncio' },
        ].map((item, i) => (
          <div key={i} className="flex items-center gap-3 bg-white border border-gray-200 rounded-xl px-5 py-3">
            <span className="text-xl">{item.icon}</span>
            <span className="text-gray-700 text-sm">{item.label}</span>
          </div>
        ))}
      </div>

      <div className="bg-white border border-gray-200 rounded-2xl p-6">
        <h2 className="font-bold text-gray-900 mb-4">Enviar reporte</h2>
        <p className="text-gray-600 text-sm mb-5 leading-relaxed">
          Para reportar un problema, envíanos un correo con la siguiente información:
        </p>
        <ul className="list-disc pl-6 space-y-2 text-sm text-gray-600 mb-5">
          <li>El enlace (URL) del anuncio o perfil que reportas.</li>
          <li>El tipo de problema (selecciona de la lista anterior).</li>
          <li>Una breve descripción de lo sucedido.</li>
          <li>Si tienes capturas de pantalla o evidencia, adjúntalas.</li>
        </ul>
        <a
          href="mailto:reportar@lleva-lleva.com"
          className="inline-block bg-red-600 text-white font-bold px-6 py-3 rounded-xl hover:bg-red-700 transition-colors"
        >
          Enviar reporte por correo
        </a>
        <p className="text-xs text-gray-600 mt-3">reportar@lleva-lleva.com</p>
      </div>

      <div className="mt-8 text-center">
        <p className="text-gray-500 text-sm">
          También puedes consultar nuestros{' '}
          <Link href="/seguridad" className="text-brand-blue font-medium underline underline-offset-2">consejos de seguridad</Link>
          {' '}para protegerte en futuras transacciones.
        </p>
      </div>
    </div>
  );
}

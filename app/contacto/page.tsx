import { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'Contacto',
  description: 'Contáctate con el equipo de LlevaLleva.co.',
};

export default function ContactoPage() {
  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 py-12">
      <div className="mb-8">
        <Link href="/" className="text-sm text-brand-blue hover:underline">← Volver al inicio</Link>
      </div>

      <div className="mb-10">
        <h1 className="text-3xl font-black text-gray-900 mb-3">Contacto</h1>
        <p className="text-gray-600 text-lg">
          ¿Tienes alguna pregunta, sugerencia o problema? Estamos aquí para ayudarte.
        </p>
      </div>

      <div className="grid sm:grid-cols-2 gap-6 mb-10">
        <div className="bg-white border border-gray-200 rounded-2xl p-6">
          <div className="text-2xl mb-3">💬</div>
          <h2 className="font-bold text-gray-900 mb-1">Soporte general</h2>
          <p className="text-gray-600 text-sm leading-relaxed mb-3">
            Para preguntas sobre tu cuenta, anuncios o el funcionamiento de la plataforma.
          </p>
          <p className="text-sm text-brand-blue font-medium">hola@lleva-lleva.com</p>
        </div>

        <div className="bg-white border border-gray-200 rounded-2xl p-6">
          <div className="text-2xl mb-3">🚨</div>
          <h2 className="font-bold text-gray-900 mb-1">Reportar un problema</h2>
          <p className="text-gray-600 text-sm leading-relaxed mb-3">
            Para reportar anuncios fraudulentos, artículos prohibidos o comportamientos abusivos.
          </p>
          <Link href="/reportar" className="text-sm text-red-600 font-medium hover:underline">
            Ir al formulario de reporte →
          </Link>
        </div>

        <div className="bg-white border border-gray-200 rounded-2xl p-6">
          <div className="text-2xl mb-3">📖</div>
          <h2 className="font-bold text-gray-900 mb-1">Centro de ayuda</h2>
          <p className="text-gray-600 text-sm leading-relaxed mb-3">
            Revisa nuestras preguntas frecuentes antes de escribirnos — quizás encuentras la respuesta allí.
          </p>
          <Link href="/ayuda" className="text-sm text-brand-blue font-medium hover:underline">
            Ver preguntas frecuentes →
          </Link>
        </div>

        <div className="bg-white border border-gray-200 rounded-2xl p-6">
          <div className="text-2xl mb-3">🏢</div>
          <h2 className="font-bold text-gray-900 mb-1">Alianzas y publicidad</h2>
          <p className="text-gray-600 text-sm leading-relaxed mb-3">
            Para propuestas comerciales, alianzas o publicidad en la plataforma.
          </p>
          <p className="text-sm text-brand-blue font-medium">alianzas@lleva-lleva.com</p>
        </div>
      </div>

      <div className="bg-gray-50 rounded-2xl p-6">
        <h2 className="font-bold text-gray-900 mb-3">Tiempos de respuesta</h2>
        <p className="text-gray-600 text-sm leading-relaxed">
          Respondemos los mensajes en un plazo de <strong>24 a 48 horas hábiles</strong>. Para reportes
          urgentes de contenido ilegal o fraudulento, haremos lo posible por actuar en menos de 24 horas.
        </p>
        <p className="text-gray-500 text-sm mt-3">
          LlevaLleva.co opera desde Santa Marta, Colombia 🇨🇴
        </p>
      </div>
    </div>
  );
}

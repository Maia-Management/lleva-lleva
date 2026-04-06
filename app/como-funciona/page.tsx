import { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: '¿Cómo funciona LlevaLleva?',
  description: 'Aprende cómo publicar y comprar en LlevaLleva.co, el clasificado colombiano.',
};

const steps = {
  vender: [
    {
      num: '1',
      title: 'Crea tu cuenta gratis',
      body: 'Regístrate en segundos con tu correo electrónico. Tu cuenta te permite publicar, gestionar tus anuncios y calificar a otros usuarios.',
    },
    {
      num: '2',
      title: 'Publica tu anuncio',
      body: 'Haz clic en "Publicar gratis", elige la categoría, agrega fotos, describe el artículo con detalle y establece el precio. Cuantos más detalles incluyas, más rápido vendes.',
    },
    {
      num: '3',
      title: 'Recibe mensajes de compradores',
      body: 'Los interesados se comunicarán contigo directamente por WhatsApp u otros medios. Responde rápido para aumentar las posibilidades de cerrar la venta.',
    },
    {
      num: '4',
      title: 'Acuerda y entrega',
      body: 'Coordina el encuentro en un lugar seguro y público. Entrega el artículo, recibe el pago y ¡listo! Recuerda eliminar el anuncio una vez vendido.',
    },
  ],
  comprar: [
    {
      num: '1',
      title: 'Busca lo que necesitas',
      body: 'Usa el buscador o navega por categorías. Puedes filtrar por ciudad, rango de precio y otros criterios para encontrar exactamente lo que buscas.',
    },
    {
      num: '2',
      title: 'Contacta al vendedor',
      body: 'Haz clic en "Contactar por WhatsApp" o escríbele un mensaje directamente. Pregunta todo lo que necesites saber antes de acordar un encuentro.',
    },
    {
      num: '3',
      title: 'Verifica el artículo',
      body: 'Reúnete con el vendedor en un lugar público y seguro. Inspecciona el artículo antes de pagar. Si todo está bien, cierra el trato.',
    },
    {
      num: '4',
      title: 'Califica la experiencia',
      body: 'Después de la transacción, califica al vendedor. Tus calificaciones ayudan a construir una comunidad de confianza.',
    },
  ],
};

export default function ComoFuncionaPage() {
  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 py-12">
      <div className="mb-8">
        <Link href="/" className="text-sm text-emerald-600 hover:underline">← Volver al inicio</Link>
      </div>

      <div className="text-center mb-12">
        <h1 className="text-3xl font-black text-gray-900 mb-3">¿Cómo funciona LlevaLleva?</h1>
        <p className="text-gray-600 text-lg max-w-2xl mx-auto">
          LlevaLleva es el clasificado colombiano donde puedes comprar y vender artículos de forma
          rápida, fácil y gratuita. Así funciona:
        </p>
      </div>

      {/* Sell section */}
      <div className="mb-12">
        <div className="flex items-center gap-3 mb-6">
          <span className="bg-emerald-100 text-emerald-700 text-sm font-bold px-3 py-1 rounded-full">Para vender</span>
          <h2 className="text-xl font-bold text-gray-900">Publica en minutos</h2>
        </div>
        <div className="grid sm:grid-cols-2 gap-4">
          {steps.vender.map((s) => (
            <div key={s.num} className="bg-white border border-gray-200 rounded-2xl p-6">
              <div className="w-8 h-8 bg-emerald-600 text-white rounded-full flex items-center justify-center text-sm font-black mb-3">
                {s.num}
              </div>
              <h3 className="font-bold text-gray-900 mb-1">{s.title}</h3>
              <p className="text-gray-600 text-sm leading-relaxed">{s.body}</p>
            </div>
          ))}
        </div>
        <div className="mt-5 text-center">
          <Link
            href="/publicar"
            className="inline-block bg-emerald-600 text-white font-bold px-6 py-3 rounded-xl hover:bg-emerald-700 transition-colors"
          >
            Publicar gratis ahora
          </Link>
        </div>
      </div>

      {/* Buy section */}
      <div className="mb-12">
        <div className="flex items-center gap-3 mb-6">
          <span className="bg-blue-100 text-blue-700 text-sm font-bold px-3 py-1 rounded-full">Para comprar</span>
          <h2 className="text-xl font-bold text-gray-900">Encuentra lo que buscas</h2>
        </div>
        <div className="grid sm:grid-cols-2 gap-4">
          {steps.comprar.map((s) => (
            <div key={s.num} className="bg-white border border-gray-200 rounded-2xl p-6">
              <div className="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-black mb-3">
                {s.num}
              </div>
              <h3 className="font-bold text-gray-900 mb-1">{s.title}</h3>
              <p className="text-gray-600 text-sm leading-relaxed">{s.body}</p>
            </div>
          ))}
        </div>
      </div>

      {/* FAQ */}
      <div className="bg-gray-50 rounded-2xl p-8">
        <h2 className="text-xl font-bold text-gray-900 mb-6">Preguntas frecuentes</h2>
        <div className="space-y-5">
          {[
            {
              q: '¿Cuánto cuesta publicar un anuncio?',
              a: 'Publicar en LlevaLleva es completamente gratuito. No cobramos comisiones por las transacciones.',
            },
            {
              q: '¿LlevaLleva procesa los pagos?',
              a: 'No. LlevaLleva es una plataforma de contacto. Los pagos se acuerdan directamente entre comprador y vendedor.',
            },
            {
              q: '¿Cómo reporto un anuncio sospechoso?',
              a: 'Puedes usar nuestro formulario de reporte disponible en cada anuncio o en la página de reportes.',
            },
            {
              q: '¿Puedo publicar si soy empresa o comercio?',
              a: 'Sí, tanto particulares como negocios pueden publicar en LlevaLleva.',
            },
          ].map((faq, i) => (
            <div key={i}>
              <p className="font-semibold text-gray-900 mb-1">{faq.q}</p>
              <p className="text-gray-600 text-sm">{faq.a}</p>
            </div>
          ))}
        </div>
      </div>

      <div className="mt-8 text-center">
        <p className="text-gray-600 text-sm">
          ¿Tienes más preguntas?{' '}
          <Link href="/ayuda" className="text-emerald-600 hover:underline font-medium">Visita nuestro centro de ayuda</Link>
          {' '}o{' '}
          <Link href="/contacto" className="text-emerald-600 hover:underline font-medium">contáctanos</Link>.
        </p>
      </div>
    </div>
  );
}

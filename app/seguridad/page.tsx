import { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'Consejos de Seguridad',
  description: 'Consejos para realizar transacciones seguras en Lleva Lleva. Protégete al comprar y vender en línea.',
};

const tips = [
  {
    icon: '🤝',
    title: 'Reúnete en lugares públicos',
    body: 'Elige lugares concurridos y bien iluminados para los encuentros de entrega: centros comerciales, cafeterías o parques principales. Evita reunirte en casas particulares o lugares aislados, especialmente con desconocidos.',
  },
  {
    icon: '🔍',
    title: 'Verifica el artículo antes de pagar',
    body: 'Inspecciona el producto en persona antes de entregar cualquier pago. Prueba que funcione correctamente, revisa su estado y compáralo con las fotos del anuncio. Si algo no coincide, tienes todo el derecho de retirarte.',
  },
  {
    icon: '🏦',
    title: 'No compartas datos bancarios ni personales',
    body: 'LlevaLleva no procesa pagos. Nunca compartas contraseñas, números de tarjeta, claves de banca en línea ni información sensible con ningún vendedor o comprador. Desconfía de quienes te las soliciten.',
  },
  {
    icon: '💸',
    title: 'Ten cuidado con precios demasiado bajos',
    body: 'Si una oferta parece demasiado buena para ser verdad, probablemente lo sea. Desconfía de artículos costosos a precios muy bajos: pueden ser robados, falsificados o parte de una estafa.',
  },
  {
    icon: '📦',
    title: 'Precaución con envíos y pagos anticipados',
    body: 'Si el vendedor solicita un pago previo para "asegurar el artículo" antes de enviarlo o mostrarlo, ten mucho cuidado. Prioriza siempre las transacciones presenciales. Si debes hacer un envío, utiliza servicios de mensajería formales y acuerda la modalidad de pago con entrega.',
  },
  {
    icon: '👤',
    title: 'Revisa el perfil del usuario',
    body: 'Antes de contactar a un vendedor, revisa su perfil: antigüedad en la plataforma, cantidad de anuncios publicados y calificaciones recibidas. Un perfil recién creado con muchos anuncios de alto valor puede ser una señal de alerta.',
  },
  {
    icon: '📸',
    title: 'Solicita fotos adicionales',
    body: 'Si las fotos del anuncio parecen genéricas o tomadas de internet, solicita fotos adicionales del artículo real. Un vendedor legítimo no tendrá problema en enviar imágenes actualizadas.',
  },
  {
    icon: '🚨',
    title: 'Reporta anuncios sospechosos',
    body: 'Si encuentras un anuncio que parece fraudulento, con artículos prohibidos o con información engañosa, repórtalo de inmediato. Tu reporte ayuda a mantener la comunidad segura para todos.',
  },
  {
    icon: '👨‍👩‍👧',
    title: 'Ve acompañado cuando sea posible',
    body: 'Para transacciones de alto valor —vehículos, equipos electrónicos, inmuebles— considera ir acompañado de un amigo o familiar. Informa a alguien de confianza sobre el lugar y la hora del encuentro.',
  },
  {
    icon: '📱',
    title: 'Comunícate dentro de la plataforma',
    body: 'Inicia las conversaciones a través de los canales disponibles en la Plataforma. Si decides continuar por WhatsApp u otro medio, evita compartir información personal hasta que estés seguro de la legitimidad del anuncio.',
  },
];

export default function SeguridadPage() {
  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 py-12">
      <div className="mb-8">
        <Link href="/" className="text-sm text-brand-blue hover:underline">← Volver al inicio</Link>
      </div>

      <div className="mb-10">
        <h1 className="text-3xl font-black text-gray-900 mb-3">Consejos de Seguridad</h1>
        <p className="text-gray-600 text-lg">
          En LlevaLleva queremos que cada transacción sea una experiencia positiva. Sigue estos consejos
          para protegerte al comprar y vender.
        </p>
      </div>

      <div className="bg-brand-yellow/10 border border-brand-yellow/30 rounded-2xl p-5 mb-10">
        <p className="text-ink text-sm font-medium">
          ⚠️ <strong>Recuerda:</strong> LlevaLleva es una plataforma de contacto entre particulares. No
          intermediamos en los pagos ni garantizamos las transacciones. Siempre actúa con precaución.
        </p>
      </div>

      <div className="grid gap-5">
        {tips.map((tip, i) => (
          <div key={i} className="bg-white border border-gray-200 rounded-2xl p-6 flex gap-4">
            <span className="text-3xl flex-shrink-0">{tip.icon}</span>
            <div>
              <h2 className="font-bold text-gray-900 mb-1">{tip.title}</h2>
              <p className="text-gray-600 text-sm leading-relaxed">{tip.body}</p>
            </div>
          </div>
        ))}
      </div>

      <div className="mt-10 bg-red-50 border border-red-200 rounded-2xl p-6">
        <h2 className="font-bold text-red-800 mb-2">¿Encontraste algo sospechoso?</h2>
        <p className="text-red-700 text-sm mb-4">
          Si crees que un anuncio es fraudulento o involucra artículos prohibidos, repórtalo
          para que nuestro equipo pueda revisarlo.
        </p>
        <Link
          href="/reportar"
          className="inline-block bg-red-600 text-white text-sm font-semibold px-5 py-2.5 rounded-xl hover:bg-red-700 transition-colors"
        >
          Reportar un problema
        </Link>
      </div>
    </div>
  );
}

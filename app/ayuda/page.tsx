import { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'Centro de Ayuda',
  description: 'Preguntas frecuentes y ayuda para usar LlevaLleva.co.',
};

const faqs = [
  {
    category: 'Cuenta y registro',
    items: [
      {
        q: '¿Cómo creo una cuenta?',
        a: 'Haz clic en "Crear cuenta" en la parte superior de la página. Solo necesitas un correo electrónico y una contraseña. El registro es gratuito.',
      },
      {
        q: '¿Olvidé mi contraseña. ¿Qué hago?',
        a: 'En la página de inicio de sesión, haz clic en "¿Olvidaste tu contraseña?" e ingresa tu correo. Te enviaremos un enlace para restablecerla.',
      },
      {
        q: '¿Cómo cambio mis datos de perfil?',
        a: 'Ingresa a tu cuenta, ve al Dashboard y edita tu información de perfil desde la sección correspondiente.',
      },
      {
        q: '¿Puedo eliminar mi cuenta?',
        a: 'Sí. Contáctanos a través de la página de contacto con la solicitud de eliminación de cuenta desde el correo asociado a tu cuenta.',
      },
    ],
  },
  {
    category: 'Publicar anuncios',
    items: [
      {
        q: '¿Cuánto cuesta publicar?',
        a: 'Publicar en LlevaLleva es completamente gratuito. No hay cargos ocultos ni comisiones.',
      },
      {
        q: '¿Cuántos anuncios puedo publicar?',
        a: 'Puedes publicar múltiples anuncios. Si detectamos comportamientos abusivos o spam, podemos limitar o suspender la cuenta.',
      },
      {
        q: '¿Cuánto tiempo permanece activo un anuncio?',
        a: 'Los anuncios permanecen activos mientras tu cuenta esté en regla. Te recomendamos eliminarlos cuando el artículo ya esté vendido.',
      },
      {
        q: '¿Puedo editar o eliminar un anuncio después de publicarlo?',
        a: 'Sí, desde tu Dashboard puedes gestionar todos tus anuncios: editarlos, pausarlos o eliminarlos cuando quieras.',
      },
      {
        q: '¿Qué artículos no puedo publicar?',
        a: 'Consulta nuestra sección de Términos y Condiciones para ver la lista completa de artículos prohibidos. En resumen: nada ilegal, robado, peligroso o que explote a personas.',
      },
    ],
  },
  {
    category: 'Compras y transacciones',
    items: [
      {
        q: '¿LlevaLleva garantiza las transacciones?',
        a: 'No. LlevaLleva es una plataforma de contacto entre particulares. No intermediamos en los pagos ni garantizamos las transacciones. Por eso recomendamos revisar nuestros consejos de seguridad.',
      },
      {
        q: '¿Cómo contacto a un vendedor?',
        a: 'En cada anuncio encontrarás un botón para contactar al vendedor por WhatsApp. También puedes enviarle un mensaje directamente desde la plataforma.',
      },
      {
        q: '¿Qué hago si un vendedor no responde?',
        a: 'Algunos vendedores pueden tardar en responder. Si el anuncio lleva mucho tiempo sin actividad, puedes reportarlo para que revisemos si sigue vigente.',
      },
    ],
  },
  {
    category: 'Seguridad y reportes',
    items: [
      {
        q: '¿Cómo reporto un anuncio sospechoso?',
        a: 'Puedes reportar anuncios desde la página de reporte. Indica el enlace del anuncio y describe el problema.',
      },
      {
        q: '¿Qué hago si fui víctima de una estafa?',
        a: 'Primero, presenta una denuncia ante las autoridades colombianas (Fiscalía, DIJIN). Luego repórtanos el caso para que podamos actuar contra el usuario en la plataforma.',
      },
    ],
  },
];

export default function AyudaPage() {
  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 py-12">
      <div className="mb-8">
        <Link href="/" className="text-sm text-emerald-600 hover:underline">← Volver al inicio</Link>
      </div>

      <div className="mb-10">
        <h1 className="text-3xl font-black text-gray-900 mb-3">Centro de Ayuda</h1>
        <p className="text-gray-600 text-lg">
          Encuentra respuestas a las preguntas más frecuentes sobre LlevaLleva.co.
        </p>
      </div>

      <div className="space-y-10">
        {faqs.map((section) => (
          <div key={section.category}>
            <h2 className="text-lg font-bold text-gray-900 mb-4 pb-2 border-b border-gray-200">
              {section.category}
            </h2>
            <div className="space-y-4">
              {section.items.map((item, i) => (
                <div key={i} className="bg-white border border-gray-200 rounded-xl p-5">
                  <p className="font-semibold text-gray-900 mb-1">{item.q}</p>
                  <p className="text-gray-600 text-sm leading-relaxed">{item.a}</p>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>

      <div className="mt-12 bg-emerald-50 border border-emerald-200 rounded-2xl p-6 text-center">
        <h2 className="font-bold text-gray-900 mb-2">¿No encontraste lo que buscabas?</h2>
        <p className="text-gray-600 text-sm mb-4">
          Escríbenos y te ayudaremos lo antes posible.
        </p>
        <Link
          href="/contacto"
          className="inline-block bg-emerald-600 text-white font-bold px-6 py-3 rounded-xl hover:bg-emerald-700 transition-colors"
        >
          Contactar soporte
        </Link>
      </div>
    </div>
  );
}

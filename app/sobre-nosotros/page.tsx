import { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'Sobre Nosotros',
  description: 'Conoce a LlevaLleva.co — el clasificado colombiano que conecta compradores y vendedores en Santa Marta y toda Colombia.',
};

export default function SobreNosotrosPage() {
  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 py-12">
      <div className="mb-8">
        <Link href="/" className="text-sm text-brand-blue hover:underline">← Volver al inicio</Link>
      </div>

      <div className="text-center mb-12">
        <Link href="/" className="inline-block mb-6">
          <span className="text-4xl font-black text-brand-blue">Lleva<span className="text-gray-900">Lleva</span></span>
          <span className="text-gray-500 text-lg">.co</span>
        </Link>
        <h1 className="text-3xl font-black text-gray-900 mb-4">El clasificado colombiano</h1>
        <p className="text-gray-600 text-lg leading-relaxed">
          Conectamos compradores y vendedores de todo Colombia con una plataforma sencilla,
          gratuita y pensada para el mercado local.
        </p>
      </div>

      <div className="space-y-8 text-gray-700 leading-relaxed">

        <section className="bg-brand-blue-50 border border-brand-blue/20 rounded-2xl p-8">
          <h2 className="text-xl font-bold text-gray-900 mb-3">Nuestra misión</h2>
          <p>
            LlevaLleva nació en Santa Marta, Colombia, con un propósito claro: crear el espacio digital
            donde colombianos puedan comprar y vender de forma fácil, segura y sin complicaciones.
            Creemos en el comercio local, en el emprendimiento de barrio y en la economía circular.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">¿Qué es LlevaLleva?</h2>
          <p>
            LlevaLleva.co es una plataforma de clasificados en línea donde particulares y negocios pueden
            publicar anuncios de cualquier categoría: vehículos, inmuebles, tecnología, ropa, muebles,
            servicios, náutico y mucho más.
          </p>
          <p className="mt-3">
            A diferencia de otras plataformas, no cobramos comisiones ni intermediamos en los pagos.
            Simplemente facilitamos el contacto entre personas para que puedan cerrar buenos negocios.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">¿Por qué LlevaLleva?</h2>
          <div className="grid sm:grid-cols-3 gap-4 mt-4">
            {[
              { icon: '🆓', title: 'Gratis', body: 'Publicar es 100% gratuito. Sin planes, sin suscripciones.' },
              { icon: '🇨🇴', title: 'Local', body: 'Hecho en Colombia, para colombianos. Entendemos el mercado.' },
              { icon: '⚡', title: 'Simple', body: 'Publica en minutos. Sin procesos complicados.' },
            ].map((item) => (
              <div key={item.title} className="bg-white border border-gray-200 rounded-xl p-5 text-center">
                <div className="text-3xl mb-2">{item.icon}</div>
                <div className="font-bold text-gray-900 mb-1">{item.title}</div>
                <div className="text-gray-600 text-sm">{item.body}</div>
              </div>
            ))}
          </div>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">Santa Marta y más allá</h2>
          <p>
            Aunque nacimos en Santa Marta — La Ciudad Mágica de Colombia —, LlevaLleva está disponible
            en todo el territorio nacional. Desde Barranquilla hasta Bogotá, desde Medellín hasta la
            Amazonía: si estás en Colombia, LlevaLleva es para ti.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">Nuestro compromiso</h2>
          <p>
            Nos comprometemos a mantener una plataforma segura, libre de fraudes y contenido ilegal.
            Revisamos reportes, tomamos acciones contra usuarios que infringen nuestras normas y
            trabajamos continuamente para mejorar la experiencia de nuestra comunidad.
          </p>
        </section>

      </div>

      <div className="mt-10 flex flex-col sm:flex-row gap-3 justify-center">
        <Link
          href="/publicar"
          className="inline-block bg-brand-blue text-white font-bold px-6 py-3 rounded-xl hover:bg-brand-blue-700 transition-colors text-center"
        >
          Publicar gratis
        </Link>
        <Link
          href="/como-funciona"
          className="inline-block bg-white border border-gray-300 text-gray-700 font-bold px-6 py-3 rounded-xl hover:bg-gray-50 transition-colors text-center"
        >
          ¿Cómo funciona?
        </Link>
      </div>
    </div>
  );
}

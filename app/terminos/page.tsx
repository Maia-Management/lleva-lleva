import { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'Términos y Condiciones',
  description: 'Términos y condiciones de uso de Lleva Lleva — el clasificado colombiano.',
  alternates: { canonical: 'https://lleva-lleva.com/terminos' },
};

export default function TerminosPage() {
  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 py-12">
      <div className="mb-8">
        <Link href="/" className="text-sm text-brand-blue hover:underline">← Volver al inicio</Link>
      </div>

      <h1 className="text-3xl font-black text-gray-900 mb-2">Términos y Condiciones</h1>
      <p className="text-sm text-gray-500 mb-10">Última actualización: abril de 2026</p>

      <div className="prose prose-gray max-w-none space-y-8 text-gray-700 leading-relaxed">

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">1. Aceptación de los términos</h2>
          <p>
            Al acceder y utilizar la plataforma LlevaLleva (en adelante "la Plataforma"), usted acepta quedar
            vinculado por los presentes Términos y Condiciones. Si no está de acuerdo con alguno de estos términos,
            le pedimos que se abstenga de utilizar la Plataforma.
          </p>
          <p className="mt-2">
            LlevaLleva es una plataforma de clasificados en línea operada desde Santa Marta, Colombia, que
            facilita el contacto entre compradores y vendedores particulares y comerciales dentro del territorio colombiano.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">2. Descripción del servicio</h2>
          <p>
            LlevaLleva es un mercado en línea que permite a los usuarios publicar, buscar y gestionar anuncios
            de compraventa de bienes y servicios. La Plataforma actúa únicamente como intermediario tecnológico;
            no es parte de las transacciones entre usuarios y no asume responsabilidad por el contenido de los
            anuncios ni por el resultado de las negociaciones.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">3. Registro y cuenta de usuario</h2>
          <p>Para publicar anuncios, el usuario deberá registrarse proporcionando información veraz, completa y actualizada. El usuario es responsable de:</p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li>Mantener la confidencialidad de sus credenciales de acceso.</li>
            <li>Toda actividad que ocurra bajo su cuenta.</li>
            <li>Notificar de inmediato a LlevaLleva cualquier uso no autorizado de su cuenta.</li>
          </ul>
          <p className="mt-2">
            LlevaLleva se reserva el derecho de suspender o eliminar cuentas que infrinjan estos términos,
            sin previo aviso.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">4. Obligaciones del vendedor</h2>
          <p>El usuario que publique un anuncio declara y garantiza que:</p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li>Es el propietario legítimo del bien o servicio ofrecido, o está autorizado para su venta.</li>
            <li>La información del anuncio es veraz, precisa y no es engañosa.</li>
            <li>El precio indicado es el precio final al que está dispuesto a vender.</li>
            <li>Responderá de forma oportuna a los mensajes de compradores interesados.</li>
            <li>Eliminará el anuncio una vez concluida la transacción.</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">5. Obligaciones del comprador</h2>
          <p>El usuario que contacte a un vendedor se compromete a:</p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li>Actuar de buena fe en todas las comunicaciones y negociaciones.</li>
            <li>Verificar el estado del bien antes de realizar el pago.</li>
            <li>No divulgar información personal del vendedor a terceros.</li>
            <li>Preferir lugares públicos y seguros para los encuentros de entrega.</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">6. Artículos y servicios prohibidos</h2>
          <p>Está estrictamente prohibido publicar en LlevaLleva anuncios que involucren:</p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li>Armas de fuego, municiones y explosivos sin la debida autorización legal.</li>
            <li>Sustancias controladas, narcóticos o drogas ilegales.</li>
            <li>Material pornográfico o que explote menores de edad.</li>
            <li>Bienes robados, hurtados o de procedencia ilícita.</li>
            <li>Especies animales o vegetales protegidas por la ley colombiana o tratados internacionales.</li>
            <li>Medicamentos de venta restringida sin receta médica.</li>
            <li>Servicios de carácter fraudulento o piramidal.</li>
            <li>Cualquier bien o servicio cuya comercialización esté prohibida por la ley colombiana.</li>
          </ul>
          <p className="mt-2">
            LlevaLleva podrá retirar sin previo aviso cualquier anuncio que, a su sola discreción, considere
            contrario a la ley o a estos términos.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">7. Resolución de disputas</h2>
          <p>
            LlevaLleva no interviene en los conflictos surgidos entre compradores y vendedores. Sin embargo,
            ponemos a disposición un canal de reporte para irregularidades en{' '}
            <Link href="/reportar" className="text-brand-blue hover:underline">nuestra página de reportes</Link>.
          </p>
          <p className="mt-2">
            Cualquier controversia derivada del uso de la Plataforma que no pueda resolverse directamente entre
            las partes se someterá a la legislación colombiana vigente y a los jueces y tribunales competentes
            de la ciudad de Santa Marta, Colombia.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">8. Limitación de responsabilidad</h2>
          <p>
            LlevaLleva no garantiza la exactitud, legalidad ni calidad de los anuncios publicados en la
            Plataforma. En la máxima medida permitida por la ley colombiana, LlevaLleva no será responsable
            por daños directos, indirectos, incidentales o consecuentes derivados del uso de la Plataforma o
            de las transacciones realizadas a través de ella.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">9. Propiedad intelectual</h2>
          <p>
            El nombre, logotipo, diseño y contenido propio de LlevaLleva son propiedad de LlevaLleva o sus
            licenciantes. Queda prohibida su reproducción total o parcial sin autorización escrita. Los usuarios
            conservan los derechos sobre el contenido que publican, pero otorgan a LlevaLleva una licencia no
            exclusiva para mostrarlo en la Plataforma.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">10. Modificaciones a los términos</h2>
          <p>
            LlevaLleva podrá actualizar estos Términos y Condiciones en cualquier momento. Los cambios
            entrarán en vigencia al momento de su publicación en la Plataforma. El uso continuado de la
            Plataforma tras la publicación de cambios constituye la aceptación de los nuevos términos.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">11. Legislación aplicable</h2>
          <p>
            Estos Términos y Condiciones se rigen por las leyes de la República de Colombia, incluyendo pero
            no limitado a: el Código de Comercio, la Ley 527 de 1999 (Comercio Electrónico), la Ley 1480 de
            2011 (Estatuto del Consumidor) y la Ley 1581 de 2012 (Protección de Datos Personales).
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">12. Contacto</h2>
          <p>
            Para consultas sobre estos términos, puede contactarnos a través de nuestra{' '}
            <Link href="/contacto" className="text-brand-blue hover:underline">página de contacto</Link>.
          </p>
        </section>

      </div>
    </div>
  );
}

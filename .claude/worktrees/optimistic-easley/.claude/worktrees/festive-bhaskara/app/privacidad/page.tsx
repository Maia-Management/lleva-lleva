import { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'Política de Privacidad',
  description: 'Política de privacidad y tratamiento de datos personales de LlevaLleva.co conforme a la Ley 1581 de 2012.',
};

export default function PrivacidadPage() {
  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 py-12">
      <div className="mb-8">
        <Link href="/" className="text-sm text-emerald-600 hover:underline">← Volver al inicio</Link>
      </div>

      <h1 className="text-3xl font-black text-gray-900 mb-2">Política de Privacidad</h1>
      <p className="text-sm text-gray-500 mb-10">Última actualización: abril de 2026</p>

      <div className="space-y-8 text-gray-700 leading-relaxed">

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">1. Responsable del tratamiento</h2>
          <p>
            LlevaLleva.co (en adelante "LlevaLleva") es el responsable del tratamiento de los datos personales
            recogidos a través de la plataforma. Operamos desde Santa Marta, Colombia, y nos regimos por la
            Ley 1581 de 2012 y el Decreto 1377 de 2013.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">2. Datos que recopilamos</h2>
          <p>Recopilamos los siguientes tipos de información:</p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li><strong>Datos de registro:</strong> nombre, correo electrónico, nombre de usuario y contraseña (cifrada).</li>
            <li><strong>Datos de anuncios:</strong> título, descripción, precio, categoría, imágenes y ubicación que usted nos proporciona al publicar.</li>
            <li><strong>Datos de uso:</strong> páginas visitadas, búsquedas realizadas, fecha y hora de acceso, dirección IP y tipo de navegador.</li>
            <li><strong>Cookies y tecnologías similares:</strong> utilizamos cookies propias y de terceros para mejorar la experiencia de navegación y mostrar publicidad relevante.</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">3. Finalidades del tratamiento</h2>
          <p>Sus datos personales se utilizan para:</p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li>Gestionar su cuenta y permitirle publicar y gestionar anuncios.</li>
            <li>Facilitar el contacto entre compradores y vendedores.</li>
            <li>Mejorar la funcionalidad y seguridad de la Plataforma.</li>
            <li>Enviar notificaciones relacionadas con su actividad en la Plataforma.</li>
            <li>Mostrar publicidad personalizada mediante Google AdSense.</li>
            <li>Cumplir con obligaciones legales aplicables.</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">4. Cookies</h2>
          <p>
            Utilizamos cookies esenciales para el funcionamiento de la Plataforma y cookies analíticas y
            publicitarias de terceros, incluyendo Google AdSense. Al continuar navegando, usted acepta el
            uso de estas cookies.
          </p>
          <p className="mt-2">
            Puede configurar su navegador para rechazar o eliminar cookies, aunque esto puede afectar el
            correcto funcionamiento de algunas funciones de la Plataforma.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">5. Compartir información con terceros</h2>
          <p>
            LlevaLleva no vende ni alquila sus datos personales a terceros. Podemos compartir información con:
          </p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li><strong>Proveedores de servicios:</strong> empresas que nos ayudan a operar la Plataforma (alojamiento, análisis), bajo estrictos acuerdos de confidencialidad.</li>
            <li><strong>Autoridades competentes:</strong> cuando lo exija la ley colombiana o una orden judicial.</li>
          </ul>
          <p className="mt-2">
            La información de sus anuncios (nombre de usuario, descripción, imágenes, precio) es pública y
            visible para todos los visitantes de la Plataforma.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">6. Derechos del titular (Ley 1581 de 2012)</h2>
          <p>Como titular de datos personales, usted tiene los siguientes derechos:</p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li><strong>Acceso:</strong> conocer qué datos suyos tratamos.</li>
            <li><strong>Rectificación:</strong> solicitar la corrección de datos inexactos o incompletos.</li>
            <li><strong>Supresión:</strong> solicitar la eliminación de sus datos cuando no exista obligación legal de conservarlos.</li>
            <li><strong>Portabilidad:</strong> recibir sus datos en un formato estructurado y de uso común.</li>
            <li><strong>Revocación:</strong> retirar el consentimiento otorgado para el tratamiento de sus datos.</li>
            <li><strong>Queja:</strong> presentar queja ante la Superintendencia de Industria y Comercio (SIC).</li>
          </ul>
          <p className="mt-2">
            Para ejercer sus derechos, puede contactarnos a través de nuestra{' '}
            <Link href="/contacto" className="text-emerald-600 hover:underline">página de contacto</Link>.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">7. Seguridad de los datos</h2>
          <p>
            Implementamos medidas técnicas y organizativas razonables para proteger sus datos personales
            contra acceso no autorizado, pérdida o alteración. Las contraseñas se almacenan cifradas y
            las comunicaciones se realizan mediante protocolos seguros (HTTPS).
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">8. Retención de datos</h2>
          <p>
            Conservamos sus datos personales mientras su cuenta esté activa o sea necesario para prestarle
            el servicio. Al eliminar su cuenta, procederemos a la supresión de sus datos personales en un
            plazo razonable, salvo que la ley exija su conservación por un periodo determinado.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">9. Menores de edad</h2>
          <p>
            LlevaLleva.co no está dirigida a personas menores de 18 años. Si detectamos que hemos recopilado
            datos de un menor sin el consentimiento de sus padres o tutores, procederemos a eliminar dicha
            información de inmediato.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">10. Cambios a esta política</h2>
          <p>
            Podemos actualizar esta Política de Privacidad periódicamente. Cuando realicemos cambios
            materiales, le notificaremos a través de la Plataforma o por correo electrónico. Le recomendamos
            revisar esta política con regularidad.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-gray-900 mb-3">11. Contacto</h2>
          <p>
            Para cualquier consulta relacionada con esta política o con el tratamiento de sus datos personales,
            contáctenos a través de nuestra{' '}
            <Link href="/contacto" className="text-emerald-600 hover:underline">página de contacto</Link>.
          </p>
        </section>

      </div>
    </div>
  );
}

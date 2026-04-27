import Link from 'next/link';

export default function Footer() {
  return (
    <footer className="bg-gray-900 text-gray-400 mt-16">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-12">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div className="col-span-2 md:col-span-1">
            <Link href="/" className="inline-block mb-3">
              <span className="text-xl font-black text-white">Lleva<span className="text-emerald-400">Lleva</span></span>
              <span className="text-sm text-gray-500">.co</span>
            </Link>
            <p className="text-sm leading-relaxed">
              El clasificado colombiano. Compra, vende y conecta con personas de tu región.
            </p>
          </div>

          <div>
            <h3 className="text-white font-semibold text-sm mb-3">Categorías populares</h3>
            <ul className="space-y-2 text-sm">
              <li><Link href="/categorias/vehiculos" className="hover:text-white transition-colors">Vehículos</Link></li>
              <li><Link href="/categorias/inmuebles" className="hover:text-white transition-colors">Inmuebles</Link></li>
              <li><Link href="/categorias/tecnologia" className="hover:text-white transition-colors">Tecnología</Link></li>
              <li><Link href="/categorias/nautico-y-pesca" className="hover:text-white transition-colors">Náutico y Pesca</Link></li>
              <li><Link href="/categorias/servicios" className="hover:text-white transition-colors">Servicios</Link></li>
            </ul>
          </div>

          <div>
            <h3 className="text-white font-semibold text-sm mb-3">LlevaLleva</h3>
            <ul className="space-y-2 text-sm">
              <li><Link href="/publicar" className="hover:text-white transition-colors">Publicar gratis</Link></li>
              <li><Link href="/como-funciona" className="hover:text-white transition-colors">¿Cómo funciona?</Link></li>
              <li><Link href="/seguridad" className="hover:text-white transition-colors">Consejos de seguridad</Link></li>
              <li><Link href="/terminos" className="hover:text-white transition-colors">Términos y condiciones</Link></li>
              <li><Link href="/privacidad" className="hover:text-white transition-colors">Política de privacidad</Link></li>
            </ul>
          </div>

          <div>
            <h3 className="text-white font-semibold text-sm mb-3">Soporte</h3>
            <ul className="space-y-2 text-sm">
              <li><Link href="/ayuda" className="hover:text-white transition-colors">Centro de ayuda</Link></li>
              <li><Link href="/contacto" className="hover:text-white transition-colors">Contacto</Link></li>
              <li><Link href="/reportar" className="hover:text-white transition-colors">Reportar un problema</Link></li>
            </ul>
            <div className="mt-4">
              <p className="text-xs text-gray-600">Síguenos en:</p>
              <div className="flex gap-3 mt-2">
                <a href="#" className="text-gray-600 hover:text-white transition-colors text-sm">Instagram</a>
                <a href="#" className="text-gray-600 hover:text-white transition-colors text-sm">Facebook</a>
              </div>
            </div>
          </div>
        </div>

        {/* Maia Group ecosystem */}
        <div className="border-t border-gray-800 mt-10 pt-6 text-xs text-gray-600 text-center">
          <p className="mb-2">
            Parte del ecosistema{' '}
            <a href="https://maia-management.com" target="_blank" rel="noopener noreferrer" className="text-emerald-400 hover:text-emerald-300 transition-colors">Maia Group</a>
            {' · '}
            <a href="https://maia-legal.com" target="_blank" rel="noopener noreferrer" className="hover:text-gray-400 transition-colors">Maia Legal</a>
            {' · '}
            <a href="https://maia-realty.com" target="_blank" rel="noopener noreferrer" className="hover:text-gray-400 transition-colors">Maia Realty</a>
            {' · '}
            <a href="https://maia-masters.com" target="_blank" rel="noopener noreferrer" className="hover:text-gray-400 transition-colors">Maia Masters</a>
          </p>
          <p className="mb-4">
            Trabaja con nosotros →{' '}
            <a href="https://maia-management.com/empleo.html" target="_blank" rel="noopener noreferrer" className="text-emerald-400 hover:text-emerald-300 transition-colors">
              Únete al equipo Maia
            </a>
          </p>
        </div>

        <div className="border-t border-gray-800 pt-4 flex flex-col sm:flex-row items-center justify-between gap-3 text-xs text-gray-600">
          <p>© {new Date().getFullYear()} LlevaLleva.co — Todos los derechos reservados</p>
          <p>Hecho con 🇨🇴 en Colombia</p>
        </div>
      </div>
    </footer>
  );
}

import Link from 'next/link';

export default function Footer() {
  return (
    <footer className="bg-ink text-white/80 mt-16">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-12">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div className="col-span-2 md:col-span-1">
            <Link href="/" className="inline-flex items-center gap-2 mb-3 group">
              <span className="inline-block w-2 h-2 rounded-full bg-brand-yellow group-hover:bg-brand-red transition-colors" aria-hidden="true" />
              <span className="text-xl font-black text-white">
                Lleva<span className="text-brand-yellow">Lleva</span>
              </span>
            </Link>
            <p className="text-sm leading-relaxed text-white/75">
              El clasificado colombiano. Compra, vende y conecta con personas de tu región.
            </p>
          </div>

          <div>
            <p className="text-white font-semibold text-sm mb-3">Categorías populares</p>
            <ul className="space-y-2 text-sm">
              <li><Link href="/categorias/vehiculos" className="hover:text-brand-yellow transition-colors">Vehículos</Link></li>
              <li><Link href="/categorias/inmuebles" className="hover:text-brand-yellow transition-colors">Inmuebles</Link></li>
              <li><Link href="/categorias/tecnologia" className="hover:text-brand-yellow transition-colors">Tecnología</Link></li>
              <li><Link href="/categorias/nautico-y-pesca" className="hover:text-brand-yellow transition-colors">Náutico y Pesca</Link></li>
              <li><Link href="/categorias/servicios" className="hover:text-brand-yellow transition-colors">Servicios</Link></li>
            </ul>
          </div>

          <div>
            <p className="text-white font-semibold text-sm mb-3">LlevaLleva</p>
            <ul className="space-y-2 text-sm">
              <li><Link href="/publicar" className="hover:text-brand-yellow transition-colors">Publicar gratis</Link></li>
              <li><Link href="/herramientas/calculadora" className="hover:text-brand-yellow transition-colors">Calculadora SMMLV/UVT</Link></li>
              <li><Link href="/info/info-publica/precios-referencia" className="hover:text-brand-yellow transition-colors">Información pública</Link></li>
              <li><Link href="/como-funciona" className="hover:text-brand-yellow transition-colors">¿Cómo funciona?</Link></li>
              <li><Link href="/seguridad" className="hover:text-brand-yellow transition-colors">Consejos de seguridad</Link></li>
              <li><Link href="/terminos" className="hover:text-brand-yellow transition-colors">Términos y condiciones</Link></li>
              <li><Link href="/privacidad" className="hover:text-brand-yellow transition-colors">Política de privacidad</Link></li>
            </ul>
          </div>

          <div>
            <p className="text-white font-semibold text-sm mb-3">Soporte</p>
            <ul className="space-y-2 text-sm">
              <li><Link href="/ayuda" className="hover:text-brand-yellow transition-colors">Centro de ayuda</Link></li>
              <li><Link href="/contacto" className="hover:text-brand-yellow transition-colors">Contacto</Link></li>
              <li><Link href="/reportar" className="hover:text-brand-yellow transition-colors">Reportar un problema</Link></li>
            </ul>
          </div>
        </div>

        {/* Maia Management ecosystem */}
        <div className="border-t border-white/10 mt-10 pt-6 text-xs text-white/75 text-center">
          <p className="mb-2">
            Parte del ecosistema{' '}
            <a href="https://the-maia-group.com" target="_blank" rel="noopener noreferrer" className="text-brand-yellow hover:text-brand-yellow-600 transition-colors font-medium">The Maia Group</a>
            {' · '}
            <a href="https://maia-management.com" target="_blank" rel="noopener noreferrer" className="text-brand-yellow hover:text-brand-yellow-600 transition-colors font-medium">Maia Management</a>
            {' · '}
            <a href="https://maia-legal.com" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors">Maia Legal</a>
            {' · '}
            <a href="https://maia-realty.com" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors">Maia Realty</a>
            {' · '}
            <a href="https://maia-masters.com" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors">Maia Masters</a>
            {' · '}
            <a href="https://maia-botanicas.com" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors">Maia Botánicas</a>
            {' · '}
            <a href="https://be-vida.com" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors">Be Vida</a>
          </p>
          <p className="mb-4">
            Trabaja con nosotros →{' '}
            <a href="https://maia-management.com/empleo.html" target="_blank" rel="noopener noreferrer" className="text-brand-yellow hover:text-brand-yellow-600 transition-colors font-medium">
              Únete al equipo Maia
            </a>
          </p>
        </div>

        <div className="border-t border-white/10 pt-4 text-xs text-white/75 space-y-2">
          <p className="text-center sm:text-left">
            MAIA MANAGEMENT S.A.S. — NIT 901.862.977-7
          </p>
          <p className="text-center sm:text-left">
            Calle 24 #3-99, Edificio Banco de Bogotá, Suite 1102, Nivel 11, Santa Marta, Magdalena, Colombia
          </p>
          <p className="text-center sm:text-left">
            Privacidad:{' '}
            <a href="mailto:privacy@maia-management.com" className="text-brand-yellow hover:text-brand-yellow-600 transition-colors">
              privacy@maia-management.com
            </a>
          </p>
          <div className="flex flex-col sm:flex-row items-center justify-between gap-3 pt-2">
            <p>© {new Date().getFullYear()} LlevaLleva — Todos los derechos reservados</p>
            <p>Hecho con 🇨🇴 en Colombia</p>
          </div>
        </div>
      </div>
    </footer>
  );
}

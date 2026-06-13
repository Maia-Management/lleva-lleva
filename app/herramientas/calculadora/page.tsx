import type { Metadata } from 'next';
import Link from 'next/link';
import Calculadora from './Calculadora';

export const metadata: Metadata = {
  title: 'Calculadora SMMLV y UVT 2026 – LlevaLleva',
  description:
    'Convierte pesos colombianos a salarios mínimos (SMMLV) o a UVT con los valores oficiales 2026. Herramienta gratuita de LlevaLleva, el clasificado colombiano.',
  alternates: { canonical: 'https://lleva-lleva.com/herramientas/calculadora' },
  openGraph: {
    title: 'Calculadora SMMLV y UVT 2026',
    description: 'Convierte pesos a salarios mínimos o UVT con los valores oficiales 2026.',
    type: 'website',
  },
};

export default function CalculadoraPage() {
  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 py-6">
      {/* Breadcrumb */}
      <nav className="text-xs text-gray-500 mb-4 flex items-center gap-1.5 flex-wrap">
        <Link href="/" className="hover:text-brand-blue">Inicio</Link>
        <span>›</span>
        <Link href="/categorias/informacion-publica" className="hover:text-brand-blue">Información Pública</Link>
        <span>›</span>
        <span className="text-gray-700">Calculadora SMMLV y UVT</span>
      </nav>

      <header className="mb-6">
        <div className="flex items-start gap-3">
          <div className="w-11 h-11 rounded-xl bg-brand-blue-50 flex items-center justify-center text-2xl flex-shrink-0" aria-hidden="true">
            🧮
          </div>
          <div>
            <h1 className="text-xl sm:text-2xl font-bold text-ink leading-tight">Calculadora SMMLV y UVT 2026</h1>
            <p className="text-sm text-ink-2 mt-1 leading-relaxed">
              Convierte entre pesos colombianos, salarios mínimos y UVT en segundos. Útil para arriendos, depósitos,
              multas, contratos y precios de referencia.
            </p>
          </div>
        </div>
      </header>

      <div className="bg-white rounded-2xl border border-gray-200 p-5 sm:p-7">
        <Calculadora />
      </div>

      {/* Contexto / SEO útil */}
      <section className="mt-8 prose prose-sm max-w-none">
        <h2 className="text-base font-bold text-ink mb-2">¿Para qué sirve esta calculadora?</h2>
        <p className="text-sm text-ink-2 leading-relaxed mb-3">
          En Colombia muchos valores no se expresan en pesos sino en <strong>salarios mínimos (SMMLV)</strong> o en{' '}
          <strong>UVT</strong>. Por ejemplo, los depósitos de arriendo, algunas multas de tránsito, topes para declarar
          renta y sanciones de la DIAN se calculan en estas unidades. Esta herramienta te deja pasar de una a otra al
          instante, con los valores vigentes de 2026.
        </p>
        <h2 className="text-base font-bold text-ink mb-2">Valores oficiales 2026</h2>
        <p className="text-sm text-ink-2 leading-relaxed">
          El salario mínimo mensual legal vigente para 2026 es de <strong>$1.750.905</strong> y el auxilio de transporte
          de <strong>$249.095</strong>, según el Decreto 1469 de 2025. La UVT 2026 es de <strong>$52.374</strong>, fijada
          por la Resolución DIAN 000238 de 2025.
        </p>
      </section>

      <div className="mt-8 flex flex-wrap gap-2">
        <Link href="/info/info-publica/precios-referencia" className="text-sm px-3 py-2 rounded-xl border border-gray-200 text-brand-blue hover:bg-brand-blue-50 transition-colors">
          💰 Precios de referencia
        </Link>
        <Link href="/info/info-publica/tasas" className="text-sm px-3 py-2 rounded-xl border border-gray-200 text-brand-blue hover:bg-brand-blue-50 transition-colors">
          ⚖️ Tasas y tarifas
        </Link>
        <Link href="/cuanto-vale" className="text-sm px-3 py-2 rounded-xl border border-gray-200 text-brand-blue hover:bg-brand-blue-50 transition-colors">
          💰 ¿Cuánto vale?
        </Link>
      </div>
    </div>
  );
}

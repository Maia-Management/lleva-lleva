import { Metadata } from 'next';
import Link from 'next/link';

interface Props {
  params: Promise<{ category: string; location: string }>;
}

type InfoLink = { label: string; href: string };
type InfoSection = {
  title: string;
  emoji: string;
  updated: string;
  intro?: string;
  content: string[];
  links?: InfoLink[];
  showCalculator?: boolean;
};

// Valores oficiales Colombia 2026.
// SMMLV: Decreto 1469 del 29-dic-2025 ($1.750.905 + auxilio $249.095).
// UVT 2026: Resolución DIAN 000238 del 15-dic-2025 ($52.374).
// Las tasas financieras (usura, DTF, IBR) cambian periódicamente — enlazamos a la fuente oficial.
const INFO_CONTENT: Record<string, InfoSection> = {
  tramites: {
    title: 'Trámites y Documentos',
    emoji: '📋',
    updated: 'enero 2026',
    intro:
      'Guía rápida de los trámites más consultados en Colombia, con los enlaces oficiales para hacerlos tú mismo, sin intermediarios.',
    content: [
      'RUT (Registro Único Tributario): se obtiene y actualiza gratis en la DIAN. Lo necesitas para facturar, vender formalmente o abrir cuenta empresarial.',
      'NIT: es el número del RUT para personas jurídicas; se asigna automáticamente al inscribir la empresa.',
      'Matrícula mercantil: si vendes de forma habitual debes registrarte y renovar cada año (antes del 31 de marzo) en la Cámara de Comercio de tu ciudad.',
      'SOAT: seguro obligatorio para todo vehículo. Renuévalo antes de que venza; circular sin SOAT genera multa e inmovilización.',
      'Revisión Técnico-Mecánica (RTM): obligatoria según el año del vehículo. Las motos y carros particulares nuevos la hacen a partir del sexto y segundo año respectivamente.',
      'Traspaso de vehículo: se hace ante un organismo de tránsito o por el RUNT. Pide siempre el paz y salvo de comparendos antes de comprar.',
    ],
    links: [
      { label: 'DIAN — RUT en línea', href: 'https://www.dian.gov.co' },
      { label: 'RUNT — consultas vehiculares', href: 'https://www.runt.gov.co' },
      { label: 'Confecámaras — Cámaras de Comercio', href: 'https://www.confecamaras.org.co' },
    ],
  },
  'precios-referencia': {
    title: 'Precios de Referencia',
    emoji: '💰',
    updated: 'enero 2026',
    intro:
      'Valores base de la economía colombiana en 2026. Útiles para fijar precios, calcular arriendos, depósitos, multas y prestaciones.',
    content: [
      'Salario mínimo (SMMLV) 2026: $1.750.905 al mes (Decreto 1469 de 2025, vigente desde el 1 de enero).',
      'Auxilio de transporte 2026: $249.095 al mes para quienes ganan hasta dos salarios mínimos.',
      'Ingreso total con auxilio: $2.000.000 al mes.',
      'UVT 2026: $52.374. Es la unidad con la que la DIAN expresa topes, sanciones y tarifas tributarias.',
      'IVA general: 19% (hay bienes y servicios exentos o con tarifa del 5%).',
      'Referencia para vender: revisa anuncios activos de productos similares en tu ciudad antes de fijar tu precio. Nuestra herramienta ¿Cuánto vale? te da un rango en segundos.',
    ],
    links: [
      { label: 'Banco de la República — indicadores', href: 'https://www.banrep.gov.co' },
      { label: 'DANE — IPC e inflación', href: 'https://www.dane.gov.co' },
    ],
    showCalculator: true,
  },
  tasas: {
    title: 'Tasas y Tarifas Vigentes',
    emoji: '⚖️',
    updated: 'enero 2026',
    intro:
      'Las tasas financieras se actualizan cada mes o cada semana. Aquí te dejamos qué significan y dónde consultar el dato oficial al día.',
    content: [
      'Tasa de usura: el interés máximo legal para créditos de consumo. La fija mensualmente la Superintendencia Financiera; cobrar por encima es delito.',
      'DTF: promedio de las tasas de los depósitos a término (CDT) a 90 días. La publica semanalmente el Banco de la República y sirve de referencia para muchos créditos.',
      'IBR (Indicador Bancario de Referencia): tasa de referencia del mercado interbancario, con actualización diaria/mensual.',
      'UVT 2026: $52.374 — base para sanciones y topes de la DIAN.',
      'ICA: impuesto de industria y comercio; la tarifa depende de la actividad y del municipio. Consúltala en la Secretaría de Hacienda de tu ciudad.',
    ],
    links: [
      { label: 'Superfinanciera — tasa de usura vigente', href: 'https://www.superfinanciera.gov.co' },
      { label: 'Banco de la República — DTF e IBR', href: 'https://www.banrep.gov.co' },
    ],
    showCalculator: true,
  },
  noticias: {
    title: 'Noticias y Avisos Locales',
    emoji: '📰',
    updated: 'enero 2026',
    intro:
      'Información de utilidad para tu región del Caribe colombiano. Aquí reunimos enlaces oficiales para que estés al día.',
    content: [
      'Alcaldía de Santa Marta: trámites de ciudad, valorización, predial y eventos. Visita santamarta.gov.co',
      'Gobernación del Magdalena: programas departamentales y convocatorias para el Magdalena.',
      'Movilidad y tránsito: pico y placa, comparendos y trámites de vehículos en el organismo de tránsito local.',
      'Servicios públicos: reporta daños y consulta cortes programados con tu empresa de acueducto y energía.',
      '¿Eres un medio o una entidad pública? Escríbenos para publicar información oficial verificada en esta sección.',
    ],
    links: [
      { label: 'Alcaldía de Santa Marta', href: 'https://www.santamarta.gov.co' },
      { label: 'Gobernación del Magdalena', href: 'https://www.magdalena.gov.co' },
    ],
  },
  alertas: {
    title: 'Alertas Comunitarias',
    emoji: '🚨',
    updated: 'enero 2026',
    intro:
      'Líneas oficiales de emergencia y seguridad que toda la comunidad debería tener a la mano.',
    content: [
      'Emergencias generales: 123 (Policía, ambulancia y atención inmediata).',
      'Bomberos: 119.',
      'Cruz Roja: 132.',
      'Gestión del riesgo y desastres: reporta emergencias ambientales o naturales a la Defensa Civil (144).',
      'Antes de comprar o vender en persona, lee nuestros consejos de seguridad: reúnete en lugares públicos y a la luz del día.',
    ],
    links: [{ label: 'Consejos de seguridad LlevaLleva', href: '/seguridad' }],
  },
  directorio: {
    title: 'Directorio de Entidades',
    emoji: '🏛️',
    updated: 'enero 2026',
    intro: 'Contactos oficiales que más se necesitan en Colombia y en el Magdalena.',
    content: [
      'DIAN (impuestos y RUT): línea nacional 01 8000 952 997 · www.dian.gov.co',
      'RUNT (vehículos y conductores): www.runt.gov.co',
      'SECOP — contratación estatal: www.colombiacompra.gov.co',
      'Alcaldía de Santa Marta: www.santamarta.gov.co',
      'Policía Nacional: 123 · Bomberos: 119 · Cruz Roja: 132',
    ],
    links: [{ label: 'Confecámaras', href: 'https://www.confecamaras.org.co' }],
  },
  convocatorias: {
    title: 'Convocatorias y Empleo Público',
    emoji: '📢',
    updated: 'enero 2026',
    intro: 'Dónde encontrar convocatorias laborales, becas y oportunidades oficiales.',
    content: [
      'Empleo público: ofertas del Estado en el portal SIGEP — www.sigep.gov.co',
      'Becas y créditos educativos: ICETEX — www.icetex.gov.co',
      'Investigación e innovación: convocatorias de Minciencias.',
      'Contratación estatal y licitaciones: SECOP — www.colombiacompra.gov.co',
      '¿Buscas trabajo cerca de ti? Explora la categoría Empleo en LlevaLleva.',
    ],
    links: [{ label: 'Ver empleos en LlevaLleva', href: '/categorias/empleo' }],
  },
};

const SECTION_ORDER = [
  'tramites',
  'precios-referencia',
  'tasas',
  'noticias',
  'alertas',
  'directorio',
  'convocatorias',
];

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { category, location } = await params;
  const section = INFO_CONTENT[location];
  const title = section ? `${section.title} en Colombia 2026` : `Información ${category}`;
  const description = section
    ? `${section.intro ?? section.title} Datos actualizados (${section.updated}) en LlevaLleva, el clasificado colombiano.`
    : `Información pública sobre ${category} en Colombia. LlevaLleva.`;
  return {
    title,
    description,
    alternates: { canonical: `https://lleva-lleva.com/info/${category}/${location}` },
    openGraph: { title, description, type: 'article' },
  };
}

export default async function InfoPage({ params }: Props) {
  const { location } = await params;
  const content = INFO_CONTENT[location] ?? null;

  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 py-6">
      {/* Breadcrumb */}
      <nav className="text-xs text-gray-500 mb-4 flex items-center gap-1.5 flex-wrap">
        <Link href="/" className="hover:text-brand-blue">Inicio</Link>
        <span>›</span>
        <Link href="/categorias/informacion-publica" className="hover:text-brand-blue">Información Pública</Link>
        <span>›</span>
        <span className="text-gray-700">{content?.title ?? location}</span>
      </nav>

      <div className="bg-white rounded-2xl border border-gray-200 p-6 sm:p-8">
        <div className="flex items-start gap-3 mb-5">
          <div className="w-11 h-11 rounded-xl bg-brand-blue-50 flex items-center justify-center text-2xl flex-shrink-0">
            {content?.emoji ?? '📋'}
          </div>
          <div>
            <h1 className="text-xl sm:text-2xl font-bold text-gray-900 leading-tight">{content?.title ?? location}</h1>
            <p className="text-xs text-gray-500 mt-1">
              Información de referencia · LlevaLleva
              {content && <span className="ml-1">· Actualizado: {content.updated}</span>}
            </p>
          </div>
        </div>

        {content ? (
          <>
            {content.intro && (
              <p className="text-sm text-gray-600 leading-relaxed mb-6">{content.intro}</p>
            )}
            <ul className="space-y-4">
              {content.content.map((item, i) => (
                <li key={i} className="flex items-start gap-3">
                  <span className="text-brand-blue mt-0.5 flex-shrink-0" aria-hidden="true">✓</span>
                  <p className="text-sm text-gray-700 leading-relaxed">{item}</p>
                </li>
              ))}
            </ul>

            {content.links && content.links.length > 0 && (
              <div className="mt-7 pt-5 border-t border-gray-100">
                <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3">Enlaces oficiales</p>
                <div className="flex flex-wrap gap-2">
                  {content.links.map((link) => {
                    const external = link.href.startsWith('http');
                    return external ? (
                      <a
                        key={link.href}
                        href={link.href}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1.5 text-sm px-3 py-1.5 rounded-lg border border-gray-200 text-brand-blue hover:bg-brand-blue-50 transition-colors"
                      >
                        {link.label} <span aria-hidden="true">↗</span>
                      </a>
                    ) : (
                      <Link
                        key={link.href}
                        href={link.href}
                        className="inline-flex items-center gap-1.5 text-sm px-3 py-1.5 rounded-lg border border-gray-200 text-brand-blue hover:bg-brand-blue-50 transition-colors"
                      >
                        {link.label} <span aria-hidden="true">→</span>
                      </Link>
                    );
                  })}
                </div>
              </div>
            )}

            {content.showCalculator && (
              <Link
                href="/herramientas/calculadora"
                className="mt-6 flex items-center gap-3 bg-brand-blue-50 border border-brand-blue/20 rounded-xl p-4 hover:border-brand-blue/40 transition-colors group"
              >
                <span className="text-2xl" aria-hidden="true">🧮</span>
                <span className="flex-1">
                  <span className="block text-sm font-semibold text-ink">Calculadora SMMLV y UVT</span>
                  <span className="block text-xs text-ink-2">Convierte pesos a salarios mínimos o UVT con los valores 2026.</span>
                </span>
                <span className="text-brand-blue group-hover:translate-x-0.5 transition-transform" aria-hidden="true">→</span>
              </Link>
            )}

            <div className="mt-7 bg-brand-yellow/10 border border-brand-yellow/30 rounded-xl p-4">
              <p className="text-xs text-ink-2 leading-relaxed">
                <strong>Aviso:</strong> esta información es de referencia y puede cambiar. Las tasas financieras y los
                trámites se actualizan periódicamente — verifica siempre con la entidad oficial antes de tomar decisiones.
              </p>
            </div>
          </>
        ) : (
          <p className="text-gray-500 text-sm">
            Contenido en construcción. Mientras tanto, revisa las otras secciones de Información Pública más abajo.
          </p>
        )}
      </div>

      {/* Related links */}
      <div className="mt-6">
        <h2 className="font-semibold text-gray-700 text-sm mb-3">Otras secciones de Información Pública</h2>
        <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
          {SECTION_ORDER.map((slug) => {
            const info = INFO_CONTENT[slug];
            return (
              <Link
                key={slug}
                href={`/info/info-publica/${slug}`}
                className={`text-sm px-3 py-2 rounded-xl border transition-colors flex items-center gap-2 ${
                  slug === location
                    ? 'border-brand-blue/40 bg-brand-blue-50 text-brand-blue font-medium'
                    : 'border-gray-200 bg-white text-gray-600 hover:border-brand-blue/20 hover:text-brand-blue'
                }`}
              >
                <span aria-hidden="true">{info.emoji}</span>
                <span className="truncate">{info.title}</span>
              </Link>
            );
          })}
        </div>
      </div>
    </div>
  );
}

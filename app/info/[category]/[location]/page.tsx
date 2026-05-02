import { Metadata } from 'next';
import { createClient } from '@/lib/supabase/server';
import { notFound } from 'next/navigation';
import Link from 'next/link';

interface Props {
  params: Promise<{ category: string; location: string }>;
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { category, location } = await params;
  return {
    title: `Información ${category} – ${location}`,
    description: `Información pública sobre ${category} en ${location}. Lleva Lleva`,
  };
}

export default async function InfoPage({ params }: Props) {
  const { category, location } = await params;
  const supabase = await createClient();

  // Find the category
  const { data: cat } = await supabase
    .from('categories')
    .select('*, parent:categories(name_es, slug)')
    .eq('slug', location)
    .single();

  // Fetch bot listings for this category + location combo
  const { data: listings } = await supabase
    .from('listings')
    .select('*, location:locations(*)')
    .eq('status', 'active')
    .ilike('tags', `%${location}%`)
    .limit(20);

  const INFO_CONTENT: Record<string, { title: string; content: string[] }> = {
    tramites: {
      title: 'Trámites y Documentos',
      content: [
        'Registro Único Tributario (RUT): Puedes obtener tu RUT gratis en la DIAN. Visita www.dian.gov.co',
        'NIT (Número de Identificación Tributaria): Se asigna automáticamente al obtener el RUT para personas jurídicas.',
        'Cámara de Comercio: Registro de empresas y actualización de matrícula mercantil.',
        'SOAT: Seguro Obligatorio de Accidentes de Tránsito — renovación anual.',
        'Revisión Técnico-Mecánica: Obligatoria para vehículos según año y tipo.',
      ],
    },
    'precios-referencia': {
      title: 'Precios de Referencia',
      content: [
        'Salario Mínimo 2024: $1.300.000 COP mensuales.',
        'Auxilio de transporte: $162.000 COP mensuales.',
        'UVT 2024: $47.065 COP.',
        'SMMLV: Se ajusta anualmente por decreto gubernamental.',
        'Estos precios son de referencia — verifica los valores actuales con la entidad correspondiente.',
      ],
    },
    tasas: {
      title: 'Tasas y Tarifas Vigentes',
      content: [
        'Tasa de usura (Superfinanciera): Consulta mensualmente en www.superfinanciera.gov.co',
        'DTF (Depósitos a Término Fijo): Variable semanal, publicada por el Banco de la República.',
        'IBR (Indicador Bancario de Referencia): Actualización mensual.',
        'IVA: Tarifa general del 19%.',
        'ICA: Varía según municipio — consulta la Secretaría de Hacienda de tu ciudad.',
      ],
    },
    noticias: {
      title: 'Noticias Locales',
      content: [
        'Esta sección mostrará noticias de interés local publicadas por entes verificados.',
        'Próximamente: integración con fuentes de noticias locales verificadas.',
        'Si eres un medio de comunicación o entidad pública, contáctanos para publicar información oficial.',
      ],
    },
    alertas: {
      title: 'Alertas Comunitarias',
      content: [
        'Esta sección muestra alertas de seguridad y emergencias relevantes para tu comunidad.',
        'Las alertas son publicadas por cuentas verificadas de entidades oficiales.',
        'Próximamente: alertas en tiempo real integradas con fuentes oficiales.',
      ],
    },
    directorio: {
      title: 'Directorio de Entidades',
      content: [
        'Alcaldía: www.alcaldia.gov.co (consulta tu municipio)',
        'DIAN: www.dian.gov.co — Tel: 57 (1) 8000-952997',
        'Cámara de Comercio: Consulta la de tu ciudad en www.confecamaras.co',
        'Policía Nacional: Línea de emergencias 123',
        'Bomberos: Línea 119',
        'Cruz Roja: 132',
      ],
    },
    convocatorias: {
      title: 'Convocatorias',
      content: [
        'Convocatorias laborales del sector público: SIGEP — www.sigep.gov.co',
        'Licitaciones y contratos estatales: SECOP — www.colombiacompra.gov.co',
        'Convocatorias de becas: ICETEX — www.icetex.gov.co',
        'Convocatorias de Colciencias/Minciencias para investigación.',
        'Próximamente: convocatorias publicadas directamente en LlevaLleva.',
      ],
    },
  };

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
        <div className="flex items-center gap-3 mb-6">
          <div className="w-10 h-10 rounded-xl bg-brand-blue-50 flex items-center justify-center text-xl">📋</div>
          <div>
            <h1 className="text-xl font-bold text-gray-900">{content?.title ?? location}</h1>
            <p className="text-xs text-gray-500">Información de referencia · LlevaLleva.co</p>
          </div>
        </div>

        {content ? (
          <>
            <ul className="space-y-4">
              {content.content.map((item, i) => (
                <li key={i} className="flex items-start gap-3">
                  <span className="text-white0 mt-0.5 flex-shrink-0">✓</span>
                  <p className="text-sm text-gray-700 leading-relaxed">{item}</p>
                </li>
              ))}
            </ul>
            <div className="mt-8 bg-brand-yellow/10 border border-brand-yellow/30 rounded-xl p-4">
              <p className="text-xs text-brand-yellow-600">
                <strong>Aviso:</strong> Esta información es de referencia y puede estar desactualizada.
                Siempre verifica con las entidades oficiales antes de tomar decisiones.
              </p>
            </div>
          </>
        ) : (
          <p className="text-gray-500 text-sm">
            Contenido en construcción. Estamos agregando información útil para esta sección.
          </p>
        )}
      </div>

      {/* Related links */}
      <div className="mt-6">
        <h2 className="font-semibold text-gray-700 text-sm mb-3">Otras secciones de Información Pública</h2>
        <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
          {Object.entries(INFO_CONTENT).map(([slug, info]) => (
            <Link
              key={slug}
              href={`/info/info-publica/${slug}`}
              className={`text-sm px-3 py-2 rounded-xl border transition-colors ${slug === location ? 'border-brand-blue/40 bg-brand-blue-50 text-brand-blue font-medium' : 'border-gray-200 bg-white text-gray-600 hover:border-brand-blue/20 hover:text-brand-blue'}`}
            >
              {info.title}
            </Link>
          ))}
        </div>
      </div>
    </div>
  );
}

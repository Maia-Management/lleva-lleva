// Posts El Sanatorio BUSCO (wanted) listings to LlevaLleva production.
// Uses Supabase service-role key to bypass RLS. Run from repo root so .env.local resolves.
//
// node post-sanatorio-busco.mjs
//
// Env required: NEXT_PUBLIC_SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY
// Loads .env.local automatically.

import { readFileSync } from 'node:fs';
import { createClient } from '@supabase/supabase-js';
import { randomUUID } from 'node:crypto';

// --- env loader (no dotenv dep) ---
try {
  const env = readFileSync('.env.local', 'utf8');
  for (const line of env.split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$/);
    if (m) process.env[m[1]] = m[2].replace(/^["']|["']$/g, '');
  }
} catch {}

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL;
const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
if (!SUPABASE_URL || !SERVICE_KEY) {
  console.error('Missing NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SERVICE_KEY, {
  auth: { persistSession: false, autoRefreshToken: false },
});

const SELLER_SANATORIO = 'a1b2c3d4-0001-0001-0001-000000000001';
const WA = '+19034598763';

// resolve category + location IDs by slug
async function idBySlug(table, slug) {
  const { data, error } = await supabase.from(table).select('id').eq('slug', slug).maybeSingle();
  if (error) throw error;
  if (!data) throw new Error(`No ${table} for slug ${slug}`);
  return data.id;
}

function slugify(s) {
  return s.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g,'')
    .replace(/[^a-z0-9]+/g,'-').replace(/^-|-$/g,'').slice(0,80);
}

async function main() {
  const [muebles, decoracion, electrodom, otros] = await Promise.all([
    idBySlug('categories','muebles'),
    idBySlug('categories','decoracion'),
    idBySlug('categories','electrodomesticos').catch(()=>null),
    idBySlug('categories','otros-hogar').catch(()=>null),
  ]);
  const loc = await idBySlug('locations','santa-marta');

  // Helper to build a BUSCO listing
  const busco = (title, slugCore, category_id, priceCOP, bullets, photoBrief) => {
    const idSuffix = randomUUID().slice(0,8);
    const slug = `${slugCore}-${idSuffix}`;
    const priceLine = priceCOP
      ? `\n\n💰 *Pagamos ${priceCOP.toLocaleString('es-CO')} COP* por unidad en buen estado.`
      : '';
    const description =
`El Sanatorio Gastro Bar abre 30 jul en Santa Marta y estamos buscando piezas auténticas para nuestra ambientación.

Qué buscamos:
${bullets.map(b=>`• ${b}`).join('\n')}

📸 Foto ideal: ${photoBrief}${priceLine}

Pago de contado el día de la entrega. Recogemos en Santa Marta o coordinamos transporte si está en otra ciudad de la costa.

📲 Contacto Maia Management: WhatsApp ${WA}
Envíanos foto, ubicación y precio. Respondemos rápido.`;

    return {
      id: randomUUID(),
      seller_id: SELLER_SANATORIO,
      category_id,
      location_id: loc,
      title,
      slug,
      description,
      price: priceCOP || null,
      price_type: priceCOP ? 'fixed' : 'contact',
      currency: 'COP',
      status: 'active',
      published_at: new Date().toISOString(),
      tags: ['se-busca','se-compra','el-sanatorio','props','vintage','santa-marta'],
      images: [{ url:'/images/placeholder.jpg', alt: title, order: 0 }],
    };
  };

  const listings = [
    busco(
      'SE BUSCA: 6 Sillas de Ruedas Vintage — Props para El Sanatorio',
      'se-busca-sillas-de-ruedas-vintage-sanatorio',
      muebles, 300000,
      [
        'Sillas de ruedas antiguas estilo años 40-60 (madera, hierro forjado o esmalte blanco)',
        'No importa si no ruedan — son props decorativos',
        'Cantidad: 6 unidades (mientras más mejor, evaluamos lotes)',
        'Estado: oxidado-romántico es perfecto, mientras estructura aguante',
      ],
      'Silla completa de frente con buena luz, mostrando estado real'
    ),
    busco(
      'SE BUSCA: 4 Camas Hospitalarias Estilo Años 50 — El Sanatorio',
      'se-busca-camas-hospitalarias-anos-50-sanatorio',
      muebles, 1000000,
      [
        'Camas de hospital antiguas, marco metálico blanco o esmaltado',
        'Cabecera tipo barrotes, ruedas metálicas pequeñas (opcional)',
        'Cantidad: 4 unidades',
        'Aceptamos sin colchón. Pintura descascarada = ideal',
      ],
      'Cama completa de lado mostrando cabecera + estructura'
    ),
    busco(
      'SE BUSCA: 3 Mesas Redondas de Calle / Bistró — El Sanatorio',
      'se-busca-mesas-redondas-calle-bistro-sanatorio',
      muebles, 200000,
      [
        'Mesas redondas tipo bistró/café de calle, diámetro 60-80 cm',
        'Base hierro forjado o pedestal de fundición, sobre mármol o madera',
        'Cantidad: 3 unidades',
        'Estilo vintage / patinado — no buscamos nuevas',
      ],
      'Mesa completa desde arriba + foto base de cerca'
    ),
    busco(
      'SE BUSCA: Escritorio Antiguo de Maestro o Médico — El Sanatorio',
      'se-busca-escritorio-antiguo-maestro-medico-sanatorio',
      muebles, 800000,
      [
        'Escritorio macizo en madera oscura, estilo años 30-50',
        'Con cajones laterales, idealmente con tirador de bronce',
        'Tamaño aproximado: 120-140 cm ancho',
        'Para staging room (sala del médico jefe)',
      ],
      'Escritorio frontal completo + detalle de cajones'
    ),
    busco(
      'SE BUSCA: 14 Bancos de Bar / Taburetes Altos — El Sanatorio',
      'se-busca-bancos-bar-taburetes-altos-sanatorio',
      muebles, 100000,
      [
        'Bancos de bar / taburetes altura ~75 cm para barra',
        'Madera, hierro o mixtos — buscamos look industrial / vintage',
        'Cantidad: 14 unidades (ya tenemos 2, completamos 16)',
        'Aceptamos lotes de 4-8 si son consistentes entre sí',
      ],
      'Banco individual completo + foto del lote junto'
    ),
    busco(
      'SE BUSCA: Props Médicos Vintage — Estetoscopios, Lámparas, Frascos, Jeringas',
      'se-busca-props-medicos-vintage-estetoscopios-frascos-sanatorio',
      decoracion, null,
      [
        'Estetoscopios antiguos (cualquier estado)',
        'Lámparas de examen médico vintage (con brazo articulado)',
        'Frascos de farmacia con etiquetas viejas o esmeriladas',
        'Jeringas de vidrio antiguas, bisturíes, instrumental oxidado',
        'Compramos por pieza o por lote — evaluamos colecciones completas',
      ],
      'Foto general del lote + 2-3 piezas hero en detalle'
    ),
    busco(
      'SE BUSCA: Letreros / Carteles Vintage Médicos y Hospitalarios — El Sanatorio',
      'se-busca-letreros-carteles-vintage-medicos-sanatorio',
      decoracion, null,
      [
        'Carteles esmaltados antiguos: "Farmacia", "Consultorio", "Sala de Espera", "Rayos X", etc.',
        'En español o inglés. Esmaltado, lata, madera pintada',
        'Patina y óxido = bienvenidos',
        'Compramos por pieza — pago según rareza/estado',
      ],
      'Letrero completo de frente con buena luz natural'
    ),
    busco(
      'SE BUSCA: Cuadros y Decoración Vintage Hospitalaria — El Sanatorio',
      'se-busca-cuadros-decoracion-vintage-hospitalaria-sanatorio',
      decoracion, null,
      [
        'Cuadros de anatomía antiguos (litografías médicas, ilustraciones del cuerpo humano)',
        'Marcos de madera o latón patinados',
        'Espejos antiguos con marco hospitalario / clínico',
        'Cualquier dressing que evoque clínica de los 40-60',
      ],
      'Cuadro completo enmarcado + detalle del marco'
    ),
    busco(
      'SE BUSCA: Sillas Estilo Médico / Sala de Espera Antiguas — El Sanatorio',
      'se-busca-sillas-medico-sala-espera-antiguas-sanatorio',
      muebles, null,
      [
        'Sillas de sala de espera vintage: madera curvada, vinilo viejo, metal cromado',
        'Compramos por unidad o por juegos de 4-6',
        'Estilo años 50-70, idealmente desparejadas (mejor)',
        'Pago por estado/estilo — envíanos foto + precio',
      ],
      'Silla completa de 3/4 + foto del juego si vienen en lote'
    ),
  ];

  console.log(`Inserting ${listings.length} BUSCO listings...`);
  const { data, error } = await supabase.from('listings').insert(listings).select('id,slug,title');
  if (error) {
    console.error('Insert failed:', error);
    process.exit(2);
  }
  for (const row of data) console.log(`OK ${row.slug}`);
  console.log(`\nDone. ${data.length} listings live at https://lleva-lleva.com/buscar?q=sanatorio`);
}

main().catch(e => { console.error(e); process.exit(1); });

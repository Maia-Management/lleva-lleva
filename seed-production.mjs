/**
 * LlevaLleva — Production Seed Script (v2)
 * Applies migrations 005–013 via the Supabase REST & Auth Admin APIs.
 * Run from the project root: node seed-production.mjs
 */

import { createClient } from '@supabase/supabase-js';
import { readFileSync } from 'fs';

const SUPABASE_URL = 'https://tweuhyqajcnzsqelbtwt.supabase.co';
const SERVICE_KEY  = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SERVICE_KEY) {
  console.error('ERROR: SUPABASE_SERVICE_ROLE_KEY environment variable is not set.');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SERVICE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false }
});

const NOW = new Date().toISOString();

// ─────────────────────────────────────────────────────────────
// Category slug mapping: migration slugs → production slugs
// ─────────────────────────────────────────────────────────────
const CAT_SLUG_MAP = {
  'ofertas-empleo':  'ofertas-de-empleo',
  'equipos-oficina': 'equipos-de-oficina',
  'tv-audio':        'audio-y-video',
  'materiales':      'insumos-industriales',
  'construccion':    'reparaciones',
  'juridico':        'tramites-y-documentos',
  'financiero':      'profesionales',
  'diseno':          'freelance',
  'otros-servicios': 'profesionales',
  'talleres':        'cursos-y-talleres',
  'lotes':           'lotes-y-terrenos',
  'bodegas':         'locales-comerciales',
  'locales':         'locales-comerciales',
  'eventos-locales': 'eventos',
  'varios':          'donaciones',
  'servicios-tech':  'profesionales',
  'servicios-marinos': 'accesorios-nauticos',
  'motores-marinos': 'equipos-de-pesca',
  'lanchas':         'embarcaciones',
  'yates':           'embarcaciones',
  'cursos-online':   'cursos-y-talleres',
  'fincas-descanso': 'alquiler-vacacional',
  'juridico':        'tramites-y-documentos',
  'servicios_fin':   'profesionales',
};

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────

// Use direct fetch for user creation with custom UUIDs
// (supabase-js SDK doesn't support specifying user ID)
async function adminCreateUser(id, email, appMeta = {}) {
  const resp = await fetch(`${SUPABASE_URL}/auth/v1/admin/users`, {
    method: 'POST',
    headers: {
      'apikey': SERVICE_KEY,
      'Authorization': `Bearer ${SERVICE_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      id,
      email,
      email_confirm: true,
      app_metadata: { provider: 'email', providers: ['email'], ...appMeta },
    }),
  });
  const data = await resp.json();
  if (data.id === id) {
    console.log(`  ✓ ${email}`);
  } else if (resp.status === 422 || (data.msg || '').includes('already been registered')) {
    console.log(`  ⏭  exists: ${email}`);
  } else {
    console.error(`  ✗ ${email}: ${JSON.stringify(data).slice(0,120)}`);
  }
}

async function upsert(table, rows, onConflict = 'id') {
  if (!rows.length) return;
  const { error } = await supabase.from(table).upsert(rows, {
    onConflict,
    ignoreDuplicates: true,
  });
  if (error) {
    console.error(`  ✗ upsert ${table}: ${error.message}`);
    if (error.details) console.error(`    ${error.details.slice(0,200)}`);
  } else {
    console.log(`  ✓ ${rows.length} rows → ${table}`);
  }
}

// ─────────────────────────────────────────────────────────────
// Pre-fetch category & location ID maps
// ─────────────────────────────────────────────────────────────

async function fetchMaps() {
  const { data: cats } = await supabase.from('categories').select('id,slug');
  const { data: locs } = await supabase.from('locations').select('id,slug');
  const rawCatMap = Object.fromEntries((cats || []).map(r => [r.slug, r.id]));
  const locMap    = Object.fromEntries((locs || []).map(r => [r.slug, r.id]));

  // Build catMap with migration-slug aliases resolved
  const catMap = { ...rawCatMap };
  for (const [migSlug, prodSlug] of Object.entries(CAT_SLUG_MAP)) {
    if (rawCatMap[prodSlug] && !catMap[migSlug]) {
      catMap[migSlug] = rawCatMap[prodSlug];
    }
  }
  return { catMap, locMap };
}

// ─────────────────────────────────────────────────────────────
// Migration 005 — New locations (only columns that exist)
// ─────────────────────────────────────────────────────────────

const LOCATIONS_005 = [
  { department: 'Atlántico',              city: 'Puerto Colombia',         slug: 'puerto-colombia',          is_active: true },
  { department: 'Atlántico',              city: 'Galapa',                  slug: 'galapa',                   is_active: true },
  { department: 'Atlántico',              city: 'Baranoa',                 slug: 'baranoa',                  is_active: true },
  { department: 'Atlántico',              city: 'Sabanalarga',             slug: 'sabanalarga',              is_active: true },
  { department: 'Magdalena',              city: 'Ciénaga',                 slug: 'cienaga',                  is_active: true },
  { department: 'Magdalena',              city: 'El Banco',                slug: 'el-banco',                 is_active: true },
  { department: 'Bolívar',                city: 'Magangué',                slug: 'magangue',                 is_active: true },
  { department: 'Bolívar',                city: 'Mompox',                  slug: 'mompox',                   is_active: true },
  { department: 'Córdoba',                city: 'Lorica',                  slug: 'lorica',                   is_active: true },
  { department: 'Córdoba',                city: 'Sahagún',                 slug: 'sahagun',                  is_active: true },
  { department: 'Córdoba',                city: 'Planeta Rica',            slug: 'planeta-rica',             is_active: true },
  { department: 'Sucre',                  city: 'Corozal',                 slug: 'corozal',                  is_active: true },
  { department: 'Sucre',                  city: 'San Marcos',              slug: 'san-marcos',               is_active: true },
  { department: 'La Guajira',             city: 'Maicao',                  slug: 'maicao',                   is_active: true },
  { department: 'La Guajira',             city: 'Uribia',                  slug: 'uribia',                   is_active: true },
  { department: 'César',                  city: 'Aguachica',               slug: 'aguachica',                is_active: true },
  { department: 'César',                  city: 'Bosconia',                slug: 'bosconia',                 is_active: true },
  { department: 'Norte de Santander',     city: 'Ocaña',                   slug: 'ocana',                    is_active: true },
  { department: 'Norte de Santander',     city: 'Pamplona',                slug: 'pamplona',                 is_active: true },
  { department: 'Santander',              city: 'Barrancabermeja',         slug: 'barrancabermeja',          is_active: true },
  { department: 'Santander',              city: 'Floridablanca',           slug: 'floridablanca',            is_active: true },
  { department: 'Santander',              city: 'Girón',                   slug: 'giron',                    is_active: true },
  { department: 'Santander',              city: 'Piedecuesta',             slug: 'piedecuesta',              is_active: true },
  { department: 'Santander',              city: 'Socorro',                 slug: 'socorro',                  is_active: true },
  { department: 'Boyacá',                 city: 'Tunja',                   slug: 'tunja',                    is_active: true },
  { department: 'Boyacá',                 city: 'Duitama',                 slug: 'duitama',                  is_active: true },
  { department: 'Boyacá',                 city: 'Sogamoso',                slug: 'sogamoso',                 is_active: true },
  { department: 'Cundinamarca',           city: 'Soacha',                  slug: 'soacha',                   is_active: true },
  { department: 'Cundinamarca',           city: 'Chía',                    slug: 'chia',                     is_active: true },
  { department: 'Cundinamarca',           city: 'Zipaquirá',               slug: 'zipaquira',                is_active: true },
  { department: 'Cundinamarca',           city: 'Facatativá',              slug: 'facatativa',               is_active: true },
  { department: 'Cundinamarca',           city: 'Mosquera',                slug: 'mosquera',                 is_active: true },
  { department: 'Cundinamarca',           city: 'Fusagasugá',              slug: 'fusagasuga',               is_active: true },
  { department: 'Antioquia',              city: 'Rionegro',                slug: 'rionegro',                 is_active: true },
  { department: 'Antioquia',              city: 'Apartadó',                slug: 'apartado',                 is_active: true },
  { department: 'Antioquia',              city: 'Turbo',                   slug: 'turbo',                    is_active: true },
  { department: 'Antioquia',              city: 'Caucasia',                slug: 'caucasia',                 is_active: true },
  { department: 'Antioquia',              city: 'Itagüí',                  slug: 'itagui',                   is_active: true },
  { department: 'Antioquia',              city: 'Sabaneta',                slug: 'sabaneta',                 is_active: true },
  { department: 'Valle del Cauca',        city: 'Buenaventura',            slug: 'buenaventura',             is_active: true },
  { department: 'Valle del Cauca',        city: 'Palmira',                 slug: 'palmira',                  is_active: true },
  { department: 'Valle del Cauca',        city: 'Tulua',                   slug: 'tulua',                    is_active: true },
  { department: 'Valle del Cauca',        city: 'Cartago',                 slug: 'cartago',                  is_active: true },
  { department: 'Cauca',                  city: 'Santander de Quilichao',  slug: 'santander-de-quilichao',   is_active: true },
  { department: 'Nariño',                 city: 'Tumaco',                  slug: 'tumaco',                   is_active: true },
  { department: 'Nariño',                 city: 'Ipiales',                 slug: 'ipiales',                  is_active: true },
  { department: 'Putumayo',               city: 'Mocoa',                   slug: 'mocoa',                    is_active: true },
  { department: 'Putumayo',               city: 'Puerto Asís',             slug: 'puerto-asis',              is_active: true },
  { department: 'Amazonas',               city: 'Leticia',                 slug: 'leticia',                  is_active: true },
  { department: 'Meta',                   city: 'Granada',                 slug: 'granada',                  is_active: true },
  { department: 'Meta',                   city: 'Puerto López',            slug: 'puerto-lopez',             is_active: true },
  { department: 'Casanare',               city: 'Yopal',                   slug: 'yopal',                    is_active: true },
  { department: 'Casanare',               city: 'Aguazul',                 slug: 'aguazul',                  is_active: true },
  { department: 'Arauca',                 city: 'Arauca',                  slug: 'arauca',                   is_active: true },
  { department: 'Vichada',                city: 'Puerto Carreño',          slug: 'puerto-carreno',           is_active: true },
  { department: 'Guainía',                city: 'Inírida',                 slug: 'inirida',                  is_active: true },
  { department: 'Chocó',                  city: 'Quibdó',                  slug: 'quibdo',                   is_active: true },
  { department: 'Huila',                  city: 'Pitalito',                slug: 'pitalito',                 is_active: true },
  { department: 'Huila',                  city: 'Garzón',                  slug: 'garzon',                   is_active: true },
  { department: 'Tolima',                 city: 'Espinal',                 slug: 'espinal',                  is_active: true },
  { department: 'Tolima',                 city: 'Honda',                   slug: 'honda',                    is_active: true },
  { department: 'Caldas',                 city: 'Chinchiná',               slug: 'chinchina',                is_active: true },
  { department: 'Risaralda',              city: 'Dosquebradas',            slug: 'dosquebradas',             is_active: true },
  { department: 'Quindío',                city: 'Calarcá',                 slug: 'calarca',                  is_active: true },
];

// ─────────────────────────────────────────────────────────────
// Migration 007 — Bot accounts (public services)
// ─────────────────────────────────────────────────────────────

const BOT_USERS_007 = [
  ['00000000-0000-4000-b000-000000000001','bot.metroagua-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000002','bot.aire-caribe-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000003','bot.surtigas-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000004','bot.etb-avisos-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000005','bot.claro-avisos-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000006','bot.movistar-avisos-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000007','bot.tigo-avisos-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000008','bot.alcaldia-santa-marta@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000009','bot.transito-santa-marta@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000010','bot.salud-distrital-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000011','bot.educacion-distrital-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000012','bot.planeacion-distrital-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000013','bot.curaduria-urbana-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000014','bot.dadsa-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000015','bot.sec-gobierno-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000016','bot.inspecciones-policia-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000017','bot.catastro-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000018','bot.gobernacion-magdalena@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000019','bot.infraestructura-magdalena@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000020','bot.policia-santa-marta@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000021','bot.bomberos-santa-marta@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000022','bot.defensa-civil-magdalena@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000023','bot.ungrd-alertas@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000024','bot.cruz-roja-magdalena@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000025','bot.dian-santa-marta@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000026','bot.migracion-santa-marta@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000027','bot.registraduria-santa-marta@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000028','bot.sena-magdalena@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000029','bot.icbf-magdalena@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000030','bot.rama-judicial-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000031','bot.notarias-santa-marta@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000032','bot.sic-alertas@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000033','bot.mintrabajo-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000034','bot.hospital-central-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000035','bot.ese-reverend-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000036','bot.ins-alertas-regionales@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000037','bot.aeropuerto-simon-bolivar@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000038','bot.terminal-transportes-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000039','bot.invias-magdalena@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000040','bot.ani-viales-caribe@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000041','bot.ideam-santa-marta@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000042','bot.dimar-capuerto-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000043','bot.parques-tayrona@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000044','bot.parques-sierra-nevada@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000045','bot.corpamag-alertas@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000046','bot.invemar-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000047','bot.unimagdalena@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000048','bot.unad-zona-caribe@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000049','bot.camara-comercio-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000050','bot.banrep-santa-marta@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000051','bot.fenalco-magdalena@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000052','bot.procolombia-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000053','bot.sec-cultura-sm@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000054','bot.festival-vallenato@internal.lleva-lleva.com'],
  ['00000000-0000-4000-b000-000000000055','bot.icanh-caribe@internal.lleva-lleva.com'],
];

const PROFILES_007 = [
  { id:'00000000-0000-4000-b000-000000000001', username:'metroagua-sm',              display_name:'Metroagua Santa Marta',                                   user_type:'bot', bio:'Avisos oficiales de cortes programados, mantenimiento de redes y alertas de suministro de agua potable y alcantarillado en Santa Marta.',                                                                                                                                                         city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000002', username:'aire-caribe-sm',             display_name:'Air-e (Electricaribe) — Santa Marta',                      user_type:'bot', bio:'Notificaciones oficiales de cortes de energía, apagones programados y mantenimiento de redes eléctricas en Santa Marta y la Costa Caribe.',                                                                                                                                                  city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000003', username:'surtigas-sm',                display_name:'Surtigas — Avisos de Gas',                                  user_type:'bot', bio:'Alertas de cortes de suministro de gas natural, fugas, revisiones de redes y trabajos de mantenimiento en Santa Marta y la región Caribe.',                                                                                                                                                 city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000004', username:'etb-avisos-sm',              display_name:'ETB — Avisos de Red',                                       user_type:'bot', bio:'Notificaciones de interrupciones y mantenimiento de servicios de telecomunicaciones ETB (internet, telefonía fija) en Santa Marta.',                                                                                                                                                          city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000005', username:'claro-avisos-sm',            display_name:'Claro — Avisos de Red',                                     user_type:'bot', bio:'Alertas de interrupciones y trabajos de mantenimiento de la red Claro (internet, telefonía móvil y fija) en Santa Marta y Magdalena.',                                                                                                                                                    city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000006', username:'movistar-avisos-sm',         display_name:'Movistar — Avisos de Red',                                  user_type:'bot', bio:'Avisos de interrupciones y trabajos de mantenimiento en la red Movistar (móvil e internet) en Santa Marta y Magdalena.',                                                                                                                                                                 city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000007', username:'tigo-avisos-sm',             display_name:'Tigo — Avisos de Red',                                      user_type:'bot', bio:'Notificaciones de cortes y mantenimiento de servicios Tigo (móvil, internet, cable) en Santa Marta y la región Caribe.',                                                                                                                                                                city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000008', username:'alcaldia-santa-marta',       display_name:'Alcaldía Distrital de Santa Marta',                         user_type:'bot', bio:'Canal oficial de la Alcaldía de Santa Marta. Decretos, pico y placa, restricciones de movilidad, cierres viales y avisos de interés ciudadano.',                                                                                                                                     city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000009', username:'transito-santa-marta',       display_name:'Secretaría de Tránsito y Transporte — SM',                  user_type:'bot', bio:'Pico y placa, cierres viales, restricciones de tránsito, operativos y novedades de movilidad en Santa Marta.',                                                                                                                                                                        city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000010', username:'salud-distrital-sm',         display_name:'Secretaría de Salud Distrital — SM',                        user_type:'bot', bio:'Jornadas de vacunación, alertas epidemiológicas, campañas de salud pública y comunicados oficiales de la Secretaría de Salud de Santa Marta.',                                                                                                                                      city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000011', username:'educacion-distrital-sm',     display_name:'Secretaría de Educación Distrital — SM',                    user_type:'bot', bio:'Calendarios escolares, suspensión de clases, fechas de matrícula, eventos educativos y comunicados del sector educativo oficial de Santa Marta.',                                                                                                                                   city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000012', username:'planeacion-distrital-sm',    display_name:'Secretaría de Planeación Distrital — SM',                   user_type:'bot', bio:'Actualizaciones del POT, licencias urbanísticas, planes de ordenamiento territorial y avisos de planificación en Santa Marta.',                                                                                                                                                     city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000013', username:'curaduria-urbana-sm',        display_name:'Curaduría Urbana No. 1 — Santa Marta',                      user_type:'bot', bio:'Información sobre licencias de construcción, permisos urbanísticos, trámites constructivos y resoluciones ante la Curaduría Urbana de Santa Marta.',                                                                                                                                city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000014', username:'dadsa-sm',                   display_name:'DADSA — Aseo Urbano Santa Marta',                           user_type:'bot', bio:'Avisos de recolección de basuras, horarios de aseo urbano, jornadas de reciclaje, operativos de limpieza y suspensiones del servicio en Santa Marta.',                                                                                                                               city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000015', username:'sec-gobierno-sm',            display_name:'Secretaría de Gobierno Distrital — SM',                     user_type:'bot', bio:'Convivencia ciudadana, permisos para eventos, restricciones nocturnas, ley seca y avisos de orden público en Santa Marta.',                                                                                                                                                           city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000016', username:'inspecciones-policia-sm',    display_name:'Inspecciones de Policía — Santa Marta',                     user_type:'bot', bio:'Avisos de querellas, mediaciones comunitarias, infractores del Código de Policía y citaciones de las Inspecciones de Santa Marta.',                                                                                                                                                  city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000017', username:'catastro-sm',                display_name:'Catastro Distrital Santa Marta',                            user_type:'bot', bio:'Fechas de pago del impuesto predial, actualización de avalúos catastrales, trámites y descuentos por pronto pago en Santa Marta.',                                                                                                                                                    city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000018', username:'gobernacion-magdalena',      display_name:'Gobernación del Magdalena',                                 user_type:'bot', bio:'Decretos departamentales, declaratorias de emergencia, programas sociales y avisos oficiales del Gobierno del departamento del Magdalena.',                                                                                                                                           city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000019', username:'infraestructura-magdalena',  display_name:'Secretaría de Infraestructura del Magdalena',               user_type:'bot', bio:'Cierres de vías departamentales, derrumbes, obras públicas, estado de carreteras y mantenimiento vial en el departamento del Magdalena.',                                                                                                                                           city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000020', username:'policia-santa-marta',        display_name:'Policía Nacional — Estación Santa Marta',                   user_type:'bot', bio:'Alertas de seguridad, operativos policiales, requisitorias, zonas de alto riesgo y comunicados de la Policía Nacional en Santa Marta.',                                                                                                                                          city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000021', username:'bomberos-santa-marta',       display_name:'Cuerpo de Bomberos de Santa Marta',                         user_type:'bot', bio:'Alertas de incendios, emergencias estructurales, recomendaciones de prevención y actividad operativa del Cuerpo de Bomberos de Santa Marta.',                                                                                                                                       city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000022', username:'defensa-civil-magdalena',    display_name:'Defensa Civil — Seccional Magdalena',                       user_type:'bot', bio:'Alertas por lluvias, inundaciones, deslizamientos, temporadas de huracanes y emergencias naturales en el departamento del Magdalena.',                                                                                                                                               city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000023', username:'ungrd-alertas',              display_name:'UNGRD — Gestión del Riesgo Nacional',                       user_type:'bot', bio:'Alertas nacionales por temporada de lluvias, fenómenos naturales, emergencias y recomendaciones de gestión del riesgo con impacto en el Caribe.',                                                                                                                                  city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000024', username:'cruz-roja-magdalena',        display_name:'Cruz Roja Colombiana — Magdalena',                          user_type:'bot', bio:'Emergencias humanitarias, jornadas de donación de sangre, primeros auxilios, atención en desastres y actividades de la Cruz Roja en Magdalena.',                                                                                                                                  city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000025', username:'dian-santa-marta',           display_name:'DIAN — Seccional Santa Marta',                              user_type:'bot', bio:'Fechas de vencimiento tributario, operativos de control fiscal, obligaciones formales y avisos de la DIAN en Santa Marta.',                                                                                                                                                      city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000026', username:'migracion-santa-marta',      display_name:'Migración Colombia — Santa Marta',                          user_type:'bot', bio:'Trámites de visas, renovaciones de cédula de extranjería, control migratorio, salvoconductos y avisos de Migración Colombia en Santa Marta.',                                                                                                                                   city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000027', username:'registraduria-santa-marta',  display_name:'Registraduría Nacional — Santa Marta',                      user_type:'bot', bio:'Fechas electorales, jornadas de cedulación, inscripción en el censo electoral, puestos de votación y avisos de la Registraduría en Santa Marta.',                                                                                                                               city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000028', username:'sena-magdalena',             display_name:'SENA — Regional Magdalena',                                 user_type:'bot', bio:'Oferta de cursos gratuitos, convocatorias de formación técnica y tecnológica, fechas de inscripción y programas del SENA en el Magdalena.',                                                                                                                                     city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000029', username:'icbf-magdalena',             display_name:'ICBF — Regional Magdalena',                                 user_type:'bot', bio:'Programas de protección infantil, primera infancia, nutrición, adopciones, convocatorias y servicios del ICBF en el departamento del Magdalena.',                                                                                                                                city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000030', username:'rama-judicial-sm',           display_name:'Rama Judicial — Juzgados Santa Marta',                      user_type:'bot', bio:'Suspensión de términos judiciales, fechas de audiencias, cierres de despachos judiciales y avisos de la Rama Judicial en Santa Marta.',                                                                                                                                        city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000031', username:'notarias-santa-marta',       display_name:'Notarías de Santa Marta (1ª, 2ª y 3ª)',                     user_type:'bot', bio:'Horarios de atención, tarifas notariales, servicios disponibles y avisos de las Notarías Primera, Segunda y Tercera de Santa Marta.',                                                                                                                                          city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000032', username:'sic-alertas',                display_name:'Superintendencia de Industria y Comercio',                  user_type:'bot', bio:'Alertas de productos peligrosos, retiros del mercado, derechos del consumidor, sanciones a empresas y avisos de la SIC a nivel nacional.',                                                                                                                                      city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000033', username:'mintrabajo-sm',              display_name:'Ministerio de Trabajo — Inspección SM',                     user_type:'bot', bio:'Operativos laborales, derechos de los trabajadores, inspecciones de trabajo, multas a empleadores y avisos del Ministerio de Trabajo en Santa Marta.',                                                                                                                          city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000034', username:'hospital-central-sm',        display_name:'Hospital Central Julio Méndez Barreneche',                  user_type:'bot', bio:'Avisos de urgencias, jornadas de salud gratuitas, servicios habilitados, suspensiones y comunicados del Hospital Central de Santa Marta.',                                                                                                                                     city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000035', username:'ese-reverend-sm',            display_name:'ESE Alejandro Próspero Reverend',                           user_type:'bot', bio:'Citas médicas, programas de salud preventiva, jornadas comunitarias y servicios de la ESE Alejandro Próspero Reverend en Santa Marta.',                                                                                                                                        city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000036', username:'ins-alertas-regionales',     display_name:'Instituto Nacional de Salud — Alertas Regionales',          user_type:'bot', bio:'Alertas epidemiológicas regionales, brotes de enfermedades, vigilancia en salud pública e informes del INS para la Costa Caribe colombiana.',                                                                                                                                  city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000037', username:'aeropuerto-simon-bolivar',   display_name:'Aeropuerto Internacional Simón Bolívar',                    user_type:'bot', bio:'Estado de vuelos, cierres temporales de pista, obras en el aeropuerto y alertas operativas del Aeropuerto Internacional Simón Bolívar de Santa Marta.',                                                                                                                        city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000038', username:'terminal-transportes-sm',    display_name:'Terminal de Transportes de Santa Marta',                    user_type:'bot', bio:'Información de rutas interdepartamentales, bloqueos de vías, paros de transportadores y novedades operativas de la Terminal de Santa Marta.',                                                                                                                                  city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000039', username:'invias-magdalena',           display_name:'INVÍAS — Unidad de Mantenimiento Magdalena',                user_type:'bot', bio:'Cierres de vías nacionales, derrumbes, obras de mantenimiento vial y estado de carreteras a cargo de INVÍAS en el departamento del Magdalena.',                                                                                                                               city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000040', username:'ani-viales-caribe',          display_name:'ANI — Concesiones Viales Caribe',                           user_type:'bot', bio:'Avances de obras viales en concesión, estado de peajes, restricciones de tránsito y novedades de las vías concesionadas en el Caribe colombiano.',                                                                                                                          city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000041', username:'ideam-santa-marta',          display_name:'IDEAM — Estación Santa Marta',                              user_type:'bot', bio:'Pronóstico del tiempo, alertas de lluvia, nivel del mar, estado del oleaje, fenómenos meteorológicos y temporadas de huracanes en Santa Marta y el Caribe.',                                                                                                                  city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000042', username:'dimar-capuerto-sm',          display_name:'DIMAR — Capitanía de Puerto Santa Marta',                   user_type:'bot', bio:'Estado del mar, restricciones de navegación, alertas para embarcaciones, zarpes y avisos de la Capitanía de Puerto de Santa Marta.',                                                                                                                                         city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000043', username:'parques-tayrona',            display_name:'Parques Nacionales — Tayrona',                              user_type:'bot', bio:'Apertura y cierre del Parque Nacional Natural Tayrona, disponibilidad de cupos, vedas temporales y avisos para visitantes y campistas.',                                                                                                                                       city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000044', username:'parques-sierra-nevada',      display_name:'Parques Nacionales — Sierra Nevada de SM',                  user_type:'bot', bio:'Acceso al PNN Sierra Nevada de Santa Marta, permisos especiales de comunidades indígenas, alertas por incendios forestales y restricciones de ingreso.',                                                                                                                    city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000045', username:'corpamag-alertas',           display_name:'CORPAMAG — Alertas Ambientales',                            user_type:'bot', bio:'Alertas ambientales, contaminación de playas, calidad del aire, vertimientos ilegales y avisos de la Corporación Autónoma Regional del Magdalena.',                                                                                                                          city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000046', username:'invemar-sm',                 display_name:'INVEMAR — Calidad del Agua en Playas',                      user_type:'bot', bio:'Reportes de calidad del agua en playas de Santa Marta, alertas de contaminación marina, índices de bañabilidad y monitoreo costero del INVEMAR.',                                                                                                                             city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000047', username:'unimagdalena',               display_name:'Universidad del Magdalena — UniMagdalena',                  user_type:'bot', bio:'Eventos académicos, fechas de inscripción y matrícula, calendarios universitarios, convocatorias de investigación y noticias de la UniMagdalena.',                                                                                                                             city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000048', username:'unad-zona-caribe',           display_name:'UNAD — Zona Caribe',                                        user_type:'bot', bio:'Inscripciones, cursos virtuales gratuitos, matrículas y novedades académicas de la Universidad Nacional Abierta y a Distancia en la Zona Caribe.',                                                                                                                            city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000049', username:'camara-comercio-sm',         display_name:'Cámara de Comercio de Santa Marta',                         user_type:'bot', bio:'Matrícula mercantil, registro de empresas, renovaciones, eventos empresariales, capacitaciones y servicios de la Cámara de Comercio de Santa Marta.',                                                                                                                        city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000050', username:'banrep-santa-marta',         display_name:'Banco de la República — Santa Marta',                       user_type:'bot', bio:'TRM del día, tasas de interés, indicadores económicos, agenda cultural del Banrepcultural y servicios del Banco de la República en Santa Marta.',                                                                                                                            city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000051', username:'fenalco-magdalena',          display_name:'Fenalco Magdalena',                                         user_type:'bot', bio:'Derechos del consumidor, gremio del comercio, eventos empresariales, alertas de prácticas irregulares y capacitaciones de Fenalco en Magdalena.',                                                                                                                              city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000052', username:'procolombia-sm',             display_name:'ProColombia — Turismo Santa Marta',                         user_type:'bot', bio:'Temporadas turísticas, eventos de turismo nacional e internacional, promoción del destino Santa Marta y Magdalena, y novedades del sector turístico.',                                                                                                                        city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000053', username:'sec-cultura-sm',             display_name:'Secretaría de Cultura Distrital — SM',                      user_type:'bot', bio:'Eventos culturales, festivales locales, patrimonio histórico, programación artística, convocatorias y agendas de la Secretaría de Cultura de Santa Marta.',                                                                                                                   city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000054', username:'festival-vallenato',         display_name:'Festival de la Leyenda Vallenata',                          user_type:'bot', bio:'Fechas del festival, inscripción de concursantes, programación musical, convocatorias artísticas y noticias de la Fundación Festival de la Leyenda Vallenata.',                                                                                                               city:'Valledupar',  department:'Cesar',     is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'00000000-0000-4000-b000-000000000055', username:'icanh-caribe',               display_name:'ICANH — Antropología e Historia Caribe',                    user_type:'bot', bio:'Patrimonio arqueológico, investigaciones históricas, restricciones en sitios arqueológicos y avisos del Instituto Colombiano de Antropología e Historia en el Caribe.',                                                                                                       city:'Santa Marta', department:'Magdalena', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
];

const BOT_ACCOUNTS_007 = [
  { id:'00000000-0000-4000-b000-000000000001', bot_name:'Metroagua Santa Marta',                    data_category:'servicios_publicos',     source_url:'https://www.metroagua.com.co',             is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000002', bot_name:'Air-e (Electricaribe) Santa Marta',        data_category:'servicios_publicos',     source_url:'https://www.aire.com.co',                  is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000003', bot_name:'Surtigas Avisos de Gas',                   data_category:'servicios_publicos',     source_url:'https://www.surtigas.com.co',              is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000004', bot_name:'ETB Avisos de Red',                        data_category:'telecomunicaciones',     source_url:'https://www.etb.com.co',                   is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000005', bot_name:'Claro Avisos de Red',                      data_category:'telecomunicaciones',     source_url:'https://www.claro.com.co',                 is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000006', bot_name:'Movistar Avisos de Red',                   data_category:'telecomunicaciones',     source_url:'https://www.movistar.co',                  is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000007', bot_name:'Tigo Avisos de Red',                       data_category:'telecomunicaciones',     source_url:'https://www.tigo.com.co',                  is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000008', bot_name:'Alcaldía Distrital de Santa Marta',        data_category:'gobierno_distrital',     source_url:'https://www.santamarta.gov.co',            is_active:true, post_interval_hours:6,  created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000009', bot_name:'Secretaría de Tránsito SM',                data_category:'transito',               source_url:'https://www.santamarta.gov.co/transito',  is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000010', bot_name:'Secretaría de Salud Distrital SM',         data_category:'salud',                  source_url:'https://www.santamarta.gov.co/salud',     is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000011', bot_name:'Secretaría de Educación Distrital',        data_category:'educacion',              source_url:'https://www.santamarta.gov.co/educacion', is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000012', bot_name:'Secretaría de Planeación Distrital',       data_category:'gobierno_distrital',     source_url:'https://www.santamarta.gov.co/planeacion', is_active:true, post_interval_hours:48, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000013', bot_name:'Curaduría Urbana No. 1 Santa Marta',       data_category:'gobierno_distrital',     source_url:null,                                       is_active:true, post_interval_hours:48, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000014', bot_name:'DADSA Aseo Urbano Santa Marta',            data_category:'gobierno_distrital',     source_url:'https://www.santamarta.gov.co/dadsa',     is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000015', bot_name:'Secretaría de Gobierno Distrital SM',      data_category:'gobierno_distrital',     source_url:'https://www.santamarta.gov.co/gobierno',  is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000016', bot_name:'Inspecciones de Policía SM',               data_category:'gobierno_distrital',     source_url:null,                                       is_active:true, post_interval_hours:48, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000017', bot_name:'Catastro Distrital Santa Marta',           data_category:'catastro',               source_url:'https://www.santamarta.gov.co/catastro',  is_active:true, post_interval_hours:168,created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000018', bot_name:'Gobernación del Magdalena',                data_category:'gobierno_departamental', source_url:'https://www.magdalena.gov.co',             is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000019', bot_name:'Secretaría de Infraestructura Magdalena',  data_category:'gobierno_departamental', source_url:'https://www.magdalena.gov.co/infraestructura', is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000020', bot_name:'Policía Nacional Santa Marta',             data_category:'seguridad',              source_url:'https://www.policia.gov.co',               is_active:true, post_interval_hours:6,  created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000021', bot_name:'Cuerpo de Bomberos Santa Marta',           data_category:'emergencias',            source_url:null,                                       is_active:true, post_interval_hours:6,  created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000022', bot_name:'Defensa Civil Magdalena',                  data_category:'emergencias',            source_url:'https://www.defensacivil.gov.co',          is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000023', bot_name:'UNGRD Alertas',                            data_category:'emergencias',            source_url:'https://www.gestiondelriesgo.gov.co',     is_active:true, post_interval_hours:6,  created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000024', bot_name:'Cruz Roja Colombiana Magdalena',           data_category:'emergencias',            source_url:'https://www.cruzrojacolombiana.org',       is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000025', bot_name:'DIAN Santa Marta',                         data_category:'tributario',             source_url:'https://www.dian.gov.co',                  is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000026', bot_name:'Migración Colombia Santa Marta',           data_category:'migracion',              source_url:'https://www.migracioncolombia.gov.co',    is_active:true, post_interval_hours:48, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000027', bot_name:'Registraduría Nacional Santa Marta',       data_category:'registraduria',          source_url:'https://www.registraduria.gov.co',         is_active:true, post_interval_hours:168,created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000028', bot_name:'SENA Regional Magdalena',                  data_category:'educacion',              source_url:'https://www.sena.edu.co',                  is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000029', bot_name:'ICBF Regional Magdalena',                  data_category:'bienestar_social',       source_url:'https://www.icbf.gov.co',                  is_active:true, post_interval_hours:48, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000030', bot_name:'Rama Judicial Juzgados Santa Marta',       data_category:'judicial',               source_url:'https://www.ramajudicial.gov.co',          is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000031', bot_name:'Notarías de Santa Marta',                  data_category:'notarial',               source_url:null,                                       is_active:true, post_interval_hours:168,created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000032', bot_name:'Superintendencia de Industria y Comercio', data_category:'consumidor',             source_url:'https://www.sic.gov.co',                   is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000033', bot_name:'Ministerio de Trabajo Inspección SM',      data_category:'laboral',                source_url:'https://www.mintrabajo.gov.co',            is_active:true, post_interval_hours:48, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000034', bot_name:'Hospital Central Julio Méndez Barreneche', data_category:'salud',                  source_url:'https://www.hcsm.gov.co',                  is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000035', bot_name:'ESE Alejandro Próspero Reverend',          data_category:'salud',                  source_url:null,                                       is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000036', bot_name:'Instituto Nacional de Salud Alertas',      data_category:'salud',                  source_url:'https://www.ins.gov.co',                   is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000037', bot_name:'Aeropuerto Simón Bolívar Santa Marta',     data_category:'transporte',             source_url:'https://www.aerocivil.gov.co',             is_active:true, post_interval_hours:6,  created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000038', bot_name:'Terminal de Transportes Santa Marta',      data_category:'transporte',             source_url:null,                                       is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000039', bot_name:'INVÍAS Magdalena',                         data_category:'vias',                   source_url:'https://www.invias.gov.co',                is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000040', bot_name:'ANI Concesiones Viales Caribe',            data_category:'vias',                   source_url:'https://www.ani.gov.co',                   is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000041', bot_name:'IDEAM Estación Santa Marta',               data_category:'medio_ambiente',         source_url:'https://www.ideam.gov.co',                 is_active:true, post_interval_hours:6,  created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000042', bot_name:'DIMAR Capitanía de Puerto Santa Marta',    data_category:'maritimo',               source_url:'https://www.dimar.mil.co',                 is_active:true, post_interval_hours:6,  created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000043', bot_name:'Parques Nacionales Tayrona',               data_category:'parques_naturales',      source_url:'https://www.parquesnacionales.gov.co',    is_active:true, post_interval_hours:12, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000044', bot_name:'Parques Nacionales Sierra Nevada SM',      data_category:'parques_naturales',      source_url:'https://www.parquesnacionales.gov.co',    is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000045', bot_name:'CORPAMAG Alertas Ambientales',             data_category:'medio_ambiente',         source_url:'https://www.corpamag.gov.co',              is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000046', bot_name:'INVEMAR Calidad del Agua',                 data_category:'medio_ambiente',         source_url:'https://www.invemar.org.co',               is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000047', bot_name:'Universidad del Magdalena',                data_category:'educacion_superior',     source_url:'https://www.unimagdalena.edu.co',          is_active:true, post_interval_hours:48, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000048', bot_name:'UNAD Zona Caribe',                         data_category:'educacion_superior',     source_url:'https://www.unad.edu.co',                  is_active:true, post_interval_hours:48, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000049', bot_name:'Cámara de Comercio de Santa Marta',        data_category:'economia',               source_url:'https://www.camarasantamarta.com.co',     is_active:true, post_interval_hours:48, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000050', bot_name:'Banco de la República Santa Marta',        data_category:'economia',               source_url:'https://www.banrep.gov.co',                is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000051', bot_name:'Fenalco Magdalena',                        data_category:'economia',               source_url:'https://www.fenalco.com.co',               is_active:true, post_interval_hours:48, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000052', bot_name:'ProColombia Turismo Santa Marta',          data_category:'turismo',                source_url:'https://www.procolombia.co',               is_active:true, post_interval_hours:24, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000053', bot_name:'Secretaría de Cultura SM',                 data_category:'cultura',                source_url:'https://www.santamarta.gov.co/cultura',   is_active:true, post_interval_hours:48, created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000054', bot_name:'Festival de la Leyenda Vallenata',         data_category:'cultura',                source_url:'https://www.festivalvallenato.com',        is_active:true, post_interval_hours:168,created_at:NOW },
  { id:'00000000-0000-4000-b000-000000000055', bot_name:'ICANH Caribe',                             data_category:'patrimonio',             source_url:'https://www.icanh.gov.co',                 is_active:true, post_interval_hours:168,created_at:NOW },
];

// Migration 008 + 010 Mapaná Marine
const MAIA_USERS = [
  ['a1b2c3d4-0001-0001-0001-000000000001','bot.elsanatorio@lleva-lleva.com'],
  ['a1b2c3d4-0001-0001-0001-000000000002','bot.junohousestudios@lleva-lleva.com'],
  ['a1b2c3d4-0001-0001-0001-000000000003','bot.maiamasters@lleva-lleva.com'],
  ['a1b2c3d4-0001-0001-0001-000000000004','bot.triviummagnum@lleva-lleva.com'],
  ['a1b2c3d4-0001-0001-0001-000000000005','bot.maialegal@lleva-lleva.com'],
  ['a1b2c3d4-0001-0001-0001-000000000006','bot.maiamanagement@lleva-lleva.com'],
  ['a1b2c3d4-0001-0001-0001-000000000007','bot.maiarealty@lleva-lleva.com'],
  ['a1b2c3d4-0001-0001-0001-000000000008','bot.llavelabs@lleva-lleva.com'],
  ['a1b2c3d4-0001-0001-0001-000000000009','bot.maiaaerial@lleva-lleva.com'],
  ['a1b2c3d4-0001-0001-0001-000000000010','bot.llevalleva@lleva-lleva.com'],
  ['a1b2c3d4-0001-0001-0001-000000000011','bot.mapana.marine@lleva-lleva.com'],
];

const MAIA_PROFILES = [
  { id:'a1b2c3d4-0001-0001-0001-000000000001', username:'bot_el_sanatorio',   display_name:'El Sanatorio — Gastro Bar + Laberinto del Horror',             user_type:'bot', bio:'Gastro bar temático de terror en el Centro Histórico de Santa Marta. Cocina japonesa-latina, cócteles artesanales y el Laberinto del Horror. Calle 19 #4-23 Centro.',                                                                                   business_name:'El Sanatorio',            city:'Santa Marta', department:'Magdalena', whatsapp_number:'+19034598763', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'a1b2c3d4-0001-0001-0001-000000000002', username:'bot_juno_house',      display_name:'Juno House Studios',                                           user_type:'bot', bio:'Agencia de contenido digital. Apoyamos a creadores independientes con gestión de plataformas, soporte técnico y estrategia de monetización.',                                                                                                            business_name:'Juno House Studios',      city:'Santa Marta', department:'Magdalena', whatsapp_number:'+19034598763', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'a1b2c3d4-0001-0001-0001-000000000003', username:'bot_maia_masters',    display_name:'Maia Masters Academy',                                         user_type:'bot', bio:'Academia de habilidades digitales para el mundo moderno. Bootcamp intensivo: marketing digital, diseño con automatización, inglés para negocios y emprendimiento. Centro, Santa Marta.',                                                                                business_name:'Maia Masters Academy',    city:'Santa Marta', department:'Magdalena', whatsapp_number:'+19034598763', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'a1b2c3d4-0001-0001-0001-000000000004', username:'bot_trivium_magnum',  display_name:'Trivium Magnum International School for Boys',                 user_type:'bot', bio:'Colegio masculino de formación integral con énfasis en humanidades clásicas, ciencias y liderazgo. Centro Histórico, Santa Marta. Educación bilingüe.',                                                                                               business_name:'Trivium Magnum',          city:'Santa Marta', department:'Magdalena', whatsapp_number:'+19034598763', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'a1b2c3d4-0001-0001-0001-000000000005', username:'bot_maia_legal',      display_name:'Maia Legal',                                                   user_type:'bot', bio:'Firma jurídica especializada en derecho inmobiliario, contratos comerciales y asesoría para inversionistas extranjeros en Colombia.',                                                                                                                       business_name:'Maia Legal',              city:'Santa Marta', department:'Magdalena', whatsapp_number:'+19034598763', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'a1b2c3d4-0001-0001-0001-000000000006', username:'bot_maia_management', display_name:'Maia Management',                                        user_type:'bot', bio:'Grupo empresarial colombiano con operaciones en hospitalidad, tecnología, educación e inmobiliaria. Sede principal en Santa Marta, Costa Caribe.',                                                                                                        business_name:'Maia Management',   city:'Santa Marta', department:'Magdalena', whatsapp_number:'+19034598763', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'a1b2c3d4-0001-0001-0001-000000000007', username:'bot_maia_realty',     display_name:'Maia Realty',                                                  user_type:'bot', bio:'Agencia inmobiliaria especializada en propiedades en la Costa Caribe colombiana. Compra, venta, arriendo e inversión. Santa Marta, Barranquilla, Cartagena.',                                                                                              business_name:'Maia Realty',             city:'Santa Marta', department:'Magdalena', whatsapp_number:'+19034598763', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'a1b2c3d4-0001-0001-0001-000000000008', username:'bot_be_vida',         display_name:'Be Vida',                                            user_type:'bot', bio:'Productora artesanal de bebidas RTD (ready-to-drink) de la Costa Caribe. Cócteles botánicos, shots de fruta tropical y bebidas de barril en formato Sankey 20L para el canal B2B. Santa Marta, Colombia.',                                                  business_name:'Be Vida',       city:'Santa Marta', department:'Magdalena', whatsapp_number:'+19034598763', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'a1b2c3d4-0001-0001-0001-000000000009', username:'bot_maia_aerial',     display_name:'Maia Aerial',                                                  user_type:'bot', bio:'Parque de aventura aérea en las estribaciones de la Sierra Nevada de Santa Marta. Canopy, tirolinas, escalada y experiencias de naturaleza extrema.',                                                                                                    business_name:'Maia Aerial',             city:'Santa Marta', department:'Magdalena', whatsapp_number:'+19034598763', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'a1b2c3d4-0001-0001-0001-000000000010', username:'bot_llevalleva',      display_name:'LlevaLleva — Plataforma',                                      user_type:'bot', bio:'Plataforma oficial de anuncios clasificados para Colombia. Conectamos compradores, vendedores y empleadores en todo el país.',                                                                                                                           business_name:'LlevaLleva',              city:'Santa Marta', department:'Magdalena', whatsapp_number:'+19034598763', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
  { id:'a1b2c3d4-0001-0001-0001-000000000011', username:'bot_mapana_marine',   display_name:'Mapaná Marine',                                                user_type:'bot', bio:'Taller naval especializado en fabricación, reparación y equipamiento de embarcaciones en fibra de vidrio y aluminio. Operamos en la Costa Caribe colombiana.',                                                                                              business_name:'Mapaná Marine',           city:'Santa Marta', department:'Magdalena', whatsapp_number:'+19034598763', is_verified:true, is_active:true, created_at:NOW, updated_at:NOW },
];

// ─────────────────────────────────────────────────────────────
// Robust SQL parser for DO $$ listing blocks
// ─────────────────────────────────────────────────────────────

/**
 * Extract the content between a VALUES( opening and its matching )
 * Properly handles single-quoted strings and E'...' escaped strings.
 */
function extractValuesContent(sql, openParenIdx) {
  let i = openParenIdx;
  let depth = 1;
  let inStr = false;
  let isEStr = false;

  while (i < sql.length && depth > 0) {
    const ch = sql[i];

    if (inStr) {
      if (isEStr && ch === '\\') {
        i += 2; // skip escape + next char
        continue;
      }
      if (ch === "'") {
        if (sql[i + 1] === "'") { i += 2; continue; } // doubled quote
        inStr = false;
      }
      i++;
    } else {
      if (ch === 'E' && sql[i + 1] === "'") { inStr = true; isEStr = true; i += 2; continue; }
      if (ch === "'") { inStr = true; isEStr = false; i++; continue; }
      if (ch === '(') { depth++; i++; continue; }
      if (ch === ')') {
        depth--;
        if (depth === 0) break;
      }
      i++;
    }
  }
  return sql.slice(openParenIdx, i);
}

/**
 * Tokenize a SQL VALUES(...) content string into JS values.
 */
function tokenizeValues(s) {
  const tokens = [];
  let pos = 0;

  function skipWS() {
    while (pos < s.length && /[\s,]/.test(s[pos])) pos++;
  }

  function readStr() {
    pos++; // skip opening '
    let out = '';
    while (pos < s.length) {
      if (s[pos] === "'" && s[pos + 1] === "'") { out += "'"; pos += 2; }
      else if (s[pos] === "'") { pos++; break; }
      else out += s[pos++];
    }
    return out;
  }

  function readEStr() {
    pos += 2; // skip E'
    let out = '';
    while (pos < s.length) {
      if (s[pos] === '\\' && pos + 1 < s.length) {
        const n = s[pos + 1];
        if (n === 'n') out += '\n';
        else if (n === 't') out += '\t';
        else if (n === 'r') out += '\r';
        else if (n === "'") out += "'";
        else if (n === '\\') out += '\\';
        else out += n;
        pos += 2;
      } else if (s[pos] === "'") {
        pos++; break;
      } else out += s[pos++];
    }
    return out;
  }

  function readArray() {
    pos += 5; // skip ARRAY
    if (s[pos] === '[') pos++;
    const arr = [];
    while (pos < s.length && s[pos] !== ']') {
      if (s[pos] === "'") arr.push(readStr());
      else if (/[\s,]/.test(s[pos])) pos++;
      else pos++;
    }
    if (s[pos] === ']') pos++;
    return arr;
  }

  while (pos < s.length) {
    skipWS();
    if (pos >= s.length) break;

    if (s[pos] === 'E' && s[pos + 1] === "'") { tokens.push(readEStr()); continue; }
    if (s[pos] === "'") { tokens.push(readStr()); continue; }

    if (s.slice(pos, pos + 4) === 'NULL') { tokens.push(null); pos += 4; continue; }
    if (s.slice(pos, pos + 5) === 'ARRAY') { tokens.push(readArray()); continue; }
    if (s.slice(pos, pos + 4) === 'true') { tokens.push(true); pos += 4; continue; }
    if (s.slice(pos, pos + 5) === 'false') { tokens.push(false); pos += 5; continue; }

    if (s.slice(pos, pos + 3).toLowerCase() === 'now') {
      while (pos < s.length && s[pos] !== ')') pos++;
      if (pos < s.length) pos++; // skip )
      tokens.push(NOW);
      continue;
    }

    // variable or keyword
    if (/[a-z_]/i.test(s[pos])) {
      let word = '';
      while (pos < s.length && /[\w]/.test(s[pos])) word += s[pos++];
      tokens.push(word);
      continue;
    }

    // number (possibly negative)
    if (/\d/.test(s[pos]) || (s[pos] === '-' && /\d/.test(s[pos + 1] || ''))) {
      let num = '';
      if (s[pos] === '-') num += s[pos++];
      while (pos < s.length && /[\d.]/.test(s[pos])) num += s[pos++];
      tokens.push(Number(num));
      continue;
    }

    pos++; // skip unknown char
  }

  return tokens;
}

function parseListingsFromFile(filePath, catMap, locMap) {
  const sql = readFileSync(filePath, 'utf8');
  const listings = [];

  // Build variable map
  const varMap = {};

  // Seller UUIDs: v_sel_X UUID := 'uuid';
  for (const m of sql.matchAll(/\bv_sel_\w+\s+UUID\s*:=\s*'([^']+)'/g)) {
    const varName = m[0].match(/\bv_sel_\w+/)[0];
    varMap[varName] = m[1];
  }

  // Category vars: SELECT id INTO v_cat_X FROM categories WHERE slug = 'x';
  for (const m of sql.matchAll(/SELECT id INTO (v_cat_\w+)\s+FROM categories WHERE slug\s*=\s*'([^']+)'/g)) {
    const resolvedSlug = CAT_SLUG_MAP[m[2]] || m[2]; // apply alias
    varMap[m[1]] = catMap[resolvedSlug];
    if (!catMap[resolvedSlug]) console.warn(`  ⚠ Cat not found: ${m[2]} (→${resolvedSlug})`);
  }

  // Location vars: SELECT id INTO v_loc_X FROM locations WHERE slug = 'x';
  for (const m of sql.matchAll(/SELECT id INTO (v_loc_\w+)\s+FROM locations WHERE slug\s*=\s*'([^']+)'/g)) {
    varMap[m[1]] = locMap[m[2]];
    if (!locMap[m[2]]) console.warn(`  ⚠ Loc not found: ${m[2]}`);
  }

  // Find each INSERT INTO listings(...) VALUES(...) block
  const insertRe = /INSERT INTO listings\s*\(([^)]+)\)\s*VALUES\s*\(/gs;
  for (const m of sql.matchAll(insertRe)) {
    const cols = m[1].replace(/\s+/g, '').split(',');
    const valStart = m.index + m[0].length;
    const valContent = extractValuesContent(sql, valStart);
    const tokens = tokenizeValues(valContent);

    if (tokens.length !== cols.length) {
      console.warn(`  ⚠ Token/col mismatch: ${tokens.length} tokens, ${cols.length} cols`);
      continue;
    }

    const row = {};
    for (let ci = 0; ci < cols.length; ci++) {
      let val = tokens[ci];
      if (typeof val === 'string' && val.startsWith('v_')) {
        val = varMap[val] ?? null;
      }
      row[cols[ci]] = val === 'NULL' ? null : val;
    }

    // Skip rows with null seller_id or category_id (unresolved vars)
    if (!row.seller_id || !row.category_id) {
      if (!row.seller_id) console.warn(`  ⚠ Skipping listing "${row.slug}": null seller_id`);
      if (!row.category_id) console.warn(`  ⚠ Skipping listing "${row.slug}": null category_id (check cat slug mapping)`);
      continue;
    }

    listings.push(row);
  }

  return listings;
}

// ─────────────────────────────────────────────────────────────
// Main
// ─────────────────────────────────────────────────────────────

async function main() {
  console.log('\n=== LlevaLleva Production Seed (v2) ===\n');

  // 1. Pre-fetch maps
  console.log('Fetching category and location maps...');
  let { catMap, locMap } = await fetchMaps();
  console.log(`  Categories: ${Object.keys(catMap).length}, Locations: ${Object.keys(locMap).length}`);

  // 2. New locations (migration 005)
  console.log('\n[005] Inserting new locations...');
  await upsert('locations', LOCATIONS_005, 'slug');

  // Re-fetch location map
  const { data: freshLocs } = await supabase.from('locations').select('id,slug');
  locMap = Object.fromEntries((freshLocs || []).map(r => [r.slug, r.id]));
  console.log(`  Locations now: ${Object.keys(locMap).length}`);

  // 3. Create auth users (migration 007)
  console.log('\n[007] Creating auth users (55 public service bots)...');
  for (const [id, email] of BOT_USERS_007) {
    await adminCreateUser(id, email, { is_bot: true });
  }

  // 4. Insert profiles (migration 007)
  console.log('\n[007] Inserting profiles...');
  await upsert('profiles', PROFILES_007);

  // 5. Insert bot_accounts (migration 007) — skip if table not in schema cache
  console.log('\n[007] Inserting bot_accounts...');
  await upsert('bot_accounts', BOT_ACCOUNTS_007);

  // 6. Create auth users (migration 008 + 010)
  console.log('\n[008+010] Creating Maia group auth users (11 bots)...');
  for (const [id, email] of MAIA_USERS) {
    await adminCreateUser(id, email, { is_bot: true });
  }

  // 7. Insert Maia profiles (migration 008 + Mapaná Marine from 010)
  console.log('\n[008+010] Inserting Maia profiles...');
  await upsert('profiles', MAIA_PROFILES);

  // 8. Re-fetch full catMap now that locations are up-to-date
  const { data: allCats } = await supabase.from('categories').select('id,slug');
  const freshCatMap = Object.fromEntries((allCats || []).map(r => [r.slug, r.id]));
  // Add migration aliases
  for (const [migSlug, prodSlug] of Object.entries(CAT_SLUG_MAP)) {
    if (freshCatMap[prodSlug] && !freshCatMap[migSlug]) {
      freshCatMap[migSlug] = freshCatMap[prodSlug];
    }
  }

  // 9. Insert listings from migrations 009-013
  const migDir = './supabase/migrations';
  const listingFiles = [
    `${migDir}/009_seed_listings_jobs.sql`,
    `${migDir}/010_seed_listings_jobs_part2.sql`,
    `${migDir}/011_seed_listings_equipment_wanted.sql`,
    `${migDir}/012_seed_listings_services_forsale_community.sql`,
    `${migDir}/013_seed_listings_services_wanted_remaining.sql`,
  ];

  let totalInserted = 0;
  for (const filePath of listingFiles) {
    console.log(`\n[listings] ${filePath.split('/').pop()}`);
    const listings = parseListingsFromFile(filePath, freshCatMap, locMap);
    console.log(`  Parsed ${listings.length} valid listings`);
    if (!listings.length) continue;

    for (let i = 0; i < listings.length; i += 20) {
      const batch = listings.slice(i, i + 20);
      const { error } = await supabase
        .from('listings')
        .upsert(batch, { onConflict: 'slug', ignoreDuplicates: true });
      if (error) {
        console.error(`  ✗ Batch ${i}–${i + batch.length}: ${error.message}`);
        if (error.details) console.error(`    ${error.details.slice(0, 180)}`);
      } else {
        totalInserted += batch.length;
        process.stdout.write(`  ✓ ${i + batch.length}/${listings.length}\r`);
      }
    }
    console.log('');
  }

  // 10. Final counts
  console.log('\n=== Final counts ===');
  const [
    { count: profileCount },
    { count: listingCount },
    { count: locCount },
  ] = await Promise.all([
    supabase.from('profiles').select('*', { count: 'exact', head: true }),
    supabase.from('listings').select('*', { count: 'exact', head: true }),
    supabase.from('locations').select('*', { count: 'exact', head: true }),
  ]);
  console.log(`  Profiles:   ${profileCount}`);
  console.log(`  Listings:   ${listingCount}`);
  console.log(`  Locations:  ${locCount}`);
  console.log(`  Seeded/updated this run: ${totalInserted}`);
  console.log('\nDone!');
}

main().catch(console.error);

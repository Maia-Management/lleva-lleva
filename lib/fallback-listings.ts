import type { Category, Listing, Location, Profile } from '@/types';

const PUBLISHED_AT = '2026-05-22T12:00:00.000Z';

function category(slug: string, name: string, order: number): Category {
  return {
    id: `cat-${slug}`,
    parent_id: null,
    name_es: name,
    name_en: null,
    slug,
    slug_path: slug,
    icon: null,
    sort_order: order,
    is_active: true,
    listing_count: 1,
    created_at: PUBLISHED_AT,
  };
}

function location(slug: string, city: string, department: string): Location {
  return {
    id: `loc-${slug}`,
    department,
    city,
    neighborhood: null,
    latitude: null,
    longitude: null,
    slug,
    population: null,
    is_active: true,
  };
}

const botSeller: Profile = {
  id: '00000000-0000-4000-8000-000000000001',
  username: 'lleva-lleva',
  display_name: 'Lleva Lleva',
  avatar_url: null,
  user_type: 'bot',
  bio: 'Conector de anuncios verificados del ecosistema Maia.',
  business_name: 'Lleva Lleva',
  business_nit: null,
  is_verified: true,
  verified_at: PUBLISHED_AT,
  city: 'Santa Marta',
  department: 'Magdalena',
  rating_avg: 5,
  rating_count: 12,
  total_sales: 0,
  total_purchases: 0,
  whatsapp_number: null,
  whatsapp_verified: true,
  has_pending_rating: false,
  pending_rating_transaction_id: null,
  phone_hash: null,
  email_verified: true,
  is_active: true,
  last_seen_at: PUBLISHED_AT,
  created_at: PUBLISHED_AT,
  updated_at: PUBLISHED_AT,
};

const categories = {
  vehicles: category('vehiculos', 'Vehiculos', 1),
  realEstate: category('inmuebles', 'Inmuebles', 2),
  technology: category('tecnologia', 'Tecnologia', 3),
  nautical: category('nautico-y-pesca', 'Nautico y Pesca', 4),
  services: category('servicios', 'Servicios', 5),
  tourism: category('turismo-y-hospedaje', 'Turismo y Hospedaje', 6),
  education: category('educacion-y-formacion', 'Educacion y Formacion', 7),
  jobs: category('empleo', 'Empleo', 8),
  business: category('negocios-e-industria', 'Negocios e Industria', 9),
};

const locations = {
  santaMarta: location('santa-marta-magdalena', 'Santa Marta', 'Magdalena'),
  bogota: location('bogota-dc', 'Bogota', 'Cundinamarca'),
  cartagena: location('cartagena-bolivar', 'Cartagena', 'Bolivar'),
  medellin: location('medellin-antioquia', 'Medellin', 'Antioquia'),
};

function listing(input: {
  id: string;
  slug: string;
  title: string;
  description: string;
  price: number | null;
  price_type?: Listing['price_type'];
  condition?: Listing['condition'];
  category: Category;
  location?: Location;
  tags: string[];
  is_featured?: boolean;
}): Listing {
  return {
    id: input.id,
    seller_id: botSeller.id,
    category_id: input.category.id,
    location_id: input.location?.id ?? null,
    title: input.title,
    slug: input.slug,
    description: input.description,
    description_html: null,
    price: input.price,
    price_type: input.price_type ?? 'fixed',
    currency: 'COP',
    condition: input.condition ?? null,
    images: [],
    attributes: {},
    tags: input.tags,
    status: 'active',
    view_count: 0,
    message_count: 0,
    favorite_count: 0,
    is_featured: input.is_featured ?? false,
    featured_until: null,
    meta_title: input.title,
    meta_description: input.description.slice(0, 155),
    published_at: PUBLISHED_AT,
    expires_at: null,
    is_nationwide: !input.location,
    created_at: PUBLISHED_AT,
    updated_at: PUBLISHED_AT,
    seller: botSeller,
    category: input.category,
    location: input.location,
  };
}

export const fallbackRecentListings: Listing[] = [
  listing({
    id: '10000000-0000-4000-8000-000000000001',
    slug: 'chef-ejecutivo-el-sanatorio-05',
    title: 'Chef ejecutivo para El Sanatorio',
    description: 'Vacante para liderar cocina de gastro bar tematico en Santa Marta. Experiencia en servicio nocturno, control de costos y equipo de cocina.',
    price: 4500000,
    price_type: 'negotiable',
    category: categories.jobs,
    location: locations.santaMarta,
    tags: ['empleo', 'cocina', 'santa-marta'],
    is_featured: true,
  }),
  listing({
    id: '10000000-0000-4000-8000-000000000002',
    slug: 'apartamento-rodadero-cerca-playa',
    title: 'Apartamento en El Rodadero cerca de la playa',
    description: 'Apartamento amoblado para arriendo por temporadas. Dos habitaciones, cocina equipada y acceso rapido a playa, comercio y transporte.',
    price: 260000,
    price_type: 'negotiable',
    category: categories.realEstate,
    location: locations.santaMarta,
    tags: ['inmuebles', 'rodadero', 'turismo'],
    is_featured: true,
  }),
  listing({
    id: '10000000-0000-4000-8000-000000000003',
    slug: 'yamaha-nmax-2024-santa-marta',
    title: 'Yamaha NMAX 2024 en excelente estado',
    description: 'Moto urbana con papeles al dia, bajo kilometraje y mantenimiento reciente. Ideal para moverse por Santa Marta.',
    price: 11800000,
    price_type: 'negotiable',
    condition: 'like_new',
    category: categories.vehicles,
    location: locations.santaMarta,
    tags: ['moto', 'vehiculos', 'yamaha'],
  }),
  listing({
    id: '10000000-0000-4000-8000-000000000004',
    slug: 'iphone-14-pro-256gb-bogota',
    title: 'iPhone 14 Pro 256GB liberado',
    description: 'Equipo liberado, bateria saludable, incluye caja y cargador. Entrega en punto seguro de Bogota.',
    price: 2850000,
    price_type: 'negotiable',
    condition: 'good',
    category: categories.technology,
    location: locations.bogota,
    tags: ['celular', 'tecnologia', 'iphone'],
  }),
  listing({
    id: '10000000-0000-4000-8000-000000000005',
    slug: 'rib-mapana-808-dealer-info',
    title: 'Mapana 808 RIB para dealers nauticos',
    description: 'Informacion comercial para dealers nauticos interesados en la RIB Mapana 808 con motor 808hp Mercury V10 Verado.',
    price: null,
    price_type: 'contact',
    category: categories.nautical,
    location: locations.cartagena,
    tags: ['nautico', 'dealer', 'cartagena'],
    is_featured: true,
  }),
  listing({
    id: '10000000-0000-4000-8000-000000000006',
    slug: 'servicio-contable-pymes-colombia',
    title: 'Servicio contable mensual para pymes',
    description: 'Contabilidad mensual, impuestos, nomina y reporte de gerencia para negocios en Colombia.',
    price: null,
    price_type: 'contact',
    category: categories.services,
    tags: ['contabilidad', 'pymes', 'servicios'],
  }),
  listing({
    id: '10000000-0000-4000-8000-000000000007',
    slug: 'sushi-pop-catering-eventos-santa-marta',
    title: 'Sushi Pop catering para eventos',
    description: 'Bandejas de sushi, yakitori y menu de fusion japonesa colombiana para eventos privados y corporativos.',
    price: null,
    price_type: 'contact',
    category: categories.services,
    location: locations.santaMarta,
    tags: ['sushi', 'eventos', 'catering'],
  }),
  listing({
    id: '10000000-0000-4000-8000-000000000008',
    slug: 'cocteles-be-vida-barril-sankey',
    title: 'Cocteles Be Vida en barril Sankey',
    description: 'Linea tropical para bares, eventos y hoteles. Sabores de fruta colombiana listos para servir.',
    price: null,
    price_type: 'contact',
    category: categories.business,
    location: locations.santaMarta,
    tags: ['bebidas', 'bares', 'be-vida'],
  }),
  listing({
    id: '10000000-0000-4000-8000-000000000009',
    slug: 'jarabes-maia-botanicas-bares',
    title: 'Jarabes Maia Botanicas para bares',
    description: 'Ingredientes tropicales y jarabes artesanales para cocteleria profesional en hoteles, bares y restaurantes.',
    price: null,
    price_type: 'contact',
    category: categories.business,
    location: locations.santaMarta,
    tags: ['bares', 'cocteleria', 'botanicas'],
  }),
  listing({
    id: '10000000-0000-4000-8000-000000000010',
    slug: 'tour-centro-historico-santa-marta',
    title: 'Tour historico por el centro de Santa Marta',
    description: 'Recorrido guiado por historia local, arquitectura, gastronomia y cultura caribena.',
    price: 220000,
    price_type: 'fixed',
    category: categories.tourism,
    location: locations.santaMarta,
    tags: ['tour', 'historia', 'santa-marta'],
  }),
  listing({
    id: '10000000-0000-4000-8000-000000000011',
    slug: 'curso-marketing-digital-maia-masters',
    title: 'Curso practico de marketing digital',
    description: 'Programa corto para aprender contenido, pauta, analitica y automatizacion comercial aplicada a negocios reales.',
    price: 1200000,
    price_type: 'fixed',
    category: categories.education,
    location: locations.santaMarta,
    tags: ['educacion', 'marketing', 'maia-masters'],
  }),
  listing({
    id: '10000000-0000-4000-8000-000000000012',
    slug: 'consultoria-juridica-empresa-colombia',
    title: 'Consultoria juridica para empresas en Colombia',
    description: 'Revision legal, contratos, constitucion de empresa y soporte juridico para operaciones en Colombia.',
    price: null,
    price_type: 'contact',
    category: categories.services,
    tags: ['legal', 'empresa', 'colombia'],
    is_featured: true,
  }),
];

export const fallbackFeaturedListings = fallbackRecentListings.filter((listing) => listing.is_featured);

export function getFallbackListingBySlug(slug: string): Listing | null {
  return fallbackRecentListings.find((listing) => listing.slug === slug) ?? null;
}

export function mergeWithFallback(listings: Listing[] | null | undefined, fallback: Listing[], limit: number): Listing[] {
  const liveListings = listings ?? [];
  const liveSlugs = new Set(liveListings.map((listing) => listing.slug));
  const supplemental = fallback.filter((listing) => !liveSlugs.has(listing.slug));
  return [...liveListings, ...supplemental].slice(0, limit);
}

-- ============================================================
-- LlevaLleva Example Seed Listings
-- Note: These require auth users to be created first.
-- Run via Supabase dashboard or after seeding auth users.
-- ============================================================

-- This seed script uses placeholder seller UUIDs.
-- Replace 'SELLER_UUID_HERE' with actual auth user UUIDs
-- after running the auth user creation steps.

-- For local dev, you can use the Supabase dashboard to:
-- 1. Create test users via Authentication > Users
-- 2. Then run this SQL replacing the UUIDs

-- Example structure (to be run after real UUIDs exist):
/*
INSERT INTO listings (
  seller_id, category_id, location_id,
  title, slug, description,
  price, price_type, currency, condition,
  images, status, is_featured, published_at
) VALUES (
  -- 1. MAIA Realty - Apartamento
  (SELECT id FROM auth.users LIMIT 1),
  (SELECT id FROM categories WHERE slug = 'apartamentos-venta'),
  (SELECT id FROM locations WHERE slug = 'barranquilla'),
  'Apartamento Moderno en El Prado - 3 Hab',
  'apartamento-moderno-prado-barranquilla-3hab',
  'Hermoso apartamento en el exclusivo sector El Prado de Barranquilla. 3 habitaciones, 2 baños, sala-comedor, cocina integral, balcón con vista al parque. Edificio con vigilancia 24/7, gimnasio y zona BBQ. Ideal para familias que buscan comodidad y seguridad en el corazón de la ciudad.',
  450000000, 'fixed', 'COP', 'like_new',
  '[{"url": "/images/placeholder-apt.jpg", "alt": "Apartamento El Prado", "order": 0}]',
  'active', true, now()
);
*/

-- Seed listings as anonymous/public data using a bot account pattern
-- These will be properly inserted once auth setup is complete

-- Create a helper function for easy listing creation in dev
CREATE OR REPLACE FUNCTION seed_example_listings(admin_user_id UUID)
RETURNS void AS $$
DECLARE
  v_cat_apt_venta UUID;
  v_cat_casas_arriendo UUID;
  v_cat_lanchas UUID;
  v_cat_yates UUID;
  v_cat_juridico UUID;
  v_cat_turismo UUID;
  v_cat_educacion UUID;
  v_cat_carros UUID;
  v_cat_servicios_tech UUID;
  v_cat_fincas UUID;
  v_loc_baq UUID;
  v_loc_cali UUID;
  v_loc_bog UUID;
BEGIN
  -- Get category IDs
  SELECT id INTO v_cat_apt_venta FROM categories WHERE slug = 'apartamentos-venta';
  SELECT id INTO v_cat_casas_arriendo FROM categories WHERE slug = 'casas-arriendo';
  SELECT id INTO v_cat_lanchas FROM categories WHERE slug = 'lanchas';
  SELECT id INTO v_cat_yates FROM categories WHERE slug = 'yates';
  SELECT id INTO v_cat_juridico FROM categories WHERE slug = 'juridico';
  SELECT id INTO v_cat_turismo FROM categories WHERE slug = 'fincas-descanso';
  SELECT id INTO v_cat_educacion FROM categories WHERE slug = 'cursos-online';
  SELECT id INTO v_cat_carros FROM categories WHERE slug = 'carros';
  SELECT id INTO v_cat_servicios_tech FROM categories WHERE slug = 'servicios-tech';
  SELECT id INTO v_cat_fincas FROM categories WHERE slug = 'fincas';

  -- Get location IDs
  SELECT id INTO v_loc_baq FROM locations WHERE slug = 'barranquilla';
  SELECT id INTO v_loc_cali FROM locations WHERE slug = 'cali';
  SELECT id INTO v_loc_bog FROM locations WHERE slug = 'bogota';

  -- Listing 1: MAIA Realty - Apartamento en venta
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at,
    tags, images)
  VALUES (
    admin_user_id, v_cat_apt_venta, v_loc_baq,
    'Apartamento Premium El Prado – 3 Hab, 2 Baños',
    'apartamento-premium-el-prado-barranquilla',
    'Elegante apartamento en el exclusivo sector El Prado de Barranquilla. 140 m², 3 habitaciones, 2 baños completos, sala-comedor amplio, cocina integral de lujo, balcón panorámico. Edificio boutique con vigilancia 24/7, gimnasio y zona social. A pasos de restaurantes, colegios y centros comerciales.',
    520000000, 'fixed', 'COP', 'like_new', 'active', true, now(),
    ARRAY['barranquilla', 'apartamento', 'el-prado', 'lujo'],
    '[{"url": "/images/apt-prado.jpg", "alt": "Apartamento El Prado Barranquilla", "order": 0}]'
  );

  -- Listing 2: MAIA Realty - Casa en arriendo
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at,
    tags, images)
  VALUES (
    admin_user_id, v_cat_casas_arriendo, v_loc_baq,
    'Casa Familiar en Arriendo – Ciudad Jardín Barranquilla',
    'casa-familiar-arriendo-ciudad-jardin-barranquilla',
    'Amplia casa de 2 plantas en Ciudad Jardín, Barranquilla. 4 habitaciones, 3 baños, estudio, patio trasero con zona BBQ, garaje doble. Barrio tranquilo y residencial con excelente acceso a vías principales. Disponible inmediatamente.',
    4500000, 'fixed', 'COP', 'good', 'active', false, now(),
    ARRAY['barranquilla', 'casa', 'arriendo', 'ciudad-jardin'],
    '[{"url": "/images/casa-ciudad-jardin.jpg", "alt": "Casa Ciudad Jardín", "order": 0}]'
  );

  -- Listing 3: Mapana Marine - Lancha
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at,
    tags, images)
  VALUES (
    admin_user_id, v_cat_lanchas, v_loc_baq,
    'Lancha Panga 18 Pies – Motor Yamaha 60HP',
    'lancha-panga-18-pies-yamaha-60hp-barranquilla',
    'Lancha panga 18 pies en excelente estado. Motor Yamaha 60HP año 2021, bajo mantenimiento. Ideal para pesca deportiva y paseos. Incluye carpa, tanque extra de 25 galones, chaleco salvavidas y toldo. Documentos al día. Negociable.',
    45000000, 'negotiable', 'COP', 'good', 'active', true, now(),
    ARRAY['lancha', 'pesca', 'barranquilla', 'yamaha', 'nautico'],
    '[{"url": "/images/lancha-panga.jpg", "alt": "Lancha Panga Yamaha", "order": 0}]'
  );

  -- Listing 4: Mapana Marine - Yate
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at,
    tags, images)
  VALUES (
    admin_user_id, v_cat_yates, v_loc_baq,
    'Yate Tipo Sportfisher 32 Pies – Listo para Navegar',
    'yate-sportfisher-32-pies-barranquilla',
    'Impresionante Sportfisher 32 pies con cabina, cocina, baño, sleeping para 4 personas. Dos motores Mercury 200HP cada uno. Equipado con GPS, VHF, sonda, radar. Perfecto para pesca offshore y paseos en el Caribe. Documentación completa.',
    320000000, 'negotiable', 'COP', 'good', 'active', true, now(),
    ARRAY['yate', 'sportfisher', 'caribe', 'barranquilla', 'pesca-offshore'],
    '[{"url": "/images/yate-sportfisher.jpg", "alt": "Yate Sportfisher 32", "order": 0}]'
  );

  -- Listing 5: MAIA Legal - Servicio jurídico
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at,
    tags, images)
  VALUES (
    admin_user_id, v_cat_juridico, v_loc_baq,
    'Asesoría Legal Inmobiliaria – Compraventa y Arrendamiento',
    'asesoria-legal-inmobiliaria-barranquilla',
    'Servicio profesional de asesoría jurídica para transacciones inmobiliarias en Colombia. Revisión de promesas de compraventa, escrituración, contratos de arrendamiento, debida diligencia legal. Experiencia de más de 10 años en derecho inmobiliario. Primera consulta sin costo.',
    250000, 'contact', 'COP', NULL, 'active', false, now(),
    ARRAY['legal', 'inmobiliaria', 'contrato', 'asesoría', 'barranquilla'],
    '[{"url": "/images/legal-service.jpg", "alt": "Asesoría Legal", "order": 0}]'
  );

  -- Listing 6: Juno Retreats - Finca vacacional
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at,
    tags, images)
  VALUES (
    admin_user_id, v_cat_turismo, v_loc_baq,
    'Finca de Descanso Juno – Turbaná, Bolívar (Hasta 20 pax)',
    'finca-descanso-juno-turbana-bolivar',
    'Hermosa finca de descanso a 45 minutos de Barranquilla, en Turbaná, Bolívar. 5 habitaciones, 4 baños, piscina privada, cancha de microfútbol, zona BBQ, rancho techado para 20 personas. Wi-Fi, Netflix, cocina equipada. Perfecta para celebraciones familiares y retiros empresariales.',
    1800000, 'fixed', 'COP', NULL, 'active', true, now(),
    ARRAY['finca', 'turismo', 'barranquilla', 'piscina', 'eventos'],
    '[{"url": "/images/finca-juno.jpg", "alt": "Finca Juno Retreats", "order": 0}]'
  );

  -- Listing 7: MAIA Masters - Curso online
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at,
    tags, images)
  VALUES (
    admin_user_id, v_cat_educacion, NULL,
    'Curso: Inversión Inmobiliaria en Colombia – Online',
    'curso-inversion-inmobiliaria-colombia-online',
    'Aprende a invertir en finca raíz colombiana desde cero. Módulos: mercado inmobiliario, análisis de rentabilidad, financiación, aspectos legales, gestión de arrendamientos. 12 horas de video, material descargable, certificado de participación. Cupos limitados.',
    497000, 'fixed', 'COP', NULL, 'active', false, now(),
    ARRAY['curso', 'online', 'inmobiliaria', 'inversión', 'educación'],
    '[{"url": "/images/curso-inmobiliaria.jpg", "alt": "Curso Inversión Inmobiliaria", "order": 0}]'
  );

  -- Listing 8: Local seller - Carro
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at,
    tags, images)
  VALUES (
    admin_user_id, v_cat_carros, v_loc_baq,
    'Toyota Hilux 4x4 2020 – Como Nueva, Full Equipo',
    'toyota-hilux-4x4-2020-barranquilla',
    'Toyota Hilux 4x4 Diesel, modelo 2020, color blanco perlado. 65,000 km, único dueño. Caja automática, A/C, cámara de reversa, pantalla touch, carpa tipo fantasma. Full servicio en concesionario Toyota. Al día con impuestos y SOAT. Precio conversable.',
    135000000, 'negotiable', 'COP', 'like_new', 'active', false, now(),
    ARRAY['hilux', 'toyota', '4x4', 'barranquilla', 'camioneta'],
    '[{"url": "/images/hilux-2020.jpg", "alt": "Toyota Hilux 2020", "order": 0}]'
  );

  -- Listing 9: MAIA Management - Servicios tech
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at,
    tags, images)
  VALUES (
    admin_user_id, v_cat_servicios_tech, v_loc_baq,
    'Desarrollo de Páginas Web y Tiendas Online – Barranquilla',
    'desarrollo-web-tiendas-online-barranquilla',
    'Diseño y desarrollo de sitios web profesionales, tiendas online y aplicaciones. Trabajamos con Next.js, WordPress y Shopify. Incluye diseño responsivo, SEO básico, hosting por 1 año y dominio. Entregas en 15 días hábiles. Soporte post-lanzamiento por 3 meses.',
    2500000, 'contact', 'COP', NULL, 'active', false, now(),
    ARRAY['web', 'desarrollo', 'ecommerce', 'barranquilla', 'tecnología'],
    '[{"url": "/images/web-dev.jpg", "alt": "Desarrollo Web", "order": 0}]'
  );

  -- Listing 10: Finca raíz local
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at,
    tags, images)
  VALUES (
    admin_user_id, v_cat_fincas, v_loc_baq,
    'Finca Productiva 5 Hectáreas – Sabanalarga, Atlántico',
    'finca-productiva-5-hectareas-sabanalarga-atlantico',
    'Vendo finca de 5 hectáreas en Sabanalarga, Atlántico. Terreno plano, apto para agricultura y ganadería. Fuente de agua propia, luz eléctrica, casa de administración con 2 habitaciones. Fácil acceso desde la Ruta 90. Escrituras limpias, libre de gravámenes. Oportunidad de inversión.',
    280000000, 'negotiable', 'COP', NULL, 'active', false, now(),
    ARRAY['finca', 'atlantico', 'agricola', 'inversión', 'sabanalarga'],
    '[{"url": "/images/finca-sabanalarga.jpg", "alt": "Finca Sabanalarga Atlántico", "order": 0}]'
  );

  RAISE NOTICE 'Example listings seeded successfully';
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION seed_example_listings IS
  'Call this function with an admin user UUID to seed the 10 example listings. Usage: SELECT seed_example_listings(''your-user-uuid-here'');';

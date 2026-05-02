-- =============================================================
-- LlevaLleva Migration 016 — Ruta Colombia (travel services)
--
-- Adds the Ruta Colombia ecosystem entity (UUID …012) and three
-- sample listings: a Medellín digital-nomad guidebook, a
-- Cartagena VIP concierge service, and Coffee Region tour
-- planning. Travel SERVICES, not accommodation — the listings
-- live under categories.slug = 'otros-servicios' (Services →
-- Other Services) per Andrew's direction.
--
-- Idempotent: ON CONFLICT DO NOTHING on every insert.
-- Depends on: 008_seed_business_profiles.sql (for profile
-- table shape), 002_categories_seed.sql, 003_locations_seed.sql.
-- =============================================================

DO $$
DECLARE
  v_sel_ruta UUID := 'a1b2c3d4-0001-0001-0001-000000000012';

  v_cat_otros_serv UUID;
  v_loc_med        UUID;
  v_loc_car        UUID;
  v_loc_arm        UUID;
BEGIN

  SELECT id INTO v_cat_otros_serv FROM categories WHERE slug = 'otros-servicios';
  SELECT id INTO v_loc_med        FROM locations  WHERE slug = 'medellin';
  SELECT id INTO v_loc_car        FROM locations  WHERE slug = 'cartagena';
  SELECT id INTO v_loc_arm        FROM locations  WHERE slug = 'armenia';

  IF v_cat_otros_serv IS NULL THEN
    RAISE EXCEPTION 'migration 016: category "otros-servicios" missing — apply 002 first';
  END IF;

  -- ==========================================================
  -- STEP 1: auth.users + profile for Ruta Colombia
  -- ==========================================================

  INSERT INTO auth.users (
    id, instance_id, aud, role, email,
    encrypted_password, email_confirmed_at,
    raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at, is_sso_user, is_anonymous
  ) VALUES (
    v_sel_ruta,
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.rutacolombia@lleva-lleva.com',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ) ON CONFLICT (id) DO NOTHING;

  INSERT INTO profiles (
    id, username, display_name, user_type,
    bio, business_name, business_nit,
    city, department,
    whatsapp_number, whatsapp_verified,
    is_verified, is_active,
    created_at, updated_at
  ) VALUES (
    v_sel_ruta,
    'bot_ruta_colombia',
    'Ruta Colombia',
    'bot',
    'Servicios de viaje a la medida en Colombia: planificación de rutas, conserjería VIP y guías locales para nómadas digitales, viajeros independientes y grupos. No alquilamos alojamiento — diseñamos la experiencia.',
    'Ruta Colombia',
    NULL,
    'Santa Marta', 'Magdalena',
    '+573174370575', true,
    true, true,
    now(), now()
  ) ON CONFLICT (id) DO NOTHING;

  -- ==========================================================
  -- STEP 2: Sample listings (3) — all under Services
  -- ==========================================================

  -- Listing 1: Medellín Digital Nomad Guidebook
  INSERT INTO listings (
    seller_id, category_id, location_id,
    title, slug, description,
    price, price_type, currency,
    status, is_featured, published_at, tags, images
  ) VALUES (
    v_sel_ruta, v_cat_otros_serv, v_loc_med,
    'Medellín Digital Nomad Guidebook — Ruta Colombia',
    'medellin-digital-nomad-guidebook-ruta-colombia',
    E'Guía digital actualizada para nómadas que aterrizan en Medellín por primera vez.\n\nIncluye:\n• Mapa de barrios para vivir (El Poblado, Laureles, Envigado, Manila) con precios y trade-offs reales\n• Lista curada de coworkings con velocidad de internet medida en sitio\n• Cafés con buen Wi-Fi, ambiente y tomas eléctricas\n• Cómo abrir cuenta bancaria como extranjero, conseguir SIM colombiana, contratar arriendo de corto plazo sin trampas\n• Guía de transporte (Metro, Encicla, taxis vs apps)\n• Comunidades de nómadas activas en español e inglés\n\nFormato: PDF + actualizaciones por 12 meses. Asesoría inicial de 30 min por WhatsApp incluida.\n\nContacto: WhatsApp +573174370575',
    180000, 'fixed', 'COP',
    'active', true, now(),
    ARRAY['servicios','viajes','medellin','nomada-digital','guia','ruta-colombia','coworking'],
    '[{"url":"/images/ruta-medellin.jpg","alt":"Medellín Digital Nomad Guidebook","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- Listing 2: Cartagena VIP Concierge Service
  INSERT INTO listings (
    seller_id, category_id, location_id,
    title, slug, description,
    price, price_type, currency,
    status, is_featured, published_at, tags, images
  ) VALUES (
    v_sel_ruta, v_cat_otros_serv, v_loc_car,
    'Cartagena VIP Concierge Service — Ruta Colombia',
    'cartagena-vip-concierge-ruta-colombia',
    E'Servicio de conserjería VIP para tu visita a Cartagena. Ideal para parejas, grupos pequeños y viajeros que valoran su tiempo.\n\nTodo incluido:\n• Bienvenida y traslado privado desde el aeropuerto Rafael Núñez\n• Reservas en los mejores restaurantes del Centro Histórico (con anticipación de hasta 6 semanas)\n• Lancha privada para Islas del Rosario o Barú\n• City tour del Centro Histórico y Getsemaní con guía bilingüe certificado\n• Línea de WhatsApp 24/7 con concierge dedicado durante tu estadía\n\nDuración mínima: 3 días. Precio por persona, en grupos de 2 a 4.\n\nNo incluye: alojamiento (te ayudamos a coordinarlo si necesitas).\n\nContacto: WhatsApp +573174370575',
    1850000, 'negotiable', 'COP',
    'active', true, now(),
    ARRAY['servicios','viajes','cartagena','conserjeria','vip','ruta-colombia','islas-rosario'],
    '[{"url":"/images/ruta-cartagena.jpg","alt":"Cartagena VIP Concierge Service","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- Listing 3: Coffee Region Tour Planning
  INSERT INTO listings (
    seller_id, category_id, location_id,
    title, slug, description,
    price, price_type, currency,
    status, is_featured, published_at, tags, images
  ) VALUES (
    v_sel_ruta, v_cat_otros_serv, v_loc_arm,
    'Coffee Region Tour Planning — Eje Cafetero | Ruta Colombia',
    'coffee-region-tour-planning-eje-cafetero-ruta-colombia',
    E'Diseñamos tu ruta por el Eje Cafetero: Armenia, Salento, Filandia, Pereira y Manizales. Itinerario hecho a medida según tus fechas, ritmo y presupuesto.\n\nLo que entregamos:\n• Itinerario día por día con horarios y rutas (Google Maps + PDF)\n• Reservas en fincas cafeteras seleccionadas (no las turísticas masivas)\n• Tour del proceso del café de la mata a la taza con catación\n• Excursión al Valle del Cocora y los palmas de cera\n• Recomendaciones de bares, restaurantes y experiencias locales\n• Coordinación de transportes intermunicipales (privados o por bus)\n\nNo incluye: alojamiento ni vuelos. Te enlazamos con operadores locales de confianza si los necesitas.\n\nDuración: planificación para viajes de 4 a 10 días.\n\nContacto: WhatsApp +573174370575',
    450000, 'fixed', 'COP',
    'active', false, now(),
    ARRAY['servicios','viajes','eje-cafetero','cafe','salento','armenia','ruta-colombia','planificacion'],
    '[{"url":"/images/ruta-eje-cafetero.jpg","alt":"Coffee Region Tour Planning","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  RAISE NOTICE 'migration 016: Ruta Colombia + 3 listings seeded';

END $$;

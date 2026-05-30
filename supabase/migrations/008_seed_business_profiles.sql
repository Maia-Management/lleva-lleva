-- ============================================================
-- Migration 008: Maia Group Business Bot Profiles
-- Creates auth.users + profiles for all Maia ecosystem entities
-- Fixed UUIDs allow downstream migrations to reference them.
-- ============================================================

DO $$
BEGIN

-- ============================================================
-- auth.users — one entry per business bot
-- encrypted_password is NULL: these accounts can't log in
-- ============================================================

INSERT INTO auth.users (
  id, instance_id, aud, role, email,
  encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data,
  created_at, updated_at,
  is_sso_user, is_anonymous
) VALUES
  (
    'a1b2c3d4-0001-0001-0001-000000000001',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.elsanatorio@lleva-lleva.com',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000002',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.junohousestudios@lleva-lleva.com',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000003',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.maiamasters@lleva-lleva.com',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000004',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.triviummagnum@lleva-lleva.com',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000005',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.maialegal@lleva-lleva.com',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000006',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.maiamanagement@lleva-lleva.com',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000007',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.maiarealty@lleva-lleva.com',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000008',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.llavelabs@lleva-lleva.com',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000009',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.maiaaerial@lleva-lleva.com',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000010',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.llevalleva@lleva-lleva.com',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  )
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- profiles — one per business entity
-- user_type = 'bot', is_verified = true
-- ============================================================

INSERT INTO profiles (
  id, username, display_name, user_type,
  bio, business_name, business_nit,
  city, department,
  whatsapp_number, whatsapp_verified,
  is_verified, is_active,
  created_at, updated_at
) VALUES
  (
    'a1b2c3d4-0001-0001-0001-000000000001',
    'bot_el_sanatorio',
    'El Sanatorio — Gastro Bar + Laberinto del Horror',
    'bot',
    'Gastro bar temático de terror en el Centro Histórico de Santa Marta. Cocina japonesa-latina, cócteles artesanales y el Laberinto del Horror. Calle 19 #4-23 Centro.',
    'El Sanatorio',
    NULL,
    'Santa Marta', 'Magdalena',
    '+19034598763', true,
    true, true,
    now(), now()
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000002',
    'bot_juno_house',
    'Juno House Studios',
    'bot',
    'Compañía de management de creadores con estudio de producción propio en Santa Marta. Acompañamos a talentos emergentes con un plan de carrera, producción de contenido y formalización legal y contable a través de las firmas del grupo Maia.',
    'Juno House Studios',
    NULL,
    'Santa Marta', 'Magdalena',
    '+19034598763', true,
    true, true,
    now(), now()
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000003',
    'bot_maia_masters',
    'Maia Masters Academy',
    'bot',
    'Academia de habilidades digitales para el mundo moderno. Bootcamp intensivo: marketing digital, diseño con automatización, inglés para negocios y emprendimiento. Centro, Santa Marta.',
    'Maia Masters Academy',
    NULL,
    'Santa Marta', 'Magdalena',
    '+19034598763', true,
    true, true,
    now(), now()
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000004',
    'bot_trivium_magnum',
    'Trivium Magnum International School for Boys',
    'bot',
    'Colegio masculino de formación integral con énfasis en humanidades clásicas, ciencias y liderazgo. Centro Histórico, Santa Marta. Educación bilingüe.',
    'Trivium Magnum',
    NULL,
    'Santa Marta', 'Magdalena',
    '+19034598763', true,
    true, true,
    now(), now()
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000005',
    'bot_maia_legal',
    'Maia Legal',
    'bot',
    'Firma jurídica especializada en derecho inmobiliario, contratos comerciales y asesoría para inversionistas extranjeros en Colombia.',
    'Maia Legal',
    NULL,
    'Santa Marta', 'Magdalena',
    '+19034598763', true,
    true, true,
    now(), now()
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000006',
    'bot_maia_management',
    'Maia Management S.A.S.',
    'bot',
    'Grupo empresarial colombiano con operaciones en hospitalidad, tecnología, educación e inmobiliaria. Sede principal en Santa Marta, Costa Caribe.',
    'Maia Management S.A.S.',
    NULL,
    'Santa Marta', 'Magdalena',
    '+19034598763', true,
    true, true,
    now(), now()
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000007',
    'bot_maia_realty',
    'Maia Realty',
    'bot',
    'Agencia inmobiliaria especializada en propiedades en la Costa Caribe colombiana. Compra, venta, arriendo e inversión. Santa Marta, Barranquilla, Cartagena.',
    'Maia Realty',
    NULL,
    'Santa Marta', 'Magdalena',
    '+19034598763', true,
    true, true,
    now(), now()
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000008',
    'bot_llave_labs',
    'Llave Labs / Llave Drinks',
    'bot',
    'Productora artesanal de bebidas de la Costa Caribe. Cervezas, kombuchas y bebidas funcionales elaboradas en Santa Marta con ingredientes locales.',
    'Llave Labs',
    NULL,
    'Santa Marta', 'Magdalena',
    '+19034598763', true,
    true, true,
    now(), now()
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000009',
    'bot_maia_aerial',
    'Maia Aerial',
    'bot',
    'Parque de aventura aérea en las estribaciones de la Sierra Nevada de Santa Marta. Canopy, tirolinas, escalada y experiencias de naturaleza extrema.',
    'Maia Aerial',
    NULL,
    'Santa Marta', 'Magdalena',
    '+19034598763', true,
    true, true,
    now(), now()
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000010',
    'bot_llevalleva',
    'LlevaLleva — Plataforma',
    'bot',
    'Plataforma oficial de anuncios clasificados para Colombia. Conectamos compradores, vendedores y empleadores en todo el país.',
    'LlevaLleva',
    NULL,
    'Santa Marta', 'Magdalena',
    '+19034598763', true,
    true, true,
    now(), now()
  )
ON CONFLICT (id) DO NOTHING;

RAISE NOTICE 'Maia Group business profiles seeded: 10 entities';

END $$;

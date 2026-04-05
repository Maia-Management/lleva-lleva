-- ============================================================
-- Migration 006: MAIA Ecosystem Seed Listings (Colombia-wide)
-- ============================================================
-- Call: SELECT seed_maia_listings('your-admin-uuid');
-- ============================================================

CREATE OR REPLACE FUNCTION seed_maia_listings(admin_user_id UUID)
RETURNS void AS $$
DECLARE
  -- Category IDs
  v_cat_apt_venta UUID;
  v_cat_casas_arriendo UUID;
  v_cat_lanchas UUID;
  v_cat_yates UUID;
  v_cat_juridico UUID;
  v_cat_turismo UUID;
  v_cat_educacion UUID;
  v_cat_carros UUID;
  v_cat_servicios_tech UUID;
  v_cat_fincas_venta UUID;
  v_cat_oficinas UUID;
  v_cat_empleo UUID;
  v_cat_servicios_fin UUID;
  v_cat_motores_marinos UUID;
  v_cat_servicios_marinos UUID;

  -- Location IDs
  v_loc_baq UUID;
  v_loc_bog UUID;
  v_loc_med UUID;
  v_loc_cali UUID;
  v_loc_car UUID;
  v_loc_buc UUID;
  v_loc_smt UUID;
BEGIN
  -- ---- Categories ----
  SELECT id INTO v_cat_apt_venta FROM categories WHERE slug = 'apartamentos-venta';
  SELECT id INTO v_cat_casas_arriendo FROM categories WHERE slug = 'casas-arriendo';
  SELECT id INTO v_cat_lanchas FROM categories WHERE slug = 'lanchas';
  SELECT id INTO v_cat_yates FROM categories WHERE slug = 'yates';
  SELECT id INTO v_cat_juridico FROM categories WHERE slug = 'juridico';
  SELECT id INTO v_cat_turismo FROM categories WHERE slug = 'fincas-descanso';
  SELECT id INTO v_cat_educacion FROM categories WHERE slug = 'cursos-online';
  SELECT id INTO v_cat_carros FROM categories WHERE slug = 'carros';
  SELECT id INTO v_cat_servicios_tech FROM categories WHERE slug = 'servicios-tech';
  SELECT id INTO v_cat_fincas_venta FROM categories WHERE slug = 'fincas';
  SELECT id INTO v_cat_oficinas FROM categories WHERE slug = 'oficinas';
  SELECT id INTO v_cat_empleo FROM categories WHERE slug = 'ofertas-empleo';
  SELECT id INTO v_cat_servicios_fin FROM categories WHERE slug = 'financiero';
  SELECT id INTO v_cat_motores_marinos FROM categories WHERE slug = 'motores-marinos';
  SELECT id INTO v_cat_servicios_marinos FROM categories WHERE slug = 'servicios-marinos';

  -- ---- Locations ----
  SELECT id INTO v_loc_baq FROM locations WHERE slug = 'barranquilla';
  SELECT id INTO v_loc_bog FROM locations WHERE slug = 'bogota';
  SELECT id INTO v_loc_med FROM locations WHERE slug = 'medellin';
  SELECT id INTO v_loc_cali FROM locations WHERE slug = 'cali';
  SELECT id INTO v_loc_car FROM locations WHERE slug = 'cartagena';
  SELECT id INTO v_loc_buc FROM locations WHERE slug = 'bucaramanga';
  SELECT id INTO v_loc_smt FROM locations WHERE slug = 'santa-marta';

  -- ==========================================================
  -- MAIA REALTY: Real Estate
  -- ==========================================================

  -- 1. Apartamento El Prado, Barranquilla
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images)
  VALUES (
    admin_user_id, v_cat_apt_venta, v_loc_baq,
    'Apartamento Premium El Prado – 3 Hab, 2 Baños',
    'apartamento-premium-el-prado-barranquilla-01',
    'Elegante apartamento en el exclusivo sector El Prado de Barranquilla. 140 m², 3 habitaciones, 2 baños completos, sala-comedor amplio, cocina integral de lujo, balcón panorámico con vista al parque. Edificio boutique con vigilancia 24/7, gimnasio y zona social. A pasos de restaurantes, colegios y centros comerciales. Escrituras limpias, entrega inmediata.',
    520000000, 'negotiable', 'COP', 'like_new', 'active', true, now(),
    ARRAY['barranquilla', 'apartamento', 'el-prado', 'lujo', 'maia-realty'],
    '[{"url": "/images/apt-prado.jpg", "alt": "Apartamento El Prado Barranquilla", "order": 0}]'
  );

  -- 2. Casa en arriendo, Bogotá
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images)
  VALUES (
    admin_user_id, v_cat_casas_arriendo, v_loc_bog,
    'Casa Familiar en Arriendo – Usaquén, Bogotá',
    'casa-familiar-arriendo-usaquen-bogota-01',
    'Amplia casa de 2 plantas en el prestigioso sector de Usaquén, Bogotá. 4 habitaciones, 3 baños, estudio, terraza con zona BBQ, garaje doble, cuarto de servicio. Barrio residencial tranquilo a 10 minutos de la Zona Rosa. Disponible inmediatamente. Canon mensual negociable para arrendatario de largo plazo.',
    7500000, 'negotiable', 'COP', 'good', 'active', false, now(),
    ARRAY['bogota', 'casa', 'arriendo', 'usaquen', 'maia-realty'],
    '[{"url": "/images/casa-usaquen.jpg", "alt": "Casa Usaquén Bogotá", "order": 0}]'
  );

  -- 3. Oficinas en Medellín
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images)
  VALUES (
    admin_user_id, v_cat_oficinas, v_loc_med,
    'Oficinas en El Poblado – 80 m², Listas para Operar',
    'oficinas-el-poblado-medellin-80m2-01',
    'Excelentes oficinas en el epicentro empresarial de El Poblado, Medellín. 80 m² con divisiones, sala de reuniones, cocina, 2 baños. Edificio inteligente con fibra óptica, planta eléctrica, ascensor y estacionamiento. Perfectas para empresas de tecnología, consultoría o servicios profesionales.',
    5500000, 'fixed', 'COP', 'like_new', 'active', false, now(),
    ARRAY['medellin', 'oficinas', 'el-poblado', 'arriendo', 'maia-realty'],
    '[{"url": "/images/oficinas-poblado.jpg", "alt": "Oficinas El Poblado Medellín", "order": 0}]'
  );

  -- ==========================================================
  -- MAPANA MARINE: Náutico
  -- ==========================================================

  -- 4. Lancha Panga, Barranquilla
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images)
  VALUES (
    admin_user_id, v_cat_lanchas, v_loc_baq,
    'Lancha Panga 18 Pies – Motor Yamaha 60HP',
    'lancha-panga-18-pies-yamaha-60hp-barranquilla-01',
    'Lancha panga 18 pies en excelente estado. Motor Yamaha 60HP año 2021, bajo mantenimiento. Ideal para pesca deportiva y paseos en el Caribe. Incluye carpa, tanque extra de 25 galones, chalecos salvavidas y toldo. Documentos al día. Operada por Mapana Marine, expertos en embarcaciones del Caribe colombiano. Negociable.',
    45000000, 'negotiable', 'COP', 'good', 'active', true, now(),
    ARRAY['lancha', 'pesca', 'barranquilla', 'yamaha', 'nautico', 'mapana-marine'],
    '[{"url": "/images/lancha-panga.jpg", "alt": "Lancha Panga Yamaha", "order": 0}]'
  );

  -- 5. Yate Sportfisher, Barranquilla/Santa Marta
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images)
  VALUES (
    admin_user_id, v_cat_yates, v_loc_smt,
    'Yate Sportfisher 32 Pies – Pesca Offshore Caribe',
    'yate-sportfisher-32-pies-santa-marta-01',
    'Impresionante Sportfisher 32 pies con cabina, cocina, baño, sleeping para 4 personas. Dos motores Mercury 200HP cada uno. Equipado con GPS, VHF, sonda, radar y redes. Perfecto para pesca offshore en el Caribe colombiano y paseos a las islas. Disponible en Santa Marta con posibilidad de traslado a Barranquilla o Cartagena. Por Mapana Marine.',
    320000000, 'negotiable', 'COP', 'good', 'active', true, now(),
    ARRAY['yate', 'sportfisher', 'caribe', 'santa-marta', 'pesca-offshore', 'mapana-marine'],
    '[{"url": "/images/yate-sportfisher.jpg", "alt": "Yate Sportfisher 32", "order": 0}]'
  );

  -- 6. Motores Marinos, nationwide
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images,
    is_nationwide)
  VALUES (
    admin_user_id, v_cat_motores_marinos, NULL,
    'Venta y Mantenimiento de Motores Marinos – Todo Colombia',
    'motores-marinos-mapana-marine-colombia-01',
    'Mapana Marine ofrece venta, instalación y mantenimiento de motores marinos en toda Colombia. Yamaha, Mercury, Suzuki y Honda. Servicio técnico certificado, garantía de fábrica. Cotizaciones sin costo. Enviamos motores a todo el país con seguimiento. Atención personalizada para flotas comerciales y embarcaciones deportivas.',
    NULL, 'contact', 'COP', NULL, 'active', false, now(),
    ARRAY['motores', 'marinos', 'yamaha', 'mercury', 'nautico', 'mapana-marine'],
    '[{"url": "/images/motores-marinos.jpg", "alt": "Motores Marinos Mapana", "order": 0}]',
    TRUE
  );

  -- ==========================================================
  -- MAIA LEGAL: Servicios Jurídicos
  -- ==========================================================

  -- 7. Asesoría inmobiliaria, nationwide
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images,
    is_nationwide)
  VALUES (
    admin_user_id, v_cat_juridico, NULL,
    'Asesoría Legal Inmobiliaria – Todo Colombia (Virtual y Presencial)',
    'asesoria-legal-inmobiliaria-maia-legal-colombia-01',
    'MAIA Legal ofrece asesoría jurídica integral para transacciones inmobiliarias en toda Colombia. Servicios: revisión de promesas de compraventa, escrituración, contratos de arrendamiento, debida diligencia legal, representación notarial. Más de 10 años de experiencia. Atención virtual (videollamada) para clientes en todo el país. Consulta inicial sin costo.',
    350000, 'contact', 'COP', NULL, 'active', false, now(),
    ARRAY['legal', 'inmobiliaria', 'contrato', 'asesoria', 'colombia', 'maia-legal'],
    '[{"url": "/images/legal-service.jpg", "alt": "Asesoría Legal MAIA", "order": 0}]',
    TRUE
  );

  -- ==========================================================
  -- JUNO RETREATS: Turismo
  -- ==========================================================

  -- 8. Finca vacacional, Santa Marta / Barranquilla
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images)
  VALUES (
    admin_user_id, v_cat_turismo, v_loc_smt,
    'Finca Juno Retreats – Costa Caribe (Hasta 20 pax, Piscina)',
    'finca-juno-retreats-costa-caribe-santa-marta-01',
    'Hermosa finca de descanso en la Costa Caribe, a 45 minutos de Santa Marta y Barranquilla. 5 habitaciones, 4 baños, piscina privada, cancha de microfútbol, zona BBQ con rancho para 20 personas. Wi-Fi de alta velocidad, Netflix, cocina completamente equipada. Perfecta para celebraciones familiares, despedidas y retiros empresariales. Reservas mínimo 2 noches.',
    1800000, 'fixed', 'COP', NULL, 'active', true, now(),
    ARRAY['finca', 'turismo', 'costa-caribe', 'santa-marta', 'piscina', 'eventos', 'juno-retreats'],
    '[{"url": "/images/finca-juno.jpg", "alt": "Finca Juno Retreats Costa Caribe", "order": 0}]'
  );

  -- ==========================================================
  -- MAIA MASTERS: Educación
  -- ==========================================================

  -- 9. Curso inversión inmobiliaria, nationwide
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images,
    is_nationwide)
  VALUES (
    admin_user_id, v_cat_educacion, NULL,
    'Curso: Inversión Inmobiliaria en Colombia – 100% Online',
    'curso-inversion-inmobiliaria-colombia-maia-masters-01',
    'Aprende a invertir en finca raíz colombiana desde cualquier ciudad. Programa MAIA Masters: 12 módulos online, 20+ horas de video, casos reales de inversión en la Costa y Bogotá. Temas: análisis de mercado, rentabilidad, financiación bancaria, aspectos legales, gestión de arrendamientos. Incluye comunidad privada y sesiones en vivo. Cupos limitados por cohorte.',
    497000, 'fixed', 'COP', NULL, 'active', true, now(),
    ARRAY['curso', 'online', 'inmobiliaria', 'inversion', 'educacion', 'colombia', 'maia-masters'],
    '[{"url": "/images/curso-inmobiliaria.jpg", "alt": "Curso MAIA Masters", "order": 0}]',
    TRUE
  );

  -- ==========================================================
  -- MAIA MANAGEMENT: Recruitment (Relocate to the Coast)
  -- ==========================================================

  -- 10. Bogotá → Costa
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images)
  VALUES (
    admin_user_id, v_cat_empleo, v_loc_bog,
    '¿Listo para vivir en la Costa? – Asesor Comercial Inmobiliario (Santa Marta)',
    'asesor-comercial-inmobiliario-santa-marta-desde-bogota-01',
    E'MAIA Management busca asesores comerciales para unirse a nuestro equipo en Santa Marta. Si estás en Bogotá y sueñas con un cambio de vida — trabajo con propósito, mar, calidad de vida y crecimiento real — esta es tu oportunidad.\n\nOfrecemos:\n• Comisiones competitivas (promedio $5–15M/mes)\n• Apoyo en relocalización y conexión con vivienda en la Costa\n• Capacitación completa en inversión inmobiliaria\n• Equipo joven y dinámico con cultura de excelencia\n\nPerfil: experiencia en ventas, orientado a resultados, dispuesto a reubicarse en Santa Marta. No se requiere experiencia previa en finca raíz.\n\nLa Costa te llama. Contáctanos.',
    NULL, 'contact', 'COP', NULL, 'active', true, now(),
    ARRAY['empleo', 'bogota', 'santa-marta', 'reubicacion', 'costa', 'inmobiliaria', 'maia-management'],
    '[{"url": "/images/empleo-costa.jpg", "alt": "Trabaja en la Costa", "order": 0}]'
  );

  -- 11. Medellín → Costa
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images)
  VALUES (
    admin_user_id, v_cat_empleo, v_loc_med,
    '¿Cambio de Vida? – Asesor Inmobiliario en el Caribe (desde Medellín)',
    'asesor-inmobiliario-caribe-desde-medellin-01',
    E'¿Vives en Medellín y quieres trabajar en el paraíso? MAIA Management abre posiciones para asesores inmobiliarios en la Costa Caribe colombiana (Santa Marta, Barranquilla, Cartagena).\n\nSi ya cansaste del frío, el tráfico y la rutina de la ciudad — la Costa te ofrece sol, mar y una carrera emocionante en finca raíz de lujo.\n\nBenefícios reales:\n• Ingresos por comisión sin techo ($5M–$20M/mes posibles)\n• Red de mentores y equipo de alto rendimiento\n• Apoyo activo en el proceso de reubicación\n• Productos premium: fincas, apartamentos, marinas\n\nPostúlate ahora y demos el primer paso juntos.',
    NULL, 'contact', 'COP', NULL, 'active', true, now(),
    ARRAY['empleo', 'medellin', 'costa-caribe', 'reubicacion', 'inmobiliaria', 'maia-management'],
    '[{"url": "/images/empleo-costa.jpg", "alt": "Trabaja en el Caribe", "order": 0}]'
  );

  -- 12. Cali → Costa
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images)
  VALUES (
    admin_user_id, v_cat_empleo, v_loc_cali,
    'Ven a la Costa – Asesor Comercial Finca Raíz (Barranquilla/Santa Marta)',
    'asesor-comercial-finca-raiz-costa-desde-cali-01',
    E'Desde Cali hasta el Caribe: MAIA Management te invita a construir tu carrera inmobiliaria en la Costa colombiana.\n\nEsta no es una oferta de empleo ordinaria. Es una invitación a cambiar de ciudad, de ritmo y de perspectiva — con el respaldo de una empresa sólida, un mercado inmobiliario en auge y un equipo que realmente invierte en su gente.\n\nLo que haces: asesorar compradores e inversores en propiedades premium en el Caribe.\nLo que recibes: comisiones altas, formación continua, acompañamiento en tu traslado.\n\nPerfil ideal: comercial, ambicioso, con ganas de un nuevo comienzo frente al mar.',
    NULL, 'contact', 'COP', NULL, 'active', false, now(),
    ARRAY['empleo', 'cali', 'barranquilla', 'santa-marta', 'reubicacion', 'maia-management'],
    '[{"url": "/images/empleo-costa.jpg", "alt": "Trabaja en el Caribe desde Cali", "order": 0}]'
  );

  -- 13. Bucaramanga → Costa
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images)
  VALUES (
    admin_user_id, v_cat_empleo, v_loc_buc,
    'Oportunidad en la Costa Caribe – Comercial Inmobiliario (MAIA)',
    'comercial-inmobiliario-costa-desde-bucaramanga-01',
    E'¿Estás en Bucaramanga buscando un nuevo horizonte? MAIA Management necesita personas con hambre de éxito para su equipo de ventas inmobiliarias en la Costa Caribe.\n\nEl mercado costero está en pleno crecimiento: turismo, inversión extranjera, proyectos de lujo. Sé parte del equipo que está moldeando ese mercado.\n\nOferemos:\n• Entrenamiento intensivo en ventas de finca raíz premium\n• Comisiones desde el primer mes\n• Relocalización asistida a Santa Marta, Barranquilla o Cartagena\n• Ambiente de trabajo positivo y de alto impacto\n\nNo dejes pasar esta oportunidad. El Caribe te espera.',
    NULL, 'contact', 'COP', NULL, 'active', false, now(),
    ARRAY['empleo', 'bucaramanga', 'costa-caribe', 'reubicacion', 'inmobiliaria', 'maia-management'],
    '[{"url": "/images/empleo-costa.jpg", "alt": "Trabajo en la Costa desde Bucaramanga", "order": 0}]'
  );

  -- 14. Cartagena (local) + nationwide recruitment
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images,
    is_nationwide)
  VALUES (
    admin_user_id, v_cat_empleo, NULL,
    'MAIA Management – Asesor Inmobiliario Costa Caribe (Todo Colombia)',
    'asesor-inmobiliario-costa-caribe-maia-management-nationwide-01',
    E'MAIA Management convoca asesores comerciales para trabajar en la Costa Caribe colombiana. Abierto a candidatos de todo Colombia dispuestos a reubicarse.\n\nSi estás en Bogotá, Medellín, Cali, Bucaramanga, Barranquilla, Pereira, Manizales, Cúcuta o cualquier otra ciudad — y sientes que es momento de un cambio real — esta es tu oportunidad.\n\nLa Costa no es solo un destino turístico: es el mercado inmobiliario de más rápido crecimiento en Colombia. Junta al equipo que lo está trabajando desde adentro.\n\nSalario base + comisiones sin techo. Apoyo en reubicación. Formación en MAIA Masters incluida.',
    NULL, 'contact', 'COP', NULL, 'active', true, now(),
    ARRAY['empleo', 'colombia', 'costa-caribe', 'reubicacion', 'inmobiliaria', 'maia-management'],
    '[{"url": "/images/empleo-costa.jpg", "alt": "MAIA Management Empleos", "order": 0}]',
    TRUE
  );

  -- ==========================================================
  -- MAIA MANAGEMENT: Tech Services (nationwide)
  -- ==========================================================

  -- 15. Desarrollo web, nationwide
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, condition, status, is_featured, published_at, tags, images,
    is_nationwide)
  VALUES (
    admin_user_id, v_cat_servicios_tech, NULL,
    'Diseño Web y Aplicaciones – MAIA Management (Toda Colombia)',
    'diseno-web-aplicaciones-maia-management-colombia-01',
    'MAIA Management desarrolla sitios web profesionales, tiendas online, apps móviles y sistemas de gestión para empresas en toda Colombia. Trabajamos 100% remoto con equipos de Barranquilla y Santa Marta. Tecnología: Next.js, React Native, WordPress, Shopify. Entrega ágil, calidad de exportación, precios justos para el mercado colombiano.',
    NULL, 'contact', 'COP', NULL, 'active', false, now(),
    ARRAY['web', 'desarrollo', 'apps', 'colombia', 'tecnologia', 'maia-management'],
    '[{"url": "/images/web-dev.jpg", "alt": "MAIA Desarrollo Web", "order": 0}]',
    TRUE
  );

  RAISE NOTICE 'MAIA ecosystem listings seeded successfully (15 listings)';
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION seed_maia_listings IS
  'Seeds 15 MAIA ecosystem listings across Colombia. Usage: SELECT seed_maia_listings(''your-admin-uuid'');';

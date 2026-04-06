-- ============================================================
-- Migration 012: Services Wanted + Offered + For Sale + Property + Community
-- Listings #108–155
-- Depends on: 008_seed_business_profiles.sql
-- ============================================================

DO $$
DECLARE
  v_sel_sanatorio UUID := 'a1b2c3d4-0001-0001-0001-000000000001';
  v_sel_masters   UUID := 'a1b2c3d4-0001-0001-0001-000000000003';
  v_sel_trivium   UUID := 'a1b2c3d4-0001-0001-0001-000000000004';
  v_sel_legal     UUID := 'a1b2c3d4-0001-0001-0001-000000000005';
  v_sel_mgmt      UUID := 'a1b2c3d4-0001-0001-0001-000000000006';
  v_sel_realty    UUID := 'a1b2c3d4-0001-0001-0001-000000000007';
  v_sel_bevida    UUID := 'a1b2c3d4-0001-0001-0001-000000000008';
  v_sel_aerial    UUID := 'a1b2c3d4-0001-0001-0001-000000000009';
  v_sel_lleva     UUID := 'a1b2c3d4-0001-0001-0001-000000000010';

  -- Categories
  v_cat_construccion UUID;
  v_cat_juridico     UUID;
  v_cat_financiero   UUID;
  v_cat_diseno       UUID;
  v_cat_otros_serv   UUID;
  v_cat_talleres     UUID;
  v_cat_oficinas     UUID;
  v_cat_lotes        UUID;
  v_cat_bodegas      UUID;
  v_cat_locales      UUID;
  v_cat_materiales   UUID;
  v_cat_eventos_loc  UUID;
  v_cat_varios       UUID;

  v_loc_smt UUID;
BEGIN

  SELECT id INTO v_cat_construccion FROM categories WHERE slug = 'construccion';
  SELECT id INTO v_cat_juridico     FROM categories WHERE slug = 'juridico';
  SELECT id INTO v_cat_financiero   FROM categories WHERE slug = 'financiero';
  SELECT id INTO v_cat_diseno       FROM categories WHERE slug = 'diseno';
  SELECT id INTO v_cat_otros_serv   FROM categories WHERE slug = 'otros-servicios';
  SELECT id INTO v_cat_talleres     FROM categories WHERE slug = 'talleres';
  SELECT id INTO v_cat_oficinas     FROM categories WHERE slug = 'oficinas';
  SELECT id INTO v_cat_lotes        FROM categories WHERE slug = 'lotes';
  SELECT id INTO v_cat_bodegas      FROM categories WHERE slug = 'bodegas';
  SELECT id INTO v_cat_locales      FROM categories WHERE slug = 'locales';
  SELECT id INTO v_cat_materiales   FROM categories WHERE slug = 'materiales';
  SELECT id INTO v_cat_eventos_loc  FROM categories WHERE slug = 'eventos-locales';
  SELECT id INTO v_cat_varios       FROM categories WHERE slug = 'varios';
  SELECT id INTO v_loc_smt          FROM locations  WHERE slug = 'santa-marta';

  -- ============================================================
  -- SERVICES WANTED (Servicios que se buscan) #108–127
  -- ============================================================

  -- #108 — Arquitecto patrimonial / PEMP
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_construccion, v_loc_smt,
    'SE BUSCA: Arquitecto/a Patrimonial con Experiencia PEMP — Santa Marta',
    'se-busca-arquitecto-patrimonial-pemp-108',
    E'El Sanatorio requiere asesoría de Arquitecto Patrimonial con experiencia en el Plan Especial de Manejo y Protección (PEMP) del Centro Histórico de Santa Marta.\n\nNuestro local está en la Calle 19 #4-23, dentro del perímetro de protección del Centro Histórico. Necesitamos:\n• Revisión de planos de adecuación para verificar cumplimiento PEMP\n• Acompañamiento ante el Ministerio de Cultura / Curaduria Urbana\n• Concepto técnico sobre intervención de fachada y estructura interior\n\nHonorarios a convenir. Se prefiere arquitecto con experiencia comprobable en proyectos similares en el Caribe colombiano.\n\nContacto: WhatsApp +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','arquitecto','patrimonial','pemp','centro-historico','santa-marta'],
    '[{"url":"/images/sanatorio-fachada.jpg","alt":"El Sanatorio Fachada","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #109 — Electricista (servicio)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_construccion, v_loc_smt,
    'SE BUSCA: Electricista para Locales Comerciales — Santa Marta',
    'se-busca-electricista-locales-comerciales-109',
    E'Maia Management Group busca electricista con experiencia en instalaciones comerciales para mantenimiento y obras en los diferentes locales del grupo en Santa Marta.\n\nTrabajos requeridos: revisión y certificación de instalaciones eléctricas, instalación de tomacorrientes y circuitos adicionales, reparaciones de emergencia.\n\nRequisitos: matrícula CONTE vigente, experiencia demostrable en locales comerciales. Trabajo recurrente para el electricista adecuado.\n\nContacto: WhatsApp +573001234567 con tarifas.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','electricista','locales-comerciales','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Electricista","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #110 — Plomero (servicio)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_construccion, v_loc_smt,
    'SE BUSCA: Plomero para Locales Comerciales — Santa Marta',
    'se-busca-plomero-locales-comerciales-110',
    E'Maia Management Group busca plomero con experiencia en instalaciones comerciales para mantenimiento recurrente y obras de adecuación.\n\nTrabajos: instalación de puntos hidráulicos en cocinas y baños, mantenimiento de redes de agua fría/caliente, instalación de sistemas de gas.\n\nRequisitos: experiencia mínima 3 años en plomería comercial, disponibilidad para Santa Marta Centro y otras zonas del Distrito. Trabajo recurrente garantizado.\n\nWhatsApp: +573001234567 con tarifas.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','plomero','fontanero','locales','comercial','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Plomero","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #111 — Pintor / decorador (servicio)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_construccion, v_loc_smt,
    'SE BUSCA: Pintor con Experiencia en Acabados Especiales — Santa Marta',
    'se-busca-pintor-acabados-especiales-111',
    E'El Sanatorio busca pintor con experiencia en acabados especiales, texturas y murales para la adecuación de nuestro local en el Centro Histórico de Santa Marta.\n\nTrabajos: pintura base en interiores con texturas envejecidas, efectos de humedad y deterioro controlado (estética horror), intervenciones murales en paredes principales.\n\nSe busca: pintor creativo con portafolio de acabados especiales. Trabajo por contrato de obra. Disponibilidad inmediata.\n\nPortafolio por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','pintor','acabados','murales','textura','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Pintura Acabados","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #112 — Carpintero / ebanista (servicio)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_construccion, v_loc_smt,
    'SE BUSCA: Carpintero / Ebanista para Mobiliario Temático — Santa Marta',
    'se-busca-carpintero-mobiliario-tematico-112',
    E'El Sanatorio busca carpintero o ebanista para fabricar el mobiliario artesanal del gastro bar y el Laberinto del Horror en el Centro de Santa Marta.\n\nProyecto: mesas y sillas estilo victoriano-horror en madera envejecida, puertas decorativas, paneles de madera para el laberinto, barra de bar.\n\nSe busca: artesano con experiencia en mobiliario personalizado, creatividad para interpretar diseños oscuros, disposición para trabajo en sitio.\n\nContacto con portafolio: WhatsApp +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','carpintero','ebanista','mobiliario','custom','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Carpintería","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #113 — Metalistero / fabricador metálico
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_construccion, v_loc_smt,
    'SE BUSCA: Metalistero / Fabricador Metálico — Estructuras y Decorado',
    'se-busca-metalistero-fabricador-metalico-113',
    E'El Sanatorio busca metalistero o fabricador metálico para estructuras decorativas y funcionales del local.\n\nProyecto: rejas decorativas de hierro forjado para ventanas y puertas, estructuras de soporte para el laberinto, mesas con patas de hierro, letreros metálicos.\n\nSe busca: herrero o metalistero con creatividad para estilo gótico-industrial. Trabajo por contrato de obra en Santa Marta.\n\nFotos de trabajos anteriores por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','metalistero','herrero','hierro','forjado','metalico','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Metalisterio","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #114 — Técnico HVAC / Aire acondicionado
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_construccion, v_loc_smt,
    'SE BUSCA: Técnico de Aire Acondicionado / HVAC — Santa Marta',
    'se-busca-tecnico-hvac-aire-acondicionado-114',
    E'Maia Management Group busca técnico de aires acondicionados para instalación y mantenimiento preventivo y correctivo en los locales del grupo en Santa Marta.\n\nTrabajos: instalación de unidades Split en oficinas y el restaurante, mantenimiento trimestral programado, reparaciones de emergencia.\n\nRequisitos: técnico certificado, disponibilidad en Santa Marta Centro, experiencia en equipos comerciales. Contrato de mantenimiento mensual disponible para el técnico adecuado.\n\nWhatsApp: +573001234567 con tarifas.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','hvac','aire-acondicionado','tecnico','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Aire Acondicionado","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #115 — Rotulista / letrero
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_diseno, v_loc_smt,
    'SE BUSCA: Rotulista / Fabricador de Letreros — Fachada y Señalética',
    'se-busca-rotulista-letreros-fachada-115',
    E'El Sanatorio busca rotulista o empresa de letrería para fabricar e instalar el letrero de fachada y la señalética interior del gastro bar.\n\nQué necesitamos:\n• Letrero principal de fachada iluminado (neón, acrílico retroiluminado o letra metálica volumétrica)\n• Señalética interior temática (baños, salidas, zonas del laberinto)\n• Menús de pizarrón y marcos personalizados\n\nEstilo: horror victoriano — oscuro, elegante, con detalles en rojo o dorado.\n\nPortafolio y presupuesto por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','rotulista','letrero','neon','fachada','señaletica','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Letrero Fachada","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #116 — Diseñador / muralista
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_diseno, v_loc_smt,
    'SE BUSCA: Diseñador Gráfico / Muralista — Concepto Horror Santa Marta',
    'se-busca-muralista-diseno-horror-116',
    E'El Sanatorio busca diseñador gráfico o muralista para la identidad visual del local y la ejecución de murales de pared.\n\nProyecto:\n• Murales temáticos horror-victoriano en paredes del salón y laberinto\n• Diseño de menú y carta de cócteles\n• Material gráfico para redes sociales (templates de marca)\n\nBuscamos artista con portafolio oscuro o de ilustración detallada. Se valora experiencia en interiorismo o proyectos de restaurante.\n\nPortafolio por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','muralista','disenador','grafico','horror','mural','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Muralista","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #117 — Proveedor de alimentos / catering
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_otros_serv, v_loc_smt,
    'SE BUSCA: Proveedor de Insumos y Alimentos — Restaurante Santa Marta',
    'se-busca-proveedor-insumos-alimentos-117',
    E'El Sanatorio busca proveedores de insumos para nuestra cocina de fusión japonesa-latina en Santa Marta.\n\nQué necesitamos:\n• Carnes y proteínas (res, cerdo, pollo, mariscos) en cortes para parrilla y yakitori\n• Verduras y vegetales frescos diarios\n• Insumos japoneses: salsa de soya, miso, sake, mirin, arroz japonés, algas\n• Condimentos y salsas artesanales\n\nBuscamos proveedores confiables con entrega diaria o interdiaria en Santa Marta Centro. Pedidos iniciales de volumen medio con posibilidad de crecimiento.\n\nContacto: WhatsApp +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','proveedor','alimentos','insumos','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Proveedor Alimentos","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #118 — Proveedor de productos del mar
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_otros_serv, v_loc_smt,
    'SE BUSCA: Proveedor de Mariscos y Pescados Frescos — Santa Marta',
    'se-busca-proveedor-mariscos-pescados-frescos-118',
    E'El Sanatorio busca proveedor directo de mariscos y pescados frescos para nuestra carta de cocina japonesa-latina en Santa Marta.\n\nQué necesitamos:\n• Camarón fresco (peladito y entero)\n• Pulpo y calamar frescos o ultracongelados de calidad\n• Pescado fresco del día (atún, pargo, sierra, mero)\n• Entregas 3–5 veces por semana, puntualidad indispensable\n\nPreferimos proveedores locales o de Barranquilla con cadena de frío certificada. Buenas condiciones de precio por volumen.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','proveedor','mariscos','pescado','fresco','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Mariscos Proveedor","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #119 — Distribuidor de licores al por mayor
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_otros_serv, v_loc_smt,
    'SE BUSCA: Distribuidor de Licores al por Mayor — Santa Marta',
    'se-busca-distribuidor-licores-mayor-119',
    E'El Sanatorio Gastro Bar busca distribuidor de licores al por mayor en Santa Marta para abastecer nuestra barra de coctelería.\n\nQué buscamos:\n• Ron (Dictador, Diplomático, Medellín, Don Pancho)\n• Vodka y Gin (Absolut, Tanqueray, Hendrick\'s, Gordon\'s)\n• Whisky y Bourbon (Jack Daniel\'s, Johnnie Walker, Jim Beam)\n• Licores nacionales y artesanales de la Costa\n• Vinos para cocina y carta\n\nBuscamos distribuidor con buenos precios, crédito a 30 días y entrega en Santa Marta. Volumen mensual estimado: alto para la escala del negocio.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','licores','distribuidor','mayorista','ron','bar','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Licores Mayorista","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #120 — Proveedor de empaques / packaging
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_bevida, v_cat_otros_serv, v_loc_smt,
    'SE BUSCA: Proveedor de Packaging / Empaques — Bebidas RTD Colombia',
    'se-busca-proveedor-packaging-bebidas-120',
    E'Be Vida Botánicas busca proveedor de empaques y packaging para nuestras bebidas artesanales.\n\nQué necesitamos:\n• Etiquetas adhesivas en material húmedo-resistente (BOPP o similar) — impresión digital\n• Tapas y sellos para envases de vidrio y PET\n• Cajas de cartón corrugado para transporte de 12 y 24 unidades\n• Tubos sellados para shots de fruta (PET o vidrio)\n\nBuscamos proveedor en Colombia con producción mínima flexible para PYME. Precios competitivos y tiempos de entrega cortos.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','packaging','empaques','etiquetas','bebidas','colombia'],
    '[{"url":"/images/placeholder.jpg","alt":"Packaging Bebidas","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #121 — Empresa de impresos / litografía
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_diseno, v_loc_smt,
    'SE BUSCA: Litografía / Empresa de Impresos — Santa Marta o Regional',
    'se-busca-litografia-impresos-regional-121',
    E'Maia Management Group busca empresa de impresión para cubrir las necesidades gráficas del grupo empresarial.\n\nQué necesitamos:\n• Tarjetas de presentación (varias marcas del grupo)\n• Flyers y volantes para eventos\n• Menús impresos y laminados para El Sanatorio\n• Pendones y banners\n• Etiquetas y material POP\n\nBuscamos litografía con buena calidad digital e impresión offset, que pueda manejar urgencias. Puede ser en Santa Marta o con servicio de envío.\n\nMuestras y cotizaciones por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','litografia','impresos','impresion','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Impresos","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #122 — Empresa de aseo / limpieza
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_otros_serv, v_loc_smt,
    'SE BUSCA: Empresa de Aseo / Limpieza para Locales Comerciales — Santa Marta',
    'se-busca-empresa-aseo-limpieza-comercial-122',
    E'Maia Management Group busca empresa de aseo o personal de limpieza para contrato mensual en los locales del grupo.\n\nServicios requeridos:\n• Limpieza profunda diaria de restaurante (El Sanatorio)\n• Aseo de oficinas (3 veces por semana)\n• Desinfección periódica de cocina y zonas de manipulación de alimentos\n• Manejo de desechos\n\nSe busca empresa formal o cooperativa con afiliación de personal a seguridad social. Contrato mensual con posibilidad de ampliar a más locales.\n\nCotización por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','aseo','limpieza','empresa','locales','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Empresa Aseo","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #123 — Empresa de seguridad privada
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_otros_serv, v_loc_smt,
    'SE BUSCA: Empresa de Vigilancia / Seguridad Privada — Santa Marta',
    'se-busca-empresa-vigilancia-seguridad-privada-123',
    E'Maia Management Group busca empresa de vigilancia y seguridad privada para brindar protección a los locales del grupo en Santa Marta.\n\nRequisitos:\n• Vigilantes certificados con tarjeta de miembro activo SuperVigilancia\n• Cobertura nocturna y de fin de semana para El Sanatorio\n• Protección de oficinas (turno diurno)\n• Capacidad de respuesta ante emergencias\n\nSe prefieren empresas con supervisión activa de personal y monitoreo en tiempo real.\n\nCotizaciones por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','seguridad','vigilancia','empresa','locales','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Seguridad Privada","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- SERVICES OFFERED (Servicios que se ofrecen) #124–136
  -- ============================================================

  -- #124 — Constitución de S.A.S. (Maia Legal)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_legal, v_cat_juridico, v_loc_smt,
    'Constitución de Empresa S.A.S. en Colombia — desde USD $1.200 | Maia Legal',
    'constitucion-empresa-sas-colombia-maia-legal-124',
    E'Maia Legal te acompaña en todo el proceso de constitución de tu empresa S.A.S. en Colombia, desde la redacción de estatutos hasta la inscripción en Cámara de Comercio y DIAN.\n\nServicio incluye:\n✓ Asesoría previa sobre estructura societaria\n✓ Redacción de estatutos personalizada\n✓ Acta de constitución\n✓ Inscripción ante Cámara de Comercio de Santa Marta\n✓ RUT y NIT ante DIAN\n✓ Apertura de cuenta bancaria empresarial (orientación)\n\nTiempo estimado: 5–10 días hábiles.\nTarifa: desde USD $1.200 (pago en COP al TRM del día).\n\nAtendemos colombianos y extranjeros. Inglés disponible.\n\nWhatsApp: +573001234567',
    1200.00, 'fixed', 'USD', 'active', now(),
    ARRAY['servicio','juridico','sas','empresa','constitucion','colombia','extranjeros'],
    '[{"url":"/images/maia-legal.jpg","alt":"Maia Legal SAS","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #125 — Visa de inversión / pensionado / matrimonio (Maia Legal)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_legal, v_cat_juridico, v_loc_smt,
    'Trámites de Visa para Colombia — Inversión, Pensionado, Matrimonio | Maia Legal',
    'tramites-visa-colombia-inversion-pensionado-maia-legal-125',
    E'Maia Legal ofrece asesoría y trámite completo de visas colombianas para extranjeros que desean vivir, invertir o retirarse en Colombia.\n\nVisas que tramitamos:\n• Visa M (migrante) por inversión — desde USD $800\n• Visa de pensionado — desde USD $800\n• Visa de cónyuge o compañero/a permanente\n• Visa de inversionista acreditado\n\nServicio incluye: evaluación de elegibilidad, compilación de documentos, apostilla, presentación ante Cancillería, seguimiento hasta resolución.\n\nExperiencia con clientes de EE.UU., Canadá, Europa, Australia y Latinoamérica.\n\nConsulta inicial gratuita por WhatsApp: +573001234567',
    800.00, 'fixed', 'USD', 'active', now(),
    ARRAY['servicio','visa','colombia','inversion','pensionado','extranjeros','maia-legal'],
    '[{"url":"/images/maia-legal.jpg","alt":"Maia Legal Visa","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #126 — Declaración de renta anual (Maia Legal / Emanuel)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_legal, v_cat_financiero, v_loc_smt,
    'Declaración de Renta Anual Colombia — desde $1.600.000 COP | Maia Legal',
    'declaracion-renta-anual-colombia-maia-legal-126',
    E'Maia Legal y nuestro equipo contable ofrecen preparación y presentación de declaraciones de renta para personas naturales y jurídicas en Colombia.\n\nServicio incluye:\n✓ Análisis de ingresos, deducciones y rentas exentas\n✓ Revisión de facturas y gastos deducibles\n✓ Preparación de la declaración en el formulario DIAN\n✓ Presentación electrónica y comprobante\n✓ Asesoría sobre pagos o devoluciones\n\nTarifas:\n• Persona natural asalariada: desde $1.600.000 COP\n• Persona natural con actividad independiente: desde $2.200.000 COP\n• Persona jurídica (empresa): cotización según complejidad\n\nAtendemos colombianos residentes y extranjeros con obligación fiscal en Colombia.\n\nWhatsApp: +573001234567',
    1600000.00, 'fixed', 'COP', 'active', now(),
    ARRAY['servicio','contabilidad','renta','dian','declaracion','colombia','maia-legal'],
    '[{"url":"/images/maia-legal.jpg","alt":"Declaración Renta","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #127 — Paquetes de contabilidad mensual (Maia Management)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_financiero, v_loc_smt,
    'Paquetes de Contabilidad Mensual para Empresas — desde $1.400.000/mes | Maia Management',
    'paquetes-contabilidad-mensual-empresas-maia-management-127',
    E'Maia Management Group ofrece paquetes de contabilidad mensual para pequeñas y medianas empresas en Colombia.\n\nQué incluye el servicio:\n✓ Causación de facturas de compra y venta\n✓ Conciliaciones bancarias\n✓ Liquidación de impuestos bimestrales (IVA, ICA)\n✓ Retención en la fuente\n✓ Estados financieros mensuales (PyG, Balance)\n✓ Informe de gestión a gerencia\n\nPaquetes desde $1.400.000 COP/mes según volumen de transacciones.\n\nEspecialistas en restaurantes, agencias y empresas de servicios. Trabajo 100% remoto con reunión virtual mensual.\n\nConsulta gratis: WhatsApp +573001234567',
    1400000.00, 'fixed', 'COP', 'active', now(),
    ARRAY['servicio','contabilidad','mensual','empresa','pyme','maia-management'],
    '[{"url":"/images/maia-management.jpg","alt":"Contabilidad Mensual","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #128 — Facturación electrónica y DIAN (Maia Management)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_financiero, v_loc_smt,
    'Facturación Electrónica — Habilitación DIAN y Acompañamiento | Maia Management',
    'facturacion-electronica-dian-habilitacion-128',
    E'Maia Management Group te ayuda a implementar la facturación electrónica en tu empresa colombiana, desde el trámite ante la DIAN hasta la activación del software.\n\nServicio incluye:\n✓ Registro como facturador electrónico ante DIAN\n✓ Selección y configuración del proveedor tecnológico (Siigo, Alegra, Factus, etc.)\n✓ Capacitación al equipo en el uso del sistema\n✓ Soporte en los primeros 30 días de operación\n✓ Revisión de primeros documentos electrónicos\n\nTarifa: desde $800.000 COP (pago único). Mantenimiento mensual disponible.\n\nWhatsApp: +573001234567',
    800000.00, 'fixed', 'COP', 'active', now(),
    ARRAY['servicio','facturacion','electronica','dian','colombia','pyme'],
    '[{"url":"/images/maia-management.jpg","alt":"Facturación Electrónica","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #129 — Consultoría DIAN / cumplimiento fiscal
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_financiero, v_loc_smt,
    'Consultoría DIAN y Cumplimiento Fiscal — Colombia | Maia Management',
    'consultoria-dian-cumplimiento-fiscal-129',
    E'Maia Management Group ofrece asesoría en cumplimiento fiscal y gestión ante la DIAN para empresas y personas naturales en Colombia.\n\nServicios:\n• Revisión de obligaciones tributarias\n• Respuesta a requerimientos de la DIAN\n• Gestión de devoluciones de IVA\n• Planeación tributaria\n• Asesoría a extranjeros con actividad económica en Colombia\n\nAtendemos empresas de todos los tamaños. Honorarios desde $500.000 COP según complejidad del caso.\n\nConsulta inicial sin costo: WhatsApp +573001234567',
    500000.00, 'negotiable', 'COP', 'active', now(),
    ARRAY['servicio','dian','fiscal','tributario','colombia','maia-management'],
    '[{"url":"/images/maia-management.jpg","alt":"Consultoría DIAN","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #130 — Reclutamiento y colocación de personal (Maia Management)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_otros_serv, v_loc_smt,
    'Reclutamiento y Colocación de Personal — Costa Caribe | Maia Management',
    'reclutamiento-colocacion-personal-costa-caribe-130',
    E'Maia Management Group ofrece servicio de reclutamiento, selección y colocación de personal para empresas en Santa Marta y la Costa Caribe colombiana.\n\nQué ofrecemos:\n✓ Publicación de vacantes en múltiples canales\n✓ Filtro de hojas de vida y preselección\n✓ Entrevistas y pruebas psicotécnicas básicas\n✓ Verificación de referencias\n✓ Presentación de terna finalista\n✓ Apoyo en contratación y onboarding\n\nEspecialidad: hospitalidad, gastronomía, servicio al cliente, administrativo y técnico.\n\nTarifa: equivalente a 1 salario mensual bruto del cargo por candidato exitoso.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['servicio','reclutamiento','seleccion','personal','rrhh','santa-marta'],
    '[{"url":"/images/maia-management.jpg","alt":"Reclutamiento RRHH","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #131 — Contratos de trabajo (Maia Legal)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_legal, v_cat_juridico, v_loc_smt,
    'Redacción de Contratos Laborales — Colombia | Maia Legal',
    'redaccion-contratos-laborales-colombia-maia-legal-131',
    E'Maia Legal redacta contratos de trabajo a la medida para empresas y empleadores en Colombia, cumpliendo con el Código Sustantivo del Trabajo y la normativa vigente.\n\nTipos de contratos:\n• Término fijo (1, 3, 6 o 12 meses)\n• Término indefinido\n• Por obra o labor\n• Prestación de servicios\n• Para trabajadores extranjeros\n\nTarifa por contrato: desde $350.000 COP. Paquetes para múltiples contratos disponibles.\n\nTambién: revisión de contratos existentes, cláusulas de confidencialidad, acuerdos de no competencia.\n\nWhatsApp: +573001234567',
    350000.00, 'fixed', 'COP', 'active', now(),
    ARRAY['servicio','contrato','laboral','juridico','colombia','maia-legal'],
    '[{"url":"/images/maia-legal.jpg","alt":"Contratos Laborales","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #132 — Nómina / payroll (Maia Management)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_financiero, v_loc_smt,
    'Liquidación de Nómina — Outsourcing Nómina Colombia | Maia Management',
    'liquidacion-nomina-outsourcing-colombia-132',
    E'Maia Management Group ofrece servicio de outsourcing de nómina para empresas colombianas.\n\nServicio incluye:\n✓ Liquidación mensual de salarios\n✓ Cálculo de horas extras, recargos nocturnos y dominicales\n✓ Prestaciones sociales (cesantías, prima, vacaciones)\n✓ Planilla PILA (seguridad social)\n✓ Certificados laborales\n✓ Liquidaciones y paz y salvos\n\nDesde $600.000 COP/mes para empresas hasta 5 empleados. Precio escala según número de trabajadores.\n\nAtendemos empresas en toda Colombia de forma remota.\n\nWhatsApp: +573001234567',
    600000.00, 'fixed', 'COP', 'active', now(),
    ARRAY['servicio','nomina','payroll','outsourcing','colombia','maia-management'],
    '[{"url":"/images/maia-management.jpg","alt":"Nómina Outsourcing","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #133 — Cursos digitales Maia Masters
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_masters, v_cat_talleres, v_loc_smt,
    'Cursos de Habilidades Digitales — Bootcamp Maia Masters Academy | Santa Marta',
    'cursos-habilidades-digitales-bootcamp-maia-masters-133',
    E'Maia Masters Academy ofrece bootcamps intensivos de habilidades digitales en Santa Marta para personas que quieren actualizarse o cambiar su perfil profesional.\n\nProgramas disponibles:\n📱 Marketing Digital y Redes Sociales — 4 semanas\n🤖 Inteligencia Artificial para el Trabajo — 3 semanas\n💼 Inglés para Negocios — 6 semanas\n🚀 Emprendimiento Digital — 4 semanas\n\nTarifas: desde $1.000.000 COP por módulo / $2.200.000 COP programa completo.\nGrupos pequeños, aprendizaje práctico, certificado de finalización.\nSede: Centro Histórico, Santa Marta.\n\nInformación e inscripciones: WhatsApp +573001234567',
    1000000.00, 'fixed', 'COP', 'active', now(),
    ARRAY['educacion','curso','digital','marketing','ia','ingles','santa-marta','maia-masters'],
    '[{"url":"/images/maia-masters.jpg","alt":"Maia Masters Academy","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #134 — Buyer's agent para extranjeros (Maia Realty)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_realty, v_cat_otros_serv, v_loc_smt,
    '¿Comprando Propiedad en Santa Marta? — Buyer\'s Agent para Extranjeros | Maia Realty',
    'buyers-agent-propiedad-santa-marta-extranjeros-maia-realty-134',
    E'Maia Realty ofrece servicio de buyer\'s agent para extranjeros que quieren comprar propiedad en Santa Marta y la Costa Caribe colombiana.\n\nCómo te ayudamos:\n✓ Búsqueda personalizada según tu presupuesto y estilo de vida\n✓ Visitas y evaluación de propiedades en tu nombre\n✓ Negociación del precio con el vendedor\n✓ Coordinación con notaría y estudio de títulos\n✓ Acompañamiento hasta escrituración y entrega\n✓ Asesoría sobre financiación y visas\n\nComisión: 3% del valor de compra (pagado por el comprador). Sin costo hasta encontrar la propiedad correcta.\n\nHablamos inglés. Inglés y español disponibles.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['servicio','inmobiliaria','buyers-agent','extranjeros','santa-marta','maia-realty'],
    '[{"url":"/images/maia-realty.jpg","alt":"Maia Realty Buyer Agent","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #135 — Estrategia de marca y marketing (Maia Management)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images, is_nationwide)
  VALUES (v_sel_mgmt, v_cat_diseno, NULL,
    'Consultoría de Marca y Marketing para Negocios — Maia Management Group',
    'consultoria-marca-marketing-negocios-maia-management-135',
    E'Maia Management Group ofrece consultoría estratégica de marca y marketing para negocios en Colombia y la región.\n\nQué incluye:\n• Diagnóstico de marca actual\n• Definición de propuesta de valor y posicionamiento\n• Estrategia de contenido para redes sociales\n• Plan de marketing digital (Meta Ads, Google Ads, SEO básico)\n• Diseño o rediseño de identidad visual\n• Acompañamiento mensual\n\nAtendemos restaurantes, hoteles, clínicas, academias y negocios de servicios.\n\nHonorarios desde $2.500.000 COP por proyecto o desde $1.500.000 COP/mes de acompañamiento.\n\nAgenda tu consulta inicial gratuita: WhatsApp +573001234567',
    2500000.00, 'negotiable', 'COP', 'active', now(),
    ARRAY['servicio','marca','marketing','estrategia','branding','colombia'],
    '[{"url":"/images/maia-management.jpg","alt":"Consultoría Marca","order":0}]',
    TRUE
  ) ON CONFLICT (slug) DO NOTHING;

  -- #136 — Desarrollo web (Nicole / Maia)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images, is_nationwide)
  VALUES (v_sel_mgmt, v_cat_diseno, NULL,
    'Desarrollo de Páginas Web para Negocios — Colombia | Maia Group',
    'desarrollo-paginas-web-negocios-colombia-136',
    E'Maia Group ofrece desarrollo de páginas web profesionales para negocios colombianos y de la región.\n\nQué hacemos:\n✓ Landing pages de alto impacto\n✓ Sitios web corporativos (5–10 páginas)\n✓ Tiendas en línea / e-commerce\n✓ Integración de WhatsApp Business y Google Analytics\n✓ SEO básico y velocidad optimizada\n✓ Dominio y hosting incluidos en planes anuales\n\nTecnologías: Next.js, WordPress, Webflow según proyecto.\nEntrega en 2–4 semanas.\nDesde $3.500.000 COP. Mantenimiento mensual desde $400.000 COP/mes.\n\nContacto y portafolio: WhatsApp +573001234567',
    3500000.00, 'fixed', 'COP', 'active', now(),
    ARRAY['servicio','web','desarrollo','pagina-web','negocio','colombia','nextjs'],
    '[{"url":"/images/maia-management.jpg","alt":"Desarrollo Web","order":0}]',
    TRUE
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- FOR SALE (Productos en venta) #137–141
  -- ============================================================

  -- #137 — Be Vida Drinks — barriles B2B
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_bevida, v_cat_materiales, v_loc_smt,
    'Be Vida Drinks — Bebidas Tropicales en Barril Sankey 20L (Canal B2B)',
    'be-vida-drinks-barril-sankey-20l-b2b-137',
    E'Be Vida Botánicas pone a disposición del canal B2B (bares, hoteles, restaurantes y tiendas) nuestras bebidas RTD en formato Sankey 20L.\n\nProductos disponibles:\n🌿 Cóctel tropical de guanábana y jengibre\n🍍 Cóctel de piña y hierbabuena con toque de ron\n🌺 Agua de Jamaica con jengibre y menta\n🍋 Limonada de coco con maracuyá\n\nFormato Sankey 20L — listo para conectar a tu grifo. Mínimo de pedido: 2 barriles por referencia.\n\nInteresados en distribución o punto de venta: WhatsApp +573001234567\nMuestras disponibles para prueba.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['venta','be-vida','bebidas','barril','sankey','b2b','tropical','santa-marta'],
    '[{"url":"/images/llave-labs.jpg","alt":"Be Vida Drinks Barril","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #138 — Be Vida Shots
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_bevida, v_cat_materiales, v_loc_smt,
    'Be Vida Shots — Tubos de Fruta Tropical Sellados | Venta al por Mayor',
    'be-vida-shots-fruta-tropical-venta-mayor-138',
    E'Be Vida Botánicas lanza su línea de Shots de Fruta Tropical en tubos sellados, ideales para venta en bares, playas, tiendas y eventos.\n\nVariedades:\n• Maracuyá + ginger + toque de ron\n• Guayaba + cítrico + hierbabuena\n• Mango + ají + limón\n• Tamarindo + panela + lima\n\nFormatos de venta:\n• Pack x4 shots — venta al detal\n• Pack x10 shots — venta horeca/tiendas\n• Caja x60 shots — venta mayorista\n\nProducto artesanal, sin conservantes artificiales. Fecha de vencimiento: 30 días refrigerado.\n\nPedidos y distribución: WhatsApp +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['venta','be-vida','shots','fruta','tropical','bar','evento','santa-marta'],
    '[{"url":"/images/llave-labs.jpg","alt":"Be Vida Shots","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #139 — Majín seasoning
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_bevida, v_cat_materiales, v_loc_smt,
    'Majín Seasoning — Sazonador Artesanal en 3-Pack | Pre-Venta Santa Marta',
    'majin-seasoning-sazonador-artesanal-3pack-139',
    E'¡Muy pronto! Majín es el sazonador artesanal de la Costa Caribe — mezcla de especias locales, chiles secos y toques tropicales desarrollada por el equipo de Be Vida Botánicas.\n\nFormato de lanzamiento: 3-pack de sobres individuales (perfecto para regalo o prueba).\n\nUsos: carnes a la parrilla, pollo al horno, mariscos, patacones, frito mixto y mucho más.\n\n⚠️ En espera de aprobación INVIMA — disponible en pre-venta con entrega estimada en 60 días.\n\nReserva tu 3-pack: WhatsApp +573001234567\nPromotores y distribuidores bienvenidos.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['venta','majin','sazonador','condimento','artesanal','costa','santa-marta','preventa'],
    '[{"url":"/images/llave-labs.jpg","alt":"Majín Seasoning","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #140 — El Sanatorio: tickets y reservas
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_eventos_loc, v_loc_smt,
    'Entradas y Reservas — El Sanatorio Gastro Bar + Laberinto del Horror | Santa Marta',
    'entradas-reservas-el-sanatorio-laberinto-140',
    E'Reserva tu experiencia en El Sanatorio — el único gastro bar de terror en la Costa Caribe colombiana.\n\n📍 Calle 19 #4-23, Centro Histórico de Santa Marta\n\n🍣 Gastro Bar: cocina de fusión japonesa-latina con yakitori, tapas y cócteles artesanales. Reserva mesa para 2–30 personas. Sin costo de reserva.\n\n👻 Laberinto del Horror: la experiencia de terror más perturbadora de Santa Marta. Grupos de hasta 6 personas por sesión.\n• Precio por persona: a confirmar en apertura\n• Duración: 20–30 minutos de terror garantizado\n• No recomendado para menores de 14 años, embarazadas o personas con condiciones cardíacas\n\n🎉 Eventos privados: cumpleaños, despedidas, corporativos. Capacidad hasta 80 personas.\n\nReservas solo por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['evento','el-sanatorio','reservas','laberinto','horror','restaurante','santa-marta'],
    '[{"url":"/images/sanatorio-salon.jpg","alt":"El Sanatorio Evento","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #141 — Maia Masters: inscripciones a cursos
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_masters, v_cat_talleres, v_loc_smt,
    'Inscripción a Bootcamp — Maia Masters Academy | Cohorte Cero Santa Marta',
    'inscripcion-bootcamp-maia-masters-cohorte-cero-141',
    E'Inscríbete en la Cohorte Cero de Maia Masters Academy — nuestro grupo fundador con descuento de lanzamiento.\n\n🎓 Programas disponibles:\n• Marketing Digital + IA: 6 semanas — $1.800.000 COP\n• Inglés para Negocios: 8 semanas — $1.400.000 COP  \n• Emprendimiento Digital: 4 semanas — $1.000.000 COP\n• Programa Completo: $2.200.000 COP (ahorra $1.000.000)\n\nCohorte Cero: grupos máximo 15 personas, atención personalizada, sesiones prácticas, certificado digital.\n\n📍 Sede: Centro Histórico, Santa Marta\n🗓️ Inicio: próxima fecha disponible — consultar\n\n¿Quieres más información? WhatsApp +573001234567',
    1000000.00, 'fixed', 'COP', 'active', now(),
    ARRAY['educacion','bootcamp','maia-masters','digital','ia','ingles','santa-marta'],
    '[{"url":"/images/maia-masters.jpg","alt":"Maia Masters Inscripción","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- PROPERTY — Inmuebles buscados / ofrecidos #142–145
  -- ============================================================

  -- #142 — Espacio de oficina buscado (Maia Masters)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_masters, v_cat_oficinas, v_loc_smt,
    'SE BUSCA: Local u Oficina para Academia — Centro Histórico Santa Marta',
    'se-busca-local-oficina-academia-centro-historico-142',
    E'Maia Masters Academy busca local comercial u oficina para instalar nuestra academia de habilidades digitales en el Centro Histórico de Santa Marta.\n\nCaracterísticas ideales:\n• Área: 80–200 m² útiles\n• Planta baja o primer piso (accesible para estudiantes)\n• Buena ventilación natural o con posibilidad de instalar aires\n• Conexión eléctrica robusta (aulas con muchos dispositivos)\n• En el perímetro del Centro Histórico o sectores aledaños (El Prado, Mamatoco)\n\nSe evalúan: arriendo, comodato o compra. Presupuesto: hasta $3.500.000 COP/mes en arriendo.\n\nContacto: WhatsApp +573001234567',
    3500000.00, 'negotiable', 'COP', 'active', now(),
    ARRAY['inmueble','local','oficina','academia','centro-historico','santa-marta','arriendo'],
    '[{"url":"/images/maia-masters.jpg","alt":"Local Academia","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #143 — Finca / tierra para turismo de aventura (Maia Aerial)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_aerial, v_cat_lotes, v_loc_smt,
    'SE BUSCA: Finca / Terreno en Sierra Nevada para Parque de Aventura | Maia Aerial',
    'se-busca-finca-terreno-sierra-nevada-aventura-maia-aerial-143',
    E'Maia Aerial busca finca o terreno en las estribaciones de la Sierra Nevada de Santa Marta para desarrollar un parque de aventura aérea (canopy, tirolinas, senderismo y ecoturismo).\n\nQué buscamos:\n• Área mínima: 5 hectáreas\n• Altitud: 400–1.200 m.s.n.m.\n• Topografía: ondulada o con desniveles aptos para tirolinas\n• Acceso vehicular desde Santa Marta máximo 1 hora\n• Agua disponible (quebrada, nacimiento o pozo)\n\nSe evalúan: compra, arriendo de largo plazo o asociación con propietario.\n\nNos interesa el sector de San Pedro de la Sierra, Minca o Ciénaga.\n\nContacto: WhatsApp +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['inmueble','finca','terreno','sierra-nevada','ecoturismo','aventura','maia-aerial'],
    '[{"url":"/images/maia-aerial.jpg","alt":"Finca Sierra Nevada","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #144 — Bodega en Barranquilla o Santa Marta (Be Vida)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_bevida, v_cat_bodegas, v_loc_smt,
    'SE BUSCA: Bodega Industrial para Producción de Bebidas — Barranquilla o Santa Marta',
    'se-busca-bodega-industrial-produccion-bebidas-144',
    E'Be Vida Botánicas busca bodega o local industrial para expandir la capacidad de producción de nuestra línea de bebidas artesanales RTD.\n\nCaracterísticas requeridas:\n• Área: 200–600 m²\n• Zona industrial o semiindustrial (no residencial)\n• Tres fases eléctricas disponibles\n• Piso en concreto liso, fácil de lavar\n• Baños y zona de vestieres para operarios\n• Acceso para camión de carga\n\nUbicación ideal: Barranquilla zona industrial (Murillo, Galapa) o Santa Marta área de Mamatoco / Terminal.\n\nSe evalúan: arriendo mensual o arriendo con opción de compra.\n\nContacto: WhatsApp +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['inmueble','bodega','industrial','produccion','barranquilla','santa-marta','be-vida'],
    '[{"url":"/images/placeholder.jpg","alt":"Bodega Industrial","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #145 — Buyer's agent promo (Maia Realty)
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_realty, v_cat_locales, v_loc_smt,
    '¿Comprando en Santa Marta? Te Acompañamos Gratis Hasta Encontrar la Propiedad | Maia Realty',
    'comprando-santa-marta-maia-realty-buyer-agent-145',
    E'Maia Realty es tu buyer\'s agent en Santa Marta — trabajamos para ti, no para el vendedor.\n\nNuestro servicio de representación de comprador incluye:\n✓ Búsqueda personalizada de propiedades según tu perfil\n✓ Evaluación imparcial de cada opción\n✓ Negociación del mejor precio en tu nombre\n✓ Estudio de títulos y due diligence\n✓ Coordinación con notaría y banco (si aplica)\n✓ Soporte post-compra\n\nSin costo hasta que encontremos tu propiedad. Nuestra comisión (3%) la pagas en el cierre.\n\nAtendemos en inglés y español. Hemos ayudado a compradores de EE.UU., Europa y Latinoamérica.\n\n📲 Primera consulta gratis: WhatsApp +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['inmobiliaria','buyer-agent','santa-marta','propiedad','extranjeros','maia-realty'],
    '[{"url":"/images/maia-realty.jpg","alt":"Maia Realty Comprador","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- COMMUNITY / ANNOUNCEMENTS #146–150
  -- ============================================================

  -- #146 — El Sanatorio: anuncio de apertura
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_eventos_loc, v_loc_smt,
    '¡El Sanatorio Abre sus Puertas en Santa Marta! — Gastro Bar + Laberinto del Horror',
    'anuncio-apertura-el-sanatorio-santa-marta-146',
    E'Santa Marta, te lo advertimos: EL SANATORIO ya está aquí. 👻\n\nEl primer gastro bar de terror del Caribe colombiano abre sus puertas en el corazón del Centro Histórico — Calle 19 #4-23.\n\n🍣 Cocina de fusión japonesa-latina con especialidad en yakitori y tapas creativas\n🍹 Barra de cócteles artesanales\n👻 Laberinto del Horror — si te atreves a entrar\n\nHorarios de apertura:\n🍽️ Restaurante: martes a domingo, 12:00–23:00\n🎭 Laberinto: viernes y sábados desde las 18:00\n\nReservas por WhatsApp: +573001234567\n\n¿Estás listo para cenar en el lado oscuro?',
    NULL, 'free', 'COP', 'active', now(),
    ARRAY['anuncio','apertura','el-sanatorio','gastrobar','laberinto','horror','santa-marta'],
    '[{"url":"/images/sanatorio-fachada.jpg","alt":"El Sanatorio Apertura","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #147 — Maia Masters: día de puertas abiertas
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_masters, v_cat_eventos_loc, v_loc_smt,
    'Jornada de Puertas Abiertas — Maia Masters Academy | Próximamente Santa Marta',
    'puertas-abiertas-maia-masters-academy-santa-marta-147',
    E'¡Te invitamos a conocer Maia Masters Academy antes de inscribirte!\n\n📅 Jornada de Puertas Abiertas — próxima fecha a confirmar\n📍 Centro Histórico, Santa Marta (dirección por WhatsApp)\n\nEn la jornada podrás:\n• Conocer las instalaciones y el equipo de instructores\n• Asistir a una clase demo de 30 minutos\n• Resolver tus dudas sobre los programas y costos\n• Inscribirte con precio de Cohorte Cero (descuento de lanzamiento)\n\nCursos disponibles: Marketing Digital, IA para el Trabajo, Inglés para Negocios, Emprendimiento Digital.\n\n🎁 Asistentes a la jornada: clase bonus incluida en la primera semana.\n\nReserva tu lugar (cupos limitados): WhatsApp +573001234567',
    NULL, 'free', 'COP', 'active', now(),
    ARRAY['evento','puertas-abiertas','maia-masters','academia','digital','santa-marta'],
    '[{"url":"/images/maia-masters.jpg","alt":"Maia Masters Puertas Abiertas","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #148 — Trivium Magnum: noche de información para padres
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_trivium, v_cat_eventos_loc, v_loc_smt,
    'Noche de Información para Padres Fundadores — Trivium Magnum International School',
    'noche-informacion-padres-fundadores-trivium-magnum-148',
    E'Trivium Magnum International School for Boys invita a padres y madres interesados en conocer el proyecto educativo de la primera escuela masculina de formación clásica en la Costa Caribe colombiana.\n\n📅 Fecha: a confirmar — inscríbase para recibir la convocatoria\n📍 Lugar: Centro Histórico, Santa Marta\n\nEn la velada conocerás:\n• La filosofía educativa del Trivium (Gramática, Retórica y Lógica)\n• El perfil del rector y el equipo docente\n• El currículo bilingüe y la metodología clásica\n• El proceso de matrícula para la primera cohorte\n• Las instalaciones provisionales y el plan de largo plazo\n\nPlazas fundadoras limitadas con condiciones especiales de matrícula.\n\nInscripción para recibir invitación: WhatsApp +573001234567',
    NULL, 'free', 'COP', 'active', now(),
    ARRAY['evento','trivium','colegio','educacion','clasica','padres','santa-marta'],
    '[{"url":"/images/trivium-magnum.jpg","alt":"Trivium Magnum Padres","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #149 — Be Vida: convocatoria de clientes B2B
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_bevida, v_cat_varios, v_loc_smt,
    'Be Vida Botánicas — Convocatoria de Distribuidores y Clientes B2B | Santa Marta',
    'be-vida-botanicas-convocatoria-distribuidores-b2b-149',
    E'Be Vida Botánicas abre convocatoria para distribuidores y clientes B2B en Santa Marta y la Costa Caribe.\n\nSomos una productora artesanal de bebidas tropicales RTD (ready-to-drink): cócteles botánicos en barril Sankey 20L y shots de fruta sellados.\n\n¿A quién buscamos?\n🍹 Bares y coctelerías que quieran añadir líneas artesanales locales\n🏨 Hoteles y resorts que busquen bebidas premium locales para su oferta\n🛒 Tiendas y licorerías interesadas en distribución\n🚚 Distribuidores de bebidas con red de clientes en la Costa\n\nCondiciones comerciales: precio mayorista, crédito a 15 días para cuentas establecidas, muestra sin costo para primeros pedidos.\n\nContáctanos: WhatsApp +573001234567\n¡Apoya lo artesanal, apoya la Costa!',
    NULL, 'free', 'COP', 'active', now(),
    ARRAY['anuncio','be-vida','b2b','distribuidores','bebidas','santa-marta','artesanal'],
    '[{"url":"/images/llave-labs.jpg","alt":"Be Vida B2B","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- #150 — LlevaLleva: anuncio de lanzamiento
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images, is_nationwide)
  VALUES (v_sel_lleva, v_cat_varios, NULL,
    '¡LlevaLleva Ya Está en Santa Marta! — Publica Tu Aviso Gratis Hoy',
    'llevalleva-lanzamiento-santa-marta-publica-gratis-150',
    E'LlevaLleva es la nueva plataforma de clasificados hecha para Colombia — y empezamos aquí en Santa Marta. 🌊\n\n¿Qué puedes hacer en LlevaLleva?\n✅ Publicar empleos, servicios, productos y propiedades — GRATIS\n✅ Encontrar trabajo local o regional\n✅ Vender lo que no usas\n✅ Contratar servicios y profesionales\n✅ Descubrir negocios locales\n\n¿Por qué LlevaLleva?\n• 100% colombiana, hecha para la Costa\n• Sin comisiones en compra-venta directa\n• WhatsApp integrado — contacta directo, sin intermediarios\n• Categorías para todo: empleo, inmuebles, servicios, vehículos y más\n\n📲 Publica tu primer aviso hoy en www.llevalleva.co\n¡Sin costo, sin trámites, sin complicaciones!\n\nContacto: +573001234567',
    NULL, 'free', 'COP', 'active', now(),
    ARRAY['anuncio','llevalleva','clasificados','colombia','santa-marta','gratis','lanzamiento'],
    '[{"url":"/images/llevalleva-dev.jpg","alt":"LlevaLleva Lanzamiento","order":0}]',
    TRUE
  ) ON CONFLICT (slug) DO NOTHING;

  RAISE NOTICE 'Migration 012 complete: services-wanted #108–123, services-offered #124–136, for-sale #137–141, property #142–145, community #146–150';

END $$;

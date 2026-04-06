-- ============================================================
-- Migration 011: Equipment Wanted Listings (#79–107)
-- All posted by El Sanatorio or Maia Management Group
-- Depends on: 008_seed_business_profiles.sql
-- ============================================================

DO $$
DECLARE
  v_sel_sanatorio UUID := 'a1b2c3d4-0001-0001-0001-000000000001';
  v_sel_mgmt      UUID := 'a1b2c3d4-0001-0001-0001-000000000006';
  v_sel_bevida    UUID := 'a1b2c3d4-0001-0001-0001-000000000008';

  v_cat_maquinaria  UUID;
  v_cat_ofic        UUID;
  v_cat_tv_audio    UUID;
  v_cat_electrodom  UUID;
  v_cat_carros      UUID;
  v_cat_motos       UUID;
  v_cat_materiales  UUID;

  v_loc_smt UUID;
BEGIN

  SELECT id INTO v_cat_maquinaria FROM categories WHERE slug = 'maquinaria';
  SELECT id INTO v_cat_ofic       FROM categories WHERE slug = 'equipos-oficina';
  SELECT id INTO v_cat_tv_audio   FROM categories WHERE slug = 'tv-audio';
  SELECT id INTO v_cat_electrodom FROM categories WHERE slug = 'electrodomesticos';
  SELECT id INTO v_cat_carros     FROM categories WHERE slug = 'carros';
  SELECT id INTO v_cat_motos      FROM categories WHERE slug = 'motos';
  SELECT id INTO v_cat_materiales FROM categories WHERE slug = 'materiales';
  SELECT id INTO v_loc_smt        FROM locations  WHERE slug = 'santa-marta';

  -- ============================================================
  -- #79 — Neveras y congeladores comerciales
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Neveras y Congeladores Comerciales — Santa Marta',
    'se-compra-neveras-congeladores-comerciales-79',
    E'El Sanatorio Gastro Bar busca neveras y congeladores comerciales de dos o cuatro puertas en buen estado para nuestra operación.\n\nBuscamos:\n• Nevera exhibidora vertical de 2 o 4 puertas (1.5 m–2 m alto)\n• Congelador horizontal tipo cofre (300 L o más)\n• Cualquier marca: Imensa, Haceb, True, Metalfrio, etc.\n\nCondición: usado en buen estado o nuevo. Pago de contado. Recogida en Santa Marta.\n\nContacto: WhatsApp +573001234567 con fotos y precio.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','nevera','congelador','comercial','restaurante','santa-marta','usado'],
    '[{"url":"/images/placeholder.jpg","alt":"Nevera Comercial","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #80 — Bajo-mesones / fridges de barra
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Bajo-Mesones y Neveras de Barra — Santa Marta',
    'se-compra-bajo-mesones-neveras-barra-80',
    E'Buscamos bajo-mesones refrigerados y botelleros para equipar la barra de El Sanatorio Gastro Bar.\n\nQué buscamos:\n• Bajo-mesón refrigerado de 1 o 2 puertas (60–120 cm ancho)\n• Botellero o wine cooler de barra\n• Marcas: Imbera, True Refrigeration, Gamko u otras\n\nEstado: usado en buen funcionamiento o nuevo. Pago inmediato. Santa Marta.\n\nWhatsApp: +573001234567 — envíe fotos y precio.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','bajo-meson','botellero','barra','bar','refrigeracion','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Botellero de Barra","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #81 — Parrilla yakitori a carbón comercial
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE BUSCA: Parrilla Yakitori a Carbón Comercial — Santa Marta',
    'se-busca-parrilla-yakitori-carbon-comercial-81',
    E'El Sanatorio busca parrilla yakitori a carbón de uso comercial para nuestra cocina de fusión japonesa-latina.\n\nEspecificaciones ideales:\n• Parrilla yakitori tipo japonés con soporte de carbón directo bajo las brochetas\n• Acero inoxidable, ancho mínimo 60 cm, con extractor de cenizas\n• Nueva o importada en buen estado\n\nTambién aceptamos parrillas de leña/carbón de restaurante adaptables a la técnica yakitori.\n\nContacto inmediato: WhatsApp +573001234567 con fotos, especificaciones y precio.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','parrilla','yakitori','carbon','cocina','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Parrilla Yakitori","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #82 — Campana extractora comercial
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Campana Extractora Comercial — Cocina Restaurante',
    'se-compra-campana-extractora-cocina-comercial-82',
    E'Buscamos campana extractora de humos de uso comercial para cocina de restaurante.\n\nCaracterísticas:\n• Ancho mínimo 1.2 m, fabricación en acero inoxidable\n• Sistema de extracción con motor de alta capacidad (m³/h suficiente para parrilla de carbón)\n• Con o sin filtros de grasa incluidos\n\nTambién se evalúan sistemas de extracción modulares o campanas de segunda mano en buen estado.\n\nUbicación: Santa Marta — recogeremos localmente.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','campana','extractora','cocina','ventilacion','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Campana Extractora","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #83 — Freidora comercial
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Freidora Comercial — Restaurante Santa Marta',
    'se-compra-freidora-comercial-restaurante-83',
    E'El Sanatorio busca freidora comercial de una o dos canastas para nuestra cocina.\n\nBuscamos:\n• Freidora a gas o eléctrica, capacidad 8–15 L por cuba\n• Acero inoxidable, con canasta y tapa\n• Marcas: Waring, Pitco, Frymaster, Anvil o similar comercial\n\nEstado: nuevo o usado en buen funcionamiento. Pago de contado.\n\nWhatsApp: +573001234567 con fotos y precio.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','freidora','cocina','comercial','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Freidora Comercial","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #84 — Lavavajillas comercial
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Lavavajillas / Loza Comercial — Restaurante',
    'se-compra-lavavajillas-comercial-restaurante-84',
    E'Buscamos lavavajillas comercial tipo capota (hood-type) o de cinta para uso en restaurante de alta rotación.\n\nEspecificaciones:\n• Ciclo de lavado ≤ 2 minutos\n• Capacidad mínima 40 canastas/hora\n• Incluyendo dosificadores de detergente y rinse-aid si es posible\n\nSe evalúan equipos usados de marcas Hobart, Meiko, Classeq, Winter-Halter o equivalentes comerciales colombianos.\n\nContacto: WhatsApp +573001234567 con especificaciones y precio.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','lavavajillas','loza','comercial','restaurante','cocina','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Lavavajillas Comercial","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #85 — Mesones de acero inoxidable
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Mesones de Acero Inoxidable — Cocina Profesional',
    'se-compra-mesones-acero-inoxidable-cocina-85',
    E'Buscamos mesones y estantes de acero inoxidable para equipar la cocina de El Sanatorio.\n\nQué necesitamos:\n• Mesones de trabajo en acero inox 304, varios tamaños (60–180 cm largo)\n• Estantes y repisas de acero para bodega de cocina\n• Estación de trabajo con entrepaños\n\nNuevo o usado en buen estado. Recogemos en Santa Marta. Pago de contado.\n\nWhatsApp: +573001234567 con medidas y precio.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','meson','acero-inoxidable','cocina','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Mesones Inox","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #86 — Máquina de hielo
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Máquina de Hielo Comercial — Bar / Restaurante',
    'se-compra-maquina-hielo-bar-restaurante-86',
    E'El Sanatorio busca máquina de hielo comercial para abastecer nuestra barra de coctelería.\n\nBuscamos:\n• Producción mínima 30 kg/día\n• Hielo en cubos o media luna — apto para coctelería\n• Depósito integrado deseable\n• Marcas: Manitowoc, Scotsman, Hoshizaki, Ice-O-Matic u otras comerciales\n\nSe evalúan equipos nuevos o usados certificados. Pago de contado. Recogida en Santa Marta.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','hielo','maquina','bar','cocteleria','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Máquina de Hielo","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #87 — Licuadora comercial de barra
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Licuadora Comercial para Barra — Coctelería',
    'se-compra-licuadora-comercial-barra-87',
    E'Buscamos licuadoras comerciales de alta potencia para uso en barra de coctelería.\n\nBuscamos:\n• Potencia mínima 1 HP, jarra de 1.5–2 L\n• Velocidades variables o programables\n• Marcas: Vitamix, Blendtec, Waring, Hamilton Beach comercial\n• Incluidas fundas insonorizadoras si es posible\n\nNueva o usada en buen estado. 1 o 2 unidades.\n\nWhatsApp: +573001234567 con precio y estado.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','licuadora','barra','cocteleria','bar','comercial','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Licuadora Barra","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #88 — Sistema POS / terminal táctil
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_ofic, v_loc_smt,
    'SE COMPRA: Sistema POS / Terminal Táctil — Restaurante / Bar',
    'se-compra-sistema-pos-terminal-tactil-88',
    E'El Sanatorio busca sistema POS completo para manejo de comandas, pagos y cierres de caja en restaurante y bar.\n\nQué buscamos:\n• Terminal táctil (mínimo 15") resistente a entorno de hostelería\n• Software compatible con impresora de cocina y datafono\n• Opciones: Siigo POS, Nubox, o terminal Android/iPad con app de POS\n• Se evalúan paquetes completos (terminal + impresora + cajón)\n\nNuevo o reacondicionado. Pago de contado.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','pos','terminal','tactil','restaurante','bar','caja','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Sistema POS","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #89 — Cajón de dinero / cash drawer
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_ofic, v_loc_smt,
    'SE COMPRA: Cajón de Dinero (Cash Drawer) para POS',
    'se-compra-cajon-dinero-pos-89',
    E'Buscamos cajón de dinero para conectar a sistema POS en restaurante.\n\nEspecificaciones:\n• Compatible con impresora térmica de comandas (apertura por señal)\n• 5 billetes + 8 monedas mínimo\n• Cualquier marca estándar\n\nNuevo o usado en perfecto estado. Precio justo.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','cajon','caja','pos','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Cajón Dinero","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #90 — Sillas y taburetes de restaurante
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Sillas de Restaurante y Taburetes de Barra — Santa Marta',
    'se-compra-sillas-restaurante-taburetes-barra-90',
    E'El Sanatorio busca sillas de restaurante y taburetes de barra en estilo industrial oscuro u oscurecible para completar el mobiliario de nuestro gastro bar de concepto horror.\n\nQué buscamos:\n• Sillas de comedor resistentes (metal, madera oscura o cuero negro/burdeos) — lote de 20–40 unidades\n• Taburetes de barra altos (65–75 cm asiento) — lote de 8–12 unidades\n• Cualquier diseño industrial, vintage o gótico que se adapte al concepto\n\nSe compran nuevas o usadas en buen estado. Pago de contado. Recogemos en Santa Marta.\n\nFotos y precio por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','sillas','taburetes','barra','restaurante','mobiliario','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Sillas Restaurante","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #91 — Mesas para terraza exterior
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Mesas para Terraza / Exterior — Restaurante Bar',
    'se-compra-mesas-terraza-exterior-restaurante-91',
    E'Buscamos mesas para terraza exterior de El Sanatorio (zona de espera y experiencia al aire libre en el Centro Histórico de Santa Marta).\n\nQué buscamos:\n• Mesas de 60–80 cm diámetro o cuadradas, resistentes a intemperie (metal, hierro forjado, madera tratada)\n• Estilo: industrial, vintage, oscuro — que encaje con el concepto horror\n• Lote de 6–12 unidades\n\nNuevas o usadas en buen estado. Pago de contado.\n\nFotos y precio por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','mesas','terraza','exterior','restaurante','mobiliario','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Mesas Terraza","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #92 — Sistema de sonido / PA
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_tv_audio, v_loc_smt,
    'SE COMPRA: Sistema de Sonido / PA — Bar / Restaurante Santa Marta',
    'se-compra-sistema-sonido-pa-bar-92',
    E'El Sanatorio busca sistema de sonido profesional para ambientación de salón y barra.\n\nQué buscamos:\n• Bocinas de techo o pared (6–10 unidades) con amplificador multizona\n• Altavoces activos de escena (para DJ y eventos) — 2 a 4 unidades\n• Subwoofer activo (deseable)\n• Marcas: JBL, QSC, Yamaha, Behringer, HK Audio u otras profesionales\n\nEquipo completo o por componentes. Nuevo o usado en buen estado. Pago de contado.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','sonido','pa','audio','bar','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Sistema PA","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #93 — Rigging de luces / lighting rig
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_tv_audio, v_loc_smt,
    'SE COMPRA: Rigging de Luces DMX / Iluminación Escénica — Santa Marta',
    'se-compra-rigging-luces-dmx-iluminacion-93',
    E'El Sanatorio busca equipos de iluminación escénica para el salón del bar y el Laberinto del Horror.\n\nQué buscamos:\n• Cabezas móviles (moving heads) — 4 a 8 unidades\n• Luces LED PAR y wash\n• Controlador DMX (consola o software)\n• Estructuras de rigging / travesaños\n• Marcas: Chauvet, Elation, Martin, Eurolite, American DJ\n\nNuevas, de segunda o alquiler con opción de compra.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','luces','dmx','iluminacion','bar','escena','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Luces DMX","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #94 — Máquinas de humo / efectos atmosféricos
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_tv_audio, v_loc_smt,
    'SE COMPRA: Máquinas de Humo y Efectos Atmosféricos — Laberinto del Horror',
    'se-compra-maquinas-humo-efectos-laberinto-94',
    E'El Sanatorio busca máquinas de humo, niebla y efectos especiales para el Laberinto del Horror y ambientación del bar.\n\nQué buscamos:\n• Máquinas de humo (fog machines) de 1000–1500W — varias unidades\n• Máquina de niebla baja (low fog / suelo)\n• Fluido de humo (varios litros)\n• Eventuales efectos de arco voltaico o plasma (decorativos, sin riesgo)\n\nNuevas o usadas en buen estado. Importadas OK si llegan a Bogotá o Barranquilla.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','humo','fog','niebla','efectos','laberinto','bar','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Máquina de Humo","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #95 — Estanterías de bodega / almacenamiento
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Estanterías Industriales / Almacenamiento Bodega — Santa Marta',
    'se-compra-estanterias-industriales-bodega-95',
    E'Buscamos estanterías metálicas industriales para bodega de almacenamiento (insumos de cocina, bebidas y equipos del laberinto).\n\nQué buscamos:\n• Estanterías de ángulo ranurado o tipo rack galvanizado\n• Altura 1.8–2.4 m, varios anchos\n• Capacidad de carga media-alta por entrepaño\n• Lote de 5–15 módulos\n\nNuevas o de segunda en buen estado. Pago de contado. Recogemos en Santa Marta.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','estanteria','rack','bodega','almacenamiento','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Estanterías Bodega","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #96 — Calentador de agua comercial
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Calentador de Agua Comercial / Industrial — Restaurante',
    'se-compra-calentador-agua-comercial-96',
    E'Buscamos calentador de agua comercial para abastecer la cocina y baños de El Sanatorio.\n\nEspecificaciones:\n• Gas natural o GLP (preferible gas)\n• Paso continuo o tanque de 80–150 L\n• Capacidad para cocina profesional + 2 baños simultáneos\n\nMarcas: Haceb, Challenger, Rheem, State, Bradford White.\n\nNuevo o usado en buen estado con garantía de funcionamiento.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','calentador','agua','comercial','gas','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Calentador Agua","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #97 — Planta eléctrica / generador
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Generador / Planta Eléctrica de Respaldo — Negocio Santa Marta',
    'se-compra-generador-planta-electrica-97',
    E'El Sanatorio busca generador / planta eléctrica de respaldo para garantizar la operación del restaurante y el Laberinto del Horror ante cortes de energía.\n\nEspecificaciones:\n• 10–20 KVA mínimo (220V trifásico o bifásico según instalación)\n• Diesel o gas\n• Con sistema de transferencia automática (ATS) si es posible\n• Insonorizado preferible\n\nMarcas: Kohler, Generac, Cummins, FG Wilson, Perkins.\n\nNuevo o reacondicionado con soporte técnico. Pago de contado.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','generador','planta','electrica','respaldo','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Generador Planta","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #98 — Cámaras CCTV de seguridad
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_ofic, v_loc_smt,
    'SE COMPRA: Sistema CCTV / Cámaras de Seguridad — Local Comercial',
    'se-compra-cctv-camaras-seguridad-local-98',
    E'Buscamos sistema de videovigilancia CCTV para instalación en El Sanatorio (interior, cocina, barra, acceso y laberinto).\n\nQué necesitamos:\n• 8–16 cámaras IP o HD (interiores y 2–4 para exterior)\n• NVR/DVR con disco duro incluido\n• Visualización remota desde celular\n• Instalación en Santa Marta Centro Histórico\n\nSe evalúan paquetes completos con instalación incluida.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','cctv','camaras','seguridad','local-comercial','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"CCTV Seguridad","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #99 — Extintores y equipos contra incendio
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_materiales, v_loc_smt,
    'SE COMPRA: Extintores y Equipos de Seguridad Contra Incendio — Santa Marta',
    'se-compra-extintores-seguridad-incendio-99',
    E'El Sanatorio requiere extintores y equipos de seguridad contra incendio para cumplir con los requisitos del Cuerpo de Bomberos de Santa Marta.\n\nQué buscamos:\n• Extintores tipo ABC (multipropósito) — 5 a 10 unidades de 5–10 lb\n• Extintor para grasa K (cocina) — 1 unidad\n• Señalización de rutas de evacuación y salidas de emergencia\n• Kit de primeros auxilios\n\nProveedores con certificación Bomberos preferibles.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','extintor','seguridad','incendio','bomberos','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Extintores","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #100 — Sistemas de grifo Sankey y CO2
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA: Sistemas de Grifo Sankey y Equipos de CO2 — Bar',
    'se-compra-grifo-sankey-co2-bar-100',
    E'El Sanatorio busca equipos completos de grifo Sankey y sistemas de CO2 para servicio de bebidas de barril.\n\nQué necesitamos:\n• Cabezas de grifo Sankey tipo D (compatibles con barriles colombianos e importados)\n• Reguladores de CO2 y mangueras de gas\n• Bombas de CO2 y tanques (cilindros de 2–10 kg)\n• Líneas de servicio con serpentines de frío o línea directa desde nevera\n\nNuevos o usados en buen estado. Pago de contado.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','sankey','grifo','co2','barril','cerveza','bar','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Grifo Sankey","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #101 — Barriles Sankey 20L
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_bevida, v_cat_maquinaria, v_loc_smt,
    'SE COMPRA / SE ALQUILA: Barriles Sankey 20L — Bebidas Artesanales',
    'se-compra-barriles-sankey-20l-101',
    E'Be Vida Botánicas busca barriles Sankey de 20 litros (acero inoxidable) para envasar y distribuir nuestras bebidas RTD al canal B2B en Santa Marta y la Costa Caribe.\n\nBuscamos:\n• Barriles Sankey 20L en acero inox, tipo D o G\n• En buen estado, sin golpes significativos que comprometan el sello\n• Lote mínimo de 10 unidades\n\nTambién evaluamos contratos de alquiler de barriles con proveedor. Pago inmediato.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','sankey','barril','20l','bebidas','artesanal','b2b','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Barriles Sankey","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #102 — Escritorios y sillas de oficina
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_ofic, v_loc_smt,
    'SE COMPRA: Escritorios y Sillas de Oficina — Maia Management Santa Marta',
    'se-compra-escritorios-sillas-oficina-102',
    E'Maia Management Group busca escritorios y sillas ergonómicas de oficina para equipar nuestras instalaciones en Santa Marta.\n\nQué necesitamos:\n• Escritorios modulares o individuales — 6 a 10 puestos\n• Sillas ergonómicas de escritorio con ajuste lumbar\n• Mesa de reuniones para 8–10 personas\n• Armarios o cajoneras de archivo\n\nNuevo o usado en buen estado. Entrega en Santa Marta Centro.\n\nWhatsApp: +573001234567 con fotos y precio.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','escritorios','sillas','oficina','mobiliario','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Oficina Mobiliario","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #103 — Proyector y pantalla
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_tv_audio, v_loc_smt,
    'SE COMPRA: Proyector y Pantalla de Proyección — Sala de Reuniones / Aula',
    'se-compra-proyector-pantalla-proyeccion-103',
    E'Maia Management Group busca proyector y pantalla para sala de reuniones y aula de Maia Masters Academy.\n\nEspecificaciones:\n• Proyector: mínimo 3.000 lúmenes, resolución 1080p, HDMI y Wi-Fi\n• Pantalla: 100"–120" retráctil o fija\n• Marcas: Epson, BenQ, ViewSonic, LG, Optoma\n\nNuevo o reacondicionado con garantía. También se evalúan TV 85" como alternativa.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','proyector','pantalla','presentaciones','aula','oficina','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Proyector Pantalla","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #104 — Computadores / laptops
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_ofic, v_loc_smt,
    'SE COMPRA: Computadores y Laptops — Oficina y Academia | Santa Marta',
    'se-compra-computadores-laptops-oficina-104',
    E'Maia Management Group busca computadores de escritorio y laptops para equipar las oficinas y el aula de Maia Masters Academy.\n\nQué buscamos:\n• Laptops: Core i5 o Ryzen 5 de 11ª generación o superior, 8 GB RAM, 256 GB SSD mínimo — 5 a 10 unidades\n• PCs de escritorio: configuración similar — 3 a 5 unidades\n• Monitores adicionales — varios\n\nNuevos, reacondicionados o segunda mano en buen estado funcional.\n\nWhatsApp: +573001234567 con especificaciones y precio.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','computador','laptop','pc','oficina','academia','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Laptops Oficina","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #105 — Impresora / escáner
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_ofic, v_loc_smt,
    'SE COMPRA: Impresora Multifuncional / Escáner — Oficina Santa Marta',
    'se-compra-impresora-multifuncional-oficina-105',
    E'Buscamos impresora multifuncional (imprime, escanea, fotocopia) para oficina.\n\nEspecificaciones:\n• Láser monocromática o color, uso intensivo\n• Wi-Fi y USB, compatible con Google Drive\n• Marcas: HP, Canon, Brother, Epson EcoTank\n• Tambien se evalúa impresora de etiquetas adicional\n\nNueva o usada en buen estado con tóner/tinta incluido.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','impresora','scanner','multifuncional','oficina','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Impresora Oficina","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #106 — Camioneta / furgoneta
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_carros, v_loc_smt,
    'SE BUSCA: Camioneta o Furgoneta para Distribución — Grupo Maia Santa Marta',
    'se-busca-camioneta-furgoneta-distribucion-106',
    E'Maia Management Group busca camioneta o furgoneta para apoyo logístico y distribución de Be Vida Botánicas en Santa Marta y la región.\n\nQué buscamos:\n• Camioneta doble cabina o furgoneta de carga liviana\n• Diesel o gasolina, modelo 2015 o más reciente\n• Buen estado mecánico, traspaso limpio\n• Carga útil mínima 800 kg\n\nPago de contado o financiación según oferta.\n\nWhatsApp: +573001234567 con fotos, km y precio.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','camioneta','furgoneta','transporte','logistica','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Camioneta","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #107 — Motocicleta / moto de mensajería
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_motos, v_loc_smt,
    'SE BUSCA: Motocicleta para Mensajería y Diligencias — Santa Marta',
    'se-busca-motocicleta-mensajeria-107',
    E'Grupo Maia busca motocicleta para mensajería, diligencias y entregas locales en Santa Marta.\n\nQué buscamos:\n• Moto 125–200 cc, modelo 2016 o más reciente\n• Papeles al día, buen estado mecánico\n• Marca: Honda, Yamaha, Bajaj, AKT u otras\n• Con cajón de carga o adaptable\n\nPago de contado. Se evalúan motos con y sin baúl.\n\nWhatsApp: +573001234567 con fotos, km y precio.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','moto','mensajeria','125cc','logistica','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Motocicleta","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  RAISE NOTICE 'Migration 011 complete: 29 equipment-wanted listings (#79–107)';

END $$;

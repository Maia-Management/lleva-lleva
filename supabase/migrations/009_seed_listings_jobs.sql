-- ============================================================
-- Migration 009: Maia Group — Job Listings (1–59)
-- Depends on: 008_seed_business_profiles.sql
-- ============================================================

DO $$
DECLARE
  -- Seller IDs (from 008)
  v_sel_sanatorio   UUID := 'a1b2c3d4-0001-0001-0001-000000000001';
  v_sel_juno        UUID := 'a1b2c3d4-0001-0001-0001-000000000002';
  v_sel_masters     UUID := 'a1b2c3d4-0001-0001-0001-000000000003';
  v_sel_trivium     UUID := 'a1b2c3d4-0001-0001-0001-000000000004';
  v_sel_legal       UUID := 'a1b2c3d4-0001-0001-0001-000000000005';
  v_sel_mgmt        UUID := 'a1b2c3d4-0001-0001-0001-000000000006';
  v_sel_realty      UUID := 'a1b2c3d4-0001-0001-0001-000000000007';
  v_sel_llave       UUID := 'a1b2c3d4-0001-0001-0001-000000000008';
  v_sel_aerial      UUID := 'a1b2c3d4-0001-0001-0001-000000000009';
  v_sel_lleva       UUID := 'a1b2c3d4-0001-0001-0001-000000000010';

  -- Categories
  v_cat_empleo      UUID;
  v_cat_freelance   UUID;

  -- Locations
  v_loc_smt         UUID;
BEGIN

  SELECT id INTO v_cat_empleo   FROM categories WHERE slug = 'ofertas-empleo';
  SELECT id INTO v_cat_freelance FROM categories WHERE slug = 'freelance';
  SELECT id INTO v_loc_smt      FROM locations  WHERE slug = 'santa-marta';

  -- ==============================================================
  -- EL SANATORIO — Gastro Bar + Laberinto del Horror (1–20)
  -- ==============================================================

  -- 1. Actor de Terror
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Actor de Terror — Laberinto del Horror | El Sanatorio',
    'actor-terror-laberinto-el-sanatorio-01',
    E'El Sanatorio Gastro Bar (Calle 19 #4-23, Centro Histórico) busca actores de terror para nuestro Laberinto del Horror. Trabajo fines de semana y festivos.\n\nBuscamos: personas expresivas, con energía y capacidad de mantener personaje bajo presión. No se requiere experiencia previa — proporcionamos entrenamiento completo.\n\nOfrecemos: vestuario y maquillaje incluidos, ambiente de trabajo dinámico, pago por sesión competitivo.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','actor','terror','laberinto','santa-marta','fines-de-semana'],
    '[{"url":"/images/sanatorio-actor.jpg","alt":"Actor de Terror El Sanatorio","order":0}]'
  );

  -- 2. Bartender Principal
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Bartender Principal | El Sanatorio Gastro Bar',
    'bartender-principal-el-sanatorio-02',
    E'Buscamos Bartender Principal para liderar la barra de El Sanatorio, nuestro gastro bar de concepto horror en el Centro de Santa Marta.\n\nRequisitos: experiencia mínima 2 años en bares de coctelería, conocimiento de destilados y técnicas de mixología, liderazgo de equipo, inglés básico preferible.\n\nOfrecemos: contrato a término indefinido, propinas, comidas durante turno, ambiente creativo y único en Santa Marta.\n\nContacto WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','bartender','cocteleria','santa-marta','tiempo-completo'],
    '[{"url":"/images/sanatorio-bar.jpg","alt":"Barra El Sanatorio","order":0}]'
  );

  -- 3. Bartender
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Bartender | El Sanatorio Gastro Bar — Santa Marta',
    'bartender-el-sanatorio-03',
    E'El Sanatorio busca bartender con experiencia en coctelería para unirse a nuestro equipo. Trabajo en un ambiente temático único — el único gastro bar de horror en la Costa Caribe.\n\nRequisitos: experiencia mínima 1 año en bar, actitud positiva, trabajo en equipo, disponibilidad nocturna y fines de semana.\n\nSe valora: conocimiento de cócteles clásicos y tropicales, inglés conversacional.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','bartender','santa-marta','nocturno'],
    '[{"url":"/images/sanatorio-bar.jpg","alt":"El Sanatorio Bar","order":0}]'
  );

  -- 4. Ayudante de Bar / Bar Back
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Ayudante de Bar / Bar Back | El Sanatorio',
    'barback-el-sanatorio-04',
    E'Buscamos Bar Back para apoyar la operación de nuestra barra en El Sanatorio. Ideal para personas que quieren iniciarse en el mundo de la coctelería y la hospitalidad.\n\nFunciones: mantener barra surtida, lavar cristalería, apoyar al bartender en servicio, gestión de inventario básico.\n\nRequisitos: actitud de servicio, trabajo en equipo, disponibilidad horario nocturno.\n\nFormación en bar incluida para quienes demuestren compromiso. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','barback','ayudante','santa-marta'],
    '[{"url":"/images/sanatorio-bar.jpg","alt":"El Sanatorio Bar Back","order":0}]'
  );

  -- 5. Chef Ejecutivo / Head Chef
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Chef Ejecutivo / Head Chef — Fusión Japonesa-Latina | El Sanatorio',
    'chef-ejecutivo-el-sanatorio-05',
    E'El Sanatorio busca Chef Ejecutivo para liderar nuestra cocina de fusión japonesa-latina con especialidad en yakitori y tapas creativas.\n\nRequisitos: experiencia mínima 3 años en cocina de autor o fusión asiática-latina, capacidad de diseñar menú, gestionar brigada y controlar costos de alimentos y bebidas.\n\nOfrecemos: proyecto gastronómico único en Santa Marta, libertad creativa, salario competitivo + incentivos por desempeño.\n\nEnviar hoja de vida y portafolio gastronómico por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','chef','cocina','gastronomia','japones','santa-marta'],
    '[{"url":"/images/sanatorio-cocina.jpg","alt":"Cocina El Sanatorio","order":0}]'
  );

  -- 6. Sous Chef
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Sous Chef — Segundo de Cocina | El Sanatorio Gastro Bar',
    'sous-chef-el-sanatorio-06',
    E'Buscamos Sous Chef para ser el segundo al mando en la cocina de El Sanatorio. Serás el enlace directo entre el Chef Ejecutivo y la brigada.\n\nRequisitos: experiencia mínima 2 años en cocina profesional, conocimiento de técnicas frías y calientes, capacidad de coordinar equipo en horas pico.\n\nSe valora: experiencia en cocina asiática o de autor, disposición para aprender el concepto horror-gourmet del restaurante.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','sous-chef','cocina','santa-marta'],
    '[{"url":"/images/sanatorio-cocina.jpg","alt":"Sous Chef El Sanatorio","order":0}]'
  );

  -- 7. Cocinero / Line Cook
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Cocinero / Line Cook | El Sanatorio — Estación de Parrilla y Frío',
    'cocinero-linea-el-sanatorio-07',
    E'El Sanatorio contrata cocineros de línea para estaciones de parrilla, frío y montaje.\n\nRequisitos: experiencia mínima 1 año en cocina profesional, rapidez y organización bajo presión, higiene y BPM (Buenas Prácticas de Manufactura).\n\nOfrecemos: contrato a término indefinido, uniforme completo, comida de turno, oportunidad de crecer dentro del equipo.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','cocinero','line-cook','santa-marta'],
    '[{"url":"/images/sanatorio-cocina.jpg","alt":"Cocina El Sanatorio","order":0}]'
  );

  -- 8. Steward / Lavacopas
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Steward / Lavacopas | El Sanatorio Gastro Bar',
    'steward-lavacopas-el-sanatorio-08',
    E'Buscamos Steward para mantener la limpieza operativa de nuestra cocina y barra en El Sanatorio.\n\nFunciones: lavado de loza, cristalería y utensilios; limpieza de cocina durante y al cierre; apoyo en organización de cuarto frío.\n\nRequisitos: responsabilidad, rapidez, trabajo en equipo. No se requiere experiencia previa.\n\nOfrecemos: buen trato, comida de turno y posibilidad de ascenso a ayudante de cocina. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','steward','lavacopas','santa-marta'],
    '[{"url":"/images/sanatorio-interior.jpg","alt":"El Sanatorio Interior","order":0}]'
  );

  -- 9. Mesero/a
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Mesero/a | El Sanatorio — Servicio de Mesa Temático',
    'mesero-el-sanatorio-09',
    E'El Sanatorio busca meseros y meseras con actitud de servicio excepcional para nuestro restaurante de concepto horror.\n\nRequisitos: experiencia mínima 6 meses en servicio de mesa, inglés básico (atendemos turistas), excelente presentación personal y capacidad de trabajar en ambiente temático oscuro.\n\nOfrecemos: propinas incluidas, uniforme, comida de turno, ambiente laboral único en Santa Marta.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','mesero','servicio','santa-marta'],
    '[{"url":"/images/sanatorio-salon.jpg","alt":"Salón El Sanatorio","order":0}]'
  );

  -- 10. Host / Anfitrión
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Host / Anfitrión — Recepción y Reservas | El Sanatorio',
    'host-anfitrion-el-sanatorio-10',
    E'Buscamos Host para recibir a nuestros clientes con la bienvenida perfecta al mundo de El Sanatorio.\n\nFunciones: gestión de lista de espera y reservas, bienvenida de grupos y eventos privados, coordinación con el equipo de sala.\n\nRequisitos: excelente presencia, inglés intermedio-avanzado, actitud cálida pero con personalidad para el concepto temático. Estudiantes de hotelería o turismo son bienvenidos.\n\nTrabajo parcial (fines de semana). WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','host','recepcion','santa-marta','parcial'],
    '[{"url":"/images/sanatorio-entrada.jpg","alt":"Entrada El Sanatorio","order":0}]'
  );

  -- 11. Cajero/a
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Cajero/a | El Sanatorio Gastro Bar — Santa Marta',
    'cajero-el-sanatorio-11',
    E'El Sanatorio busca Cajero/a para manejo de punto de venta y cierre diario de caja.\n\nRequisitos: experiencia en manejo de POS y efectivo, honestidad comprobada, orden y concentración, conocimiento básico de Excel.\n\nSe valora: experiencia previa en restaurantes o bares, inglés básico para atención a turistas.\n\nContrato a término indefinido, prestaciones completas. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','cajero','santa-marta','tiempo-completo'],
    '[{"url":"/images/sanatorio-caja.jpg","alt":"Caja El Sanatorio","order":0}]'
  );

  -- 12. Seguridad / Portero
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Seguridad / Portero | El Sanatorio — Control de Acceso',
    'seguridad-portero-el-sanatorio-12',
    E'Buscamos personal de seguridad y portería para El Sanatorio. Serás el primer contacto con los visitantes: verificación de edad, control de aforo y seguridad del establecimiento.\n\nRequisitos: curso de seguridad privada (deseable), buena condición física, presencia intimidante pero profesional, manejo de público.\n\nHorario nocturno y fines de semana. Contrato a término indefinido. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','seguridad','portero','santa-marta','nocturno'],
    '[{"url":"/images/sanatorio-entrada.jpg","alt":"Entrada El Sanatorio","order":0}]'
  );

  -- 13. Aseadora — Restaurante
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Aseadora — Restaurante | El Sanatorio Gastro Bar',
    'aseadora-restaurante-el-sanatorio-13',
    E'El Sanatorio busca aseadora para limpieza profunda diaria de las instalaciones del restaurante, baños, salón y zonas comunes del Laberinto del Horror.\n\nRequisitos: experiencia en limpieza de establecimientos comerciales, uso correcto de productos de desinfección, puntualidad.\n\nHorario: mañana (antes de apertura) + turno de cierre parcial. Contrato a término indefinido, prestaciones completas.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','aseadora','limpieza','santa-marta'],
    '[{"url":"/images/sanatorio-interior.jpg","alt":"El Sanatorio Interior","order":0}]'
  );

  -- 14. Maquilladora de Terror
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Maquilladora de Terror — SFX | Laberinto del Horror El Sanatorio',
    'maquilladora-terror-sfx-el-sanatorio-14',
    E'Buscamos maquilladora con experiencia en efectos especiales (SFX) y caracterización de horror para preparar a nuestros actores del Laberinto del Horror.\n\nRequisitos: conocimiento de técnicas de maquillaje teatral y SFX (heridas, cicatrices, prótesis básicas), creatividad y velocidad en la aplicación.\n\nTrabajo fines de semana y días de función. Pago por evento + bonificaciones según aforo.\n\nPortafolio por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','maquillaje','sfx','terror','santa-marta','fines-de-semana'],
    '[{"url":"/images/sanatorio-actor.jpg","alt":"Maquillaje Terror El Sanatorio","order":0}]'
  );

  -- 15. Diseñador/a de Sets — Laberinto
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Diseñador/a de Sets — Laberinto del Horror | El Sanatorio (Contrato)',
    'disenador-sets-laberinto-el-sanatorio-15',
    E'El Sanatorio busca un/a Diseñador/a de Sets para conceptualizar, diseñar y construir las salas de nuestro Laberinto del Horror.\n\nBuscamos: creatividad oscura, experiencia en diseño de producción, teatro o cine, capacidad de trabajar con materiales de bajo costo y alto impacto visual.\n\nProyecto: expansión de 3 salas nuevas del laberinto + rediseño de 2 existentes. Contrato por obra.\n\nPortafolio por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','disenador','sets','laberinto','contrato','santa-marta'],
    '[{"url":"/images/sanatorio-laberinto.jpg","alt":"Laberinto El Sanatorio","order":0}]'
  );

  -- 16. Técnico de Sonido y Luces
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Técnico de Sonido y Luces | El Sanatorio — Ambiente Temático',
    'tecnico-sonido-luces-el-sanatorio-16',
    E'Buscamos Técnico de Sonido y Luces para operar y mantener el sistema audiovisual de El Sanatorio: ambientación del restaurante, efectos del laberinto y sonido para eventos privados.\n\nRequisitos: experiencia en consolas de sonido y controladores de iluminación DMX, manejo de software de audio (DAW básico), disponibilidad nocturna.\n\nTrabajo parcial (principalmente fines de semana). Buen ambiente de trabajo. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','tecnico','sonido','luces','santa-marta','parcial'],
    '[{"url":"/images/sanatorio-interior.jpg","alt":"Sonido y Luces El Sanatorio","order":0}]'
  );

  -- 17. DJ Residente
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'DJ Residente — Noches de Terror | El Sanatorio Gastro Bar',
    'dj-residente-el-sanatorio-17',
    E'El Sanatorio busca DJ Residente para ambientar nuestras noches con sets oscuros y temáticos. Géneros: dark electronic, industrial, ambient horror, synthwave, metal de ambiente.\n\nRequisitos: equipo propio (se puede negociar uso del equipo del bar), repertorio adaptable al concepto de horror, experiencia en bares o eventos.\n\nSesiones: viernes, sábados y fechas especiales. Pago por noche + propinas.\n\nMezclas por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','dj','musica','nocturno','santa-marta','fines-de-semana'],
    '[{"url":"/images/sanatorio-bar.jpg","alt":"DJ El Sanatorio","order":0}]'
  );

  -- 18. Coordinador/a de Eventos Privados
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Coordinador/a de Eventos Privados | El Sanatorio',
    'coordinador-eventos-privados-el-sanatorio-18',
    E'El Sanatorio busca Coordinador/a de Eventos para gestionar reservas de espacios privados: cumpleaños, despedidas, cenas corporativas y experiencias grupales en el Laberinto del Horror.\n\nFunciones: atención de clientes, cotización de paquetes, coordinación con cocina y bar, supervisión del evento.\n\nRequisitos: experiencia en atención al cliente o eventos, inglés conversacional, uso de WhatsApp Business y Google Sheets.\n\nTrabajo parcial, horario flexible. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','eventos','coordinador','santa-marta','parcial'],
    '[{"url":"/images/sanatorio-salon.jpg","alt":"Eventos El Sanatorio","order":0}]'
  );

  -- 19. Creador/a de Contenido en Sitio
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Creador/a de Contenido en Sitio — Redes Sociales | El Sanatorio',
    'creador-contenido-el-sanatorio-19',
    E'El Sanatorio busca Creador/a de Contenido para capturar la magia (y el terror) de nuestra experiencia en video y foto para redes sociales.\n\nBuscamos: alguien con ojo para el storytelling visual, manejo de Instagram Reels y TikTok, edición móvil ágil.\n\nFunciones: capturar contenido en servicio (cocina, barra, laberinto, eventos), editar y publicar reels semanales, apoyo con historias y posts.\n\nTrabajo principalmente fines de semana. Portafolio por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','contenido','redes','video','santa-marta','creativo'],
    '[{"url":"/images/sanatorio-interior.jpg","alt":"Contenido El Sanatorio","order":0}]'
  );

  -- 20. Diseñador/a de Vestuario — Horror
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Diseñador/a de Vestuario Horror — Actores del Laberinto | El Sanatorio',
    'disenador-vestuario-horror-el-sanatorio-20',
    E'El Sanatorio busca Diseñador/a de Vestuario para crear los trajes de los personajes del Laberinto del Horror.\n\nBuscamos: experiencia en diseño textil, teatro o cosplay, creatividad para conceptos oscuros, capacidad de trabajar con presupuesto ajustado sin sacrificar impacto visual.\n\nProyecto: 8 personajes base + variantes para fechas especiales (Halloween, etc). Contrato por proyecto con posibilidad de continuidad.\n\nPortafolio por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','vestuario','diseno','terror','contrato','santa-marta'],
    '[{"url":"/images/sanatorio-actor.jpg","alt":"Vestuario El Sanatorio","order":0}]'
  );

  -- ==============================================================
  -- JUNO HOUSE STUDIOS (21–23)
  -- ==============================================================

  -- 21. Modelo de Contenido Digital — Trabajo desde Casa
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images, is_nationwide)
  VALUES (v_sel_juno, v_cat_freelance, NULL,
    'Modelo de Contenido Digital — Trabaja desde Casa | Juno House Studios',
    'modelo-contenido-digital-juno-house-21',
    E'Juno House Studios invita a mujeres mayores de 18 años a unirse a nuestra red de creadores de contenido digital para adultos.\n\nTrabaja desde tu casa a tu propio ritmo. Nosotros gestionamos la plataforma, los pagos y el soporte técnico — tú te concentras en crear.\n\nBeneficios: 70% de los ingresos directamente para ti, privacidad garantizada, soporte personalizado en todo el proceso de onboarding, sin experiencia previa necesaria.\n\nAplicaciones solo por WhatsApp: +573001234567 (mayores de 18 años, foto de cédula requerida)',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','juno-house','modelo','contenido-digital','freelance','desde-casa'],
    '[{"url":"/images/juno-studios.jpg","alt":"Juno House Studios","order":0}]',
    TRUE
  );

  -- 22. Coordinadora de Soporte a Modelos
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_juno, v_cat_empleo, v_loc_smt,
    'Coordinadora de Soporte a Modelos | Juno House Studios',
    'coordinadora-soporte-modelos-juno-house-22',
    E'Juno House Studios busca Coordinadora de Soporte para acompañar a nuestros creadores de contenido en su proceso de onboarding y operación diaria.\n\nFunciones: onboarding de nuevos talentos, soporte en dudas de plataforma, seguimiento de desempeño, comunicación directa con modelos.\n\nRequisitos: empatía, discreción absoluta, manejo de WhatsApp Business, conocimiento básico de plataformas de contenido digital. Se valora experiencia en atención al cliente.\n\nTrabajo parcial, principalmente remoto. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','juno-house','coordinadora','soporte','santa-marta','parcial'],
    '[{"url":"/images/juno-studios.jpg","alt":"Juno House Studios","order":0}]'
  );

  -- 23. Operador/a de Plataformas Digitales
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_juno, v_cat_empleo, v_loc_smt,
    'Operador/a de Plataformas Digitales | Juno House Studios',
    'operador-plataformas-digitales-juno-house-23',
    E'Buscamos Operador/a para gestión de cuentas en plataformas de contenido digital: publicaciones, análisis de métricas, optimización de perfiles y atención a suscriptores.\n\nRequisitos: comodidad trabajando con plataformas digitales para adultos, discreción total, organización, capacidad de manejar múltiples cuentas simultáneamente.\n\nConocimientos valorados: análisis de datos básico, copywriting en inglés y español, manejo de Canva o herramientas de edición simple.\n\nTrabajo parcial con posibilidad de tiempo completo. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','juno-house','operador','plataformas','digital','santa-marta'],
    '[{"url":"/images/juno-studios.jpg","alt":"Juno House Plataformas","order":0}]'
  );

  -- ==============================================================
  -- MAIA MASTERS ACADEMY (24–27)
  -- ==============================================================

  -- 24. Instructor Principal — Habilidades Digitales
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_masters, v_cat_empleo, v_loc_smt,
    'Instructor Principal — Habilidades Digitales | Maia Masters Academy',
    'instructor-habilidades-digitales-maia-masters-24',
    E'Maia Masters Academy busca Instructor Principal para liderar nuestro bootcamp de habilidades digitales en Santa Marta.\n\nTemario base: marketing digital, diseño con IA, productividad con herramientas modernas, emprendimiento online.\n\nRequisitos: experiencia práctica y comprobable en al menos 2 de las áreas anteriores, capacidad pedagógica (no se requiere título docente), inglés conversacional, energía y carisma frente a grupo.\n\nContrato a término fijo con renovación. Sede: Centro, Santa Marta. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-masters','instructor','digital','educacion','santa-marta'],
    '[{"url":"/images/maia-masters.jpg","alt":"Maia Masters Academy","order":0}]'
  );

  -- 25. Instructor de Inglés — Cohorte Cero
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_masters, v_cat_empleo, v_loc_smt,
    'Instructor de Inglés para Negocios — Cohorte Cero | Maia Masters',
    'instructor-ingles-negocios-maia-masters-25',
    E'Maia Masters Academy busca Instructor de Inglés enfocado en inglés para negocios, comunicación profesional y entornos laborales modernos.\n\nCohorte Cero es nuestra primera promoción: grupo pequeño, ambiente íntimo, gran oportunidad para construir reputación y metodología propia dentro de la academia.\n\nRequisitos: inglés nativo o C1+ certificado, experiencia enseñando adultos, enfoque práctico (no gramática por gramática). Valoramos candidatos bilingües con experiencia en empresas internacionales.\n\nContrato por cohorte (3 meses). WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-masters','instructor','ingles','idiomas','santa-marta'],
    '[{"url":"/images/maia-masters.jpg","alt":"Inglés Maia Masters","order":0}]'
  );

  -- 26. Coordinador/a Administrativo
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_masters, v_cat_empleo, v_loc_smt,
    'Coordinador/a Administrativo | Maia Masters Academy — Santa Marta',
    'coordinador-admin-maia-masters-26',
    E'Maia Masters Academy busca Coordinador/a Administrativo para gestionar el día a día de la academia.\n\nFunciones: atención a estudiantes, gestión de inscripciones y pagos, coordinación de horarios, soporte a instructores, manejo de redes sociales de la academia.\n\nRequisitos: excelente comunicación, manejo de Google Workspace, organización y proactividad. Inglés básico deseable.\n\nContrato a término indefinido. Sede: Centro, Santa Marta. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-masters','administrativo','coordinador','santa-marta'],
    '[{"url":"/images/maia-masters.jpg","alt":"Coordinación Maia Masters","order":0}]'
  );

  -- 27. Asesor/a de Inscripciones
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_masters, v_cat_empleo, v_loc_smt,
    'Asesor/a de Inscripciones | Maia Masters Academy',
    'asesor-inscripciones-maia-masters-27',
    E'Maia Masters Academy busca Asesor/a de Inscripciones para guiar a potenciales estudiantes hacia el programa correcto.\n\nFunciones: responder consultas por WhatsApp e Instagram, explicar el programa, acompañar el proceso de pago e inscripción, seguimiento a prospectos.\n\nRequisitos: habilidad de ventas consultivas, empatía, conocimiento básico de educación digital. Trabajo parcial con comisión por inscripción concretada.\n\nIdeal para estudiantes universitarios o egresados de administración o comunicaciones. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-masters','asesor','inscripciones','ventas','santa-marta','parcial'],
    '[{"url":"/images/maia-masters.jpg","alt":"Asesor Maia Masters","order":0}]'
  );

  -- ==============================================================
  -- TRIVIUM MAGNUM INTERNATIONAL SCHOOL FOR BOYS (28–35)
  -- ==============================================================

  -- 28. Profesor de Matemáticas
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_trivium, v_cat_empleo, v_loc_smt,
    'Profesor de Matemáticas | Trivium Magnum International School',
    'profesor-matematicas-trivium-magnum-28',
    E'Trivium Magnum International School for Boys busca Profesor de Matemáticas para primaria y bachillerato.\n\nEnfoque: rigor matemático con aplicación práctica, preparación para exámenes internacionales, mentoría individual.\n\nRequisitos: licenciatura en matemáticas, ingeniería o afines; experiencia docente mínima 2 años; inglés intermedio (ambiente bilingüe).\n\nOfrecemos: proyecto educativo de largo plazo, comunidad de docentes comprometidos, sede en Centro Histórico de Santa Marta. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','trivium','profesor','matematicas','educacion','santa-marta'],
    '[{"url":"/images/trivium-magnum.jpg","alt":"Trivium Magnum","order":0}]'
  );

  -- 29. Profesor de Inglés
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_trivium, v_cat_empleo, v_loc_smt,
    'Profesor de Inglés | Trivium Magnum International School for Boys',
    'profesor-ingles-trivium-magnum-29',
    E'Trivium Magnum busca Profesor de Inglés nativo o con certificación C1+ para nuestro programa de educación bilingüe.\n\nEnfoque: inglés académico y conversacional, literatura clásica en inglés, debate y oratoria.\n\nRequisitos: nativo o certificación avanzada, experiencia enseñando niños y adolescentes, vocación docente genuina.\n\nMisión: formar hombres con dominio pleno del inglés como herramienta de liderazgo global. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','trivium','profesor','ingles','bilingue','santa-marta'],
    '[{"url":"/images/trivium-magnum.jpg","alt":"Trivium Magnum Inglés","order":0}]'
  );

  -- 30. Profesor de Ciencias
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_trivium, v_cat_empleo, v_loc_smt,
    'Profesor de Ciencias — Física, Química, Biología | Trivium Magnum',
    'profesor-ciencias-trivium-magnum-30',
    E'Trivium Magnum busca Profesor de Ciencias Naturales para bachillerato con énfasis en física, química y biología experimental.\n\nEnfoque pedagógico: aprendizaje por descubrimiento, laboratorio práctico, conexión con el entorno natural del Caribe colombiano.\n\nRequisitos: licenciatura en ciencias naturales o áreas afines, experiencia docente, pasión por la pedagogía activa. Inglés básico deseable.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','trivium','profesor','ciencias','fisica','quimica','santa-marta'],
    '[{"url":"/images/trivium-magnum.jpg","alt":"Trivium Magnum Ciencias","order":0}]'
  );

  -- 31. Profesor de Humanidades / Español
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_trivium, v_cat_empleo, v_loc_smt,
    'Profesor de Humanidades / Literatura y Español | Trivium Magnum',
    'profesor-humanidades-trivium-magnum-31',
    E'Trivium Magnum busca Profesor de Humanidades con dominio de literatura clásica, filosofía básica, historia y lengua castellana.\n\nEl Trivium — Gramática, Retórica y Lógica — es el corazón de nuestra filosofía educativa. El candidato ideal comprende y vive esta tradición.\n\nRequisitos: licenciatura en humanidades, filosofía, letras o historia; amor genuino por los clásicos; capacidad de inspirar a jóvenes a través de la palabra.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','trivium','profesor','humanidades','espanol','literatura','santa-marta'],
    '[{"url":"/images/trivium-magnum.jpg","alt":"Trivium Magnum Humanidades","order":0}]'
  );

  -- 32. Entrenador de Educación Física
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_trivium, v_cat_empleo, v_loc_smt,
    'Entrenador de Educación Física | Trivium Magnum — Formación de Carácter',
    'entrenador-ed-fisica-trivium-magnum-32',
    E'Trivium Magnum busca Entrenador de Educación Física que entienda el deporte como formación de carácter, disciplina y trabajo en equipo.\n\nActividades: atletismo, natación (acceso a instalaciones cercanas), artes marciales introductorias, deportes de equipo.\n\nRequisitos: licenciatura en educación física o entrenamiento deportivo, experiencia con niños y adolescentes, liderazgo positivo y firme.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','trivium','educacion-fisica','deporte','santa-marta'],
    '[{"url":"/images/trivium-magnum.jpg","alt":"Trivium Magnum Deporte","order":0}]'
  );

  -- 33. Director/a Académico / Rector/a
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_trivium, v_cat_empleo, v_loc_smt,
    'Director/a Académico — Rector/a | Trivium Magnum International School',
    'director-academico-trivium-magnum-33',
    E'Trivium Magnum busca su primer Director Académico / Rector para liderar la visión educativa de la institución desde su fundación.\n\nBuscamos a alguien que comparta una convicción profunda en la educación clásica, la formación del carácter masculino y la excelencia académica.\n\nRequisitos: maestría o doctorado en educación o humanidades, experiencia en liderazgo institucional, capacidad bilingüe español-inglés, disposición para construir desde cero con autonomía y visión.\n\nCargo de alta responsabilidad y alto impacto. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','trivium','director','rector','educacion','santa-marta','liderazgo'],
    '[{"url":"/images/trivium-magnum.jpg","alt":"Trivium Magnum Director","order":0}]'
  );

  -- 34. Psicólogo/a Escolar
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_trivium, v_cat_empleo, v_loc_smt,
    'Psicólogo/a Escolar | Trivium Magnum International School',
    'psicologo-escolar-trivium-magnum-34',
    E'Trivium Magnum busca Psicólogo/a Escolar para acompañar el bienestar emocional y académico de los estudiantes.\n\nFunciones: atención individual y grupal, orientación vocacional, apoyo a docentes en manejo de aula, comunicación con familias.\n\nRequisitos: título de psicología con tarjeta profesional vigente, enfoque en psicología educativa o infantojuvenil, empatía y vocación.\n\nCargo parcial (días definidos por semana). WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','trivium','psicologo','bienestar','educacion','santa-marta','parcial'],
    '[{"url":"/images/trivium-magnum.jpg","alt":"Trivium Magnum Psicología","order":0}]'
  );

  -- 35. Asistente Administrativo — Colegio
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_trivium, v_cat_empleo, v_loc_smt,
    'Asistente Administrativo — Colegio | Trivium Magnum',
    'asistente-admin-trivium-magnum-35',
    E'Trivium Magnum busca Asistente Administrativo para apoyar la secretaría académica y la operación general del colegio.\n\nFunciones: atención a padres de familia, gestión de documentos académicos, apoyo en matrículas, manejo de agenda institucional.\n\nRequisitos: técnico o tecnólogo en administración, excelente trato con el público, manejo de Office, orden y confidencialidad.\n\nContrato a término indefinido. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','trivium','administrativo','secretaria','santa-marta'],
    '[{"url":"/images/trivium-magnum.jpg","alt":"Trivium Magnum Administrativo","order":0}]'
  );

  -- ==============================================================
  -- MAIA LEGAL / MAIA MANAGEMENT GROUP (36–39)
  -- ==============================================================

  -- 36. Asistente Jurídico / Paralegal
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_legal, v_cat_empleo, v_loc_smt,
    'Asistente Jurídico / Paralegal | Maia Legal — Santa Marta',
    'asistente-juridico-paralegal-maia-legal-36',
    E'Maia Legal busca Asistente Jurídico o Paralegal para apoyar a nuestros abogados en casos de derecho inmobiliario, contratos comerciales y asesoría a inversionistas extranjeros.\n\nFunciones: revisión de contratos, consulta de registros en la Oficina de Instrumentos Públicos, redacción de derechos de petición, gestión documental.\n\nRequisitos: estudiante de últimos semestres de derecho o abogado recién graduado, inglés conversacional (trabajamos con clientes extranjeros), proactividad.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-legal','juridico','paralegal','derecho','santa-marta'],
    '[{"url":"/images/maia-legal.jpg","alt":"Maia Legal","order":0}]'
  );

  -- 37. Asistente Contable
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_empleo, v_loc_smt,
    'Asistente Contable | Maia Management Group — Santa Marta',
    'asistente-contable-maia-management-37',
    E'Maia Management Group busca Asistente Contable para apoyar la operación financiera del grupo empresarial.\n\nFunciones: causación de facturas, conciliaciones bancarias, preparación de informes de gastos, apoyo en declaraciones de renta y retención.\n\nRequisitos: tecnólogo o profesional en contaduría, manejo de software contable (Siigo o Helio), orden, precisión y confidencialidad.\n\nContrato a término indefinido, prestaciones completas. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-management','contable','finanzas','santa-marta'],
    '[{"url":"/images/maia-management.jpg","alt":"Maia Management","order":0}]'
  );

  -- 38. Recepcionista / Asistente Administrativo
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_empleo, v_loc_smt,
    'Recepcionista / Asistente Administrativo | Maia Management Group',
    'recepcionista-admin-maia-management-38',
    E'Maia Management Group busca Recepcionista y Asistente Administrativo para nuestra oficina en Santa Marta.\n\nFunciones: atención de clientes y visitantes, gestión de agenda, manejo de correspondencia, soporte a diferentes áreas del grupo.\n\nRequisitos: excelente presentación personal, inglés conversacional (indispensable — atendemos clientes internacionales), manejo de Office, actitud positiva.\n\nContrato a término indefinido. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-management','recepcionista','administrativo','ingles','santa-marta'],
    '[{"url":"/images/maia-management.jpg","alt":"Maia Management Oficina","order":0}]'
  );

  -- 39. Coordinador/a de Nómina
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_empleo, v_loc_smt,
    'Coordinador/a de Nómina | Maia Management Group',
    'coordinador-nomina-maia-management-39',
    E'Maia Management Group busca Coordinador/a de Nómina para administrar la nómina de las diferentes empresas del grupo (restaurante, academia, inmobiliaria y más).\n\nFunciones: liquidación de nómina, cálculo de prestaciones, gestión de seguridad social, novedades de personal, informes a gerencia.\n\nRequisitos: tecnólogo o profesional en contaduría o gestión humana, manejo de software de nómina, conocimiento de legislación laboral colombiana.\n\nCargo parcial. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-management','nomina','rrhh','contabilidad','santa-marta','parcial'],
    '[{"url":"/images/maia-management.jpg","alt":"Maia Management Nómina","order":0}]'
  );

  -- ==============================================================
  -- MAIA REALTY (40–41)
  -- ==============================================================

  -- 40. Agente Inmobiliario / Asesor de Compradores
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_realty, v_cat_empleo, v_loc_smt,
    'Agente Inmobiliario — Asesor de Compradores | Maia Realty Santa Marta',
    'agente-inmobiliario-maia-realty-40',
    E'Maia Realty busca Agentes Inmobiliarios para asesorar compradores nacionales e internacionales en la adquisición de propiedades en la Costa Caribe.\n\nNo se requiere matrícula de agente inmobiliario previa — te acompañamos en el proceso. Sí se requiere: habilidades comerciales, inglés conversacional, conocimiento de Santa Marta y sus barrios.\n\nIngresos: 100% comisión sobre ventas cerradas (entre 1.5% y 3% del valor del inmueble). Nuestros agentes activos ganan entre $5M y $20M por mes.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-realty','inmobiliaria','agente','comisiones','santa-marta'],
    '[{"url":"/images/maia-realty.jpg","alt":"Maia Realty","order":0}]'
  );

  -- 41. Fotógrafo/a de Propiedades
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_realty, v_cat_freelance, v_loc_smt,
    'Fotógrafo/a de Propiedades Inmobiliarias | Maia Realty (Freelance)',
    'fotografo-propiedades-maia-realty-41',
    E'Maia Realty busca Fotógrafo/a Freelance especializado en fotografía de inmuebles para enriquecer nuestros listados en Santa Marta.\n\nBuscamos: ojo para la composición, manejo de luz natural e iluminación de interiores, edición ágil en Lightroom o similar. Se valora experiencia en fotografía aérea con drone.\n\nCompensación: por sesión fotográfica (precio a convenir según tipo de propiedad).\n\nPortafolio por WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-realty','fotografo','inmuebles','freelance','santa-marta'],
    '[{"url":"/images/maia-realty.jpg","alt":"Fotografía Inmobiliaria","order":0}]'
  );

  -- ==============================================================
  -- LLAVE LABS (42–45)
  -- ==============================================================

  -- 42. Operario de Producción — Bebidas
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_llave, v_cat_empleo, v_loc_smt,
    'Operario de Producción — Bebidas Artesanales | Llave Labs',
    'operario-produccion-llave-labs-42',
    E'Llave Labs busca Operario de Producción para nuestra planta de elaboración de bebidas artesanales en Santa Marta.\n\nFunciones: preparación de insumos, operación de equipos de mezcla y embotellado, control de calidad básico, limpieza de planta bajo protocolos HACCP.\n\nRequisitos: bachiller o técnico en alimentos, responsabilidad y organización, capacidad física para trabajo de pie, disponibilidad de lunes a sábado.\n\nContrato a término indefinido, prestaciones completas. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','llave-labs','produccion','bebidas','operario','santa-marta'],
    '[{"url":"/images/llave-labs.jpg","alt":"Llave Labs Producción","order":0}]'
  );

  -- 43. Repartidor / Conductor de Entregas
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_llave, v_cat_empleo, v_loc_smt,
    'Repartidor / Conductor de Entregas | Llave Drinks — Santa Marta',
    'repartidor-conductor-llave-labs-43',
    E'Llave Drinks busca Repartidor/Conductor para distribución de nuestras bebidas a bares, restaurantes y hoteles en Santa Marta y alrededores.\n\nRequisitos: licencia de conducción B1 o C1 vigente, conocimiento de vías de Santa Marta y Costa, buena presentación para atención a clientes.\n\nSe valora: experiencia en distribución, manejo de furgoneta de carga liviana.\n\nSalario fijo + rodamiento + prestaciones. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','llave-labs','repartidor','conductor','entregas','santa-marta'],
    '[{"url":"/images/llave-labs.jpg","alt":"Llave Labs Entregas","order":0}]'
  );

  -- 44. Representante de Ventas — Canal Horeca
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_llave, v_cat_empleo, v_loc_smt,
    'Representante de Ventas — Canal HoReCa | Llave Drinks',
    'representante-ventas-horeca-llave-labs-44',
    E'Llave Drinks busca Representante de Ventas para el canal HoReCa (Hoteles, Restaurantes, Cafés) en Santa Marta y la Costa Caribe.\n\nFunciones: prospección de cuentas nuevas, mantenimiento de cuentas activas, presentación de productos, toma de pedidos, seguimiento de cobros.\n\nRequisitos: experiencia mínima 1 año en ventas B2B o canal HoReCa, vehículo propio deseable, actitud comercial y red de contactos en la industria.\n\nSalario base + comisiones + rodamiento. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','llave-labs','ventas','horeca','bebidas','santa-marta'],
    '[{"url":"/images/llave-labs.jpg","alt":"Llave Drinks Ventas","order":0}]'
  );

  -- 45. Brand Ambassador — Llave Drinks
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_llave, v_cat_empleo, v_loc_smt,
    'Brand Ambassador — Llave Drinks | Eventos y Activaciones',
    'brand-ambassador-llave-drinks-45',
    E'Llave Drinks busca Brand Ambassadors para representar la marca en eventos, activaciones y degustaciones en Santa Marta y la región.\n\nBuscamos: personas con excelente presentación personal, energía positiva, facilidad de comunicación con el público, pasión por las bebidas artesanales.\n\nTrabajo por evento/jornada. Pago competitivo, producto a disposición, uniforme Llave incluido.\n\nIdeal para estudiantes universitarios, modelos o personas con experiencia en eventos. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','llave-labs','ambassador','marca','eventos','santa-marta','parcial'],
    '[{"url":"/images/llave-labs.jpg","alt":"Llave Drinks Ambassador","order":0}]'
  );

  -- ==============================================================
  -- MAIA AERIAL (46–49)
  -- ==============================================================

  -- 46. Guía de Aventura / Adventure Guide
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_aerial, v_cat_empleo, v_loc_smt,
    'Guía de Aventura — Adventure Guide | Maia Aerial (Sierra Nevada)',
    'guia-aventura-maia-aerial-46',
    E'Maia Aerial busca Guías de Aventura para nuestro parque aéreo en las estribaciones de la Sierra Nevada de Santa Marta.\n\nFunciones: acompañamiento en canopy y tirolinas, briefing de seguridad, gestión de grupos, primeros auxilios básicos.\n\nRequisitos: experiencia en actividades de aventura o turismo de naturaleza, certificación en primeros auxilios (o disposición a certificarse), inglés conversacional, actitud positiva y de servicio.\n\nContrato a término indefinido. Trabajo en el entorno natural más impresionante de Colombia. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-aerial','guia','aventura','canopy','sierra-nevada','santa-marta'],
    '[{"url":"/images/maia-aerial.jpg","alt":"Maia Aerial Sierra Nevada","order":0}]'
  );

  -- 47. Técnico en Seguridad en Alturas
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_aerial, v_cat_empleo, v_loc_smt,
    'Técnico en Seguridad en Alturas | Maia Aerial — Certificado SENA',
    'tecnico-seguridad-alturas-maia-aerial-47',
    E'Maia Aerial busca Técnico en Seguridad en Alturas certificado para inspección y mantenimiento de nuestros equipos de canopy, tirolinas y estructuras de aventura.\n\nRequisitos: certificación vigente en trabajo seguro en alturas (nivel avanzado), experiencia en inspección de equipos de protección personal (EPP), conocimiento de normas ICONTEC para parques de aventura.\n\nOfrecemos: trabajo en un entorno natural extraordinario, contrato estable, equipo de trabajo apasionado.\n\nWhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-aerial','seguridad','alturas','tecnico','santa-marta'],
    '[{"url":"/images/maia-aerial.jpg","alt":"Maia Aerial Seguridad","order":0}]'
  );

  -- 48. Auxiliar de Construcción — Aventura
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_aerial, v_cat_empleo, v_loc_smt,
    'Auxiliar de Construcción — Estructuras de Aventura | Maia Aerial (Contrato)',
    'auxiliar-construccion-maia-aerial-48',
    E'Maia Aerial contrata Auxiliares de Construcción para la fase de expansión de nuestro parque de aventura en Gaira / Rodadero.\n\nFunciones: construcción de plataformas de madera, instalación de postes y cables guía, acabados en áreas naturales.\n\nRequisitos: experiencia en construcción o carpintería de obra, sin miedo a las alturas, disponibilidad inmediata.\n\nContrato por obra. Posibilidad de vinculación permanente al término de la construcción. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-aerial','construccion','contrato','santa-marta','gaira'],
    '[{"url":"/images/maia-aerial.jpg","alt":"Maia Aerial Construcción","order":0}]'
  );

  -- 49. Operador de Bar en Canopy
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_aerial, v_cat_empleo, v_loc_smt,
    'Operador de Bar — Zona de Canopy | Maia Aerial',
    'operador-bar-canopy-maia-aerial-49',
    E'Maia Aerial busca Operador de Bar para nuestra zona de descanso y celebración dentro del parque de aventura.\n\nFunciones: preparación y venta de bebidas (Llave Drinks y cócteles sencillos), atención al cliente post-aventura, mantenimiento de la zona de bar.\n\nRequisitos: experiencia mínima en servicio de bebidas, buena energía con grupos, gusto por la naturaleza y el outdoor.\n\nTrabajo principalmente fines de semana y festivos. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-aerial','bar','canopy','santa-marta','fines-de-semana'],
    '[{"url":"/images/maia-aerial.jpg","alt":"Bar Maia Aerial","order":0}]'
  );

  -- ==============================================================
  -- LLEVALLEVA PLATFORM (50–52)
  -- ==============================================================

  -- 50. Desarrollador/a Frontend — Next.js
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images, is_nationwide)
  VALUES (v_sel_lleva, v_cat_freelance, NULL,
    'Desarrollador/a Frontend Next.js — Plataforma LlevaLleva (Freelance/Contrato)',
    'desarrollador-frontend-nextjs-llevalleva-50',
    E'LlevaLleva busca Desarrollador/a Frontend con experiencia en Next.js para contribuir al desarrollo de nuestra plataforma de clasificados colombiana.\n\nStack: Next.js (App Router), TypeScript, Tailwind CSS, Supabase. Experiencia con RSC (React Server Components) y patrones modernos de data fetching.\n\nProyecto: features de búsqueda, filtros, páginas de listado y perfil. Código limpio, accesible, rápido.\n\nTrabajo remoto. Pago en COP o USD. Repositorio en GitHub. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','llevalleva','frontend','nextjs','typescript','remote','freelance'],
    '[{"url":"/images/llevalleva-dev.jpg","alt":"LlevaLleva Dev","order":0}]',
    TRUE
  );

  -- 51. Redactor/a de Contenido SEO
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images, is_nationwide)
  VALUES (v_sel_lleva, v_cat_freelance, NULL,
    'Redactor/a de Contenido SEO — LlevaLleva (Remoto, Freelance)',
    'redactor-contenido-seo-llevalleva-51',
    E'LlevaLleva busca Redactor/a de Contenido SEO para crear guías, artículos y páginas de categoría que posicionen la plataforma en Google Colombia.\n\nTemas: clasificados, compra-venta, empleos, inmobiliaria, vida en la Costa Caribe, guías de ciudades colombianas.\n\nRequisitos: experiencia en escritura SEO (keyword research, on-page optimization), español nativo impecable, entrega puntual.\n\nPago por artículo. Trabajo 100% remoto. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','llevalleva','seo','redactor','contenido','freelance','remoto'],
    '[{"url":"/images/llevalleva-dev.jpg","alt":"LlevaLleva Contenido","order":0}]',
    TRUE
  );

  -- 52. Moderador/a de Plataforma
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images, is_nationwide)
  VALUES (v_sel_lleva, v_cat_empleo, NULL,
    'Moderador/a de Plataforma | LlevaLleva — Trabajo Remoto',
    'moderador-plataforma-llevalleva-52',
    E'LlevaLleva busca Moderador/a de Contenido para revisar y aprobar listados publicados en la plataforma, detectar spam y fraudes, y mantener la comunidad sana.\n\nFunciones: revisión diaria de nuevos listados, respuesta a reportes de usuarios, aplicación de políticas de contenido.\n\nRequisitos: criterio para distinguir contenido legítimo de fraudulento, rapidez de revisión, comunicación clara y profesional.\n\nTrabajo remoto, horario flexible. Ideal como trabajo adicional. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','llevalleva','moderador','remoto','parcial'],
    '[{"url":"/images/llevalleva-dev.jpg","alt":"LlevaLleva Moderación","order":0}]',
    TRUE
  );

  -- ==============================================================
  -- HOGAR — Servicio Doméstico (53–54)
  -- Posted by Maia Management Group as HR service
  -- ==============================================================

  -- 53. Chef / Cocinero/a para el Hogar
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_empleo, v_loc_smt,
    'Se Busca: Chef / Cocinero/a para el Hogar — Santa Marta',
    'chef-cocinero-hogar-santa-marta-53',
    E'Familia en Santa Marta busca Chef o Cocinero/a para el hogar. Personas interesadas en el cargo, apliquen aquí.\n\nFunciones: preparación de desayunos y comidas, compras en mercado, mantenimiento de cocina limpia.\n\nRequisitos: experiencia comprobada en cocina casera o de restaurante, referencias personales, honestidad y discreción.\n\nDisponibilidad: tiempo completo o por días (se negocia). WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','hogar','chef','cocinero','santa-marta','servicio-domestico'],
    '[{"url":"/images/placeholder.jpg","alt":"Chef Hogar","order":0}]'
  );

  -- 54. Aseadora / Empleada Doméstica
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_empleo, v_loc_smt,
    'Se Busca: Aseadora / Empleada Doméstica — Santa Marta (Tiempo Completo)',
    'aseadora-empleada-domestica-santa-marta-54',
    E'Familia en Santa Marta busca Aseadora de tiempo completo con experiencia en limpieza de hogares.\n\nFunciones: limpieza general del hogar, lavado y planchado de ropa, orden de espacios.\n\nRequisitos: experiencia comprobable, referencias de empleadores anteriores, responsabilidad y puntualidad.\n\nSalario mínimo + prestaciones completas conforme a ley. Posibilidad de alojamiento. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','hogar','aseadora','domestica','santa-marta','tiempo-completo'],
    '[{"url":"/images/placeholder.jpg","alt":"Aseadora Hogar","order":0}]'
  );

  -- ==============================================================
  -- EL SANATORIO — Construcción y Remodelación (55–59)
  -- ==============================================================

  -- 55. Electricista
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Electricista — Instalación y Remodelación | El Sanatorio (Contrato)',
    'electricista-el-sanatorio-55',
    E'El Sanatorio requiere Electricista para trabajos de instalación y remodelación eléctrica en nuestro local del Centro Histórico (Calle 19 #4-23).\n\nTrabajos: instalación de circuitos de iluminación temática, tomas especiales para equipos de bar y cocina, sistema de luces DMX, planta eléctrica de respaldo.\n\nRequisitos: matrícula CONTE vigente, experiencia en locales comerciales y restaurantes, disponibilidad inmediata.\n\nContrato por obra. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','electricista','construccion','contrato','santa-marta'],
    '[{"url":"/images/sanatorio-interior.jpg","alt":"El Sanatorio Eléctrico","order":0}]'
  );

  -- 56. Plomero / Gasfitero
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Plomero / Gasfitero — Remodelación Local | El Sanatorio (Contrato)',
    'plomero-gasfitero-el-sanatorio-56',
    E'El Sanatorio requiere Plomero para trabajos de plomería y gasfitería en nuestro local en el Centro de Santa Marta.\n\nTrabajos: instalación de puntos de agua en barra y cocina, tuberías de gas para zona de cocina yakitori, baños nuevos.\n\nRequisitos: experiencia mínima 3 años en plomería comercial, manejo de normas de gas NTC, disponibilidad inmediata.\n\nContrato por obra determinada. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','plomero','gasfitero','construccion','contrato','santa-marta'],
    '[{"url":"/images/sanatorio-interior.jpg","alt":"El Sanatorio Plomería","order":0}]'
  );

  -- 57. Carpintero / Ebanista
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Carpintero / Ebanista — Mobiliario Temático | El Sanatorio (Contrato)',
    'carpintero-ebanista-el-sanatorio-57',
    E'El Sanatorio busca Carpintero o Ebanista para fabricar el mobiliario temático de nuestro gastro bar y laberinto del horror.\n\nProyecto: mesas, sillas y barras de madera envejecida con estética victoriana-horror; estructuras del laberinto; puertas y paneles decorativos.\n\nRequisitos: experiencia en carpintería fina y de obra, creatividad para adaptar diseños temáticos, disponibilidad para trabajo en sitio (Calle 19 #4-23 Centro).\n\nContrato por obra. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','carpintero','ebanista','mobiliario','contrato','santa-marta'],
    '[{"url":"/images/sanatorio-interior.jpg","alt":"El Sanatorio Carpintería","order":0}]'
  );

  -- 58. Pintor
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Pintor — Murales y Acabados Temáticos | El Sanatorio (Contrato)',
    'pintor-murales-el-sanatorio-58',
    E'El Sanatorio busca Pintor con experiencia en acabados especiales y capacidad para ejecutar (o interpretar) murales de temática horror-victoriana en paredes y techos.\n\nTrabajos: pintura base y acabados de todo el local; murales temáticos en salón y laberinto; efectos de envejecimiento y texturas.\n\nRequisitos: experiencia en pintura de acabados especiales; se valora experiencia en murales o grafiti artístico oscuro.\n\nContrato por obra. Disponibilidad inmediata. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','pintor','murales','contrato','santa-marta'],
    '[{"url":"/images/sanatorio-interior.jpg","alt":"El Sanatorio Pintura","order":0}]'
  );

  -- 59. Diseñador/a de Interiores — Concepto Horror
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Diseñador/a de Interiores — Concepto Horror-Gourmet | El Sanatorio (Contrato)',
    'disenador-interiores-horror-el-sanatorio-59',
    E'El Sanatorio busca Diseñador/a de Interiores para co-liderar la conceptualización y supervisión de los acabados finales de nuestro gastro bar de terror.\n\nConcepto: horror victoriano con toques japoneses — oscuro, elegante, perturbador y funcional para un restaurante de alta rotación.\n\nBuscamos: portafolio en diseño de restaurantes o entretenimiento, comprensión de flujos de cocina y bar, gusto por lo inusual.\n\nContrato por proyecto con honorarios a convenir. WhatsApp: +573001234567',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','disenador','interiores','horror','contrato','santa-marta'],
    '[{"url":"/images/sanatorio-interior.jpg","alt":"El Sanatorio Diseño Interior","order":0}]'
  );

  RAISE NOTICE 'Job listings seeded: 59 listings (1–59)';

END $$;

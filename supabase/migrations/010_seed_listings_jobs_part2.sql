-- ============================================================
-- Migration 010: Remaining Jobs + Mapaná Marine Profile
-- Listings #60–79 — fills gaps from master list
-- Depends on: 008_seed_business_profiles.sql, 009_seed_listings_jobs.sql
-- ============================================================

DO $$
DECLARE
  v_sel_sanatorio UUID := 'a1b2c3d4-0001-0001-0001-000000000001';
  v_sel_juno      UUID := 'a1b2c3d4-0001-0001-0001-000000000002';
  v_sel_legal     UUID := 'a1b2c3d4-0001-0001-0001-000000000005';
  v_sel_mgmt      UUID := 'a1b2c3d4-0001-0001-0001-000000000006';
  v_sel_bevida    UUID := 'a1b2c3d4-0001-0001-0001-000000000008';
  v_sel_aerial    UUID := 'a1b2c3d4-0001-0001-0001-000000000009';
  v_sel_lleva     UUID := 'a1b2c3d4-0001-0001-0001-000000000010';
  v_sel_mapana    UUID := 'a1b2c3d4-0001-0001-0001-000000000011';

  v_cat_empleo    UUID;
  v_cat_freelance UUID;
  v_loc_smt       UUID;
BEGIN

  SELECT id INTO v_cat_empleo   FROM categories WHERE slug = 'ofertas-empleo';
  SELECT id INTO v_cat_freelance FROM categories WHERE slug = 'freelance';
  SELECT id INTO v_loc_smt      FROM locations  WHERE slug = 'santa-marta';

  -- ============================================================
  -- PASO 1: Mapaná Marine — nuevo perfil de negocio
  -- ============================================================

  INSERT INTO auth.users (
    id, instance_id, aud, role, email,
    encrypted_password, email_confirmed_at,
    raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at, is_sso_user, is_anonymous
  ) VALUES (
    v_sel_mapana,
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.mapana.marine@llevalleva.co',
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
    v_sel_mapana,
    'bot_mapana_marine',
    'Mapaná Marine',
    'bot',
    'Taller naval especializado en fabricación, reparación y equipamiento de embarcaciones en fibra de vidrio y aluminio. Operamos en la Costa Caribe colombiana.',
    'Mapaná Marine',
    NULL,
    'Santa Marta', 'Magdalena',
    '+573174370575', true,
    true, true,
    now(), now()
  ) ON CONFLICT (id) DO NOTHING;

  -- ============================================================
  -- PASO 2: Actualizar perfil Be Vida (rebrand de Llave Labs)
  -- ============================================================

  UPDATE profiles SET
    display_name   = 'Be Vida Botánicas',
    business_name  = 'Be Vida Botánicas',
    bio            = 'Productora artesanal de bebidas RTD (ready-to-drink) de la Costa Caribe. Cócteles botánicos, shots de fruta tropical y bebidas de barril en formato Sankey 20L para el canal B2B. Santa Marta, Colombia.',
    updated_at     = now()
  WHERE id = v_sel_bevida;

  -- ============================================================
  -- EL SANATORIO — Bar Manager (#60)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_empleo, v_loc_smt,
    'Bar Manager | El Sanatorio Gastro Bar — Santa Marta',
    'bar-manager-el-sanatorio-60',
    E'El Sanatorio busca Bar Manager para liderar la operación completa de nuestra barra.\n\nResponsabilidades: gestión del equipo de bartenders y bar backs, diseño y actualización de la carta de cócteles, control de inventario y costos de bebidas, coordinación con proveedores de licores.\n\nRequisitos: mínimo 3 años de experiencia en bares de coctelería, liderazgo comprobado de equipos, conocimiento de costos F&B, carácter fuerte y organizativo. Inglés básico deseable.\n\nSalario: $2.800.000 – $3.800.000 COP/mes + propinas + prestaciones completas.\n\nContacto: WhatsApp +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','bar-manager','gestion','cocteleria','santa-marta','tiempo-completo'],
    '[{"url":"/images/sanatorio-bar.jpg","alt":"Bar El Sanatorio","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- JUNO HOUSE STUDIOS — Studio Manager (#61)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_juno, v_cat_empleo, v_loc_smt,
    'Coordinador/a de Estudio | Juno House Studios — Santa Marta',
    'coordinador-estudio-juno-house-61',
    E'Juno House Studios busca Coordinador/a de Estudio para gestionar la operación diaria de la agencia.\n\nFunciones: planificación de agenda de producción, coordinación entre equipos de contenido, atención a clientes, seguimiento de entregas y métricas, gestión de proveedores.\n\nRequisitos: experiencia en coordinación de proyectos o producción de contenido, discreción absoluta, habilidades organizativas sólidas, manejo de herramientas de gestión (Notion, Trello o similar).\n\nSalario: $1.800.000 – $2.500.000 COP/mes. Trabajo presencial en Santa Marta.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','juno-house','coordinador','estudio','produccion','santa-marta'],
    '[{"url":"/images/juno-studios.jpg","alt":"Juno House Studios","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- MAIA LEGAL — Asistente Administrativo Legal (#62)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_legal, v_cat_empleo, v_loc_smt,
    'Asistente Administrativo/a Legal | Maia Legal — Santa Marta',
    'asistente-admin-legal-maia-legal-62',
    E'Maia Legal busca Asistente Administrativo/a para apoyar la operación de nuestra firma jurídica en Santa Marta.\n\nFunciones: atención a clientes (muchos son extranjeros), agendamiento de citas, gestión y archivo de documentos legales, seguimiento de trámites ante notarías, DIAN y Cámara de Comercio, comunicación en inglés y español.\n\nRequisitos: técnico o tecnólogo en administración o áreas afines, inglés conversacional (indispensable), excelente presentación personal, confidencialidad.\n\nSalario: $1.600.000 – $2.000.000 COP/mes + prestaciones.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-legal','asistente','administrativo','ingles','santa-marta'],
    '[{"url":"/images/maia-legal.jpg","alt":"Maia Legal","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- MAIA MANAGEMENT — Recruitment Coordinator (#63)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_empleo, v_loc_smt,
    'Coordinador/a de Reclutamiento | Maia Management Group',
    'coordinador-reclutamiento-maia-management-63',
    E'Maia Management Group busca Coordinador/a de Reclutamiento para gestionar los procesos de selección del grupo empresarial y sus empresas aliadas.\n\nFunciones: publicación de vacantes, filtro de hojas de vida, coordinación de entrevistas, verificación de referencias, onboarding de nuevos colaboradores.\n\nRequisitos: tecnólogo o profesional en psicología, administración o gestión humana; experiencia mínima 1 año en selección de personal; manejo de LinkedIn Recruiter y WhatsApp Business.\n\nSalario: $1.800.000 – $2.300.000 COP/mes + prestaciones.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-management','reclutamiento','rrhh','seleccion','santa-marta'],
    '[{"url":"/images/maia-management.jpg","alt":"Maia Management RRHH","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- MAIA MANAGEMENT — Office Manager (#64)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_empleo, v_loc_smt,
    'Office Manager | Maia Management Group — Santa Marta',
    'office-manager-maia-management-64',
    E'Maia Management Group busca Office Manager para coordinar el funcionamiento de nuestras oficinas centrales en Santa Marta.\n\nFunciones: gestión de proveedores de servicios de oficina, control de suministros, coordinación de mantenimiento, apoyo logístico a la gerencia, organización de reuniones y viajes corporativos.\n\nRequisitos: mínimo 2 años en cargo similar, inglés intermedio, manejo avanzado de Google Workspace, capacidad de tomar decisiones con autonomía.\n\nSalario: $2.000.000 – $2.800.000 COP/mes + prestaciones completas.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-management','office-manager','administracion','santa-marta'],
    '[{"url":"/images/maia-management.jpg","alt":"Maia Management Oficina","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- MAIA MANAGEMENT — Bilingual Customer Service Rep (#65)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_empleo, v_loc_smt,
    'Asesor/a Bilingüe de Servicio al Cliente | Maia Management Group',
    'asesor-bilingue-servicio-cliente-maia-65',
    E'Maia Management Group busca Asesor/a de Servicio al Cliente bilingüe español-inglés para atender a nuestra clientela nacional e internacional.\n\nFunciones: atención por WhatsApp, correo y presencial; resolución de consultas y quejas; direccionamiento a las áreas correctas del grupo (legal, realty, academia).\n\nRequisitos: inglés fluido (escrito y hablado — se evalúa), excelente comunicación, paciencia y orientación al servicio, experiencia mínima 1 año en atención al cliente.\n\nSalario: $1.800.000 – $2.500.000 COP/mes + prestaciones.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-management','bilingue','servicio-cliente','ingles','santa-marta'],
    '[{"url":"/images/maia-management.jpg","alt":"Maia Management Atención","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- BE VIDA BOTÁNICAS — Production Supervisor (#66)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_bevida, v_cat_empleo, v_loc_smt,
    'Supervisor/a de Producción — Bebidas RTD | Be Vida Botánicas',
    'supervisor-produccion-be-vida-66',
    E'Be Vida Botánicas busca Supervisor/a de Producción para liderar el equipo operativo de nuestra planta de bebidas artesanales en Santa Marta.\n\nFunciones: planificación de producción por lotes, supervisión del proceso desde recepción de materia prima hasta empaque, control de BPM, gestión de turnos de operarios.\n\nRequisitos: tecnólogo o profesional en ingeniería de alimentos, producción industrial o áreas afines; mínimo 2 años en cargos similares en industria de alimentos o bebidas; conocimiento de BPM y HACCP.\n\nSalario: $2.200.000 – $3.000.000 COP/mes + prestaciones.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','be-vida','produccion','supervisor','bebidas','bpm','santa-marta'],
    '[{"url":"/images/llave-labs.jpg","alt":"Be Vida Producción","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- BE VIDA BOTÁNICAS — QC Specialist (#67)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_bevida, v_cat_empleo, v_loc_smt,
    'Especialista de Control de Calidad — Bebidas | Be Vida Botánicas',
    'especialista-qc-be-vida-67',
    E'Be Vida Botánicas busca Especialista en Control de Calidad (QC) para garantizar que cada lote de nuestras bebidas cumpla con los estándares sensoriales, microbiológicos y de etiquetado.\n\nFunciones: análisis sensorial por lote, toma de muestras para laboratorio, verificación de etiquetado y fechas, gestión de no conformidades, apoyo en trámites INVIMA.\n\nRequisitos: profesional o tecnólogo en ciencias de alimentos, microbiología o afines; experiencia en QC de bebidas o alimentos; conocimiento de normativa INVIMA y BPM.\n\nSalario: $2.000.000 – $2.800.000 COP/mes.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','be-vida','calidad','qc','invima','bebidas','santa-marta'],
    '[{"url":"/images/llave-labs.jpg","alt":"Be Vida Control Calidad","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- BE VIDA BOTÁNICAS — Warehouse & Logistics Lead (#68)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_bevida, v_cat_empleo, v_loc_smt,
    'Jefe de Bodega y Logística | Be Vida Botánicas — Santa Marta',
    'jefe-bodega-logistica-be-vida-68',
    E'Be Vida Botánicas busca Jefe de Bodega y Logística para controlar el inventario de materias primas y producto terminado, y coordinar las entregas B2B en la región.\n\nFunciones: control de inventario (entradas y salidas), gestión de bodega con FIFO, coordinación de despachos a bares, hoteles y distribuidores, relación con transportistas y mensajeros.\n\nRequisitos: tecnólogo en logística, administración o afines; experiencia mínima 2 años en bodega o logística; manejo de Excel o software de inventario; licencia de conducción deseable.\n\nSalario: $1.900.000 – $2.500.000 COP/mes + prestaciones.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','be-vida','bodega','logistica','inventario','santa-marta'],
    '[{"url":"/images/llave-labs.jpg","alt":"Be Vida Bodega","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- MAIA AERIAL — Zip Line Safety Technician (#69)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_aerial, v_cat_empleo, v_loc_smt,
    'Técnico de Seguridad — Tirolina / Zip Line | Maia Aerial (Sierra Nevada)',
    'tecnico-seguridad-tirolina-maia-aerial-69',
    E'Maia Aerial busca Técnico de Seguridad especializado en sistemas de tirolina y canopy para nuestro parque de aventura aérea en las estribaciones de la Sierra Nevada.\n\nFunciones: inspección diaria de cables, arneses y plataformas; briefing de seguridad a visitantes; operación de los puntos de salida y llegada; reporte de mantenimiento preventivo.\n\nRequisitos: certificación en trabajo en alturas vigente (resolución 4272/2021 o equivalente), experiencia en parques de aventura o rigging, buena forma física, primeros auxilios básicos.\n\nSalario: $1.800.000 – $2.400.000 COP/mes + auxilio de transporte + prestaciones.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','maia-aerial','seguridad','tirolina','zip-line','alturas','sierra-nevada'],
    '[{"url":"/images/maia-aerial.jpg","alt":"Maia Aerial Tirolina","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- MAPANÁ MARINE — Marine Fabricator / Welder (#70)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mapana, v_cat_empleo, v_loc_smt,
    'Fabricador / Soldador Naval | Mapaná Marine — Santa Marta',
    'fabricador-soldador-naval-mapana-marine-70',
    E'Mapaná Marine busca Fabricador/Soldador Naval con experiencia en estructuras metálicas para embarcaciones recreativas y de trabajo en la Costa Caribe.\n\nFunciones: fabricación y soldadura de estructuras en acero inoxidable y aluminio marino, pasamanos, soportes de motor, anclas y accesorios de cubierta; interpretación de planos navales básicos.\n\nRequisitos: experiencia mínima 3 años en soldadura MIG/TIG (materiales marinos), deseable certificación AWS o SMAW, disponibilidad para trabajar en astillero y embarcaciones en agua.\n\nSalario: $2.000.000 – $2.800.000 COP/mes + prestaciones + dotación.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','mapana-marine','soldador','fabricador','naval','astillero','santa-marta'],
    '[{"url":"/images/mapana-marine.jpg","alt":"Mapaná Marine Soldadura","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- MAPANÁ MARINE — Marine Electrical Technician (#71)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mapana, v_cat_empleo, v_loc_smt,
    'Técnico Eléctrico Naval | Mapaná Marine — Santa Marta',
    'tecnico-electrico-naval-mapana-marine-71',
    E'Mapaná Marine busca Técnico Eléctrico Naval para instalación y mantenimiento de sistemas eléctricos de 12V, 24V y 220V en embarcaciones.\n\nFunciones: instalación de paneles solares y baterías en lanchas, cableado de instrumentación náutica (GPS, sonda, VHF), diagnóstico de fallas eléctricas, instalación de sistemas de iluminación LED marina.\n\nRequisitos: técnico en electricidad con experiencia en instalaciones marinas o automotrices (se adapta), conocimiento de normas ABYC o equivalente deseable, capacidad de trabajo en espacios confinados y a bordo.\n\nSalario: $2.200.000 – $3.000.000 COP/mes.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','mapana-marine','electrico','tecnico','naval','embarcaciones','santa-marta'],
    '[{"url":"/images/mapana-marine.jpg","alt":"Mapaná Marine Eléctrico","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- MAPANÁ MARINE — Fibreglass Laminator (#72)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mapana, v_cat_empleo, v_loc_smt,
    'Laminador en Fibra de Vidrio | Mapaná Marine — Santa Marta',
    'laminador-fibra-vidrio-mapana-marine-72',
    E'Mapaná Marine busca Laminador en Fibra de Vidrio (FRP) para fabricación y reparación de cascos, cubiertas y estructuras de embarcaciones en nuestra planta naval.\n\nFunciones: laminado manual (hand lay-up) y proyección de resinas; aplicación de gelcoat; lijado y acabados superficiales; reparaciones estructurales de embarcaciones dañadas.\n\nRequisitos: mínimo 2 años de experiencia en laminación de fibra de vidrio (náutica, piscinas o automotriz); uso correcto de EPP para resinas y catalizadores; trabajo en equipo bajo supervisión de maestro de obra.\n\nSalario: $1.800.000 – $2.400.000 COP/mes + dotación y EPP completos.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','mapana-marine','fibra-vidrio','laminador','naval','frp','santa-marta'],
    '[{"url":"/images/mapana-marine.jpg","alt":"Mapaná Marine Fibra","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- GENERAL — Diseñador/a Gráfico/a (#73)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images, is_nationwide)
  VALUES (v_sel_mgmt, v_cat_freelance, NULL,
    'Diseñador/a Gráfico/a — Grupo Maia | Freelance o Parcial',
    'disenador-grafico-grupo-maia-73',
    E'Maia Management Group busca Diseñador/a Gráfico/a para apoyar las marcas del grupo: El Sanatorio, Be Vida, Maia Masters Academy, Trivium Magnum y LlevaLleva.\n\nTrabajos frecuentes: diseño de piezas para redes sociales, flyers de eventos, menús, identidad visual y material impreso.\n\nRequisitos: dominio de Adobe Illustrator y Photoshop (o Affinity equivalente), portafolio variado, entrega puntual, disposición para trabajar con briefings creativos específicos por marca.\n\nModalidad: freelance por proyecto o parcial (10–20 hrs/semana). Pago en COP por entregable.\n\nPortafolio + tarifa por WhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','diseno','grafico','freelance','marcas','remoto','maia'],
    '[{"url":"/images/maia-management.jpg","alt":"Diseño Gráfico Maia","order":0}]',
    TRUE
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- GENERAL — Community Manager / Social Media (#74)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images, is_nationwide)
  VALUES (v_sel_mgmt, v_cat_freelance, NULL,
    'Community Manager / Social Media Manager — Grupo Maia',
    'community-manager-grupo-maia-74',
    E'Maia Management Group busca Community Manager para gestionar las redes sociales de las marcas del grupo en Instagram y TikTok principalmente.\n\nFunciones: publicación de contenido (en coordinación con diseñador y fotógrafo), respuesta a comentarios y mensajes, reportes mensuales de métricas, propuestas de contenido.\n\nRequisitos: experiencia comprobable manejando cuentas de negocio, conocimiento de Meta Business Suite, creatividad para adaptar el tono por marca (horror/gourmet para El Sanatorio, tropical para Be Vida, académico para Masters).\n\nModalidad: remoto. Salario: $1.500.000 – $2.200.000 COP/mes según experiencia.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','community-manager','redes-sociales','instagram','tiktok','remoto','maia'],
    '[{"url":"/images/maia-management.jpg","alt":"Social Media Maia","order":0}]',
    TRUE
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- GENERAL — Fotógrafo/a y Videoasta (#75)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_freelance, v_loc_smt,
    'Fotógrafo/a y Videoasta — Marcas Maia | Santa Marta (Freelance)',
    'fotografo-videoasta-grupo-maia-75',
    E'Maia Management Group busca Fotógrafo/a y Videoasta freelance basado/a en Santa Marta para cubrir los proyectos visuales del grupo.\n\nProyectos: fotografía gastronómica para El Sanatorio, videos de producto para Be Vida, contenido de campus para Trivium Magnum, fotografia de inmuebles para Maia Realty.\n\nRequisitos: equipo propio (cámara mirrorless o DSLR, iluminación básica), edición en Lightroom y Premiere/CapCut, portafolio variado, disponibilidad para sesiones en sitio.\n\nPago por sesión según tipo de proyecto. Tarifas a convenir.\n\nPortafolio por WhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','fotografo','video','freelance','gastronomia','inmobiliaria','santa-marta'],
    '[{"url":"/images/maia-management.jpg","alt":"Fotografía Maia","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- GENERAL — IT Support Technician (#76)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_empleo, v_loc_smt,
    'Técnico/a de Soporte IT | Maia Management Group — Santa Marta',
    'tecnico-soporte-it-maia-management-76',
    E'Maia Management Group busca Técnico de Soporte IT para dar soporte tecnológico a las oficinas y negocios del grupo en Santa Marta.\n\nFunciones: mantenimiento de computadores y periféricos, soporte de red Wi-Fi y cableado estructurado, configuración de sistemas POS, soporte a usuarios en herramientas Google Workspace y CRM.\n\nRequisitos: técnico o tecnólogo en sistemas, mínimo 1 año de experiencia en soporte técnico, capacidad de diagnóstico rápido, buena disposición con usuarios no técnicos.\n\nSalario: $1.600.000 – $2.200.000 COP/mes. Presencial Santa Marta con visitas a distintos locales del grupo.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','it','soporte','tecnologia','sistemas','santa-marta','tiempo-completo'],
    '[{"url":"/images/maia-management.jpg","alt":"IT Soporte Maia","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- GENERAL — Driver / Messenger (#77)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_empleo, v_loc_smt,
    'Conductor/a Mensajero/a — Diligencias y Apoyo Logístico | Grupo Maia',
    'conductor-mensajero-grupo-maia-77',
    E'Maia Management Group busca Conductor/Mensajero para apoyo logístico y diligencias del grupo empresarial en Santa Marta.\n\nFunciones: diligencias bancarias y ante entidades, entrega de documentos, apoyo en transporte de insumos y equipos entre los diferentes negocios del grupo, transporte ocasional de personal directivo.\n\nRequisitos: licencia de conducción B1 vigente, conocimiento de las vías de Santa Marta y municipios cercanos, puntualidad y confianza absoluta, vehículo propio deseable (se reconoce rodamiento).\n\nSalario: $1.423.500 – $1.700.000 COP/mes + auxilio de transporte + prestaciones.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','conductor','mensajero','logistica','santa-marta','tiempo-completo'],
    '[{"url":"/images/maia-management.jpg","alt":"Conductor Maia","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- GENERAL — General Builder / Handyman (#78)
  -- ============================================================

  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_empleo, v_loc_smt,
    'Maestro/a de Obra / Ayudante Múltiple — Obras Grupo Maia | Santa Marta',
    'maestro-obra-ayudante-grupo-maia-78',
    E'Grupo Maia busca Maestro/a de Obra o Ayudante General para apoyar trabajos de adecuación y mantenimiento en los distintos locales del grupo en Santa Marta.\n\nTrabajos frecuentes: pañete y resane, enchape, instalación de drywall, pintura general, mantenimiento preventivo de locales, apoyo en obras de adecuación.\n\nRequisitos: experiencia mínima 3 años en construcción o acabados, herramienta propia básica, disponibilidad inmediata, referencias de trabajo anteriores.\n\nContrato por obra o término indefinido según desempeño. Pago: desde $1.423.500 + prestaciones.\n\nWhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','obra','construccion','maestro','ayudante','santa-marta','contrato'],
    '[{"url":"/images/sanatorio-interior.jpg","alt":"Obras Grupo Maia","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  RAISE NOTICE 'Migration 010 complete: Mapaná Marine profile + job listings #60–78';

END $$;

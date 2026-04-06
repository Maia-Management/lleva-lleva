-- ============================================================
-- Migration 013: Remaining Services Wanted (#151–154)
-- Closes the four gaps left open after migration 012:
--   Fresh produce supplier, Accountant, Lawyer, Web developer
-- Depends on: 008_seed_business_profiles.sql
-- ============================================================

DO $$
DECLARE
  v_sel_sanatorio UUID := 'a1b2c3d4-0001-0001-0001-000000000001';
  v_sel_legal     UUID := 'a1b2c3d4-0001-0001-0001-000000000005';
  v_sel_mgmt      UUID := 'a1b2c3d4-0001-0001-0001-000000000006';

  v_cat_otros_serv UUID;
  v_cat_juridico   UUID;
  v_cat_financiero UUID;
  v_cat_serv_tech  UUID;

  v_loc_smt UUID;
BEGIN

  SELECT id INTO v_cat_otros_serv FROM categories WHERE slug = 'otros-servicios';
  SELECT id INTO v_cat_juridico   FROM categories WHERE slug = 'juridico';
  SELECT id INTO v_cat_financiero FROM categories WHERE slug = 'financiero';
  SELECT id INTO v_cat_serv_tech  FROM categories WHERE slug = 'servicios-tech';
  SELECT id INTO v_loc_smt        FROM locations  WHERE slug = 'santa-marta';

  -- ============================================================
  -- #151 — Proveedor de frutas y verduras frescas
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_sanatorio, v_cat_otros_serv, v_loc_smt,
    'SE BUSCA: Proveedor de Frutas y Verduras Frescas — Restaurante Santa Marta',
    'se-busca-proveedor-frutas-verduras-frescas-151',
    E'El Sanatorio Gastro Bar busca proveedor confiable de frutas y verduras frescas para el abastecimiento diario de nuestra cocina en el Centro Histórico de Santa Marta.\n\nQué necesitamos:\n• Frutas tropicales frescas: maracuyá, guanábana, mango, piña, limón tahití, tomate de árbol\n• Verduras de cocina: cebolla, ajo, pimentones, tomate, cilantro, hierbas aromáticas\n• Ingredientes para cocina japonesa-latina: aguacate, pepino, jengibre fresco, limón\n\nCondiciones:\n• Entrega diaria o interdiaria en el Centro de Santa Marta\n• Producto limpio, sin daños, en bolsa o caja adecuada\n• Facturación electrónica\n• Precios competitivos con posibilidad de crédito a 8 días\n\nInteresados contactar: WhatsApp +573174370575 con lista de precios.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','proveedor','frutas','verduras','fresco','restaurante','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Frutas Verduras Frescas","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #152 — Contador/a para empresas del grupo
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_financiero, v_loc_smt,
    'SE BUSCA: Contador/a Público/a — Contrato o Outsourcing | Grupo Maia Santa Marta',
    'se-busca-contador-publico-outsourcing-grupo-maia-152',
    E'Maia Management Group busca Contador/a Público/a para apoyar la gestión contable y tributaria del grupo empresarial (restaurante, academia, productora de bebidas, firma jurídica e inmobiliaria).\n\nQué necesitamos:\n• Revisión y firma de estados financieros mensuales\n• Declaraciones tributarias: IVA, retención en la fuente, renta\n• Asesoría en planeación fiscal para el grupo\n• Acompañamiento en auditorías o requerimientos DIAN\n• Firma como Contador Público Certificado en documentos oficiales\n\nModalidad: outsourcing (no se requiere presencia diaria). 10–20 horas mensuales estimadas.\nTarjeta profesional vigente indispensable.\n\nHonorarios a convenir según alcance. Preferimos contador con experiencia en hostelería o servicios.\n\nHoja de vida y tarjeta profesional por WhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','contador','contable','tributario','outsourcing','santa-marta','grupo-maia'],
    '[{"url":"/images/maia-management.jpg","alt":"Contador Público","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #153 — Abogado/a externo para casos específicos
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images)
  VALUES (v_sel_mgmt, v_cat_juridico, v_loc_smt,
    'SE BUSCA: Abogado/a Externo — Litigios y Casos Especiales | Grupo Maia',
    'se-busca-abogado-externo-litigios-grupo-maia-153',
    E'Maia Management Group y sus empresas buscan abogado o firma de abogados para apoyo jurídico externo en áreas complementarias a las de Maia Legal.\n\nÁreas de interés:\n• Derecho laboral — defensa en demandas laborales\n• Derecho administrativo y permisos municipales (Curaduria, Planeación, Bomberos)\n• Litigios comerciales y cobros de cartera\n• Derecho de propiedad intelectual (marcas, nombres comerciales)\n• Contratos de arrendamiento comercial\n\nBuscamos abogado con tarjeta profesional vigente, experiencia práctica en Santa Marta y disponibilidad para atender casos con relativa rapidez. Se paga por caso o bajo esquema de retainer mensual.\n\nHoja de vida y referencias por WhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','abogado','juridico','litigios','laboral','santa-marta','grupo-maia'],
    '[{"url":"/images/maia-legal.jpg","alt":"Abogado Externo","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  -- ============================================================
  -- #154 — Desarrollador web externo / freelance
  -- ============================================================
  INSERT INTO listings (seller_id, category_id, location_id, title, slug, description,
    price, price_type, currency, status, published_at, tags, images, is_nationwide)
  VALUES (v_sel_mgmt, v_cat_serv_tech, NULL,
    'SE BUSCA: Desarrollador/a Web Freelance — Proyectos del Grupo Maia (Remoto)',
    'se-busca-desarrollador-web-freelance-grupo-maia-154',
    E'Maia Management Group busca desarrollador/a web freelance para proyectos puntuales de sus marcas (El Sanatorio, Be Vida, Trivium Magnum, Maia Masters, LlevaLleva y más).\n\nTipos de trabajo:\n• Landing pages de eventos y lanzamientos\n• Actualizaciones a sitios existentes (WordPress, Webflow, Next.js)\n• Integraciones de WhatsApp Business, Google Analytics y píxeles de Meta\n• Formularios de contacto e inscripción\n• Optimización de velocidad y SEO técnico básico\n\nRequisitos:\n• Portafolio con proyectos reales y funcionales\n• Entrega puntual y comunicación clara\n• Dominio de al menos uno de: WordPress, Webflow, Next.js o React\n• Disponibilidad para proyectos de 1–4 semanas\n\nTrabajo 100% remoto. Pago por proyecto en COP o USD.\n\nPortafolio y tarifas por WhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','desarrollador','web','freelance','wordpress','nextjs','remoto','grupo-maia'],
    '[{"url":"/images/maia-management.jpg","alt":"Desarrollador Web","order":0}]',
    TRUE
  ) ON CONFLICT (slug) DO NOTHING;

  RAISE NOTICE 'Migration 013 complete: 4 remaining services-wanted listings (#151–154). Master list fully seeded.';

END $$;

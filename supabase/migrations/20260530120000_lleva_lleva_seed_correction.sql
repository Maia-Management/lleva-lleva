-- ============================================================
-- Migration: lleva_lleva_seed_correction
-- Date: 2026-05-30
-- ============================================================
-- Corrective forward migration for content seeded by 008/009/012
-- (parsed and inserted into production by seed-production.mjs).
--
-- Fixes two flagged issues that are LIVE in production:
--
--   1. JUNO HOUSE STUDIOS — three listings framed Juno as an
--      "adult content" creator/model recruiter ("contenido digital
--      para adultos", "modelos", "discreción absoluta"). Juno's
--      current, canonical positioning is a creator-management &
--      production studio (talent management + in-house production),
--      NOT adult content. These rows are re-framed to that positioning.
--
--   2. BANNED ENTITY NAME — listing #136 published under the
--      informal umbrella brand "Maia Group", which is not a
--      registered legal entity. The verified marketplace seller is
--      "Maia Management S.A.S." (NIT 901.862.977-7). The public
--      strings are corrected to the registered name.
--
-- All operations are idempotent UPDATEs keyed on slug / id, so this
-- migration is safe to re-run and preserves existing rows (backward
-- compatible — no slugs, ids, categories or URLs change).
--
-- NOTE: contains no destructive DELETEs. It mutates 4 listing rows
-- and 1 profile row only.
-- ============================================================

DO $$
BEGIN

  -- ----------------------------------------------------------
  -- 1a. Juno listing #21 (freelance / nationwide)
  --     was: "Modelo de Contenido Digital ... para adultos"
  -- ----------------------------------------------------------
  UPDATE listings SET
    title = 'Programa de Talento para Creadores de Contenido | Juno House Studios',
    description = E'Juno House Studios es una compañía de management de creadores con estudio de producción propio en Santa Marta. Buscamos talentos emergentes de redes sociales (Instagram, TikTok, YouTube) que quieran crecer con un plan real y un equipo detrás.\n\nQué ofrecemos:\n✓ Un plan de contenido y de carrera estructurado\n✓ Equipo de producción que graba y edita contigo\n✓ Manejo profesional de tus redes y tus marcas\n✓ Formalización legal y contable a través de las firmas del grupo Maia\n\nTrabajas desde donde estés, a tu ritmo, con acompañamiento real.\n\nPostulaciones por WhatsApp: +19034598763',
    tags = ARRAY['empleo','juno-house','creador-contenido','redes-sociales','talento','produccion'],
    updated_at = now()
  WHERE slug = 'modelo-contenido-digital-juno-house-21';

  -- ----------------------------------------------------------
  -- 1b. Juno listing #22
  --     was: "Coordinadora de Soporte a Modelos"
  -- ----------------------------------------------------------
  UPDATE listings SET
    title = 'Coordinador/a de Talento y Creadores | Juno House Studios',
    description = E'Juno House Studios busca Coordinador/a de Talento para acompañar a nuestros creadores en su proceso de incorporación y en su día a día.\n\nFunciones: onboarding de nuevos talentos, seguimiento de su plan de contenido y de crecimiento, comunicación directa con los creadores, coordinación con el equipo de producción.\n\nRequisitos: empatía, organización, excelente comunicación, manejo de WhatsApp Business y conocimiento de redes sociales (Instagram, TikTok, YouTube). Se valora experiencia en atención al cliente o manejo de comunidades.\n\nTrabajo parcial, principalmente remoto. WhatsApp: +19034598763',
    tags = ARRAY['empleo','juno-house','coordinador','talento','redes-sociales','santa-marta','parcial'],
    updated_at = now()
  WHERE slug = 'coordinadora-soporte-modelos-juno-house-22';

  -- ----------------------------------------------------------
  -- 1c. Juno listing #23
  --     was: "Operador/a de Plataformas Digitales ... para adultos"
  -- ----------------------------------------------------------
  UPDATE listings SET
    title = 'Coordinador/a de Producción y Redes Sociales | Juno House Studios',
    description = E'Juno House Studios busca Coordinador/a de Producción y Redes para la gestión de los canales de nuestros creadores: programación de publicaciones, análisis de métricas, optimización de perfiles y coordinación de las sesiones de grabación.\n\nRequisitos: organización, manejo de varias cuentas de redes sociales a la vez, análisis de datos básico, copywriting en español e inglés, manejo de Canva o herramientas de edición simple.\n\nTrabajo parcial con posibilidad de tiempo completo. WhatsApp: +19034598763',
    tags = ARRAY['empleo','juno-house','produccion','redes-sociales','contenido','santa-marta'],
    updated_at = now()
  WHERE slug = 'operador-plataformas-digitales-juno-house-23';

  -- ----------------------------------------------------------
  -- 1d. Juno House Studios profile bio → creator-management
  -- ----------------------------------------------------------
  UPDATE profiles SET
    bio = 'Compañía de management de creadores con estudio de producción propio en Santa Marta. Acompañamos a talentos emergentes con un plan de carrera, producción de contenido y formalización legal y contable a través de las firmas del grupo Maia.',
    updated_at = now()
  WHERE id = 'a1b2c3d4-0001-0001-0001-000000000002';

  -- ----------------------------------------------------------
  -- 2. Banned entity name: "Maia Group" → "Maia Management S.A.S."
  --    (listing #136)
  -- ----------------------------------------------------------
  UPDATE listings SET
    title = 'Desarrollo de Páginas Web para Negocios — Colombia | Maia Management S.A.S.',
    description = E'Maia Management S.A.S. ofrece desarrollo de páginas web profesionales para negocios colombianos y de la región.\n\nQué hacemos:\n✓ Landing pages de alto impacto\n✓ Sitios web corporativos (5–10 páginas)\n✓ Tiendas en línea / e-commerce\n✓ Integración de WhatsApp Business y Google Analytics\n✓ SEO básico y velocidad optimizada\n✓ Dominio y hosting incluidos en planes anuales\n\nTecnologías: Next.js, WordPress, Webflow según proyecto.\nEntrega en 2–4 semanas.\nDesde $3.500.000 COP. Mantenimiento mensual desde $400.000 COP/mes.\n\nContacto y portafolio: WhatsApp +19034598763',
    updated_at = now()
  WHERE slug = 'desarrollo-paginas-web-negocios-colombia-136';

  RAISE NOTICE 'lleva_lleva_seed_correction applied: Juno adult-content listings re-framed + Maia Group entity name corrected.';

END $$;

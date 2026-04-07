-- ============================================================
-- LlevaLleva Migration 007 — Cuentas Bot de Servicio Público
-- 55 cuentas oficiales para Santa Marta / Magdalena, Colombia
-- ============================================================
-- profiles.id → auth.users(id), por lo que primero se insertan
-- los usuarios en auth.users, luego los perfiles y bot_accounts.
-- RLS se omite automáticamente para el rol postgres/service_role.
-- ============================================================

DO $$
BEGIN

-- ============================================================
-- PASO 1: Insertar usuarios en auth.users
-- Cada bot tiene email interno @internal.llevalleva.co
-- encrypted_password vacío — estos bots nunca hacen login por contraseña
-- ============================================================

INSERT INTO auth.users (
  id,
  instance_id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  is_super_admin,
  created_at,
  updated_at
) VALUES

-- SERVICIOS PÚBLICOS
('00000000-0000-4000-b000-000000000001','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.metroagua-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000002','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.aire-caribe-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000003','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.surtigas-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000004','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.etb-avisos-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000005','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.claro-avisos-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000006','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.movistar-avisos-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000007','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.tigo-avisos-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),

-- ALCALDÍA Y GOBIERNO DISTRITAL
('00000000-0000-4000-b000-000000000008','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.alcaldia-santa-marta@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000009','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.transito-santa-marta@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000010','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.salud-distrital-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000011','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.educacion-distrital-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000012','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.planeacion-distrital-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000013','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.curaduria-urbana-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000014','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.dadsa-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000015','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.sec-gobierno-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000016','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.inspecciones-policia-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000017','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.catastro-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),

-- GOBERNACIÓN DEL MAGDALENA
('00000000-0000-4000-b000-000000000018','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.gobernacion-magdalena@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000019','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.infraestructura-magdalena@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),

-- SEGURIDAD Y EMERGENCIAS
('00000000-0000-4000-b000-000000000020','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.policia-santa-marta@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000021','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.bomberos-santa-marta@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000022','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.defensa-civil-magdalena@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000023','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.ungrd-alertas@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000024','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.cruz-roja-magdalena@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),

-- ENTIDADES NACIONALES
('00000000-0000-4000-b000-000000000025','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.dian-santa-marta@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000026','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.migracion-santa-marta@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000027','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.registraduria-santa-marta@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000028','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.sena-magdalena@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000029','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.icbf-magdalena@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000030','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.rama-judicial-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000031','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.notarias-santa-marta@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000032','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.sic-alertas@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000033','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.mintrabajo-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),

-- SALUD
('00000000-0000-4000-b000-000000000034','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.hospital-central-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000035','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.ese-reverend-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000036','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.ins-alertas-regionales@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),

-- TRANSPORTE E INFRAESTRUCTURA
('00000000-0000-4000-b000-000000000037','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.aeropuerto-simon-bolivar@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000038','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.terminal-transportes-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000039','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.invias-magdalena@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000040','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.ani-viales-caribe@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),

-- MEDIO AMBIENTE
('00000000-0000-4000-b000-000000000041','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.ideam-santa-marta@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000042','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.dimar-capuerto-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000043','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.parques-tayrona@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000044','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.parques-sierra-nevada@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000045','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.corpamag-alertas@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000046','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.invemar-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),

-- EDUCACIÓN SUPERIOR
('00000000-0000-4000-b000-000000000047','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.unimagdalena@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000048','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.unad-zona-caribe@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),

-- ECONOMÍA Y COMERCIO
('00000000-0000-4000-b000-000000000049','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.camara-comercio-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000050','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.banrep-santa-marta@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000051','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.fenalco-magdalena@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),

-- CULTURA Y TURISMO
('00000000-0000-4000-b000-000000000052','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.procolombia-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000053','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.sec-cultura-sm@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000054','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.festival-vallenato@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now()),
('00000000-0000-4000-b000-000000000055','00000000-0000-0000-0000-000000000000','authenticated','authenticated','bot.icanh-caribe@internal.llevalleva.co','',now(),'{"provider":"email","providers":["email"],"is_bot":true}','{}',false,now(),now())

ON CONFLICT (id) DO NOTHING;


-- ============================================================
-- PASO 2: Insertar perfiles (profiles)
-- ============================================================

INSERT INTO profiles (
  id,
  username,
  display_name,
  user_type,
  bio,
  city,
  department,
  is_verified,
  verified_at,
  is_active,
  created_at,
  updated_at
) VALUES

-- ── SERVICIOS PÚBLICOS ──────────────────────────────────────
('00000000-0000-4000-b000-000000000001',
 'metroagua-sm',
 'Metroagua Santa Marta',
 'bot',
 'Avisos oficiales de cortes programados, mantenimiento de redes y alertas de suministro de agua potable y alcantarillado en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000002',
 'aire-caribe-sm',
 'Air-e (Electricaribe) — Santa Marta',
 'bot',
 'Notificaciones oficiales de cortes de energía, apagones programados y mantenimiento de redes eléctricas en Santa Marta y la Costa Caribe.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000003',
 'surtigas-sm',
 'Surtigas — Avisos de Gas',
 'bot',
 'Alertas de cortes de suministro de gas natural, fugas, revisiones de redes y trabajos de mantenimiento en Santa Marta y la región Caribe.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000004',
 'etb-avisos-sm',
 'ETB — Avisos de Red',
 'bot',
 'Notificaciones de interrupciones y mantenimiento de servicios de telecomunicaciones ETB (internet, telefonía fija) en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000005',
 'claro-avisos-sm',
 'Claro — Avisos de Red',
 'bot',
 'Alertas de interrupciones y trabajos de mantenimiento de la red Claro (internet, telefonía móvil y fija) en Santa Marta y Magdalena.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000006',
 'movistar-avisos-sm',
 'Movistar — Avisos de Red',
 'bot',
 'Avisos de interrupciones y trabajos de mantenimiento en la red Movistar (móvil e internet) en Santa Marta y Magdalena.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000007',
 'tigo-avisos-sm',
 'Tigo — Avisos de Red',
 'bot',
 'Notificaciones de cortes y mantenimiento de servicios Tigo (móvil, internet, cable) en Santa Marta y la región Caribe.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

-- ── ALCALDÍA Y GOBIERNO DISTRITAL ───────────────────────────
('00000000-0000-4000-b000-000000000008',
 'alcaldia-santa-marta',
 'Alcaldía Distrital de Santa Marta',
 'bot',
 'Canal oficial de la Alcaldía de Santa Marta. Decretos, pico y placa, restricciones de movilidad, cierres viales y avisos de interés ciudadano.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000009',
 'transito-santa-marta',
 'Secretaría de Tránsito y Transporte — SM',
 'bot',
 'Pico y placa, cierres viales, restricciones de tránsito, operativos y novedades de movilidad en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000010',
 'salud-distrital-sm',
 'Secretaría de Salud Distrital — SM',
 'bot',
 'Jornadas de vacunación, alertas epidemiológicas, campañas de salud pública y comunicados oficiales de la Secretaría de Salud de Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000011',
 'educacion-distrital-sm',
 'Secretaría de Educación Distrital — SM',
 'bot',
 'Calendarios escolares, suspensión de clases, fechas de matrícula, eventos educativos y comunicados del sector educativo oficial de Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000012',
 'planeacion-distrital-sm',
 'Secretaría de Planeación Distrital — SM',
 'bot',
 'Actualizaciones del POT, licencias urbanísticas, planes de ordenamiento territorial y avisos de planificación en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000013',
 'curaduria-urbana-sm',
 'Curaduría Urbana No. 1 — Santa Marta',
 'bot',
 'Información sobre licencias de construcción, permisos urbanísticos, trámites constructivos y resoluciones ante la Curaduría Urbana de Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000014',
 'dadsa-sm',
 'DADSA — Aseo Urbano Santa Marta',
 'bot',
 'Avisos de recolección de basuras, horarios de aseo urbano, jornadas de reciclaje, operativos de limpieza y suspensiones del servicio en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000015',
 'sec-gobierno-sm',
 'Secretaría de Gobierno Distrital — SM',
 'bot',
 'Convivencia ciudadana, permisos para eventos, restricciones nocturnas, ley seca y avisos de orden público en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000016',
 'inspecciones-policia-sm',
 'Inspecciones de Policía — Santa Marta',
 'bot',
 'Avisos de querellas, mediaciones comunitarias, infractores del Código de Policía y citaciones de las Inspecciones de Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000017',
 'catastro-sm',
 'Catastro Distrital Santa Marta',
 'bot',
 'Fechas de pago del impuesto predial, actualización de avalúos catastrales, trámites y descuentos por pronto pago en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

-- ── GOBERNACIÓN DEL MAGDALENA ────────────────────────────────
('00000000-0000-4000-b000-000000000018',
 'gobernacion-magdalena',
 'Gobernación del Magdalena',
 'bot',
 'Decretos departamentales, declaratorias de emergencia, programas sociales y avisos oficiales del Gobierno del departamento del Magdalena.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000019',
 'infraestructura-magdalena',
 'Secretaría de Infraestructura del Magdalena',
 'bot',
 'Cierres de vías departamentales, derrumbes, obras públicas, estado de carreteras y mantenimiento vial en el departamento del Magdalena.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

-- ── SEGURIDAD Y EMERGENCIAS ──────────────────────────────────
('00000000-0000-4000-b000-000000000020',
 'policia-santa-marta',
 'Policía Nacional — Estación Santa Marta',
 'bot',
 'Alertas de seguridad, operativos policiales, requisitorias, zonas de alto riesgo y comunicados de la Policía Nacional en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000021',
 'bomberos-santa-marta',
 'Cuerpo de Bomberos de Santa Marta',
 'bot',
 'Alertas de incendios, emergencias estructurales, recomendaciones de prevención y actividad operativa del Cuerpo de Bomberos de Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000022',
 'defensa-civil-magdalena',
 'Defensa Civil — Seccional Magdalena',
 'bot',
 'Alertas por lluvias, inundaciones, deslizamientos, temporadas de huracanes y emergencias naturales en el departamento del Magdalena.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000023',
 'ungrd-alertas',
 'UNGRD — Gestión del Riesgo Nacional',
 'bot',
 'Alertas nacionales por temporada de lluvias, fenómenos naturales, emergencias y recomendaciones de gestión del riesgo con impacto en el Caribe.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000024',
 'cruz-roja-magdalena',
 'Cruz Roja Colombiana — Magdalena',
 'bot',
 'Emergencias humanitarias, jornadas de donación de sangre, primeros auxilios, atención en desastres y actividades de la Cruz Roja en Magdalena.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

-- ── ENTIDADES NACIONALES ─────────────────────────────────────
('00000000-0000-4000-b000-000000000025',
 'dian-santa-marta',
 'DIAN — Seccional Santa Marta',
 'bot',
 'Fechas de vencimiento tributario, operativos de control fiscal, obligaciones formales y avisos de la DIAN en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000026',
 'migracion-santa-marta',
 'Migración Colombia — Santa Marta',
 'bot',
 'Trámites de visas, renovaciones de cédula de extranjería, control migratorio, salvoconductos y avisos de Migración Colombia en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000027',
 'registraduria-santa-marta',
 'Registraduría Nacional — Santa Marta',
 'bot',
 'Fechas electorales, jornadas de cedulación, inscripción en el censo electoral, puestos de votación y avisos de la Registraduría en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000028',
 'sena-magdalena',
 'SENA — Regional Magdalena',
 'bot',
 'Oferta de cursos gratuitos, convocatorias de formación técnica y tecnológica, fechas de inscripción y programas del SENA en el Magdalena.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000029',
 'icbf-magdalena',
 'ICBF — Regional Magdalena',
 'bot',
 'Programas de protección infantil, primera infancia, nutrición, adopciones, convocatorias y servicios del ICBF en el departamento del Magdalena.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000030',
 'rama-judicial-sm',
 'Rama Judicial — Juzgados Santa Marta',
 'bot',
 'Suspensión de términos judiciales, fechas de audiencias, cierres de despachos judiciales y avisos de la Rama Judicial en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000031',
 'notarias-santa-marta',
 'Notarías de Santa Marta (1ª, 2ª y 3ª)',
 'bot',
 'Horarios de atención, tarifas notariales, servicios disponibles y avisos de las Notarías Primera, Segunda y Tercera de Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000032',
 'sic-alertas',
 'Superintendencia de Industria y Comercio',
 'bot',
 'Alertas de productos peligrosos, retiros del mercado, derechos del consumidor, sanciones a empresas y avisos de la SIC a nivel nacional.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000033',
 'mintrabajo-sm',
 'Ministerio de Trabajo — Inspección SM',
 'bot',
 'Operativos laborales, derechos de los trabajadores, inspecciones de trabajo, multas a empleadores y avisos del Ministerio de Trabajo en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

-- ── SALUD ────────────────────────────────────────────────────
('00000000-0000-4000-b000-000000000034',
 'hospital-central-sm',
 'Hospital Central Julio Méndez Barreneche',
 'bot',
 'Avisos de urgencias, jornadas de salud gratuitas, servicios habilitados, suspensiones y comunicados del Hospital Central de Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000035',
 'ese-reverend-sm',
 'ESE Alejandro Próspero Reverend',
 'bot',
 'Citas médicas, programas de salud preventiva, jornadas comunitarias y servicios de la ESE Alejandro Próspero Reverend en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000036',
 'ins-alertas-regionales',
 'Instituto Nacional de Salud — Alertas Regionales',
 'bot',
 'Alertas epidemiológicas regionales, brotes de enfermedades, vigilancia en salud pública e informes del INS para la Costa Caribe colombiana.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

-- ── TRANSPORTE E INFRAESTRUCTURA ─────────────────────────────
('00000000-0000-4000-b000-000000000037',
 'aeropuerto-simon-bolivar',
 'Aeropuerto Internacional Simón Bolívar',
 'bot',
 'Estado de vuelos, cierres temporales de pista, obras en el aeropuerto y alertas operativas del Aeropuerto Internacional Simón Bolívar de Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000038',
 'terminal-transportes-sm',
 'Terminal de Transportes de Santa Marta',
 'bot',
 'Información de rutas interdepartamentales, bloqueos de vías, paros de transportadores y novedades operativas de la Terminal de Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000039',
 'invias-magdalena',
 'INVÍAS — Unidad de Mantenimiento Magdalena',
 'bot',
 'Cierres de vías nacionales, derrumbes, obras de mantenimiento vial y estado de carreteras a cargo de INVÍAS en el departamento del Magdalena.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000040',
 'ani-viales-caribe',
 'ANI — Concesiones Viales Caribe',
 'bot',
 'Avances de obras viales en concesión, estado de peajes, restricciones de tránsito y novedades de las vías concesionadas en el Caribe colombiano.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

-- ── MEDIO AMBIENTE ───────────────────────────────────────────
('00000000-0000-4000-b000-000000000041',
 'ideam-santa-marta',
 'IDEAM — Estación Santa Marta',
 'bot',
 'Pronóstico del tiempo, alertas de lluvia, nivel del mar, estado del oleaje, fenómenos meteorológicos y temporadas de huracanes en Santa Marta y el Caribe.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000042',
 'dimar-capuerto-sm',
 'DIMAR — Capitanía de Puerto Santa Marta',
 'bot',
 'Estado del mar, restricciones de navegación, alertas para embarcaciones, zarpes y avisos de la Capitanía de Puerto de Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000043',
 'parques-tayrona',
 'Parques Nacionales — Tayrona',
 'bot',
 'Apertura y cierre del Parque Nacional Natural Tayrona, disponibilidad de cupos, vedas temporales y avisos para visitantes y campistas.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000044',
 'parques-sierra-nevada',
 'Parques Nacionales — Sierra Nevada de SM',
 'bot',
 'Acceso al PNN Sierra Nevada de Santa Marta, permisos especiales de comunidades indígenas, alertas por incendios forestales y restricciones de ingreso.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000045',
 'corpamag-alertas',
 'CORPAMAG — Alertas Ambientales',
 'bot',
 'Alertas ambientales, contaminación de playas, calidad del aire, vertimientos ilegales y avisos de la Corporación Autónoma Regional del Magdalena.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000046',
 'invemar-sm',
 'INVEMAR — Calidad del Agua en Playas',
 'bot',
 'Reportes de calidad del agua en playas de Santa Marta, alertas de contaminación marina, índices de bañabilidad y monitoreo costero del INVEMAR.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

-- ── EDUCACIÓN SUPERIOR ───────────────────────────────────────
('00000000-0000-4000-b000-000000000047',
 'unimagdalena',
 'Universidad del Magdalena — UniMagdalena',
 'bot',
 'Eventos académicos, fechas de inscripción y matrícula, calendarios universitarios, convocatorias de investigación y noticias de la UniMagdalena.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000048',
 'unad-zona-caribe',
 'UNAD — Zona Caribe',
 'bot',
 'Inscripciones, cursos virtuales gratuitos, matrículas y novedades académicas de la Universidad Nacional Abierta y a Distancia en la Zona Caribe.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

-- ── ECONOMÍA Y COMERCIO ──────────────────────────────────────
('00000000-0000-4000-b000-000000000049',
 'camara-comercio-sm',
 'Cámara de Comercio de Santa Marta',
 'bot',
 'Matrícula mercantil, registro de empresas, renovaciones, eventos empresariales, capacitaciones y servicios de la Cámara de Comercio de Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000050',
 'banrep-santa-marta',
 'Banco de la República — Santa Marta',
 'bot',
 'TRM del día, tasas de interés, indicadores económicos, agenda cultural del Banrepcultural y servicios del Banco de la República en Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000051',
 'fenalco-magdalena',
 'Fenalco Magdalena',
 'bot',
 'Derechos del consumidor, gremio del comercio, eventos empresariales, alertas de prácticas irregulares y capacitaciones de Fenalco en Magdalena.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

-- ── CULTURA Y TURISMO ────────────────────────────────────────
('00000000-0000-4000-b000-000000000052',
 'procolombia-sm',
 'ProColombia — Turismo Santa Marta',
 'bot',
 'Temporadas turísticas, eventos de turismo nacional e internacional, promoción del destino Santa Marta y Magdalena, y novedades del sector turístico.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000053',
 'sec-cultura-sm',
 'Secretaría de Cultura Distrital — SM',
 'bot',
 'Eventos culturales, festivales locales, patrimonio histórico, programación artística, convocatorias y agendas de la Secretaría de Cultura de Santa Marta.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000054',
 'festival-vallenato',
 'Festival de la Leyenda Vallenata',
 'bot',
 'Fechas del festival, inscripción de concursantes, programación musical, convocatorias artísticas y noticias de la Fundación Festival de la Leyenda Vallenata.',
 'Valledupar', 'Cesar', true, now(), true, now(), now()),

('00000000-0000-4000-b000-000000000055',
 'icanh-caribe',
 'ICANH — Antropología e Historia Caribe',
 'bot',
 'Patrimonio arqueológico, investigaciones históricas, restricciones en sitios arqueológicos y avisos del Instituto Colombiano de Antropología e Historia en el Caribe.',
 'Santa Marta', 'Magdalena', true, now(), true, now(), now())

ON CONFLICT (id) DO NOTHING;


-- ============================================================
-- PASO 3: Insertar en bot_accounts
-- ============================================================

INSERT INTO bot_accounts (
  id,
  bot_name,
  data_category,
  source_url,
  is_active,
  post_interval_hours,
  created_at
) VALUES

-- SERVICIOS PÚBLICOS
('00000000-0000-4000-b000-000000000001', 'Metroagua Santa Marta',              'servicios_publicos',     'https://www.metroagua.com.co',                   true, 24, now()),
('00000000-0000-4000-b000-000000000002', 'Air-e (Electricaribe) Santa Marta',  'servicios_publicos',     'https://www.aire.com.co',                        true, 12, now()),
('00000000-0000-4000-b000-000000000003', 'Surtigas Avisos de Gas',             'servicios_publicos',     'https://www.surtigas.com.co',                    true, 24, now()),
('00000000-0000-4000-b000-000000000004', 'ETB Avisos de Red',                  'telecomunicaciones',     'https://www.etb.com.co',                         true, 24, now()),
('00000000-0000-4000-b000-000000000005', 'Claro Avisos de Red',                'telecomunicaciones',     'https://www.claro.com.co',                       true, 12, now()),
('00000000-0000-4000-b000-000000000006', 'Movistar Avisos de Red',             'telecomunicaciones',     'https://www.movistar.co',                        true, 12, now()),
('00000000-0000-4000-b000-000000000007', 'Tigo Avisos de Red',                 'telecomunicaciones',     'https://www.tigo.com.co',                        true, 12, now()),

-- ALCALDÍA Y GOBIERNO DISTRITAL
('00000000-0000-4000-b000-000000000008', 'Alcaldía Distrital de Santa Marta',  'gobierno_distrital',     'https://www.santamarta.gov.co',                  true, 6,  now()),
('00000000-0000-4000-b000-000000000009', 'Secretaría de Tránsito SM',          'transito',               'https://www.santamarta.gov.co/transito',         true, 12, now()),
('00000000-0000-4000-b000-000000000010', 'Secretaría de Salud Distrital SM',   'salud',                  'https://www.santamarta.gov.co/salud',            true, 24, now()),
('00000000-0000-4000-b000-000000000011', 'Secretaría de Educación Distrital',  'educacion',              'https://www.santamarta.gov.co/educacion',        true, 24, now()),
('00000000-0000-4000-b000-000000000012', 'Secretaría de Planeación Distrital', 'gobierno_distrital',     'https://www.santamarta.gov.co/planeacion',       true, 48, now()),
('00000000-0000-4000-b000-000000000013', 'Curaduría Urbana No. 1 Santa Marta', 'gobierno_distrital',     null,                                             true, 48, now()),
('00000000-0000-4000-b000-000000000014', 'DADSA Aseo Urbano Santa Marta',      'gobierno_distrital',     'https://www.santamarta.gov.co/dadsa',            true, 24, now()),
('00000000-0000-4000-b000-000000000015', 'Secretaría de Gobierno Distrital',   'gobierno_distrital',     'https://www.santamarta.gov.co/gobierno',         true, 24, now()),
('00000000-0000-4000-b000-000000000016', 'Inspecciones de Policía Santa Marta','seguridad',              null,                                             true, 48, now()),
('00000000-0000-4000-b000-000000000017', 'Catastro Distrital Santa Marta',     'gobierno_distrital',     null,                                             true, 48, now()),

-- GOBERNACIÓN
('00000000-0000-4000-b000-000000000018', 'Gobernación del Magdalena',          'gobierno_departamental', 'https://www.magdalena.gov.co',                   true, 12, now()),
('00000000-0000-4000-b000-000000000019', 'Secretaría de Infraestructura Mag.', 'transporte',             'https://www.magdalena.gov.co',                   true, 24, now()),

-- SEGURIDAD Y EMERGENCIAS
('00000000-0000-4000-b000-000000000020', 'Policía Nacional Estación SM',       'seguridad',              'https://www.policia.gov.co',                     true, 6,  now()),
('00000000-0000-4000-b000-000000000021', 'Cuerpo de Bomberos Santa Marta',     'emergencias',            null,                                             true, 6,  now()),
('00000000-0000-4000-b000-000000000022', 'Defensa Civil Seccional Magdalena',  'emergencias',            'https://www.defensacivil.gov.co',                true, 6,  now()),
('00000000-0000-4000-b000-000000000023', 'UNGRD Gestión del Riesgo',           'emergencias',            'https://www.gestiondelriesgo.gov.co',            true, 6,  now()),
('00000000-0000-4000-b000-000000000024', 'Cruz Roja Colombiana Magdalena',     'emergencias',            'https://www.cruzrojacolombiana.org',             true, 12, now()),

-- ENTIDADES NACIONALES
('00000000-0000-4000-b000-000000000025', 'DIAN Seccional Santa Marta',         'gobierno_nacional',      'https://www.dian.gov.co',                        true, 24, now()),
('00000000-0000-4000-b000-000000000026', 'Migración Colombia Santa Marta',     'gobierno_nacional',      'https://www.migracioncolombia.gov.co',           true, 48, now()),
('00000000-0000-4000-b000-000000000027', 'Registraduría Nacional Santa Marta', 'gobierno_nacional',      'https://www.registraduria.gov.co',               true, 48, now()),
('00000000-0000-4000-b000-000000000028', 'SENA Regional Magdalena',            'educacion',              'https://www.sena.edu.co',                        true, 24, now()),
('00000000-0000-4000-b000-000000000029', 'ICBF Regional Magdalena',            'bienestar',              'https://www.icbf.gov.co',                        true, 48, now()),
('00000000-0000-4000-b000-000000000030', 'Rama Judicial Juzgados Santa Marta', 'gobierno_nacional',      'https://www.ramajudicial.gov.co',                true, 24, now()),
('00000000-0000-4000-b000-000000000031', 'Notarías Santa Marta 1ª 2ª 3ª',     'gobierno_nacional',      null,                                             true, 48, now()),
('00000000-0000-4000-b000-000000000032', 'Superintendencia Industria Comercio', 'gobierno_nacional',     'https://www.sic.gov.co',                         true, 24, now()),
('00000000-0000-4000-b000-000000000033', 'Ministerio de Trabajo Inspección SM','gobierno_nacional',      'https://www.mintrabajo.gov.co',                  true, 48, now()),

-- SALUD
('00000000-0000-4000-b000-000000000034', 'Hospital Central Julio Méndez B.',   'salud',                  null,                                             true, 12, now()),
('00000000-0000-4000-b000-000000000035', 'ESE Alejandro Próspero Reverend',    'salud',                  null,                                             true, 24, now()),
('00000000-0000-4000-b000-000000000036', 'INS Alertas Epidemiológicas Caribe', 'salud',                  'https://www.ins.gov.co',                         true, 12, now()),

-- TRANSPORTE
('00000000-0000-4000-b000-000000000037', 'Aeropuerto Internacional Simón Bol.','transporte',             null,                                             true, 6,  now()),
('00000000-0000-4000-b000-000000000038', 'Terminal de Transportes Santa Marta','transporte',             null,                                             true, 12, now()),
('00000000-0000-4000-b000-000000000039', 'INVÍAS Unidad Mantenimiento Mag.',   'transporte',             'https://www.invias.gov.co',                      true, 12, now()),
('00000000-0000-4000-b000-000000000040', 'ANI Concesiones Viales Caribe',      'transporte',             'https://www.ani.gov.co',                         true, 24, now()),

-- MEDIO AMBIENTE
('00000000-0000-4000-b000-000000000041', 'IDEAM Estación Santa Marta',         'medio_ambiente',         'https://www.ideam.gov.co',                       true, 6,  now()),
('00000000-0000-4000-b000-000000000042', 'DIMAR Capitanía Puerto Santa Marta', 'medio_ambiente',         'https://www.dimar.mil.co',                       true, 6,  now()),
('00000000-0000-4000-b000-000000000043', 'Parques Nacionales Tayrona',         'turismo',                'https://www.parquesnacionales.gov.co',           true, 12, now()),
('00000000-0000-4000-b000-000000000044', 'Parques Nacionales Sierra Nevada',   'medio_ambiente',         'https://www.parquesnacionales.gov.co',           true, 24, now()),
('00000000-0000-4000-b000-000000000045', 'CORPAMAG Alertas Ambientales',       'medio_ambiente',         'https://www.corpamag.gov.co',                    true, 24, now()),
('00000000-0000-4000-b000-000000000046', 'INVEMAR Calidad del Agua',           'medio_ambiente',         'https://www.invemar.org.co',                     true, 48, now()),

-- EDUCACIÓN SUPERIOR
('00000000-0000-4000-b000-000000000047', 'Universidad del Magdalena',          'educacion',              'https://www.unimagdalena.edu.co',                true, 24, now()),
('00000000-0000-4000-b000-000000000048', 'UNAD Zona Caribe',                   'educacion',              'https://www.unad.edu.co',                        true, 24, now()),

-- ECONOMÍA Y COMERCIO
('00000000-0000-4000-b000-000000000049', 'Cámara de Comercio Santa Marta',     'economia',               'https://www.camarasantamarta.com.co',            true, 24, now()),
('00000000-0000-4000-b000-000000000050', 'Banco de la República Santa Marta',  'economia',               'https://www.banrep.gov.co',                      true, 24, now()),
('00000000-0000-4000-b000-000000000051', 'Fenalco Magdalena',                  'economia',               'https://www.fenalco.com.co',                     true, 48, now()),

-- CULTURA Y TURISMO
('00000000-0000-4000-b000-000000000052', 'ProColombia Turismo Santa Marta',    'turismo',                'https://www.procolombia.co',                     true, 24, now()),
('00000000-0000-4000-b000-000000000053', 'Secretaría de Cultura Distrital SM', 'cultura',                'https://www.santamarta.gov.co/cultura',          true, 48, now()),
('00000000-0000-4000-b000-000000000054', 'Festival de la Leyenda Vallenata',   'cultura',                'https://www.festivalvallenato.com',              true, 168,now()),
('00000000-0000-4000-b000-000000000055', 'ICANH Caribe',                       'cultura',                'https://www.icanh.gov.co',                       true, 168,now())

ON CONFLICT (id) DO NOTHING;

END $$;

-- ============================================================
-- Verificación rápida
-- ============================================================
-- SELECT COUNT(*) FROM profiles WHERE user_type = 'bot';         -- debe ser 55
-- SELECT COUNT(*) FROM bot_accounts;                             -- debe ser 55
-- SELECT p.username, p.display_name, p.is_verified, b.data_category
--   FROM profiles p JOIN bot_accounts b ON b.id = p.id
--   ORDER BY b.data_category, p.display_name;

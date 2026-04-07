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
    'bot.elsanatorio@llevalleva.co',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000002',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.junohousestudios@llevalleva.co',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000003',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.maiamasters@llevalleva.co',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000004',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.triviummagnum@llevalleva.co',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000005',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.maialegal@llevalleva.co',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000006',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.maiamanagement@llevalleva.co',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000007',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.maiarealty@llevalleva.co',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000008',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.llavelabs@llevalleva.co',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000009',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.maiaaerial@llevalleva.co',
    NULL, now(),
    '{"provider":"email","providers":["email"]}', '{"bot":true}',
    now(), now(), false, false
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000010',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'bot.llevalleva@llevalleva.co',
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
    '+573174370575', true,
    true, true,
    now(), now()
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000002',
    'bot_juno_house',
    'Juno House Studios',
    'bot',
    'Agencia de contenido digital. Apoyamos a creadores independientes con gestión de plataformas, soporte técnico y estrategia de monetización.',
    'Juno House Studios',
    NULL,
    'Santa Marta', 'Magdalena',
    '+573174370575', true,
    true, true,
    now(), now()
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000003',
    'bot_maia_masters',
    'Maia Masters Academy',
    'bot',
    'Academia de habilidades digitales para el mundo moderno. Bootcamp intensivo: marketing digital, diseño con IA, inglés para negocios y emprendimiento. Centro, Santa Marta.',
    'Maia Masters Academy',
    NULL,
    'Santa Marta', 'Magdalena',
    '+573174370575', true,
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
    '+573174370575', true,
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
    '+573174370575', true,
    true, true,
    now(), now()
  ),
  (
    'a1b2c3d4-0001-0001-0001-000000000006',
    'bot_maia_management',
    'Maia Management Group',
    'bot',
    'Grupo empresarial colombiano con operaciones en hospitalidad, tecnología, educación e inmobiliaria. Sede principal en Santa Marta, Costa Caribe.',
    'Maia Management Group',
    NULL,
    'Santa Marta', 'Magdalena',
    '+573174370575', true,
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
    '+573174370575', true,
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
    '+573174370575', true,
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
    '+573174370575', true,
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
    '+573174370575', true,
    true, true,
    now(), now()
  )
ON CONFLICT (id) DO NOTHING;

RAISE NOTICE 'Maia Group business profiles seeded: 10 entities';

END $$;
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
    E'El Sanatorio Gastro Bar (Calle 19 #4-23, Centro Histórico) busca actores de terror para nuestro Laberinto del Horror. Trabajo fines de semana y festivos.\n\nBuscamos: personas expresivas, con energía y capacidad de mantener personaje bajo presión. No se requiere experiencia previa — proporcionamos entrenamiento completo.\n\nOfrecemos: vestuario y maquillaje incluidos, ambiente de trabajo dinámico, pago por sesión competitivo.\n\nWhatsApp: +573174370575',
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
    E'Buscamos Bartender Principal para liderar la barra de El Sanatorio, nuestro gastro bar de concepto horror en el Centro de Santa Marta.\n\nRequisitos: experiencia mínima 2 años en bares de coctelería, conocimiento de destilados y técnicas de mixología, liderazgo de equipo, inglés básico preferible.\n\nOfrecemos: contrato a término indefinido, propinas, comidas durante turno, ambiente creativo y único en Santa Marta.\n\nContacto WhatsApp: +573174370575',
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
    E'El Sanatorio busca bartender con experiencia en coctelería para unirse a nuestro equipo. Trabajo en un ambiente temático único — el único gastro bar de horror en la Costa Caribe.\n\nRequisitos: experiencia mínima 1 año en bar, actitud positiva, trabajo en equipo, disponibilidad nocturna y fines de semana.\n\nSe valora: conocimiento de cócteles clásicos y tropicales, inglés conversacional.\n\nWhatsApp: +573174370575',
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
    E'Buscamos Bar Back para apoyar la operación de nuestra barra en El Sanatorio. Ideal para personas que quieren iniciarse en el mundo de la coctelería y la hospitalidad.\n\nFunciones: mantener barra surtida, lavar cristalería, apoyar al bartender en servicio, gestión de inventario básico.\n\nRequisitos: actitud de servicio, trabajo en equipo, disponibilidad horario nocturno.\n\nFormación en bar incluida para quienes demuestren compromiso. WhatsApp: +573174370575',
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
    E'El Sanatorio busca Chef Ejecutivo para liderar nuestra cocina de fusión japonesa-latina con especialidad en yakitori y tapas creativas.\n\nRequisitos: experiencia mínima 3 años en cocina de autor o fusión asiática-latina, capacidad de diseñar menú, gestionar brigada y controlar costos de alimentos y bebidas.\n\nOfrecemos: proyecto gastronómico único en Santa Marta, libertad creativa, salario competitivo + incentivos por desempeño.\n\nEnviar hoja de vida y portafolio gastronómico por WhatsApp: +573174370575',
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
    E'Buscamos Sous Chef para ser el segundo al mando en la cocina de El Sanatorio. Serás el enlace directo entre el Chef Ejecutivo y la brigada.\n\nRequisitos: experiencia mínima 2 años en cocina profesional, conocimiento de técnicas frías y calientes, capacidad de coordinar equipo en horas pico.\n\nSe valora: experiencia en cocina asiática o de autor, disposición para aprender el concepto horror-gourmet del restaurante.\n\nWhatsApp: +573174370575',
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
    E'El Sanatorio contrata cocineros de línea para estaciones de parrilla, frío y montaje.\n\nRequisitos: experiencia mínima 1 año en cocina profesional, rapidez y organización bajo presión, higiene y BPM (Buenas Prácticas de Manufactura).\n\nOfrecemos: contrato a término indefinido, uniforme completo, comida de turno, oportunidad de crecer dentro del equipo.\n\nWhatsApp: +573174370575',
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
    E'Buscamos Steward para mantener la limpieza operativa de nuestra cocina y barra en El Sanatorio.\n\nFunciones: lavado de loza, cristalería y utensilios; limpieza de cocina durante y al cierre; apoyo en organización de cuarto frío.\n\nRequisitos: responsabilidad, rapidez, trabajo en equipo. No se requiere experiencia previa.\n\nOfrecemos: buen trato, comida de turno y posibilidad de ascenso a ayudante de cocina. WhatsApp: +573174370575',
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
    E'El Sanatorio busca meseros y meseras con actitud de servicio excepcional para nuestro restaurante de concepto horror.\n\nRequisitos: experiencia mínima 6 meses en servicio de mesa, inglés básico (atendemos turistas), excelente presentación personal y capacidad de trabajar en ambiente temático oscuro.\n\nOfrecemos: propinas incluidas, uniforme, comida de turno, ambiente laboral único en Santa Marta.\n\nWhatsApp: +573174370575',
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
    E'Buscamos Host para recibir a nuestros clientes con la bienvenida perfecta al mundo de El Sanatorio.\n\nFunciones: gestión de lista de espera y reservas, bienvenida de grupos y eventos privados, coordinación con el equipo de sala.\n\nRequisitos: excelente presencia, inglés intermedio-avanzado, actitud cálida pero con personalidad para el concepto temático. Estudiantes de hotelería o turismo son bienvenidos.\n\nTrabajo parcial (fines de semana). WhatsApp: +573174370575',
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
    E'El Sanatorio busca Cajero/a para manejo de punto de venta y cierre diario de caja.\n\nRequisitos: experiencia en manejo de POS y efectivo, honestidad comprobada, orden y concentración, conocimiento básico de Excel.\n\nSe valora: experiencia previa en restaurantes o bares, inglés básico para atención a turistas.\n\nContrato a término indefinido, prestaciones completas. WhatsApp: +573174370575',
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
    E'Buscamos personal de seguridad y portería para El Sanatorio. Serás el primer contacto con los visitantes: verificación de edad, control de aforo y seguridad del establecimiento.\n\nRequisitos: curso de seguridad privada (deseable), buena condición física, presencia intimidante pero profesional, manejo de público.\n\nHorario nocturno y fines de semana. Contrato a término indefinido. WhatsApp: +573174370575',
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
    E'El Sanatorio busca aseadora para limpieza profunda diaria de las instalaciones del restaurante, baños, salón y zonas comunes del Laberinto del Horror.\n\nRequisitos: experiencia en limpieza de establecimientos comerciales, uso correcto de productos de desinfección, puntualidad.\n\nHorario: mañana (antes de apertura) + turno de cierre parcial. Contrato a término indefinido, prestaciones completas.\n\nWhatsApp: +573174370575',
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
    E'Buscamos maquilladora con experiencia en efectos especiales (SFX) y caracterización de horror para preparar a nuestros actores del Laberinto del Horror.\n\nRequisitos: conocimiento de técnicas de maquillaje teatral y SFX (heridas, cicatrices, prótesis básicas), creatividad y velocidad en la aplicación.\n\nTrabajo fines de semana y días de función. Pago por evento + bonificaciones según aforo.\n\nPortafolio por WhatsApp: +573174370575',
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
    E'El Sanatorio busca un/a Diseñador/a de Sets para conceptualizar, diseñar y construir las salas de nuestro Laberinto del Horror.\n\nBuscamos: creatividad oscura, experiencia en diseño de producción, teatro o cine, capacidad de trabajar con materiales de bajo costo y alto impacto visual.\n\nProyecto: expansión de 3 salas nuevas del laberinto + rediseño de 2 existentes. Contrato por obra.\n\nPortafolio por WhatsApp: +573174370575',
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
    E'Buscamos Técnico de Sonido y Luces para operar y mantener el sistema audiovisual de El Sanatorio: ambientación del restaurante, efectos del laberinto y sonido para eventos privados.\n\nRequisitos: experiencia en consolas de sonido y controladores de iluminación DMX, manejo de software de audio (DAW básico), disponibilidad nocturna.\n\nTrabajo parcial (principalmente fines de semana). Buen ambiente de trabajo. WhatsApp: +573174370575',
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
    E'El Sanatorio busca DJ Residente para ambientar nuestras noches con sets oscuros y temáticos. Géneros: dark electronic, industrial, ambient horror, synthwave, metal de ambiente.\n\nRequisitos: equipo propio (se puede negociar uso del equipo del bar), repertorio adaptable al concepto de horror, experiencia en bares o eventos.\n\nSesiones: viernes, sábados y fechas especiales. Pago por noche + propinas.\n\nMezclas por WhatsApp: +573174370575',
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
    E'El Sanatorio busca Coordinador/a de Eventos para gestionar reservas de espacios privados: cumpleaños, despedidas, cenas corporativas y experiencias grupales en el Laberinto del Horror.\n\nFunciones: atención de clientes, cotización de paquetes, coordinación con cocina y bar, supervisión del evento.\n\nRequisitos: experiencia en atención al cliente o eventos, inglés conversacional, uso de WhatsApp Business y Google Sheets.\n\nTrabajo parcial, horario flexible. WhatsApp: +573174370575',
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
    E'El Sanatorio busca Creador/a de Contenido para capturar la magia (y el terror) de nuestra experiencia en video y foto para redes sociales.\n\nBuscamos: alguien con ojo para el storytelling visual, manejo de Instagram Reels y TikTok, edición móvil ágil.\n\nFunciones: capturar contenido en servicio (cocina, barra, laberinto, eventos), editar y publicar reels semanales, apoyo con historias y posts.\n\nTrabajo principalmente fines de semana. Portafolio por WhatsApp: +573174370575',
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
    E'El Sanatorio busca Diseñador/a de Vestuario para crear los trajes de los personajes del Laberinto del Horror.\n\nBuscamos: experiencia en diseño textil, teatro o cosplay, creatividad para conceptos oscuros, capacidad de trabajar con presupuesto ajustado sin sacrificar impacto visual.\n\nProyecto: 8 personajes base + variantes para fechas especiales (Halloween, etc). Contrato por proyecto con posibilidad de continuidad.\n\nPortafolio por WhatsApp: +573174370575',
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
    E'Juno House Studios invita a mujeres mayores de 18 años a unirse a nuestra red de creadores de contenido digital para adultos.\n\nTrabaja desde tu casa a tu propio ritmo. Nosotros gestionamos la plataforma, los pagos y el soporte técnico — tú te concentras en crear.\n\nBeneficios: 70% de los ingresos directamente para ti, privacidad garantizada, soporte personalizado en todo el proceso de onboarding, sin experiencia previa necesaria.\n\nAplicaciones solo por WhatsApp: +573174370575 (mayores de 18 años, foto de cédula requerida)',
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
    E'Juno House Studios busca Coordinadora de Soporte para acompañar a nuestros creadores de contenido en su proceso de onboarding y operación diaria.\n\nFunciones: onboarding de nuevos talentos, soporte en dudas de plataforma, seguimiento de desempeño, comunicación directa con modelos.\n\nRequisitos: empatía, discreción absoluta, manejo de WhatsApp Business, conocimiento básico de plataformas de contenido digital. Se valora experiencia en atención al cliente.\n\nTrabajo parcial, principalmente remoto. WhatsApp: +573174370575',
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
    E'Buscamos Operador/a para gestión de cuentas en plataformas de contenido digital: publicaciones, análisis de métricas, optimización de perfiles y atención a suscriptores.\n\nRequisitos: comodidad trabajando con plataformas digitales para adultos, discreción total, organización, capacidad de manejar múltiples cuentas simultáneamente.\n\nConocimientos valorados: análisis de datos básico, copywriting en inglés y español, manejo de Canva o herramientas de edición simple.\n\nTrabajo parcial con posibilidad de tiempo completo. WhatsApp: +573174370575',
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
    E'Maia Masters Academy busca Instructor Principal para liderar nuestro bootcamp de habilidades digitales en Santa Marta.\n\nTemario base: marketing digital, diseño con IA, productividad con herramientas modernas, emprendimiento online.\n\nRequisitos: experiencia práctica y comprobable en al menos 2 de las áreas anteriores, capacidad pedagógica (no se requiere título docente), inglés conversacional, energía y carisma frente a grupo.\n\nContrato a término fijo con renovación. Sede: Centro, Santa Marta. WhatsApp: +573174370575',
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
    E'Maia Masters Academy busca Instructor de Inglés enfocado en inglés para negocios, comunicación profesional y entornos laborales modernos.\n\nCohorte Cero es nuestra primera promoción: grupo pequeño, ambiente íntimo, gran oportunidad para construir reputación y metodología propia dentro de la academia.\n\nRequisitos: inglés nativo o C1+ certificado, experiencia enseñando adultos, enfoque práctico (no gramática por gramática). Valoramos candidatos bilingües con experiencia en empresas internacionales.\n\nContrato por cohorte (3 meses). WhatsApp: +573174370575',
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
    E'Maia Masters Academy busca Coordinador/a Administrativo para gestionar el día a día de la academia.\n\nFunciones: atención a estudiantes, gestión de inscripciones y pagos, coordinación de horarios, soporte a instructores, manejo de redes sociales de la academia.\n\nRequisitos: excelente comunicación, manejo de Google Workspace, organización y proactividad. Inglés básico deseable.\n\nContrato a término indefinido. Sede: Centro, Santa Marta. WhatsApp: +573174370575',
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
    E'Maia Masters Academy busca Asesor/a de Inscripciones para guiar a potenciales estudiantes hacia el programa correcto.\n\nFunciones: responder consultas por WhatsApp e Instagram, explicar el programa, acompañar el proceso de pago e inscripción, seguimiento a prospectos.\n\nRequisitos: habilidad de ventas consultivas, empatía, conocimiento básico de educación digital. Trabajo parcial con comisión por inscripción concretada.\n\nIdeal para estudiantes universitarios o egresados de administración o comunicaciones. WhatsApp: +573174370575',
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
    E'Trivium Magnum International School for Boys busca Profesor de Matemáticas para primaria y bachillerato.\n\nEnfoque: rigor matemático con aplicación práctica, preparación para exámenes internacionales, mentoría individual.\n\nRequisitos: licenciatura en matemáticas, ingeniería o afines; experiencia docente mínima 2 años; inglés intermedio (ambiente bilingüe).\n\nOfrecemos: proyecto educativo de largo plazo, comunidad de docentes comprometidos, sede en Centro Histórico de Santa Marta. WhatsApp: +573174370575',
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
    E'Trivium Magnum busca Profesor de Inglés nativo o con certificación C1+ para nuestro programa de educación bilingüe.\n\nEnfoque: inglés académico y conversacional, literatura clásica en inglés, debate y oratoria.\n\nRequisitos: nativo o certificación avanzada, experiencia enseñando niños y adolescentes, vocación docente genuina.\n\nMisión: formar hombres con dominio pleno del inglés como herramienta de liderazgo global. WhatsApp: +573174370575',
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
    E'Trivium Magnum busca Profesor de Ciencias Naturales para bachillerato con énfasis en física, química y biología experimental.\n\nEnfoque pedagógico: aprendizaje por descubrimiento, laboratorio práctico, conexión con el entorno natural del Caribe colombiano.\n\nRequisitos: licenciatura en ciencias naturales o áreas afines, experiencia docente, pasión por la pedagogía activa. Inglés básico deseable.\n\nWhatsApp: +573174370575',
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
    E'Trivium Magnum busca Profesor de Humanidades con dominio de literatura clásica, filosofía básica, historia y lengua castellana.\n\nEl Trivium — Gramática, Retórica y Lógica — es el corazón de nuestra filosofía educativa. El candidato ideal comprende y vive esta tradición.\n\nRequisitos: licenciatura en humanidades, filosofía, letras o historia; amor genuino por los clásicos; capacidad de inspirar a jóvenes a través de la palabra.\n\nWhatsApp: +573174370575',
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
    E'Trivium Magnum busca Entrenador de Educación Física que entienda el deporte como formación de carácter, disciplina y trabajo en equipo.\n\nActividades: atletismo, natación (acceso a instalaciones cercanas), artes marciales introductorias, deportes de equipo.\n\nRequisitos: licenciatura en educación física o entrenamiento deportivo, experiencia con niños y adolescentes, liderazgo positivo y firme.\n\nWhatsApp: +573174370575',
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
    E'Trivium Magnum busca su primer Director Académico / Rector para liderar la visión educativa de la institución desde su fundación.\n\nBuscamos a alguien que comparta una convicción profunda en la educación clásica, la formación del carácter masculino y la excelencia académica.\n\nRequisitos: maestría o doctorado en educación o humanidades, experiencia en liderazgo institucional, capacidad bilingüe español-inglés, disposición para construir desde cero con autonomía y visión.\n\nCargo de alta responsabilidad y alto impacto. WhatsApp: +573174370575',
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
    E'Trivium Magnum busca Psicólogo/a Escolar para acompañar el bienestar emocional y académico de los estudiantes.\n\nFunciones: atención individual y grupal, orientación vocacional, apoyo a docentes en manejo de aula, comunicación con familias.\n\nRequisitos: título de psicología con tarjeta profesional vigente, enfoque en psicología educativa o infantojuvenil, empatía y vocación.\n\nCargo parcial (días definidos por semana). WhatsApp: +573174370575',
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
    E'Trivium Magnum busca Asistente Administrativo para apoyar la secretaría académica y la operación general del colegio.\n\nFunciones: atención a padres de familia, gestión de documentos académicos, apoyo en matrículas, manejo de agenda institucional.\n\nRequisitos: técnico o tecnólogo en administración, excelente trato con el público, manejo de Office, orden y confidencialidad.\n\nContrato a término indefinido. WhatsApp: +573174370575',
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
    E'Maia Legal busca Asistente Jurídico o Paralegal para apoyar a nuestros abogados en casos de derecho inmobiliario, contratos comerciales y asesoría a inversionistas extranjeros.\n\nFunciones: revisión de contratos, consulta de registros en la Oficina de Instrumentos Públicos, redacción de derechos de petición, gestión documental.\n\nRequisitos: estudiante de últimos semestres de derecho o abogado recién graduado, inglés conversacional (trabajamos con clientes extranjeros), proactividad.\n\nWhatsApp: +573174370575',
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
    E'Maia Management Group busca Asistente Contable para apoyar la operación financiera del grupo empresarial.\n\nFunciones: causación de facturas, conciliaciones bancarias, preparación de informes de gastos, apoyo en declaraciones de renta y retención.\n\nRequisitos: tecnólogo o profesional en contaduría, manejo de software contable (Siigo o Helio), orden, precisión y confidencialidad.\n\nContrato a término indefinido, prestaciones completas. WhatsApp: +573174370575',
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
    E'Maia Management Group busca Recepcionista y Asistente Administrativo para nuestra oficina en Santa Marta.\n\nFunciones: atención de clientes y visitantes, gestión de agenda, manejo de correspondencia, soporte a diferentes áreas del grupo.\n\nRequisitos: excelente presentación personal, inglés conversacional (indispensable — atendemos clientes internacionales), manejo de Office, actitud positiva.\n\nContrato a término indefinido. WhatsApp: +573174370575',
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
    E'Maia Management Group busca Coordinador/a de Nómina para administrar la nómina de las diferentes empresas del grupo (restaurante, academia, inmobiliaria y más).\n\nFunciones: liquidación de nómina, cálculo de prestaciones, gestión de seguridad social, novedades de personal, informes a gerencia.\n\nRequisitos: tecnólogo o profesional en contaduría o gestión humana, manejo de software de nómina, conocimiento de legislación laboral colombiana.\n\nCargo parcial. WhatsApp: +573174370575',
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
    E'Maia Realty busca Agentes Inmobiliarios para asesorar compradores nacionales e internacionales en la adquisición de propiedades en la Costa Caribe.\n\nNo se requiere matrícula de agente inmobiliario previa — te acompañamos en el proceso. Sí se requiere: habilidades comerciales, inglés conversacional, conocimiento de Santa Marta y sus barrios.\n\nIngresos: 100% comisión sobre ventas cerradas (entre 1.5% y 3% del valor del inmueble). Nuestros agentes activos ganan entre $5M y $20M por mes.\n\nWhatsApp: +573174370575',
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
    E'Maia Realty busca Fotógrafo/a Freelance especializado en fotografía de inmuebles para enriquecer nuestros listados en Santa Marta.\n\nBuscamos: ojo para la composición, manejo de luz natural e iluminación de interiores, edición ágil en Lightroom o similar. Se valora experiencia en fotografía aérea con drone.\n\nCompensación: por sesión fotográfica (precio a convenir según tipo de propiedad).\n\nPortafolio por WhatsApp: +573174370575',
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
    E'Llave Labs busca Operario de Producción para nuestra planta de elaboración de bebidas artesanales en Santa Marta.\n\nFunciones: preparación de insumos, operación de equipos de mezcla y embotellado, control de calidad básico, limpieza de planta bajo protocolos HACCP.\n\nRequisitos: bachiller o técnico en alimentos, responsabilidad y organización, capacidad física para trabajo de pie, disponibilidad de lunes a sábado.\n\nContrato a término indefinido, prestaciones completas. WhatsApp: +573174370575',
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
    E'Llave Drinks busca Repartidor/Conductor para distribución de nuestras bebidas a bares, restaurantes y hoteles en Santa Marta y alrededores.\n\nRequisitos: licencia de conducción B1 o C1 vigente, conocimiento de vías de Santa Marta y Costa, buena presentación para atención a clientes.\n\nSe valora: experiencia en distribución, manejo de furgoneta de carga liviana.\n\nSalario fijo + rodamiento + prestaciones. WhatsApp: +573174370575',
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
    E'Llave Drinks busca Representante de Ventas para el canal HoReCa (Hoteles, Restaurantes, Cafés) en Santa Marta y la Costa Caribe.\n\nFunciones: prospección de cuentas nuevas, mantenimiento de cuentas activas, presentación de productos, toma de pedidos, seguimiento de cobros.\n\nRequisitos: experiencia mínima 1 año en ventas B2B o canal HoReCa, vehículo propio deseable, actitud comercial y red de contactos en la industria.\n\nSalario base + comisiones + rodamiento. WhatsApp: +573174370575',
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
    E'Llave Drinks busca Brand Ambassadors para representar la marca en eventos, activaciones y degustaciones en Santa Marta y la región.\n\nBuscamos: personas con excelente presentación personal, energía positiva, facilidad de comunicación con el público, pasión por las bebidas artesanales.\n\nTrabajo por evento/jornada. Pago competitivo, producto a disposición, uniforme Llave incluido.\n\nIdeal para estudiantes universitarios, modelos o personas con experiencia en eventos. WhatsApp: +573174370575',
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
    E'Maia Aerial busca Guías de Aventura para nuestro parque aéreo en las estribaciones de la Sierra Nevada de Santa Marta.\n\nFunciones: acompañamiento en canopy y tirolinas, briefing de seguridad, gestión de grupos, primeros auxilios básicos.\n\nRequisitos: experiencia en actividades de aventura o turismo de naturaleza, certificación en primeros auxilios (o disposición a certificarse), inglés conversacional, actitud positiva y de servicio.\n\nContrato a término indefinido. Trabajo en el entorno natural más impresionante de Colombia. WhatsApp: +573174370575',
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
    E'Maia Aerial busca Técnico en Seguridad en Alturas certificado para inspección y mantenimiento de nuestros equipos de canopy, tirolinas y estructuras de aventura.\n\nRequisitos: certificación vigente en trabajo seguro en alturas (nivel avanzado), experiencia en inspección de equipos de protección personal (EPP), conocimiento de normas ICONTEC para parques de aventura.\n\nOfrecemos: trabajo en un entorno natural extraordinario, contrato estable, equipo de trabajo apasionado.\n\nWhatsApp: +573174370575',
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
    E'Maia Aerial contrata Auxiliares de Construcción para la fase de expansión de nuestro parque de aventura en Gaira / Rodadero.\n\nFunciones: construcción de plataformas de madera, instalación de postes y cables guía, acabados en áreas naturales.\n\nRequisitos: experiencia en construcción o carpintería de obra, sin miedo a las alturas, disponibilidad inmediata.\n\nContrato por obra. Posibilidad de vinculación permanente al término de la construcción. WhatsApp: +573174370575',
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
    E'Maia Aerial busca Operador de Bar para nuestra zona de descanso y celebración dentro del parque de aventura.\n\nFunciones: preparación y venta de bebidas (Llave Drinks y cócteles sencillos), atención al cliente post-aventura, mantenimiento de la zona de bar.\n\nRequisitos: experiencia mínima en servicio de bebidas, buena energía con grupos, gusto por la naturaleza y el outdoor.\n\nTrabajo principalmente fines de semana y festivos. WhatsApp: +573174370575',
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
    E'LlevaLleva busca Desarrollador/a Frontend con experiencia en Next.js para contribuir al desarrollo de nuestra plataforma de clasificados colombiana.\n\nStack: Next.js (App Router), TypeScript, Tailwind CSS, Supabase. Experiencia con RSC (React Server Components) y patrones modernos de data fetching.\n\nProyecto: features de búsqueda, filtros, páginas de listado y perfil. Código limpio, accesible, rápido.\n\nTrabajo remoto. Pago en COP o USD. Repositorio en GitHub. WhatsApp: +573174370575',
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
    E'LlevaLleva busca Redactor/a de Contenido SEO para crear guías, artículos y páginas de categoría que posicionen la plataforma en Google Colombia.\n\nTemas: clasificados, compra-venta, empleos, inmobiliaria, vida en la Costa Caribe, guías de ciudades colombianas.\n\nRequisitos: experiencia en escritura SEO (keyword research, on-page optimization), español nativo impecable, entrega puntual.\n\nPago por artículo. Trabajo 100% remoto. WhatsApp: +573174370575',
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
    E'LlevaLleva busca Moderador/a de Contenido para revisar y aprobar listados publicados en la plataforma, detectar spam y fraudes, y mantener la comunidad sana.\n\nFunciones: revisión diaria de nuevos listados, respuesta a reportes de usuarios, aplicación de políticas de contenido.\n\nRequisitos: criterio para distinguir contenido legítimo de fraudulento, rapidez de revisión, comunicación clara y profesional.\n\nTrabajo remoto, horario flexible. Ideal como trabajo adicional. WhatsApp: +573174370575',
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
    E'Familia en Santa Marta busca Chef o Cocinero/a para el hogar. Personas interesadas en el cargo, apliquen aquí.\n\nFunciones: preparación de desayunos y comidas, compras en mercado, mantenimiento de cocina limpia.\n\nRequisitos: experiencia comprobada en cocina casera o de restaurante, referencias personales, honestidad y discreción.\n\nDisponibilidad: tiempo completo o por días (se negocia). WhatsApp: +573174370575',
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
    E'Familia en Santa Marta busca Aseadora de tiempo completo con experiencia en limpieza de hogares.\n\nFunciones: limpieza general del hogar, lavado y planchado de ropa, orden de espacios.\n\nRequisitos: experiencia comprobable, referencias de empleadores anteriores, responsabilidad y puntualidad.\n\nSalario mínimo + prestaciones completas conforme a ley. Posibilidad de alojamiento. WhatsApp: +573174370575',
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
    E'El Sanatorio requiere Electricista para trabajos de instalación y remodelación eléctrica en nuestro local del Centro Histórico (Calle 19 #4-23).\n\nTrabajos: instalación de circuitos de iluminación temática, tomas especiales para equipos de bar y cocina, sistema de luces DMX, planta eléctrica de respaldo.\n\nRequisitos: matrícula CONTE vigente, experiencia en locales comerciales y restaurantes, disponibilidad inmediata.\n\nContrato por obra. WhatsApp: +573174370575',
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
    E'El Sanatorio requiere Plomero para trabajos de plomería y gasfitería en nuestro local en el Centro de Santa Marta.\n\nTrabajos: instalación de puntos de agua en barra y cocina, tuberías de gas para zona de cocina yakitori, baños nuevos.\n\nRequisitos: experiencia mínima 3 años en plomería comercial, manejo de normas de gas NTC, disponibilidad inmediata.\n\nContrato por obra determinada. WhatsApp: +573174370575',
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
    E'El Sanatorio busca Carpintero o Ebanista para fabricar el mobiliario temático de nuestro gastro bar y laberinto del horror.\n\nProyecto: mesas, sillas y barras de madera envejecida con estética victoriana-horror; estructuras del laberinto; puertas y paneles decorativos.\n\nRequisitos: experiencia en carpintería fina y de obra, creatividad para adaptar diseños temáticos, disponibilidad para trabajo en sitio (Calle 19 #4-23 Centro).\n\nContrato por obra. WhatsApp: +573174370575',
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
    E'El Sanatorio busca Pintor con experiencia en acabados especiales y capacidad para ejecutar (o interpretar) murales de temática horror-victoriana en paredes y techos.\n\nTrabajos: pintura base y acabados de todo el local; murales temáticos en salón y laberinto; efectos de envejecimiento y texturas.\n\nRequisitos: experiencia en pintura de acabados especiales; se valora experiencia en murales o grafiti artístico oscuro.\n\nContrato por obra. Disponibilidad inmediata. WhatsApp: +573174370575',
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
    E'El Sanatorio busca Diseñador/a de Interiores para co-liderar la conceptualización y supervisión de los acabados finales de nuestro gastro bar de terror.\n\nConcepto: horror victoriano con toques japoneses — oscuro, elegante, perturbador y funcional para un restaurante de alta rotación.\n\nBuscamos: portafolio en diseño de restaurantes o entretenimiento, comprensión de flujos de cocina y bar, gusto por lo inusual.\n\nContrato por proyecto con honorarios a convenir. WhatsApp: +573174370575',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['empleo','el-sanatorio','disenador','interiores','horror','contrato','santa-marta'],
    '[{"url":"/images/sanatorio-interior.jpg","alt":"El Sanatorio Diseño Interior","order":0}]'
  );

  RAISE NOTICE 'Job listings seeded: 59 listings (1–59)';

END $$;
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
    E'El Sanatorio Gastro Bar busca neveras y congeladores comerciales de dos o cuatro puertas en buen estado para nuestra operación.\n\nBuscamos:\n• Nevera exhibidora vertical de 2 o 4 puertas (1.5 m–2 m alto)\n• Congelador horizontal tipo cofre (300 L o más)\n• Cualquier marca: Imensa, Haceb, True, Metalfrio, etc.\n\nCondición: usado en buen estado o nuevo. Pago de contado. Recogida en Santa Marta.\n\nContacto: WhatsApp +573174370575 con fotos y precio.',
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
    E'Buscamos bajo-mesones refrigerados y botelleros para equipar la barra de El Sanatorio Gastro Bar.\n\nQué buscamos:\n• Bajo-mesón refrigerado de 1 o 2 puertas (60–120 cm ancho)\n• Botellero o wine cooler de barra\n• Marcas: Imbera, True Refrigeration, Gamko u otras\n\nEstado: usado en buen funcionamiento o nuevo. Pago inmediato. Santa Marta.\n\nWhatsApp: +573174370575 — envíe fotos y precio.',
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
    E'El Sanatorio busca parrilla yakitori a carbón de uso comercial para nuestra cocina de fusión japonesa-latina.\n\nEspecificaciones ideales:\n• Parrilla yakitori tipo japonés con soporte de carbón directo bajo las brochetas\n• Acero inoxidable, ancho mínimo 60 cm, con extractor de cenizas\n• Nueva o importada en buen estado\n\nTambién aceptamos parrillas de leña/carbón de restaurante adaptables a la técnica yakitori.\n\nContacto inmediato: WhatsApp +573174370575 con fotos, especificaciones y precio.',
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
    E'Buscamos campana extractora de humos de uso comercial para cocina de restaurante.\n\nCaracterísticas:\n• Ancho mínimo 1.2 m, fabricación en acero inoxidable\n• Sistema de extracción con motor de alta capacidad (m³/h suficiente para parrilla de carbón)\n• Con o sin filtros de grasa incluidos\n\nTambién se evalúan sistemas de extracción modulares o campanas de segunda mano en buen estado.\n\nUbicación: Santa Marta — recogeremos localmente.\n\nWhatsApp: +573174370575',
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
    E'El Sanatorio busca freidora comercial de una o dos canastas para nuestra cocina.\n\nBuscamos:\n• Freidora a gas o eléctrica, capacidad 8–15 L por cuba\n• Acero inoxidable, con canasta y tapa\n• Marcas: Waring, Pitco, Frymaster, Anvil o similar comercial\n\nEstado: nuevo o usado en buen funcionamiento. Pago de contado.\n\nWhatsApp: +573174370575 con fotos y precio.',
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
    E'Buscamos lavavajillas comercial tipo capota (hood-type) o de cinta para uso en restaurante de alta rotación.\n\nEspecificaciones:\n• Ciclo de lavado ≤ 2 minutos\n• Capacidad mínima 40 canastas/hora\n• Incluyendo dosificadores de detergente y rinse-aid si es posible\n\nSe evalúan equipos usados de marcas Hobart, Meiko, Classeq, Winter-Halter o equivalentes comerciales colombianos.\n\nContacto: WhatsApp +573174370575 con especificaciones y precio.',
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
    E'Buscamos mesones y estantes de acero inoxidable para equipar la cocina de El Sanatorio.\n\nQué necesitamos:\n• Mesones de trabajo en acero inox 304, varios tamaños (60–180 cm largo)\n• Estantes y repisas de acero para bodega de cocina\n• Estación de trabajo con entrepaños\n\nNuevo o usado en buen estado. Recogemos en Santa Marta. Pago de contado.\n\nWhatsApp: +573174370575 con medidas y precio.',
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
    E'El Sanatorio busca máquina de hielo comercial para abastecer nuestra barra de coctelería.\n\nBuscamos:\n• Producción mínima 30 kg/día\n• Hielo en cubos o media luna — apto para coctelería\n• Depósito integrado deseable\n• Marcas: Manitowoc, Scotsman, Hoshizaki, Ice-O-Matic u otras comerciales\n\nSe evalúan equipos nuevos o usados certificados. Pago de contado. Recogida en Santa Marta.\n\nWhatsApp: +573174370575',
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
    E'Buscamos licuadoras comerciales de alta potencia para uso en barra de coctelería.\n\nBuscamos:\n• Potencia mínima 1 HP, jarra de 1.5–2 L\n• Velocidades variables o programables\n• Marcas: Vitamix, Blendtec, Waring, Hamilton Beach comercial\n• Incluidas fundas insonorizadoras si es posible\n\nNueva o usada en buen estado. 1 o 2 unidades.\n\nWhatsApp: +573174370575 con precio y estado.',
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
    E'El Sanatorio busca sistema POS completo para manejo de comandas, pagos y cierres de caja en restaurante y bar.\n\nQué buscamos:\n• Terminal táctil (mínimo 15") resistente a entorno de hostelería\n• Software compatible con impresora de cocina y datafono\n• Opciones: Siigo POS, Nubox, o terminal Android/iPad con app de POS\n• Se evalúan paquetes completos (terminal + impresora + cajón)\n\nNuevo o reacondicionado. Pago de contado.\n\nWhatsApp: +573174370575',
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
    E'Buscamos cajón de dinero para conectar a sistema POS en restaurante.\n\nEspecificaciones:\n• Compatible con impresora térmica de comandas (apertura por señal)\n• 5 billetes + 8 monedas mínimo\n• Cualquier marca estándar\n\nNuevo o usado en perfecto estado. Precio justo.\n\nWhatsApp: +573174370575',
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
    E'El Sanatorio busca sillas de restaurante y taburetes de barra en estilo industrial oscuro u oscurecible para completar el mobiliario de nuestro gastro bar de concepto horror.\n\nQué buscamos:\n• Sillas de comedor resistentes (metal, madera oscura o cuero negro/burdeos) — lote de 20–40 unidades\n• Taburetes de barra altos (65–75 cm asiento) — lote de 8–12 unidades\n• Cualquier diseño industrial, vintage o gótico que se adapte al concepto\n\nSe compran nuevas o usadas en buen estado. Pago de contado. Recogemos en Santa Marta.\n\nFotos y precio por WhatsApp: +573174370575',
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
    E'Buscamos mesas para terraza exterior de El Sanatorio (zona de espera y experiencia al aire libre en el Centro Histórico de Santa Marta).\n\nQué buscamos:\n• Mesas de 60–80 cm diámetro o cuadradas, resistentes a intemperie (metal, hierro forjado, madera tratada)\n• Estilo: industrial, vintage, oscuro — que encaje con el concepto horror\n• Lote de 6–12 unidades\n\nNuevas o usadas en buen estado. Pago de contado.\n\nFotos y precio por WhatsApp: +573174370575',
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
    E'El Sanatorio busca sistema de sonido profesional para ambientación de salón y barra.\n\nQué buscamos:\n• Bocinas de techo o pared (6–10 unidades) con amplificador multizona\n• Altavoces activos de escena (para DJ y eventos) — 2 a 4 unidades\n• Subwoofer activo (deseable)\n• Marcas: JBL, QSC, Yamaha, Behringer, HK Audio u otras profesionales\n\nEquipo completo o por componentes. Nuevo o usado en buen estado. Pago de contado.\n\nWhatsApp: +573174370575',
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
    E'El Sanatorio busca equipos de iluminación escénica para el salón del bar y el Laberinto del Horror.\n\nQué buscamos:\n• Cabezas móviles (moving heads) — 4 a 8 unidades\n• Luces LED PAR y wash\n• Controlador DMX (consola o software)\n• Estructuras de rigging / travesaños\n• Marcas: Chauvet, Elation, Martin, Eurolite, American DJ\n\nNuevas, de segunda o alquiler con opción de compra.\n\nWhatsApp: +573174370575',
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
    E'El Sanatorio busca máquinas de humo, niebla y efectos especiales para el Laberinto del Horror y ambientación del bar.\n\nQué buscamos:\n• Máquinas de humo (fog machines) de 1000–1500W — varias unidades\n• Máquina de niebla baja (low fog / suelo)\n• Fluido de humo (varios litros)\n• Eventuales efectos de arco voltaico o plasma (decorativos, sin riesgo)\n\nNuevas o usadas en buen estado. Importadas OK si llegan a Bogotá o Barranquilla.\n\nWhatsApp: +573174370575',
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
    E'Buscamos estanterías metálicas industriales para bodega de almacenamiento (insumos de cocina, bebidas y equipos del laberinto).\n\nQué buscamos:\n• Estanterías de ángulo ranurado o tipo rack galvanizado\n• Altura 1.8–2.4 m, varios anchos\n• Capacidad de carga media-alta por entrepaño\n• Lote de 5–15 módulos\n\nNuevas o de segunda en buen estado. Pago de contado. Recogemos en Santa Marta.\n\nWhatsApp: +573174370575',
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
    E'Buscamos calentador de agua comercial para abastecer la cocina y baños de El Sanatorio.\n\nEspecificaciones:\n• Gas natural o GLP (preferible gas)\n• Paso continuo o tanque de 80–150 L\n• Capacidad para cocina profesional + 2 baños simultáneos\n\nMarcas: Haceb, Challenger, Rheem, State, Bradford White.\n\nNuevo o usado en buen estado con garantía de funcionamiento.\n\nWhatsApp: +573174370575',
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
    E'El Sanatorio busca generador / planta eléctrica de respaldo para garantizar la operación del restaurante y el Laberinto del Horror ante cortes de energía.\n\nEspecificaciones:\n• 10–20 KVA mínimo (220V trifásico o bifásico según instalación)\n• Diesel o gas\n• Con sistema de transferencia automática (ATS) si es posible\n• Insonorizado preferible\n\nMarcas: Kohler, Generac, Cummins, FG Wilson, Perkins.\n\nNuevo o reacondicionado con soporte técnico. Pago de contado.\n\nWhatsApp: +573174370575',
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
    E'Buscamos sistema de videovigilancia CCTV para instalación en El Sanatorio (interior, cocina, barra, acceso y laberinto).\n\nQué necesitamos:\n• 8–16 cámaras IP o HD (interiores y 2–4 para exterior)\n• NVR/DVR con disco duro incluido\n• Visualización remota desde celular\n• Instalación en Santa Marta Centro Histórico\n\nSe evalúan paquetes completos con instalación incluida.\n\nWhatsApp: +573174370575',
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
    E'El Sanatorio requiere extintores y equipos de seguridad contra incendio para cumplir con los requisitos del Cuerpo de Bomberos de Santa Marta.\n\nQué buscamos:\n• Extintores tipo ABC (multipropósito) — 5 a 10 unidades de 5–10 lb\n• Extintor para grasa K (cocina) — 1 unidad\n• Señalización de rutas de evacuación y salidas de emergencia\n• Kit de primeros auxilios\n\nProveedores con certificación Bomberos preferibles.\n\nWhatsApp: +573174370575',
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
    E'El Sanatorio busca equipos completos de grifo Sankey y sistemas de CO2 para servicio de bebidas de barril.\n\nQué necesitamos:\n• Cabezas de grifo Sankey tipo D (compatibles con barriles colombianos e importados)\n• Reguladores de CO2 y mangueras de gas\n• Bombas de CO2 y tanques (cilindros de 2–10 kg)\n• Líneas de servicio con serpentines de frío o línea directa desde nevera\n\nNuevos o usados en buen estado. Pago de contado.\n\nWhatsApp: +573174370575',
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
    E'Be Vida Botánicas busca barriles Sankey de 20 litros (acero inoxidable) para envasar y distribuir nuestras bebidas RTD al canal B2B en Santa Marta y la Costa Caribe.\n\nBuscamos:\n• Barriles Sankey 20L en acero inox, tipo D o G\n• En buen estado, sin golpes significativos que comprometan el sello\n• Lote mínimo de 10 unidades\n\nTambién evaluamos contratos de alquiler de barriles con proveedor. Pago inmediato.\n\nWhatsApp: +573174370575',
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
    E'Maia Management Group busca escritorios y sillas ergonómicas de oficina para equipar nuestras instalaciones en Santa Marta.\n\nQué necesitamos:\n• Escritorios modulares o individuales — 6 a 10 puestos\n• Sillas ergonómicas de escritorio con ajuste lumbar\n• Mesa de reuniones para 8–10 personas\n• Armarios o cajoneras de archivo\n\nNuevo o usado en buen estado. Entrega en Santa Marta Centro.\n\nWhatsApp: +573174370575 con fotos y precio.',
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
    E'Maia Management Group busca proyector y pantalla para sala de reuniones y aula de Maia Masters Academy.\n\nEspecificaciones:\n• Proyector: mínimo 3.000 lúmenes, resolución 1080p, HDMI y Wi-Fi\n• Pantalla: 100"–120" retráctil o fija\n• Marcas: Epson, BenQ, ViewSonic, LG, Optoma\n\nNuevo o reacondicionado con garantía. También se evalúan TV 85" como alternativa.\n\nWhatsApp: +573174370575',
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
    E'Maia Management Group busca computadores de escritorio y laptops para equipar las oficinas y el aula de Maia Masters Academy.\n\nQué buscamos:\n• Laptops: Core i5 o Ryzen 5 de 11ª generación o superior, 8 GB RAM, 256 GB SSD mínimo — 5 a 10 unidades\n• PCs de escritorio: configuración similar — 3 a 5 unidades\n• Monitores adicionales — varios\n\nNuevos, reacondicionados o segunda mano en buen estado funcional.\n\nWhatsApp: +573174370575 con especificaciones y precio.',
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
    E'Buscamos impresora multifuncional (imprime, escanea, fotocopia) para oficina.\n\nEspecificaciones:\n• Láser monocromática o color, uso intensivo\n• Wi-Fi y USB, compatible con Google Drive\n• Marcas: HP, Canon, Brother, Epson EcoTank\n• Tambien se evalúa impresora de etiquetas adicional\n\nNueva o usada en buen estado con tóner/tinta incluido.\n\nWhatsApp: +573174370575',
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
    E'Maia Management Group busca camioneta o furgoneta para apoyo logístico y distribución de Be Vida Botánicas en Santa Marta y la región.\n\nQué buscamos:\n• Camioneta doble cabina o furgoneta de carga liviana\n• Diesel o gasolina, modelo 2015 o más reciente\n• Buen estado mecánico, traspaso limpio\n• Carga útil mínima 800 kg\n\nPago de contado o financiación según oferta.\n\nWhatsApp: +573174370575 con fotos, km y precio.',
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
    E'Grupo Maia busca motocicleta para mensajería, diligencias y entregas locales en Santa Marta.\n\nQué buscamos:\n• Moto 125–200 cc, modelo 2016 o más reciente\n• Papeles al día, buen estado mecánico\n• Marca: Honda, Yamaha, Bajaj, AKT u otras\n• Con cajón de carga o adaptable\n\nPago de contado. Se evalúan motos con y sin baúl.\n\nWhatsApp: +573174370575 con fotos, km y precio.',
    NULL, 'contact', 'COP', 'active', now(),
    ARRAY['se-busca','moto','mensajeria','125cc','logistica','santa-marta'],
    '[{"url":"/images/placeholder.jpg","alt":"Motocicleta","order":0}]'
  ) ON CONFLICT (slug) DO NOTHING;

  RAISE NOTICE 'Migration 011 complete: 29 equipment-wanted listings (#79–107)';

END $$;
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
    E'El Sanatorio requiere asesoría de Arquitecto Patrimonial con experiencia en el Plan Especial de Manejo y Protección (PEMP) del Centro Histórico de Santa Marta.\n\nNuestro local está en la Calle 19 #4-23, dentro del perímetro de protección del Centro Histórico. Necesitamos:\n• Revisión de planos de adecuación para verificar cumplimiento PEMP\n• Acompañamiento ante el Ministerio de Cultura / Curaduria Urbana\n• Concepto técnico sobre intervención de fachada y estructura interior\n\nHonorarios a convenir. Se prefiere arquitecto con experiencia comprobable en proyectos similares en el Caribe colombiano.\n\nContacto: WhatsApp +573174370575',
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
    E'Maia Management Group busca electricista con experiencia en instalaciones comerciales para mantenimiento y obras en los diferentes locales del grupo en Santa Marta.\n\nTrabajos requeridos: revisión y certificación de instalaciones eléctricas, instalación de tomacorrientes y circuitos adicionales, reparaciones de emergencia.\n\nRequisitos: matrícula CONTE vigente, experiencia demostrable en locales comerciales. Trabajo recurrente para el electricista adecuado.\n\nContacto: WhatsApp +573174370575 con tarifas.',
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
    E'Maia Management Group busca plomero con experiencia en instalaciones comerciales para mantenimiento recurrente y obras de adecuación.\n\nTrabajos: instalación de puntos hidráulicos en cocinas y baños, mantenimiento de redes de agua fría/caliente, instalación de sistemas de gas.\n\nRequisitos: experiencia mínima 3 años en plomería comercial, disponibilidad para Santa Marta Centro y otras zonas del Distrito. Trabajo recurrente garantizado.\n\nWhatsApp: +573174370575 con tarifas.',
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
    E'El Sanatorio busca pintor con experiencia en acabados especiales, texturas y murales para la adecuación de nuestro local en el Centro Histórico de Santa Marta.\n\nTrabajos: pintura base en interiores con texturas envejecidas, efectos de humedad y deterioro controlado (estética horror), intervenciones murales en paredes principales.\n\nSe busca: pintor creativo con portafolio de acabados especiales. Trabajo por contrato de obra. Disponibilidad inmediata.\n\nPortafolio por WhatsApp: +573174370575',
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
    E'El Sanatorio busca carpintero o ebanista para fabricar el mobiliario artesanal del gastro bar y el Laberinto del Horror en el Centro de Santa Marta.\n\nProyecto: mesas y sillas estilo victoriano-horror en madera envejecida, puertas decorativas, paneles de madera para el laberinto, barra de bar.\n\nSe busca: artesano con experiencia en mobiliario personalizado, creatividad para interpretar diseños oscuros, disposición para trabajo en sitio.\n\nContacto con portafolio: WhatsApp +573174370575',
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
    E'El Sanatorio busca metalistero o fabricador metálico para estructuras decorativas y funcionales del local.\n\nProyecto: rejas decorativas de hierro forjado para ventanas y puertas, estructuras de soporte para el laberinto, mesas con patas de hierro, letreros metálicos.\n\nSe busca: herrero o metalistero con creatividad para estilo gótico-industrial. Trabajo por contrato de obra en Santa Marta.\n\nFotos de trabajos anteriores por WhatsApp: +573174370575',
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
    E'Maia Management Group busca técnico de aires acondicionados para instalación y mantenimiento preventivo y correctivo en los locales del grupo en Santa Marta.\n\nTrabajos: instalación de unidades Split en oficinas y el restaurante, mantenimiento trimestral programado, reparaciones de emergencia.\n\nRequisitos: técnico certificado, disponibilidad en Santa Marta Centro, experiencia en equipos comerciales. Contrato de mantenimiento mensual disponible para el técnico adecuado.\n\nWhatsApp: +573174370575 con tarifas.',
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
    E'El Sanatorio busca rotulista o empresa de letrería para fabricar e instalar el letrero de fachada y la señalética interior del gastro bar.\n\nQué necesitamos:\n• Letrero principal de fachada iluminado (neón, acrílico retroiluminado o letra metálica volumétrica)\n• Señalética interior temática (baños, salidas, zonas del laberinto)\n• Menús de pizarrón y marcos personalizados\n\nEstilo: horror victoriano — oscuro, elegante, con detalles en rojo o dorado.\n\nPortafolio y presupuesto por WhatsApp: +573174370575',
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
    E'El Sanatorio busca diseñador gráfico o muralista para la identidad visual del local y la ejecución de murales de pared.\n\nProyecto:\n• Murales temáticos horror-victoriano en paredes del salón y laberinto\n• Diseño de menú y carta de cócteles\n• Material gráfico para redes sociales (templates de marca)\n\nBuscamos artista con portafolio oscuro o de ilustración detallada. Se valora experiencia en interiorismo o proyectos de restaurante.\n\nPortafolio por WhatsApp: +573174370575',
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
    E'El Sanatorio busca proveedores de insumos para nuestra cocina de fusión japonesa-latina en Santa Marta.\n\nQué necesitamos:\n• Carnes y proteínas (res, cerdo, pollo, mariscos) en cortes para parrilla y yakitori\n• Verduras y vegetales frescos diarios\n• Insumos japoneses: salsa de soya, miso, sake, mirin, arroz japonés, algas\n• Condimentos y salsas artesanales\n\nBuscamos proveedores confiables con entrega diaria o interdiaria en Santa Marta Centro. Pedidos iniciales de volumen medio con posibilidad de crecimiento.\n\nContacto: WhatsApp +573174370575',
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
    E'El Sanatorio busca proveedor directo de mariscos y pescados frescos para nuestra carta de cocina japonesa-latina en Santa Marta.\n\nQué necesitamos:\n• Camarón fresco (peladito y entero)\n• Pulpo y calamar frescos o ultracongelados de calidad\n• Pescado fresco del día (atún, pargo, sierra, mero)\n• Entregas 3–5 veces por semana, puntualidad indispensable\n\nPreferimos proveedores locales o de Barranquilla con cadena de frío certificada. Buenas condiciones de precio por volumen.\n\nWhatsApp: +573174370575',
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
    E'El Sanatorio Gastro Bar busca distribuidor de licores al por mayor en Santa Marta para abastecer nuestra barra de coctelería.\n\nQué buscamos:\n• Ron (Dictador, Diplomático, Medellín, Don Pancho)\n• Vodka y Gin (Absolut, Tanqueray, Hendrick\'s, Gordon\'s)\n• Whisky y Bourbon (Jack Daniel\'s, Johnnie Walker, Jim Beam)\n• Licores nacionales y artesanales de la Costa\n• Vinos para cocina y carta\n\nBuscamos distribuidor con buenos precios, crédito a 30 días y entrega en Santa Marta. Volumen mensual estimado: alto para la escala del negocio.\n\nWhatsApp: +573174370575',
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
    E'Be Vida Botánicas busca proveedor de empaques y packaging para nuestras bebidas artesanales.\n\nQué necesitamos:\n• Etiquetas adhesivas en material húmedo-resistente (BOPP o similar) — impresión digital\n• Tapas y sellos para envases de vidrio y PET\n• Cajas de cartón corrugado para transporte de 12 y 24 unidades\n• Tubos sellados para shots de fruta (PET o vidrio)\n\nBuscamos proveedor en Colombia con producción mínima flexible para PYME. Precios competitivos y tiempos de entrega cortos.\n\nWhatsApp: +573174370575',
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
    E'Maia Management Group busca empresa de impresión para cubrir las necesidades gráficas del grupo empresarial.\n\nQué necesitamos:\n• Tarjetas de presentación (varias marcas del grupo)\n• Flyers y volantes para eventos\n• Menús impresos y laminados para El Sanatorio\n• Pendones y banners\n• Etiquetas y material POP\n\nBuscamos litografía con buena calidad digital e impresión offset, que pueda manejar urgencias. Puede ser en Santa Marta o con servicio de envío.\n\nMuestras y cotizaciones por WhatsApp: +573174370575',
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
    E'Maia Management Group busca empresa de aseo o personal de limpieza para contrato mensual en los locales del grupo.\n\nServicios requeridos:\n• Limpieza profunda diaria de restaurante (El Sanatorio)\n• Aseo de oficinas (3 veces por semana)\n• Desinfección periódica de cocina y zonas de manipulación de alimentos\n• Manejo de desechos\n\nSe busca empresa formal o cooperativa con afiliación de personal a seguridad social. Contrato mensual con posibilidad de ampliar a más locales.\n\nCotización por WhatsApp: +573174370575',
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
    E'Maia Management Group busca empresa de vigilancia y seguridad privada para brindar protección a los locales del grupo en Santa Marta.\n\nRequisitos:\n• Vigilantes certificados con tarjeta de miembro activo SuperVigilancia\n• Cobertura nocturna y de fin de semana para El Sanatorio\n• Protección de oficinas (turno diurno)\n• Capacidad de respuesta ante emergencias\n\nSe prefieren empresas con supervisión activa de personal y monitoreo en tiempo real.\n\nCotizaciones por WhatsApp: +573174370575',
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
    E'Maia Legal te acompaña en todo el proceso de constitución de tu empresa S.A.S. en Colombia, desde la redacción de estatutos hasta la inscripción en Cámara de Comercio y DIAN.\n\nServicio incluye:\n✓ Asesoría previa sobre estructura societaria\n✓ Redacción de estatutos personalizada\n✓ Acta de constitución\n✓ Inscripción ante Cámara de Comercio de Santa Marta\n✓ RUT y NIT ante DIAN\n✓ Apertura de cuenta bancaria empresarial (orientación)\n\nTiempo estimado: 5–10 días hábiles.\nTarifa: desde USD $1.200 (pago en COP al TRM del día).\n\nAtendemos colombianos y extranjeros. Inglés disponible.\n\nWhatsApp: +573174370575',
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
    E'Maia Legal ofrece asesoría y trámite completo de visas colombianas para extranjeros que desean vivir, invertir o retirarse en Colombia.\n\nVisas que tramitamos:\n• Visa M (migrante) por inversión — desde USD $800\n• Visa de pensionado — desde USD $800\n• Visa de cónyuge o compañero/a permanente\n• Visa de inversionista acreditado\n\nServicio incluye: evaluación de elegibilidad, compilación de documentos, apostilla, presentación ante Cancillería, seguimiento hasta resolución.\n\nExperiencia con clientes de EE.UU., Canadá, Europa, Australia y Latinoamérica.\n\nConsulta inicial gratuita por WhatsApp: +573174370575',
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
    E'Maia Legal y nuestro equipo contable ofrecen preparación y presentación de declaraciones de renta para personas naturales y jurídicas en Colombia.\n\nServicio incluye:\n✓ Análisis de ingresos, deducciones y rentas exentas\n✓ Revisión de facturas y gastos deducibles\n✓ Preparación de la declaración en el formulario DIAN\n✓ Presentación electrónica y comprobante\n✓ Asesoría sobre pagos o devoluciones\n\nTarifas:\n• Persona natural asalariada: desde $1.600.000 COP\n• Persona natural con actividad independiente: desde $2.200.000 COP\n• Persona jurídica (empresa): cotización según complejidad\n\nAtendemos colombianos residentes y extranjeros con obligación fiscal en Colombia.\n\nWhatsApp: +573174370575',
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
    E'Maia Management Group ofrece paquetes de contabilidad mensual para pequeñas y medianas empresas en Colombia.\n\nQué incluye el servicio:\n✓ Causación de facturas de compra y venta\n✓ Conciliaciones bancarias\n✓ Liquidación de impuestos bimestrales (IVA, ICA)\n✓ Retención en la fuente\n✓ Estados financieros mensuales (PyG, Balance)\n✓ Informe de gestión a gerencia\n\nPaquetes desde $1.400.000 COP/mes según volumen de transacciones.\n\nEspecialistas en restaurantes, agencias y empresas de servicios. Trabajo 100% remoto con reunión virtual mensual.\n\nConsulta gratis: WhatsApp +573174370575',
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
    E'Maia Management Group te ayuda a implementar la facturación electrónica en tu empresa colombiana, desde el trámite ante la DIAN hasta la activación del software.\n\nServicio incluye:\n✓ Registro como facturador electrónico ante DIAN\n✓ Selección y configuración del proveedor tecnológico (Siigo, Alegra, Factus, etc.)\n✓ Capacitación al equipo en el uso del sistema\n✓ Soporte en los primeros 30 días de operación\n✓ Revisión de primeros documentos electrónicos\n\nTarifa: desde $800.000 COP (pago único). Mantenimiento mensual disponible.\n\nWhatsApp: +573174370575',
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
    E'Maia Management Group ofrece asesoría en cumplimiento fiscal y gestión ante la DIAN para empresas y personas naturales en Colombia.\n\nServicios:\n• Revisión de obligaciones tributarias\n• Respuesta a requerimientos de la DIAN\n• Gestión de devoluciones de IVA\n• Planeación tributaria\n• Asesoría a extranjeros con actividad económica en Colombia\n\nAtendemos empresas de todos los tamaños. Honorarios desde $500.000 COP según complejidad del caso.\n\nConsulta inicial sin costo: WhatsApp +573174370575',
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
    E'Maia Management Group ofrece servicio de reclutamiento, selección y colocación de personal para empresas en Santa Marta y la Costa Caribe colombiana.\n\nQué ofrecemos:\n✓ Publicación de vacantes en múltiples canales\n✓ Filtro de hojas de vida y preselección\n✓ Entrevistas y pruebas psicotécnicas básicas\n✓ Verificación de referencias\n✓ Presentación de terna finalista\n✓ Apoyo en contratación y onboarding\n\nEspecialidad: hospitalidad, gastronomía, servicio al cliente, administrativo y técnico.\n\nTarifa: equivalente a 1 salario mensual bruto del cargo por candidato exitoso.\n\nWhatsApp: +573174370575',
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
    E'Maia Legal redacta contratos de trabajo a la medida para empresas y empleadores en Colombia, cumpliendo con el Código Sustantivo del Trabajo y la normativa vigente.\n\nTipos de contratos:\n• Término fijo (1, 3, 6 o 12 meses)\n• Término indefinido\n• Por obra o labor\n• Prestación de servicios\n• Para trabajadores extranjeros\n\nTarifa por contrato: desde $350.000 COP. Paquetes para múltiples contratos disponibles.\n\nTambién: revisión de contratos existentes, cláusulas de confidencialidad, acuerdos de no competencia.\n\nWhatsApp: +573174370575',
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
    E'Maia Management Group ofrece servicio de outsourcing de nómina para empresas colombianas.\n\nServicio incluye:\n✓ Liquidación mensual de salarios\n✓ Cálculo de horas extras, recargos nocturnos y dominicales\n✓ Prestaciones sociales (cesantías, prima, vacaciones)\n✓ Planilla PILA (seguridad social)\n✓ Certificados laborales\n✓ Liquidaciones y paz y salvos\n\nDesde $600.000 COP/mes para empresas hasta 5 empleados. Precio escala según número de trabajadores.\n\nAtendemos empresas en toda Colombia de forma remota.\n\nWhatsApp: +573174370575',
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
    E'Maia Masters Academy ofrece bootcamps intensivos de habilidades digitales en Santa Marta para personas que quieren actualizarse o cambiar su perfil profesional.\n\nProgramas disponibles:\n📱 Marketing Digital y Redes Sociales — 4 semanas\n🤖 Inteligencia Artificial para el Trabajo — 3 semanas\n💼 Inglés para Negocios — 6 semanas\n🚀 Emprendimiento Digital — 4 semanas\n\nTarifas: desde $1.000.000 COP por módulo / $2.200.000 COP programa completo.\nGrupos pequeños, aprendizaje práctico, certificado de finalización.\nSede: Centro Histórico, Santa Marta.\n\nInformación e inscripciones: WhatsApp +573174370575',
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
    E'Maia Realty ofrece servicio de buyer\'s agent para extranjeros que quieren comprar propiedad en Santa Marta y la Costa Caribe colombiana.\n\nCómo te ayudamos:\n✓ Búsqueda personalizada según tu presupuesto y estilo de vida\n✓ Visitas y evaluación de propiedades en tu nombre\n✓ Negociación del precio con el vendedor\n✓ Coordinación con notaría y estudio de títulos\n✓ Acompañamiento hasta escrituración y entrega\n✓ Asesoría sobre financiación y visas\n\nComisión: 3% del valor de compra (pagado por el comprador). Sin costo hasta encontrar la propiedad correcta.\n\nHablamos inglés. Inglés y español disponibles.\n\nWhatsApp: +573174370575',
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
    E'Maia Management Group ofrece consultoría estratégica de marca y marketing para negocios en Colombia y la región.\n\nQué incluye:\n• Diagnóstico de marca actual\n• Definición de propuesta de valor y posicionamiento\n• Estrategia de contenido para redes sociales\n• Plan de marketing digital (Meta Ads, Google Ads, SEO básico)\n• Diseño o rediseño de identidad visual\n• Acompañamiento mensual\n\nAtendemos restaurantes, hoteles, clínicas, academias y negocios de servicios.\n\nHonorarios desde $2.500.000 COP por proyecto o desde $1.500.000 COP/mes de acompañamiento.\n\nAgenda tu consulta inicial gratuita: WhatsApp +573174370575',
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
    E'Maia Group ofrece desarrollo de páginas web profesionales para negocios colombianos y de la región.\n\nQué hacemos:\n✓ Landing pages de alto impacto\n✓ Sitios web corporativos (5–10 páginas)\n✓ Tiendas en línea / e-commerce\n✓ Integración de WhatsApp Business y Google Analytics\n✓ SEO básico y velocidad optimizada\n✓ Dominio y hosting incluidos en planes anuales\n\nTecnologías: Next.js, WordPress, Webflow según proyecto.\nEntrega en 2–4 semanas.\nDesde $3.500.000 COP. Mantenimiento mensual desde $400.000 COP/mes.\n\nContacto y portafolio: WhatsApp +573174370575',
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
    E'Be Vida Botánicas pone a disposición del canal B2B (bares, hoteles, restaurantes y tiendas) nuestras bebidas RTD en formato Sankey 20L.\n\nProductos disponibles:\n🌿 Cóctel tropical de guanábana y jengibre\n🍍 Cóctel de piña y hierbabuena con toque de ron\n🌺 Agua de Jamaica con jengibre y menta\n🍋 Limonada de coco con maracuyá\n\nFormato Sankey 20L — listo para conectar a tu grifo. Mínimo de pedido: 2 barriles por referencia.\n\nInteresados en distribución o punto de venta: WhatsApp +573174370575\nMuestras disponibles para prueba.',
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
    E'Be Vida Botánicas lanza su línea de Shots de Fruta Tropical en tubos sellados, ideales para venta en bares, playas, tiendas y eventos.\n\nVariedades:\n• Maracuyá + ginger + toque de ron\n• Guayaba + cítrico + hierbabuena\n• Mango + ají + limón\n• Tamarindo + panela + lima\n\nFormatos de venta:\n• Pack x4 shots — venta al detal\n• Pack x10 shots — venta horeca/tiendas\n• Caja x60 shots — venta mayorista\n\nProducto artesanal, sin conservantes artificiales. Fecha de vencimiento: 30 días refrigerado.\n\nPedidos y distribución: WhatsApp +573174370575',
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
    E'¡Muy pronto! Majín es el sazonador artesanal de la Costa Caribe — mezcla de especias locales, chiles secos y toques tropicales desarrollada por el equipo de Be Vida Botánicas.\n\nFormato de lanzamiento: 3-pack de sobres individuales (perfecto para regalo o prueba).\n\nUsos: carnes a la parrilla, pollo al horno, mariscos, patacones, frito mixto y mucho más.\n\n⚠️ En espera de aprobación INVIMA — disponible en pre-venta con entrega estimada en 60 días.\n\nReserva tu 3-pack: WhatsApp +573174370575\nPromotores y distribuidores bienvenidos.',
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
    E'Reserva tu experiencia en El Sanatorio — el único gastro bar de terror en la Costa Caribe colombiana.\n\n📍 Calle 19 #4-23, Centro Histórico de Santa Marta\n\n🍣 Gastro Bar: cocina de fusión japonesa-latina con yakitori, tapas y cócteles artesanales. Reserva mesa para 2–30 personas. Sin costo de reserva.\n\n👻 Laberinto del Horror: la experiencia de terror más perturbadora de Santa Marta. Grupos de hasta 6 personas por sesión.\n• Precio por persona: a confirmar en apertura\n• Duración: 20–30 minutos de terror garantizado\n• No recomendado para menores de 14 años, embarazadas o personas con condiciones cardíacas\n\n🎉 Eventos privados: cumpleaños, despedidas, corporativos. Capacidad hasta 80 personas.\n\nReservas solo por WhatsApp: +573174370575',
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
    E'Inscríbete en la Cohorte Cero de Maia Masters Academy — nuestro grupo fundador con descuento de lanzamiento.\n\n🎓 Programas disponibles:\n• Marketing Digital + IA: 6 semanas — $1.800.000 COP\n• Inglés para Negocios: 8 semanas — $1.400.000 COP  \n• Emprendimiento Digital: 4 semanas — $1.000.000 COP\n• Programa Completo: $2.200.000 COP (ahorra $1.000.000)\n\nCohorte Cero: grupos máximo 15 personas, atención personalizada, sesiones prácticas, certificado digital.\n\n📍 Sede: Centro Histórico, Santa Marta\n🗓️ Inicio: próxima fecha disponible — consultar\n\n¿Quieres más información? WhatsApp +573174370575',
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
    E'Maia Masters Academy busca local comercial u oficina para instalar nuestra academia de habilidades digitales en el Centro Histórico de Santa Marta.\n\nCaracterísticas ideales:\n• Área: 80–200 m² útiles\n• Planta baja o primer piso (accesible para estudiantes)\n• Buena ventilación natural o con posibilidad de instalar aires\n• Conexión eléctrica robusta (aulas con muchos dispositivos)\n• En el perímetro del Centro Histórico o sectores aledaños (El Prado, Mamatoco)\n\nSe evalúan: arriendo, comodato o compra. Presupuesto: hasta $3.500.000 COP/mes en arriendo.\n\nContacto: WhatsApp +573174370575',
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
    E'Maia Aerial busca finca o terreno en las estribaciones de la Sierra Nevada de Santa Marta para desarrollar un parque de aventura aérea (canopy, tirolinas, senderismo y ecoturismo).\n\nQué buscamos:\n• Área mínima: 5 hectáreas\n• Altitud: 400–1.200 m.s.n.m.\n• Topografía: ondulada o con desniveles aptos para tirolinas\n• Acceso vehicular desde Santa Marta máximo 1 hora\n• Agua disponible (quebrada, nacimiento o pozo)\n\nSe evalúan: compra, arriendo de largo plazo o asociación con propietario.\n\nNos interesa el sector de San Pedro de la Sierra, Minca o Ciénaga.\n\nContacto: WhatsApp +573174370575',
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
    E'Be Vida Botánicas busca bodega o local industrial para expandir la capacidad de producción de nuestra línea de bebidas artesanales RTD.\n\nCaracterísticas requeridas:\n• Área: 200–600 m²\n• Zona industrial o semiindustrial (no residencial)\n• Tres fases eléctricas disponibles\n• Piso en concreto liso, fácil de lavar\n• Baños y zona de vestieres para operarios\n• Acceso para camión de carga\n\nUbicación ideal: Barranquilla zona industrial (Murillo, Galapa) o Santa Marta área de Mamatoco / Terminal.\n\nSe evalúan: arriendo mensual o arriendo con opción de compra.\n\nContacto: WhatsApp +573174370575',
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
    E'Maia Realty es tu buyer\'s agent en Santa Marta — trabajamos para ti, no para el vendedor.\n\nNuestro servicio de representación de comprador incluye:\n✓ Búsqueda personalizada de propiedades según tu perfil\n✓ Evaluación imparcial de cada opción\n✓ Negociación del mejor precio en tu nombre\n✓ Estudio de títulos y due diligence\n✓ Coordinación con notaría y banco (si aplica)\n✓ Soporte post-compra\n\nSin costo hasta que encontremos tu propiedad. Nuestra comisión (3%) la pagas en el cierre.\n\nAtendemos en inglés y español. Hemos ayudado a compradores de EE.UU., Europa y Latinoamérica.\n\n📲 Primera consulta gratis: WhatsApp +573174370575',
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
    E'Santa Marta, te lo advertimos: EL SANATORIO ya está aquí. 👻\n\nEl primer gastro bar de terror del Caribe colombiano abre sus puertas en el corazón del Centro Histórico — Calle 19 #4-23.\n\n🍣 Cocina de fusión japonesa-latina con especialidad en yakitori y tapas creativas\n🍹 Barra de cócteles artesanales\n👻 Laberinto del Horror — si te atreves a entrar\n\nHorarios de apertura:\n🍽️ Restaurante: martes a domingo, 12:00–23:00\n🎭 Laberinto: viernes y sábados desde las 18:00\n\nReservas por WhatsApp: +573174370575\n\n¿Estás listo para cenar en el lado oscuro?',
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
    E'¡Te invitamos a conocer Maia Masters Academy antes de inscribirte!\n\n📅 Jornada de Puertas Abiertas — próxima fecha a confirmar\n📍 Centro Histórico, Santa Marta (dirección por WhatsApp)\n\nEn la jornada podrás:\n• Conocer las instalaciones y el equipo de instructores\n• Asistir a una clase demo de 30 minutos\n• Resolver tus dudas sobre los programas y costos\n• Inscribirte con precio de Cohorte Cero (descuento de lanzamiento)\n\nCursos disponibles: Marketing Digital, IA para el Trabajo, Inglés para Negocios, Emprendimiento Digital.\n\n🎁 Asistentes a la jornada: clase bonus incluida en la primera semana.\n\nReserva tu lugar (cupos limitados): WhatsApp +573174370575',
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
    E'Trivium Magnum International School for Boys invita a padres y madres interesados en conocer el proyecto educativo de la primera escuela masculina de formación clásica en la Costa Caribe colombiana.\n\n📅 Fecha: a confirmar — inscríbase para recibir la convocatoria\n📍 Lugar: Centro Histórico, Santa Marta\n\nEn la velada conocerás:\n• La filosofía educativa del Trivium (Gramática, Retórica y Lógica)\n• El perfil del rector y el equipo docente\n• El currículo bilingüe y la metodología clásica\n• El proceso de matrícula para la primera cohorte\n• Las instalaciones provisionales y el plan de largo plazo\n\nPlazas fundadoras limitadas con condiciones especiales de matrícula.\n\nInscripción para recibir invitación: WhatsApp +573174370575',
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
    E'Be Vida Botánicas abre convocatoria para distribuidores y clientes B2B en Santa Marta y la Costa Caribe.\n\nSomos una productora artesanal de bebidas tropicales RTD (ready-to-drink): cócteles botánicos en barril Sankey 20L y shots de fruta sellados.\n\n¿A quién buscamos?\n🍹 Bares y coctelerías que quieran añadir líneas artesanales locales\n🏨 Hoteles y resorts que busquen bebidas premium locales para su oferta\n🛒 Tiendas y licorerías interesadas en distribución\n🚚 Distribuidores de bebidas con red de clientes en la Costa\n\nCondiciones comerciales: precio mayorista, crédito a 15 días para cuentas establecidas, muestra sin costo para primeros pedidos.\n\nContáctanos: WhatsApp +573174370575\n¡Apoya lo artesanal, apoya la Costa!',
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
    E'LlevaLleva es la nueva plataforma de clasificados hecha para Colombia — y empezamos aquí en Santa Marta. 🌊\n\n¿Qué puedes hacer en LlevaLleva?\n✅ Publicar empleos, servicios, productos y propiedades — GRATIS\n✅ Encontrar trabajo local o regional\n✅ Vender lo que no usas\n✅ Contratar servicios y profesionales\n✅ Descubrir negocios locales\n\n¿Por qué LlevaLleva?\n• 100% colombiana, hecha para la Costa\n• Sin comisiones en compra-venta directa\n• WhatsApp integrado — contacta directo, sin intermediarios\n• Categorías para todo: empleo, inmuebles, servicios, vehículos y más\n\n📲 Publica tu primer aviso hoy en www.llevalleva.co\n¡Sin costo, sin trámites, sin complicaciones!\n\nContacto: +573174370575',
    NULL, 'free', 'COP', 'active', now(),
    ARRAY['anuncio','llevalleva','clasificados','colombia','santa-marta','gratis','lanzamiento'],
    '[{"url":"/images/llevalleva-dev.jpg","alt":"LlevaLleva Lanzamiento","order":0}]',
    TRUE
  ) ON CONFLICT (slug) DO NOTHING;

  RAISE NOTICE 'Migration 012 complete: services-wanted #108–123, services-offered #124–136, for-sale #137–141, property #142–145, community #146–150';

END $$;
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

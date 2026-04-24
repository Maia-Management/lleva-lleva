-- ============================================================
-- LlevaLleva Category Taxonomy Seed
-- 16 top-level categories + subcategories
-- ============================================================

-- ============================================================
-- 1. Vehículos
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Vehículos', 'Vehicles', 'vehiculos', 'vehiculos', '🚗', 1);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'vehiculos/' || sub.slug, '🚗', sub.ord
FROM categories, (VALUES
  ('Carros y Camionetas', 'Cars & SUVs', 'carros', 1),
  ('Motos', 'Motorcycles', 'motos', 2),
  ('Camiones y Buses', 'Trucks & Buses', 'camiones', 3),
  ('Bicicletas', 'Bicycles', 'bicicletas', 4),
  ('Repuestos y Accesorios', 'Parts & Accessories', 'repuestos-vehiculos', 5),
  ('Vehículos Eléctricos', 'Electric Vehicles', 'electricos', 6),
  ('Otros Vehículos', 'Other Vehicles', 'otros-vehiculos', 7)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'vehiculos';

-- ============================================================
-- 2. Inmuebles
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Inmuebles', 'Real Estate', 'inmuebles', 'inmuebles', '🏠', 2);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'inmuebles/' || sub.slug, '🏠', sub.ord
FROM categories, (VALUES
  ('Apartamentos en Venta', 'Apartments for Sale', 'apartamentos-venta', 1),
  ('Casas en Venta', 'Houses for Sale', 'casas-venta', 2),
  ('Apartamentos en Arriendo', 'Apartments for Rent', 'apartamentos-arriendo', 3),
  ('Casas en Arriendo', 'Houses for Rent', 'casas-arriendo', 4),
  ('Lotes y Terrenos', 'Land & Lots', 'lotes', 5),
  ('Locales Comerciales', 'Commercial Spaces', 'locales', 6),
  ('Oficinas', 'Offices', 'oficinas', 7),
  ('Bodegas', 'Warehouses', 'bodegas', 8),
  ('Fincas y Haciendas', 'Farms', 'fincas', 9),
  ('Parqueaderos', 'Parking', 'parqueaderos', 10)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'inmuebles';

-- ============================================================
-- 3. Tecnología
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Tecnología', 'Technology', 'tecnologia', 'tecnologia', '💻', 3);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'tecnologia/' || sub.slug, '💻', sub.ord
FROM categories, (VALUES
  ('Celulares y Smartphones', 'Phones & Smartphones', 'celulares', 1),
  ('Computadores y Laptops', 'Computers & Laptops', 'computadores', 2),
  ('Tablets', 'Tablets', 'tablets', 3),
  ('Televisores y Audio', 'TVs & Audio', 'tv-audio', 4),
  ('Cámaras y Fotografía', 'Cameras & Photography', 'camaras', 5),
  ('Videojuegos', 'Video Games', 'videojuegos', 6),
  ('Accesorios y Periféricos', 'Accessories & Peripherals', 'accesorios-tech', 7)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'tecnologia';

-- ============================================================
-- 4. Hogar y Jardín
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Hogar y Jardín', 'Home & Garden', 'hogar', 'hogar', '🏡', 4);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'hogar/' || sub.slug, '🏡', sub.ord
FROM categories, (VALUES
  ('Muebles', 'Furniture', 'muebles', 1),
  ('Electrodomésticos', 'Appliances', 'electrodomesticos', 2),
  ('Decoración', 'Decor', 'decoracion', 3),
  ('Herramientas', 'Tools', 'herramientas', 4),
  ('Jardín y Exteriores', 'Garden & Outdoors', 'jardin', 5),
  ('Otros Hogar', 'Other Home', 'otros-hogar', 6)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'hogar';

-- ============================================================
-- 5. Servicios
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Servicios', 'Services', 'servicios', 'servicios', '🛠️', 5);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'servicios/' || sub.slug, '🛠️', sub.ord
FROM categories, (VALUES
  ('Construcción y Remodelación', 'Construction & Renovation', 'construccion', 1),
  ('Limpieza y Aseo', 'Cleaning', 'limpieza', 2),
  ('Mudanzas y Transporte', 'Moving & Transport', 'mudanzas', 3),
  ('Eventos y Bodas', 'Events & Weddings', 'eventos', 4),
  ('Salud y Bienestar', 'Health & Wellness', 'salud', 5),
  ('Tecnología e IT', 'Tech & IT', 'servicios-tech', 6),
  ('Diseño y Creatividad', 'Design & Creative', 'diseno', 7),
  ('Jurídico y Legal', 'Legal', 'juridico', 8),
  ('Financiero y Contable', 'Financial & Accounting', 'financiero', 9),
  ('Otros Servicios', 'Other Services', 'otros-servicios', 10)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'servicios';

-- ============================================================
-- 6. Empleo
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Empleo', 'Employment', 'empleo', 'empleo', '💼', 6);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'empleo/' || sub.slug, '💼', sub.ord
FROM categories, (VALUES
  ('Ofertas de Empleo', 'Job Offers', 'ofertas-empleo', 1),
  ('Búsqueda de Empleo', 'Job Seeking', 'busqueda-empleo', 2),
  ('Trabajos Freelance', 'Freelance Work', 'freelance', 3),
  ('Prácticas y Pasantías', 'Internships', 'practicas', 4)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'empleo';

-- ============================================================
-- 7. Náutico y Pesca
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Náutico y Pesca', 'Nautical & Fishing', 'nautico', 'nautico', '⛵', 7);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'nautico/' || sub.slug, '⛵', sub.ord
FROM categories, (VALUES
  ('Lanchas y Botes', 'Boats', 'lanchas', 1),
  ('Yates y Veleros', 'Yachts & Sailboats', 'yates', 2),
  ('Equipos de Pesca', 'Fishing Gear', 'pesca', 3),
  ('Motores Marinos', 'Marine Engines', 'motores-marinos', 4),
  ('Accesorios Náuticos', 'Nautical Accessories', 'accesorios-nauticos', 5),
  ('Servicios Marinos', 'Marine Services', 'servicios-marinos', 6)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'nautico';

-- ============================================================
-- 8. Moda y Belleza
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Moda y Belleza', 'Fashion & Beauty', 'moda', 'moda', '👗', 8);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'moda/' || sub.slug, '👗', sub.ord
FROM categories, (VALUES
  ('Ropa Mujer', "Women''s Clothing", 'ropa-mujer', 1),
  ('Ropa Hombre', "Men''s Clothing", 'ropa-hombre', 2),
  ('Ropa Niños', "Children''s Clothing", 'ropa-ninos', 3),
  ('Calzado', 'Footwear', 'calzado', 4),
  ('Accesorios y Joyería', 'Accessories & Jewelry', 'accesorios-moda', 5),
  ('Cosméticos y Belleza', 'Cosmetics & Beauty', 'cosmeticos', 6)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'moda';

-- ============================================================
-- 9. Turismo y Hospedaje
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Turismo y Hospedaje', 'Tourism & Lodging', 'turismo', 'turismo', '🌴', 9);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'turismo/' || sub.slug, '🌴', sub.ord
FROM categories, (VALUES
  ('Casas Vacacionales', 'Vacation Homes', 'casas-vacacionales', 1),
  ('Apartamentos Turísticos', 'Tourist Apartments', 'apartamentos-turisticos', 2),
  ('Fincas de Descanso', 'Rest Farms', 'fincas-descanso', 3),
  ('Hoteles y Hostales', 'Hotels & Hostels', 'hoteles', 4),
  ('Paquetes Turísticos', 'Tour Packages', 'paquetes', 5),
  ('Experiencias', 'Experiences', 'experiencias', 6)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'turismo';

-- ============================================================
-- 10. Educación y Formación
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Educación y Formación', 'Education & Training', 'educacion', 'educacion', '📚', 10);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'educacion/' || sub.slug, '📚', sub.ord
FROM categories, (VALUES
  ('Clases y Tutorías', 'Classes & Tutoring', 'clases', 1),
  ('Cursos Online', 'Online Courses', 'cursos-online', 2),
  ('Idiomas', 'Languages', 'idiomas', 3),
  ('Libros y Material', 'Books & Materials', 'libros', 4),
  ('Talleres y Seminarios', 'Workshops & Seminars', 'talleres', 5),
  ('Educación Técnica', 'Technical Education', 'educacion-tecnica', 6)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'educacion';

-- ============================================================
-- 11. Mascotas y Animales
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Mascotas y Animales', 'Pets & Animals', 'mascotas', 'mascotas', '🐾', 11);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'mascotas/' || sub.slug, '🐾', sub.ord
FROM categories, (VALUES
  ('Perros', 'Dogs', 'perros', 1),
  ('Gatos', 'Cats', 'gatos', 2),
  ('Aves y Exóticos', 'Birds & Exotic Pets', 'aves', 3),
  ('Accesorios para Mascotas', 'Pet Accessories', 'accesorios-mascotas', 4),
  ('Servicios Veterinarios', 'Veterinary Services', 'veterinaria', 5)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'mascotas';

-- ============================================================
-- 12. Deportes y Fitness
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Deportes y Fitness', 'Sports & Fitness', 'deportes', 'deportes', '⚽', 12);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'deportes/' || sub.slug, '⚽', sub.ord
FROM categories, (VALUES
  ('Equipos Deportivos', 'Sports Equipment', 'equipos-deportivos', 1),
  ('Ropa Deportiva', 'Sports Clothing', 'ropa-deportiva', 2),
  ('Gimnasio y Fitness', 'Gym & Fitness', 'gimnasio', 3),
  ('Deportes Acuáticos', 'Water Sports', 'deportes-acuaticos', 4),
  ('Aventura y Montaña', 'Adventure & Mountain', 'aventura', 5)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'deportes';

-- ============================================================
-- 13. Negocios e Industria
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Negocios e Industria', 'Business & Industry', 'negocios', 'negocios', '🏭', 13);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'negocios/' || sub.slug, '🏭', sub.ord
FROM categories, (VALUES
  ('Maquinaria Industrial', 'Industrial Machinery', 'maquinaria', 1),
  ('Equipos de Oficina', 'Office Equipment', 'equipos-oficina', 2),
  ('Negocios en Venta', 'Businesses for Sale', 'negocios-venta', 3),
  ('Materiales y Suministros', 'Materials & Supplies', 'materiales', 4),
  ('Franquicias', 'Franchises', 'franquicias', 5)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'negocios';

-- ============================================================
-- 14. Agro y Campo
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Agro y Campo', 'Agriculture & Rural', 'agro', 'agro', '🌾', 14);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'agro/' || sub.slug, '🌾', sub.ord
FROM categories, (VALUES
  ('Maquinaria Agrícola', 'Agricultural Machinery', 'maquinaria-agricola', 1),
  ('Semillas y Plantas', 'Seeds & Plants', 'semillas', 2),
  ('Ganado y Animales de Granja', 'Livestock & Farm Animals', 'ganado', 3),
  ('Insumos Agrícolas', 'Agricultural Supplies', 'insumos', 4),
  ('Tierras Productivas', 'Productive Land', 'tierras', 5)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'agro';

-- ============================================================
-- 15. Comunidad
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Comunidad', 'Community', 'comunidad', 'comunidad', '🤝', 15);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'comunidad/' || sub.slug, '🤝', sub.ord
FROM categories, (VALUES
  ('Se Busca / Se Encuentra', 'Lost & Found', 'perdidos', 1),
  ('Donaciones', 'Donations', 'donaciones', 2),
  ('Trueque', 'Barter', 'trueque', 3),
  ('Eventos Locales', 'Local Events', 'eventos-locales', 4),
  ('Anuncios Varios', 'Miscellaneous', 'varios', 5)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'comunidad';

-- ============================================================
-- 16. Información Pública (Bot Content)
-- ============================================================
INSERT INTO categories (name_es, name_en, slug, slug_path, icon, sort_order) VALUES
  ('Información Pública', 'Public Information', 'info-publica', 'info-publica', '📢', 16);

INSERT INTO categories (parent_id, name_es, name_en, slug, slug_path, icon, sort_order)
SELECT id, sub.name_es, sub.name_en, sub.slug, 'info-publica/' || sub.slug, '📢', sub.ord
FROM categories, (VALUES
  ('Trámites y Documentos', 'Government Procedures', 'tramites', 1),
  ('Precios de Referencia', 'Reference Prices', 'precios-referencia', 2),
  ('Tasas y Tarifas', 'Rates & Fees', 'tasas', 3),
  ('Noticias Locales', 'Local News', 'noticias', 4),
  ('Alertas Comunitarias', 'Community Alerts', 'alertas', 5),
  ('Directorio de Entidades', 'Entity Directory', 'directorio', 6),
  ('Convocatorias', 'Calls & Announcements', 'convocatorias', 7)
) AS sub(name_es, name_en, slug, ord)
WHERE categories.slug = 'info-publica';

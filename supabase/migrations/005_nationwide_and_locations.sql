-- ============================================================
-- Migration 005: Nationwide listing support + expand locations
-- ============================================================

-- Add nationwide flag to listings
ALTER TABLE listings
  ADD COLUMN IF NOT EXISTS is_nationwide BOOLEAN DEFAULT FALSE;

CREATE INDEX IF NOT EXISTS idx_listings_nationwide ON listings(is_nationwide) WHERE is_nationwide = TRUE;

-- Update RLS: nationwide listings appear in all city queries
-- (Handled at the query level by OR-ing is_nationwide = TRUE)

-- Add remaining cities for full Colombia coverage
INSERT INTO locations (department, city, slug, population, latitude, longitude)
VALUES
  -- Atlántico
  ('Atlántico', 'Puerto Colombia', 'puerto-colombia', 30000, 10.9988, -74.9561),
  ('Atlántico', 'Galapa', 'galapa', 70000, 10.9017, -74.8885),
  ('Atlántico', 'Baranoa', 'baranoa', 70000, 10.7987, -74.9231),
  ('Atlántico', 'Sabanalarga', 'sabanalarga', 100000, 10.6326, -74.9212),
  -- Magdalena
  ('Magdalena', 'Ciénaga', 'cienaga', 120000, 11.0054, -74.2514),
  ('Magdalena', 'El Banco', 'el-banco', 60000, 9.0025, -73.9758),
  -- Bolívar
  ('Bolívar', 'Magangué', 'magangue', 130000, 9.2439, -74.7531),
  ('Bolívar', 'Mompox', 'mompox', 48000, 9.2408, -74.4264),
  -- Córdoba
  ('Córdoba', 'Lorica', 'lorica', 120000, 9.2333, -75.8167),
  ('Córdoba', 'Sahagún', 'sahagun', 90000, 8.9503, -75.4467),
  ('Córdoba', 'Planeta Rica', 'planeta-rica', 70000, 8.4083, -75.5833),
  -- Sucre
  ('Sucre', 'Corozal', 'corozal', 70000, 9.3225, -75.2958),
  ('Sucre', 'San Marcos', 'san-marcos', 60000, 8.6614, -75.1267),
  -- La Guajira
  ('La Guajira', 'Maicao', 'maicao', 150000, 11.3816, -72.2442),
  ('La Guajira', 'Uribia', 'uribia', 170000, 11.7131, -72.2711),
  -- César
  ('César', 'Aguachica', 'aguachica', 100000, 8.3094, -73.6175),
  ('César', 'Bosconia', 'bosconia', 50000, 9.9726, -73.888),
  -- Norte de Santander
  ('Norte de Santander', 'Ocaña', 'ocana', 100000, 8.2358, -73.3636),
  ('Norte de Santander', 'Pamplona', 'pamplona', 60000, 7.3767, -72.6486),
  -- Santander
  ('Santander', 'Barrancabermeja', 'barrancabermeja', 200000, 7.0644, -73.8542),
  ('Santander', 'Floridablanca', 'floridablanca', 280000, 7.0644, -73.0911),
  ('Santander', 'Girón', 'giron', 180000, 7.0736, -73.1678),
  ('Santander', 'Piedecuesta', 'piedecuesta', 160000, 6.9917, -73.0514),
  ('Santander', 'Socorro', 'socorro', 32000, 6.4697, -73.2667),
  -- Boyacá
  ('Boyacá', 'Tunja', 'tunja', 210000, 5.5344, -73.3678),
  ('Boyacá', 'Duitama', 'duitama', 120000, 5.8272, -73.0328),
  ('Boyacá', 'Sogamoso', 'sogamoso', 120000, 5.7183, -72.9353),
  -- Cundinamarca
  ('Cundinamarca', 'Soacha', 'soacha', 700000, 4.5797, -74.2178),
  ('Cundinamarca', 'Chía', 'chia', 130000, 4.8619, -74.0589),
  ('Cundinamarca', 'Zipaquirá', 'zipaquira', 130000, 5.0225, -74.0058),
  ('Cundinamarca', 'Facatativá', 'facatativa', 140000, 4.8144, -74.3556),
  ('Cundinamarca', 'Mosquera', 'mosquera', 130000, 4.7067, -74.2331),
  ('Cundinamarca', 'Fusagasugá', 'fusagasuga', 140000, 4.3408, -74.3639),
  -- Antioquia
  ('Antioquia', 'Rionegro', 'rionegro', 120000, 6.1544, -75.3758),
  ('Antioquia', 'Apartadó', 'apartado', 180000, 7.8844, -76.6272),
  ('Antioquia', 'Turbo', 'turbo', 170000, 8.0958, -76.7267),
  ('Antioquia', 'Caucasia', 'caucasia', 100000, 7.9897, -75.1972),
  ('Antioquia', 'Itagüí', 'itagui', 280000, 6.1739, -75.5986),
  ('Antioquia', 'Sabaneta', 'sabaneta', 115000, 6.1503, -75.6153),
  -- Valle del Cauca
  ('Valle del Cauca', 'Buenaventura', 'buenaventura', 410000, 3.8826, -77.0311),
  ('Valle del Cauca', 'Palmira', 'palmira', 320000, 3.5394, -76.3028),
  ('Valle del Cauca', 'Tulua', 'tulua', 230000, 4.0836, -76.2006),
  ('Valle del Cauca', 'Cartago', 'cartago', 140000, 4.7467, -75.9131),
  -- Cauca
  ('Cauca', 'Santander de Quilichao', 'santander-de-quilichao', 100000, 3.0072, -76.4833),
  -- Nariño
  ('Nariño', 'Tumaco', 'tumaco', 210000, 1.7997, -78.7897),
  ('Nariño', 'Ipiales', 'ipiales', 120000, 0.8286, -77.6458),
  -- Putumayo
  ('Putumayo', 'Mocoa', 'mocoa', 50000, 1.1497, -76.6475),
  ('Putumayo', 'Puerto Asís', 'puerto-asis', 65000, 0.5092, -76.4978),
  -- Amazonas
  ('Amazonas', 'Leticia', 'leticia', 40000, -4.2153, -69.9406),
  -- Vaupés
  ('Vaupés', 'Mitú', 'mitu', 30000, 1.1986, -70.1731),
  -- Guainía
  ('Guainía', 'Inírida', 'inirida', 22000, 3.8653, -67.9239),
  -- Vichada
  ('Vichada', 'Puerto Carreño', 'puerto-carreno', 18000, 6.1883, -67.485),
  -- Arauca
  ('Arauca', 'Arauca', 'arauca', 100000, 7.0897, -70.7589),
  -- Casanare
  ('Casanare', 'Yopal', 'yopal', 150000, 5.3378, -72.3953),
  ('Casanare', 'Aguazul', 'aguazul', 60000, 5.1736, -72.5508),
  -- Meta
  ('Meta', 'Villavicencio', 'villavicencio', 560000, 4.142, -73.6267),
  ('Meta', 'Acacías', 'acacias', 80000, 3.9884, -73.7661),
  -- Guaviare
  ('Guaviare', 'San José del Guaviare', 'san-jose-del-guaviare', 60000, 2.5647, -72.6381),
  -- Caquetá
  ('Caquetá', 'Florencia', 'florencia', 190000, 1.6144, -75.6061),
  -- Huila
  ('Huila', 'Garzón', 'garzon', 50000, 2.1997, -75.6258),
  ('Huila', 'Pitalito', 'pitalito', 130000, 1.8556, -76.0542),
  -- Tolima
  ('Tolima', 'Espinal', 'espinal', 80000, 4.1511, -74.8886),
  ('Tolima', 'Honda', 'honda', 30000, 5.2028, -74.7369),
  -- Quindío
  ('Quindío', 'Calarcá', 'calarca', 80000, 4.5339, -75.6458),
  -- Risaralda
  ('Risaralda', 'Dosquebradas', 'dosquebradas', 210000, 4.8392, -75.6658),
  ('Risaralda', 'Santa Rosa de Cabal', 'santa-rosa-de-cabal', 80000, 4.8683, -75.6208),
  -- Caldas
  ('Caldas', 'La Dorada', 'la-dorada', 80000, 5.4497, -74.6708),
  -- Chocó
  ('Chocó', 'Tumaco', 'tumaco-choco', 20000, 5.7003, -76.6586),
  -- Magdalena (additional)
  ('Magdalena', 'Plato', 'plato', 60000, 9.7897, -74.7833)
ON CONFLICT (slug) DO NOTHING;

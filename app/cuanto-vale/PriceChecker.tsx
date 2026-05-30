'use client';

import { useState, FormEvent } from 'react';
import Link from 'next/link';

interface PriceResult {
  low: number;
  mid: number;
  high: number;
  currency: string;
  count: number;
  sources: string[];
  tip: string;
  updated: string;
  error?: string;
  fallback?: boolean;
}

const CITIES = [
  { value: 'nacional', label: '🇨🇴 Colombia (nacional)' },
  { value: 'Bogotá', label: 'Bogotá' },
  { value: 'Medellín', label: 'Medellín' },
  { value: 'Cali', label: 'Cali' },
  { value: 'Barranquilla', label: 'Barranquilla' },
  { value: 'Cartagena', label: 'Cartagena' },
  { value: 'Bucaramanga', label: 'Bucaramanga' },
  { value: 'Santa Marta', label: 'Santa Marta' },
  { value: 'Pereira', label: 'Pereira' },
  { value: 'Manizales', label: 'Manizales' },
];

// Colombia flag colours
const C = {
  yellow: '#FCD116',
  yellowBg: '#FFFBEA',
  yellowBorder: '#F5D400',
  yellowText: '#8A6B00',
  blue: '#003893',
  blueBg: '#EEF2FF',
  blueBorder: '#003893',
  blueText: '#003893',
  red: '#CE1126',
  redBg: '#FFF0F1',
  redBorder: '#CE1126',
  redText: '#9B000D',
};

function formatCOP(n: number): string {
  return new Intl.NumberFormat('es-CO', {
    style: 'currency',
    currency: 'COP',
    maximumFractionDigits: 0,
  }).format(n);
}

export default function PriceChecker() {
  const [item, setItem] = useState('');
  const [city, setCity] = useState('nacional');
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<PriceResult | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [lastItem, setLastItem] = useState('');

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    const trimmed = item.trim();
    if (!trimmed) return;

    setLoading(true);
    setResult(null);
    setError(null);
    setLastItem(trimmed);

    try {
      const res = await fetch('/api/price-check', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ item: trimmed, city }),
      });

      const data: PriceResult = await res.json();

      if (data.fallback || data.error) {
        setError(
          data.error ||
            'No se encontraron precios para este artículo. Intenta con otro término.'
        );
      } else if (typeof data.low === 'number') {
        setResult(data);
      } else {
        setError(
          'No se encontraron precios para este artículo. Intenta con un término más específico.'
        );
      }
    } catch {
      setError('Error de conexión. Por favor intenta de nuevo.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div>
      {/* ── Search Form ─────────────────────────────────────────── */}
      <form onSubmit={handleSubmit} className="mb-6">
        <div className="bg-white rounded-2xl border border-gray-200 shadow-sm p-4 sm:p-6">
          <label htmlFor="item-input" className="block text-sm font-semibold text-gray-800 mb-2">
            ¿Qué quieres vender?
          </label>
          <textarea
            id="item-input"
            value={item}
            onChange={(e) => setItem(e.target.value)}
            placeholder='Ej: iPhone 14 128GB negro, bicicleta de montaña Trek, sofá de 3 puestos beige...'
            rows={2}
            className="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 resize-none mb-3 text-gray-900 placeholder:text-gray-600"
            required
          />
          <div className="flex flex-col sm:flex-row gap-3">
            <select
              value={city}
              onChange={(e) => setCity(e.target.value)}
              className="flex-1 border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 bg-white text-gray-800"
              aria-label="Ciudad"
            >
              {CITIES.map((c) => (
                <option key={c.value} value={c.value}>
                  {c.label}
                </option>
              ))}
            </select>
            <button
              type="submit"
              disabled={loading || !item.trim()}
              className="sm:flex-shrink-0 bg-emerald-600 disabled:opacity-50 disabled:cursor-not-allowed text-white font-bold px-6 py-3 rounded-xl hover:bg-emerald-700 active:bg-emerald-800 transition-colors text-sm"
            >
              {loading ? 'Buscando...' : '🔍 Buscar precios'}
            </button>
          </div>
        </div>
      </form>

      {/* ── Loading ─────────────────────────────────────────────── */}
      {loading && (
        <div className="bg-white rounded-2xl border border-gray-200 p-8 text-center">
          <div className="flex items-center justify-center gap-3 mb-2">
            <div className="w-5 h-5 border-2 border-emerald-500 border-t-transparent rounded-full animate-spin flex-shrink-0" />
            <p className="text-gray-700 font-medium text-sm">
              Buscando precios en los marketplaces de Colombia...
            </p>
          </div>
          <p className="text-xs text-gray-600">
            Revisando Mercado Libre, OLX, Facebook Marketplace y más
          </p>
        </div>
      )}

      {/* ── Error ───────────────────────────────────────────────── */}
      {error && !loading && (
        <div className="bg-amber-50 border border-amber-200 rounded-2xl p-5 text-center">
          <p className="text-amber-800 font-semibold text-sm mb-1">
            ⚠️ {error}
          </p>
          <p className="text-amber-600 text-xs">
            Prueba añadiendo marca, modelo o más detalles al artículo.
          </p>
        </div>
      )}

      {/* ── Results ─────────────────────────────────────────────── */}
      {result && !loading && (
        <div className="space-y-4">
          {/* Price Range Card */}
          <div className="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
            {/* Card header */}
            <div className="px-5 py-4 border-b border-gray-100 flex items-center justify-between flex-wrap gap-2">
              <div>
                <h2 className="font-bold text-gray-900 text-base leading-tight">
                  Rango de precios: {lastItem}
                </h2>
                <p className="text-xs text-gray-600 mt-0.5">
                  Actualizado: {result.updated} · Basado en anuncios reales de Colombia
                </p>
              </div>
              {result.count > 0 && (
                <span className="text-xs text-gray-500 bg-gray-100 px-2.5 py-1 rounded-full flex-shrink-0">
                  ~{result.count} anuncios
                </span>
              )}
            </div>

            {/* Price tiers */}
            <div className="p-5 sm:p-6">
              <div className="grid grid-cols-3 gap-2 sm:gap-4 mb-5">

                {/* Low */}
                <div className="text-center">
                  <div
                    className="rounded-xl p-3 sm:p-4 mb-2"
                    style={{
                      backgroundColor: C.yellowBg,
                      border: `2px solid ${C.yellowBorder}`,
                    }}
                  >
                    <p
                      className="text-[10px] font-bold uppercase tracking-wider mb-1.5"
                      style={{ color: C.yellowText }}
                    >
                      Precio bajo
                    </p>
                    <p className="font-black text-xs sm:text-sm text-gray-900 leading-tight break-all">
                      {formatCOP(result.low)}
                    </p>
                  </div>
                  <p className="text-[10px] text-gray-600">20% más baratos</p>
                </div>

                {/* Mid — highlighted */}
                <div className="text-center">
                  <div
                    className="rounded-xl p-3 sm:p-4 mb-2 relative"
                    style={{
                      backgroundColor: C.blueBg,
                      border: `2px solid ${C.blueBorder}`,
                    }}
                  >
                    <p
                      className="text-[10px] font-bold uppercase tracking-wider mb-1.5"
                      style={{ color: C.blueText }}
                    >
                      Precio ideal ⭐
                    </p>
                    <p
                      className="font-black text-sm sm:text-base text-gray-900 leading-tight break-all"
                    >
                      {formatCOP(result.mid)}
                    </p>
                  </div>
                  <p className="text-[10px] text-gray-600">Precio mediano</p>
                </div>

                {/* High */}
                <div className="text-center">
                  <div
                    className="rounded-xl p-3 sm:p-4 mb-2"
                    style={{
                      backgroundColor: C.redBg,
                      border: `2px solid ${C.redBorder}`,
                    }}
                  >
                    <p
                      className="text-[10px] font-bold uppercase tracking-wider mb-1.5"
                      style={{ color: C.redText }}
                    >
                      Precio alto
                    </p>
                    <p className="font-black text-xs sm:text-sm text-gray-900 leading-tight break-all">
                      {formatCOP(result.high)}
                    </p>
                  </div>
                  <p className="text-[10px] text-gray-600">20% más caros</p>
                </div>
              </div>

              {/* Colombia-flag price bar */}
              <div className="h-3 rounded-full overflow-hidden flex" aria-hidden="true">
                <div
                  className="h-full"
                  style={{ width: '30%', backgroundColor: C.yellow }}
                />
                <div
                  className="h-full"
                  style={{ width: '40%', backgroundColor: C.blue }}
                />
                <div
                  className="h-full"
                  style={{ width: '30%', backgroundColor: C.red }}
                />
              </div>
              <div className="flex justify-between text-[10px] text-gray-600 mt-1.5">
                <span>Más barato</span>
                <span>Precio ideal</span>
                <span>Más caro</span>
              </div>
            </div>
          </div>

          {/* Tip card */}
          {result.tip && (
            <div
              className="rounded-2xl p-4 sm:p-5"
              style={{ backgroundColor: '#F0FDF4', border: '1px solid #BBF7D0' }}
            >
              <div className="flex gap-3 items-start">
                <span className="text-xl flex-shrink-0 mt-0.5">💡</span>
                <div>
                  <p className="text-xs font-bold text-emerald-700 uppercase tracking-wider mb-1">
                    Consejo de precio
                  </p>
                  <p className="text-sm text-gray-700 leading-relaxed">
                    {result.tip}
                  </p>
                </div>
              </div>
            </div>
          )}

          {/* Sources */}
          {result.sources && result.sources.length > 0 && (
            <div className="bg-gray-50 rounded-2xl p-4">
              <p className="text-[10px] font-bold text-gray-500 uppercase tracking-wider mb-2">
                Fuentes consultadas
              </p>
              <div className="flex flex-wrap gap-2">
                {result.sources.map((s, i) => (
                  <span
                    key={i}
                    className="text-xs bg-white border border-gray-200 text-gray-600 px-2.5 py-1 rounded-full"
                  >
                    {s}
                  </span>
                ))}
              </div>
            </div>
          )}

          {/* CTA */}
          <div
            className="rounded-2xl p-5 sm:p-6 text-center"
            style={{
              background: 'linear-gradient(135deg, #065f46 0%, #047857 100%)',
            }}
          >
            <p className="text-white font-black text-lg mb-1">
              ¿Listo para vender?
            </p>
            <p className="text-emerald-100 text-sm mb-4 leading-relaxed">
              Publica gratis en LlevaLleva y conecta con compradores en toda Colombia.
            </p>
            <Link
              href="/publicar"
              className="inline-block bg-white text-emerald-700 font-bold px-6 py-2.5 rounded-xl text-sm hover:bg-emerald-50 transition-colors"
            >
              Publicar gratis en LlevaLleva →
            </Link>
          </div>
        </div>
      )}

      {/* Empty state before first search */}
      {!result && !loading && !error && (
        <div className="text-center py-10 text-gray-600">
          <div className="text-4xl mb-3">🇨🇴</div>
          <p className="text-sm">
            Escribe lo que quieres vender arriba y descubre su precio justo.
          </p>
          <p className="text-xs mt-1 text-gray-600">
            Datos de Mercado Libre, OLX, Facebook Marketplace y más
          </p>
        </div>
      )}
    </div>
  );
}

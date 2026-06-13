'use client';

import { useState } from 'react';
import Link from 'next/link';

// Valores oficiales Colombia 2026.
// SMMLV: Decreto 1469 del 29-dic-2025. UVT: Resolución DIAN 000238 del 15-dic-2025.
const SMMLV = 1_750_905;
const AUX_TRANSPORTE = 249_095;
const UVT = 52_374;
const ANIO = 2026;

const COP = new Intl.NumberFormat('es-CO', {
  style: 'currency',
  currency: 'COP',
  maximumFractionDigits: 0,
});

const NUM = new Intl.NumberFormat('es-CO', { maximumFractionDigits: 2 });

type Mode = 'pesos' | 'smmlv' | 'uvt';

const MODES: { id: Mode; label: string; hint: string }[] = [
  { id: 'pesos', label: 'Pesos (COP)', hint: 'Escribe un monto en pesos' },
  { id: 'smmlv', label: 'Salarios mínimos', hint: 'Escribe un número de SMMLV' },
  { id: 'uvt', label: 'UVT', hint: 'Escribe un número de UVT' },
];

function parseInput(raw: string): number {
  // Acepta "1.750.905", "1750905", "2,5" → número.
  const cleaned = raw.replace(/\./g, '').replace(/,/g, '.').replace(/[^0-9.]/g, '');
  const n = parseFloat(cleaned);
  return Number.isFinite(n) ? n : 0;
}

export default function Calculadora() {
  const [mode, setMode] = useState<Mode>('pesos');
  const [value, setValue] = useState('');

  const n = parseInput(value);

  // Convertir todo a pesos primero.
  let pesos = 0;
  if (mode === 'pesos') pesos = n;
  if (mode === 'smmlv') pesos = n * SMMLV;
  if (mode === 'uvt') pesos = n * UVT;

  const enSmmlv = pesos / SMMLV;
  const enUvt = pesos / UVT;

  const active = MODES.find((m) => m.id === mode)!;
  const hasValue = n > 0;

  return (
    <div className="space-y-6">
      {/* Modo */}
      <div>
        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">Quiero convertir desde</p>
        <div className="grid grid-cols-3 gap-2">
          {MODES.map((m) => (
            <button
              key={m.id}
              type="button"
              onClick={() => setMode(m.id)}
              className={`text-sm font-medium px-3 py-2.5 rounded-xl border transition-colors ${
                mode === m.id
                  ? 'border-brand-blue bg-brand-blue text-white'
                  : 'border-gray-200 bg-white text-gray-600 hover:border-brand-blue/40'
              }`}
            >
              {m.label}
            </button>
          ))}
        </div>
      </div>

      {/* Entrada */}
      <div>
        <label htmlFor="calc-input" className="block text-sm font-medium text-ink mb-1.5">
          {active.hint}
        </label>
        <input
          id="calc-input"
          inputMode="decimal"
          autoComplete="off"
          value={value}
          onChange={(e) => setValue(e.target.value)}
          placeholder={mode === 'pesos' ? 'Ej: 3.500.000' : 'Ej: 2'}
          className="w-full text-lg font-semibold px-4 py-3 rounded-xl border border-gray-300 focus:border-brand-blue focus:ring-2 focus:ring-brand-blue/20 outline-none"
        />
      </div>

      {/* Resultados */}
      <div className="grid sm:grid-cols-3 gap-3">
        <div className="bg-brand-blue-50 border border-brand-blue/20 rounded-xl p-4">
          <p className="text-xs text-ink-2 mb-1">En pesos</p>
          <p className="text-lg font-black text-brand-blue break-words">
            {hasValue ? COP.format(Math.round(pesos)) : '—'}
          </p>
        </div>
        <div className="bg-surface border border-line rounded-xl p-4">
          <p className="text-xs text-ink-2 mb-1">En salarios mínimos</p>
          <p className="text-lg font-black text-ink">
            {hasValue ? `${NUM.format(enSmmlv)} SMMLV` : '—'}
          </p>
        </div>
        <div className="bg-surface border border-line rounded-xl p-4">
          <p className="text-xs text-ink-2 mb-1">En UVT</p>
          <p className="text-lg font-black text-ink">
            {hasValue ? `${NUM.format(enUvt)} UVT` : '—'}
          </p>
        </div>
      </div>

      {/* Valores base */}
      <div className="bg-white border border-gray-200 rounded-xl p-4">
        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3">Valores base {ANIO}</p>
        <dl className="grid grid-cols-1 sm:grid-cols-3 gap-3 text-sm">
          <div>
            <dt className="text-ink-2">Salario mínimo (SMMLV)</dt>
            <dd className="font-bold text-ink">{COP.format(SMMLV)}</dd>
          </div>
          <div>
            <dt className="text-ink-2">Auxilio de transporte</dt>
            <dd className="font-bold text-ink">{COP.format(AUX_TRANSPORTE)}</dd>
          </div>
          <div>
            <dt className="text-ink-2">UVT</dt>
            <dd className="font-bold text-ink">{COP.format(UVT)}</dd>
          </div>
        </dl>
        <p className="text-xs text-ink-2 mt-3 leading-relaxed">
          SMMLV según Decreto 1469 de 2025 · UVT según Resolución DIAN 000238 de 2025. Ingreso mínimo con auxilio:{' '}
          <strong>{COP.format(SMMLV + AUX_TRANSPORTE)}</strong>.
        </p>
      </div>

      {/* CTA cruzado */}
      <Link
        href="/cuanto-vale"
        className="flex items-center gap-3 bg-gradient-to-br from-brand-blue-50 to-brand-yellow/10 border border-brand-blue/20 rounded-xl p-4 hover:border-brand-blue/40 transition-colors group"
      >
        <span className="text-2xl" aria-hidden="true">💰</span>
        <span className="flex-1">
          <span className="block text-sm font-semibold text-ink">¿Vas a vender algo?</span>
          <span className="block text-xs text-ink-2">Usa ¿Cuánto vale? para ver el precio real de productos similares en Colombia.</span>
        </span>
        <span className="text-brand-blue group-hover:translate-x-0.5 transition-transform" aria-hidden="true">→</span>
      </Link>

      <p className="text-xs text-ink-2 text-center leading-relaxed">
        Valores de referencia. Verifica los montos oficiales en{' '}
        <a href="https://www.dian.gov.co" target="_blank" rel="noopener noreferrer" className="text-brand-blue hover:underline">DIAN</a>{' '}y el{' '}
        <a href="https://www.banrep.gov.co" target="_blank" rel="noopener noreferrer" className="text-brand-blue hover:underline">Banco de la República</a>.
      </p>
    </div>
  );
}

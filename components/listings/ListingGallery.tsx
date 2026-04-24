'use client';

import { useState } from 'react';
import { ListingImage } from '@/types';

interface Props {
  images: ListingImage[];
  title: string;
}

export default function ListingGallery({ images, title }: Props) {
  const [activeIdx, setActiveIdx] = useState(0);
  const [lightbox, setLightbox] = useState(false);

  if (!images || images.length === 0) {
    return (
      <div className="aspect-[4/3] bg-gray-100 flex items-center justify-center text-gray-300 rounded-2xl">
        <svg className="w-16 h-16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1}
            d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
        </svg>
      </div>
    );
  }

  const sorted = [...images].sort((a, b) => (a.order ?? 0) - (b.order ?? 0));
  const hasPrev = activeIdx > 0;
  const hasNext = activeIdx < sorted.length - 1;

  return (
    <>
      {/* Main image */}
      <div className="relative aspect-[4/3] bg-gray-100 rounded-2xl overflow-hidden group cursor-zoom-in"
        onClick={() => setLightbox(true)}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src={sorted[activeIdx].url}
          alt={sorted[activeIdx].alt ?? title}
          className="w-full h-full object-cover transition-opacity duration-200"
        />

        {/* Nav arrows */}
        {sorted.length > 1 && (
          <>
            {hasPrev && (
              <button
                type="button"
                onClick={(e) => { e.stopPropagation(); setActiveIdx(activeIdx - 1); }}
                className="absolute left-3 top-1/2 -translate-y-1/2 bg-black/50 hover:bg-black/70 text-white rounded-full w-9 h-9 flex items-center justify-center transition-colors opacity-0 group-hover:opacity-100"
                aria-label="Imagen anterior"
              >
                ‹
              </button>
            )}
            {hasNext && (
              <button
                type="button"
                onClick={(e) => { e.stopPropagation(); setActiveIdx(activeIdx + 1); }}
                className="absolute right-3 top-1/2 -translate-y-1/2 bg-black/50 hover:bg-black/70 text-white rounded-full w-9 h-9 flex items-center justify-center transition-colors opacity-0 group-hover:opacity-100"
                aria-label="Imagen siguiente"
              >
                ›
              </button>
            )}
          </>
        )}

        {/* Counter badge */}
        {sorted.length > 1 && (
          <span className="absolute bottom-3 right-3 bg-black/50 text-white text-xs px-2 py-1 rounded-full">
            {activeIdx + 1} / {sorted.length}
          </span>
        )}
      </div>

      {/* Thumbnail strip */}
      {sorted.length > 1 && (
        <div className="flex gap-2 mt-2 overflow-x-auto pb-1">
          {sorted.map((img, i) => (
            <button
              key={i}
              type="button"
              onClick={() => setActiveIdx(i)}
              className={`flex-shrink-0 w-16 h-16 rounded-xl overflow-hidden border-2 transition-colors ${
                i === activeIdx ? 'border-emerald-500' : 'border-gray-200 hover:border-emerald-300'
              }`}
            >
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={img.url}
                alt={img.alt ?? `Imagen ${i + 1}`}
                className="w-full h-full object-cover"
              />
            </button>
          ))}
        </div>
      )}

      {/* Lightbox */}
      {lightbox && (
        <div
          className="fixed inset-0 bg-black/90 z-50 flex items-center justify-center p-4"
          onClick={() => setLightbox(false)}
        >
          <button
            type="button"
            onClick={() => setLightbox(false)}
            className="absolute top-4 right-4 text-white/80 hover:text-white text-3xl font-light"
            aria-label="Cerrar"
          >
            ×
          </button>

          <div className="relative max-w-4xl w-full" onClick={(e) => e.stopPropagation()}>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={sorted[activeIdx].url}
              alt={sorted[activeIdx].alt ?? title}
              className="w-full max-h-[85vh] object-contain rounded-xl"
            />

            {sorted.length > 1 && (
              <div className="flex justify-center gap-3 mt-4">
                <button
                  type="button"
                  disabled={!hasPrev}
                  onClick={() => setActiveIdx(activeIdx - 1)}
                  className="bg-white/20 hover:bg-white/30 disabled:opacity-30 text-white px-5 py-2 rounded-full text-lg transition-colors"
                >
                  ‹
                </button>
                <span className="text-white/70 text-sm self-center">
                  {activeIdx + 1} / {sorted.length}
                </span>
                <button
                  type="button"
                  disabled={!hasNext}
                  onClick={() => setActiveIdx(activeIdx + 1)}
                  className="bg-white/20 hover:bg-white/30 disabled:opacity-30 text-white px-5 py-2 rounded-full text-lg transition-colors"
                >
                  ›
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </>
  );
}

'use client';

import { useCallback, useRef, useState } from 'react';

interface UploadedImage {
  file: File;
  previewUrl: string;
  uploading?: boolean;
  error?: string;
}

interface Props {
  images: UploadedImage[];
  onChange: (images: UploadedImage[]) => void;
  maxImages?: number;
  maxSizeMB?: number;
}

const ACCEPTED_TYPES = ['image/jpeg', 'image/png', 'image/webp'];
const MAX_IMAGES = 5;
const MAX_SIZE_MB = 5;

export default function ImageUploader({
  images,
  onChange,
  maxImages = MAX_IMAGES,
  maxSizeMB = MAX_SIZE_MB,
}: Props) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [dragOver, setDragOver] = useState(false);

  const addFiles = useCallback(
    (files: FileList | null) => {
      if (!files) return;
      const remaining = maxImages - images.length;
      if (remaining <= 0) return;

      const newImages: UploadedImage[] = [];
      const errors: string[] = [];

      Array.from(files)
        .slice(0, remaining)
        .forEach((file) => {
          if (!ACCEPTED_TYPES.includes(file.type)) {
            errors.push(`${file.name}: formato no soportado (usa JPG, PNG o WebP)`);
            return;
          }
          if (file.size > maxSizeMB * 1024 * 1024) {
            errors.push(`${file.name}: demasiado grande (máx ${maxSizeMB} MB)`);
            return;
          }
          newImages.push({
            file,
            previewUrl: URL.createObjectURL(file),
          });
        });

      if (errors.length > 0) {
        alert(errors.join('\n'));
      }

      if (newImages.length > 0) {
        onChange([...images, ...newImages]);
      }
    },
    [images, maxImages, maxSizeMB, onChange]
  );

  const removeImage = useCallback(
    (index: number) => {
      const updated = images.filter((_, i) => i !== index);
      // Revoke the object URL to free memory
      URL.revokeObjectURL(images[index].previewUrl);
      onChange(updated);
    },
    [images, onChange]
  );

  const moveImage = useCallback(
    (from: number, to: number) => {
      const updated = [...images];
      const [moved] = updated.splice(from, 1);
      updated.splice(to, 0, moved);
      onChange(updated);
    },
    [images, onChange]
  );

  const handleDrop = useCallback(
    (e: React.DragEvent) => {
      e.preventDefault();
      setDragOver(false);
      addFiles(e.dataTransfer.files);
    },
    [addFiles]
  );

  const canAddMore = images.length < maxImages;

  return (
    <div className="space-y-3">
      {/* Preview grid */}
      {images.length > 0 && (
        <div className="grid grid-cols-3 sm:grid-cols-5 gap-2">
          {images.map((img, i) => (
            <div key={img.previewUrl} className="relative group aspect-square">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={img.previewUrl}
                alt={`Imagen ${i + 1}`}
                className="w-full h-full object-cover rounded-xl border border-gray-200"
              />
              {/* First image badge */}
              {i === 0 && (
                <span className="absolute bottom-1 left-1 bg-black/60 text-white text-[9px] px-1.5 py-0.5 rounded-full">
                  Principal
                </span>
              )}
              {/* Error overlay */}
              {img.error && (
                <div className="absolute inset-0 bg-red-500/80 rounded-xl flex items-center justify-center">
                  <span className="text-white text-xs text-center px-1">Error</span>
                </div>
              )}
              {/* Controls overlay */}
              <div className="absolute inset-0 bg-black/0 group-hover:bg-black/30 rounded-xl transition-colors flex items-start justify-end p-1 gap-1 opacity-0 group-hover:opacity-100">
                {i > 0 && (
                  <button
                    type="button"
                    onClick={() => moveImage(i, i - 1)}
                    className="bg-white/90 text-gray-700 rounded-full w-6 h-6 flex items-center justify-center text-xs hover:bg-white"
                    title="Mover a la izquierda"
                  >
                    ←
                  </button>
                )}
                <button
                  type="button"
                  onClick={() => removeImage(i)}
                  className="bg-white/90 text-red-600 rounded-full w-6 h-6 flex items-center justify-center text-xs hover:bg-white font-bold"
                  title="Eliminar imagen"
                >
                  ×
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Drop zone */}
      {canAddMore && (
        <div
          onDrop={handleDrop}
          onDragOver={(e) => { e.preventDefault(); setDragOver(true); }}
          onDragLeave={() => setDragOver(false)}
          onClick={() => inputRef.current?.click()}
          className={`
            border-2 border-dashed rounded-xl p-6 text-center cursor-pointer transition-colors
            ${dragOver
              ? 'border-emerald-400 bg-emerald-50'
              : 'border-gray-300 bg-gray-50 hover:border-emerald-400 hover:bg-emerald-50'
            }
          `}
        >
          <div className="text-3xl mb-2">📷</div>
          <p className="text-sm font-medium text-gray-700">
            Toca para agregar fotos
          </p>
          <p className="text-xs text-gray-400 mt-1">
            {images.length}/{maxImages} imágenes · JPG, PNG o WebP · máx {maxSizeMB} MB c/u
          </p>
          <input
            ref={inputRef}
            type="file"
            accept="image/*"
            multiple
            capture={undefined}
            className="hidden"
            onChange={(e) => addFiles(e.target.files)}
          />
        </div>
      )}

      {!canAddMore && (
        <p className="text-xs text-gray-400 text-center">
          Límite de {maxImages} imágenes alcanzado.{' '}
          <button
            type="button"
            onClick={() => removeImage(images.length - 1)}
            className="text-emerald-600 hover:underline"
          >
            Eliminar la última
          </button>
        </p>
      )}

      <p className="text-xs text-gray-400">
        💡 La primera imagen será la foto principal. Pasa el cursor sobre una imagen para reordenar o eliminar.
      </p>
    </div>
  );
}

export type { UploadedImage };

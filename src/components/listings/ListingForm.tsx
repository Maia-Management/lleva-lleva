"use client";

import { useState, useRef } from "react";
import Image from "next/image";
import { useRouter } from "next/navigation";
import { ImagePlus, X, Loader2 } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { CATEGORIES, CITIES, formatCityName } from "@/lib/constants";
import { useLocale } from "@/lib/locale-context";
import { getCategoryLabel } from "@/lib/i18n";
import Button from "@/components/ui/Button";
import Input from "@/components/ui/Input";
import type { Listing, Category } from "@/lib/types";

interface ListingFormProps {
  listing?: Listing;
  userId: string;
}

export default function ListingForm({ listing, userId }: ListingFormProps) {
  const router = useRouter();
  const supabase = createClient();
  const fileInputRef = useRef<HTMLInputElement>(null);
  const isEditing = !!listing;
  const { t, locale } = useLocale();

  const [title, setTitle] = useState(listing?.title ?? "");
  const [description, setDescription] = useState(listing?.description ?? "");
  const [price, setPrice] = useState(listing?.price?.toString() ?? "");
  const [category, setCategory] = useState<Category>(
    listing?.category ?? "buy_sell"
  );
  const [city, setCity] = useState(listing?.city ?? "Santa Marta");
  const [whatsapp, setWhatsapp] = useState(listing?.whatsapp_number ?? "");
  const [images, setImages] = useState<string[]>(listing?.images ?? []);
  const [uploading, setUploading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0) return;
    if (images.length + files.length > 8) {
      setError(t("form.maxImages"));
      return;
    }

    setUploading(true);
    setError("");

    const newImages: string[] = [];
    for (const file of Array.from(files)) {
      if (file.size > 5 * 1024 * 1024) {
        setError(t("form.maxSize"));
        continue;
      }

      const ext = file.name.split(".").pop();
      const path = `${userId}/${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`;

      const { error: uploadError } = await supabase.storage
        .from("listing-images")
        .upload(path, file);

      if (uploadError) {
        setError(`${t("form.uploadError")}: ${uploadError.message}`);
        continue;
      }

      const {
        data: { publicUrl },
      } = supabase.storage.from("listing-images").getPublicUrl(path);

      newImages.push(publicUrl);
    }

    setImages((prev) => [...prev, ...newImages]);
    setUploading(false);
    if (fileInputRef.current) fileInputRef.current.value = "";
  };

  const removeImage = (index: number) => {
    setImages((prev) => prev.filter((_, i) => i !== index));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim() || !description.trim() || !whatsapp.trim()) {
      setError(t("form.required"));
      return;
    }

    setSubmitting(true);
    setError("");

    const listingData = {
      user_id: userId,
      title: title.trim(),
      description: description.trim(),
      price: price ? parseFloat(price) : 0,
      category,
      city,
      whatsapp_number: whatsapp.replace(/\D/g, ""),
      images,
    };

    if (isEditing) {
      const { error: updateError } = await supabase
        .from("listings")
        .update(listingData)
        .eq("id", listing.id);

      if (updateError) {
        setError(updateError.message);
        setSubmitting(false);
        return;
      }
      router.push(`/listings/${listing.id}`);
    } else {
      const { data, error: insertError } = await supabase
        .from("listings")
        .insert(listingData)
        .select()
        .single();

      if (insertError) {
        setError(insertError.message);
        setSubmitting(false);
        return;
      }
      router.push(`/listings/${data.id}`);
    }

    router.refresh();
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-lg p-3">
          {error}
        </div>
      )}

      {/* Images */}
      <div>
        <label className="block text-sm font-medium text-navy-700 mb-2">
          {t("form.photos")}
        </label>
        <div className="flex flex-wrap gap-3">
          {images.map((url, i) => (
            <div
              key={i}
              className="relative w-24 h-24 rounded-lg overflow-hidden border border-navy-200"
            >
              <Image
                src={url}
                alt={`Foto ${i + 1}`}
                fill
                sizes="96px"
                className="object-cover"
              />
              <button
                type="button"
                aria-label={`Eliminar foto ${i + 1}`}
                onClick={() => removeImage(i)}
                className="absolute top-1 right-1 bg-red-500 text-white rounded-full p-0.5"
              >
                <X className="w-3 h-3" />
              </button>
            </div>
          ))}
          {images.length < 8 && (
            <button
              type="button"
              aria-label={t("form.photos")}
              onClick={() => fileInputRef.current?.click()}
              disabled={uploading}
              className="w-24 h-24 rounded-lg border-2 border-dashed border-navy-200 hover:border-amber-400 flex items-center justify-center transition-colors"
            >
              {uploading ? (
                <Loader2 className="w-6 h-6 text-navy-400 animate-spin" />
              ) : (
                <ImagePlus className="w-6 h-6 text-navy-400" />
              )}
            </button>
          )}
        </div>
        <input
          ref={fileInputRef}
          type="file"
          accept="image/*"
          multiple
          onChange={handleImageUpload}
          aria-label={t("form.photos")}
          className="hidden"
        />
      </div>

      {/* Title */}
      <Input
        id="listing-title"
        label={`${t("form.title")} *`}
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        placeholder={t("form.titlePlaceholder")}
        maxLength={100}
        required
      />

      {/* Description */}
      <div>
        <label
          htmlFor="listing-description"
          className="block text-sm font-medium text-navy-700 mb-1"
        >
          {t("form.description")} *
        </label>
        <textarea
          id="listing-description"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          placeholder={t("form.descPlaceholder")}
          rows={4}
          maxLength={2000}
          required
          className="w-full rounded-lg border border-navy-200 bg-white px-3 py-2 text-sm text-navy-800 placeholder:text-navy-400 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20 transition-colors resize-none"
        />
      </div>

      {/* Price + Category */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <Input
          id="listing-price"
          label={t("form.price")}
          type="number"
          value={price}
          onChange={(e) => setPrice(e.target.value)}
          placeholder={t("form.priceFree")}
          min="0"
        />
        <div>
          <label
            htmlFor="listing-category"
            className="block text-sm font-medium text-navy-700 mb-1"
          >
            {t("form.category")} *
          </label>
          <select
            id="listing-category"
            value={category}
            onChange={(e) => setCategory(e.target.value as Category)}
            className="w-full rounded-lg border border-navy-200 bg-white px-3 py-2 text-sm text-navy-700 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
          >
            {CATEGORIES.map((cat) => (
              <option key={cat.value} value={cat.value}>
                {getCategoryLabel(cat.value, locale)}
              </option>
            ))}
          </select>
        </div>
      </div>

      {/* City + WhatsApp */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label
            htmlFor="listing-city"
            className="block text-sm font-medium text-navy-700 mb-1"
          >
            {t("form.city")} *
          </label>
          <select
            id="listing-city"
            value={city}
            onChange={(e) => setCity(e.target.value)}
            className="w-full rounded-lg border border-navy-200 bg-white px-3 py-2 text-sm text-navy-700 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
          >
            {CITIES.map((c) => (
              <option key={c} value={c}>
                {formatCityName(c)}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label
            htmlFor="listing-whatsapp"
            className="block text-sm font-medium text-navy-700 mb-1"
          >
            {t("form.whatsapp")} *
          </label>
          <div className="flex">
            <span className="inline-flex items-center px-3 rounded-l-lg border border-r-0 border-navy-200 bg-navy-50 text-sm text-navy-500">
              +57
            </span>
            <input
              id="listing-whatsapp"
              type="tel"
              value={whatsapp}
              onChange={(e) => setWhatsapp(e.target.value.replace(/\D/g, ""))}
              placeholder="300 123 4567"
              maxLength={10}
              required
              className="flex-1 rounded-r-lg border border-navy-200 px-3 py-2 text-sm text-navy-800 placeholder:text-navy-400 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
            />
          </div>
        </div>
      </div>

      <Button type="submit" loading={submitting} className="w-full" size="lg">
        {isEditing ? t("form.submitEdit") : t("form.submit")}
      </Button>
    </form>
  );
}

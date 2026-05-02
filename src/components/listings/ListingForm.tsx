"use client";

import { useState, useRef } from "react";
import Image from "next/image";
import { useRouter } from "next/navigation";
import { ImagePlus, X, Loader2 } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { useLocale } from "@/lib/locale-context";
import Button from "@/components/ui/Button";
import Input from "@/components/ui/Input";
import type {
  CategoryOption,
  Listing,
  LocationOption,
  PriceType,
} from "@/lib/types";

interface ListingFormProps {
  listing?: Listing;
  userId: string;
  categories: CategoryOption[];
  locations: LocationOption[];
}

function createSlug(title: string) {
  const base = title
    .trim()
    .toLocaleLowerCase("es-CO")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 70);

  return `${base || "anuncio"}-${Date.now().toString(36)}`;
}

function formatCategoryOption(option: CategoryOption, locale: string) {
  const label = locale === "en" ? (option.name_en ?? option.name_es) : option.name_es;
  return option.parent_id ? `- ${label}` : label;
}

export default function ListingForm({
  listing,
  userId,
  categories,
  locations,
}: ListingFormProps) {
  const router = useRouter();
  const supabase = createClient();
  const fileInputRef = useRef<HTMLInputElement>(null);
  const isEditing = !!listing;
  const { t, locale } = useLocale();
  const defaultCategoryId =
    listing?.category_id ??
    categories.find((cat) => cat.slug === listing?.category)?.id ??
    categories.find((cat) => cat.slug === "servicios")?.id ??
    categories[0]?.id ??
    "";
  const defaultLocationId =
    listing?.location_id ??
    locations.find((location) => location.city === listing?.city)?.id ??
    locations.find((location) => location.slug === "santa-marta")?.id ??
    locations[0]?.id ??
    "";

  const [title, setTitle] = useState(listing?.title ?? "");
  const [description, setDescription] = useState(listing?.description ?? "");
  const [price, setPrice] = useState(listing?.price?.toString() ?? "");
  const [priceType, setPriceType] = useState<PriceType>(
    listing?.price_type ?? "contact",
  );
  const [categoryId, setCategoryId] = useState(defaultCategoryId);
  const [locationId, setLocationId] = useState(defaultLocationId);
  const [whatsapp, setWhatsapp] = useState(listing?.whatsapp_number ?? "");
  const [images, setImages] = useState<string[]>(listing?.images ?? []);
  const [uploading, setUploading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");
  const selectedLocation = locations.find((location) => location.id === locationId);

  const priceTypeOptions: Array<{ value: PriceType; label: string }> = [
    {
      value: "contact",
      label: locale === "en" ? "Contact for price" : "Consultar precio",
    },
    {
      value: "fixed",
      label: locale === "en" ? "Fixed price" : "Precio fijo",
    },
    {
      value: "negotiable",
      label: locale === "en" ? "Negotiable" : "Negociable",
    },
    {
      value: "free",
      label: locale === "en" ? "Free" : "Gratis",
    },
  ];

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
    if (
      !title.trim() ||
      !description.trim() ||
      !categoryId ||
      !locationId ||
      !whatsapp.trim()
    ) {
      setError(t("form.required"));
      return;
    }

    setSubmitting(true);
    setError("");
    const parsedPrice = price.trim() ? Number.parseFloat(price) : null;
    const cleanPrice =
      parsedPrice !== null && Number.isFinite(parsedPrice) ? parsedPrice : null;
    const imageRecords = images.map((url, index) => ({
      url,
      alt: `${title.trim()} foto ${index + 1}`,
      order: index,
    }));
    const listingData = {
      seller_id: userId,
      category_id: categoryId,
      location_id: locationId,
      is_nationwide: !!selectedLocation?.is_nationwide,
      title: title.trim(),
      description: description.trim(),
      price: priceType === "free" ? 0 : cleanPrice,
      price_type: priceType,
      currency: "COP",
      images: imageRecords,
      status: "active",
      published_at: listing?.published_at ?? new Date().toISOString(),
    };

    if (isEditing) {
      const { error: updateError } = await supabase
        .from("listings")
        .update(listingData)
        .eq("id", listing.id)
        .eq("seller_id", userId);

      if (updateError) {
        setError(updateError.message);
        setSubmitting(false);
        return;
      }
      router.push(`/listings/${listing.slug ?? listing.id}`);
    } else {
      const { data, error: insertError } = await supabase
        .from("listings")
        .insert({ ...listingData, slug: createSlug(title) })
        .select("id, slug")
        .single();

      if (insertError) {
        setError(insertError.message);
        setSubmitting(false);
        return;
      }
      router.push(`/listings/${data.slug ?? data.id}`);
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

      <Input
        id="listing-title"
        label={`${t("form.title")} *`}
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        placeholder={t("form.titlePlaceholder")}
        maxLength={100}
        required
      />

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
            htmlFor="listing-price-type"
            className="block text-sm font-medium text-navy-700 mb-1"
          >
            {locale === "en" ? "Price type" : "Tipo de precio"} *
          </label>
          <select
            id="listing-price-type"
            value={priceType}
            onChange={(e) => setPriceType(e.target.value as PriceType)}
            className="w-full rounded-lg border border-navy-200 bg-white px-3 py-2 text-sm text-navy-700 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
          >
            {priceTypeOptions.map((option) => (
              <option key={option.value} value={option.value}>
                {option.label}
              </option>
            ))}
          </select>
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label
            htmlFor="listing-category"
            className="block text-sm font-medium text-navy-700 mb-1"
          >
            {t("form.category")} *
          </label>
          <select
            id="listing-category"
            value={categoryId}
            onChange={(e) => setCategoryId(e.target.value)}
            className="w-full rounded-lg border border-navy-200 bg-white px-3 py-2 text-sm text-navy-700 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
          >
            {categories.map((cat) => (
              <option key={cat.id} value={cat.id}>
                {formatCategoryOption(cat, locale)}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label
            htmlFor="listing-city"
            className="block text-sm font-medium text-navy-700 mb-1"
          >
            {t("form.city")} *
          </label>
          <select
            id="listing-city"
            value={locationId}
            onChange={(e) => setLocationId(e.target.value)}
            className="w-full rounded-lg border border-navy-200 bg-white px-3 py-2 text-sm text-navy-700 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
          >
            {locations.map((location) => (
              <option key={location.id} value={location.id}>
                {location.is_nationwide
                  ? location.city
                  : `${location.city}, ${location.department}`}
              </option>
            ))}
          </select>
        </div>
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

      <Button type="submit" loading={submitting} className="w-full" size="lg">
        {isEditing ? t("form.submitEdit") : t("form.submit")}
      </Button>
    </form>
  );
}

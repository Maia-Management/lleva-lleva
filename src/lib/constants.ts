import {
  Briefcase,
  Car,
  Dumbbell,
  Factory,
  GraduationCap,
  Home,
  Hotel,
  Landmark,
  Laptop,
  PawPrint,
  Ship,
  Shirt,
  ShoppingBag,
  Sprout,
  Users,
  Wrench,
  type LucideIcon,
} from "lucide-react";
import type { Category } from "./types";

export interface CategoryInfo {
  value: Category;
  label: string;
  labelEs: string;
  icon: LucideIcon;
  color: string;
}

export const CATEGORIES: CategoryInfo[] = [
  {
    value: "vehiculos",
    label: "Vehicles",
    labelEs: "Vehículos",
    icon: Car,
    color: "bg-red-100 text-red-700",
  },
  {
    value: "inmuebles",
    label: "Real estate",
    labelEs: "Inmuebles",
    icon: Home,
    color: "bg-emerald-100 text-emerald-700",
  },
  {
    value: "tecnologia",
    label: "Technology",
    labelEs: "Tecnología",
    icon: Laptop,
    color: "bg-blue-100 text-blue-700",
  },
  {
    value: "hogar-y-jardin",
    label: "Home & garden",
    labelEs: "Hogar y Jardín",
    icon: ShoppingBag,
    color: "bg-amber-100 text-amber-700",
  },
  {
    value: "servicios",
    label: "Services",
    labelEs: "Servicios",
    icon: Wrench,
    color: "bg-purple-100 text-purple-700",
  },
  {
    value: "empleo",
    label: "Jobs",
    labelEs: "Empleo",
    icon: Briefcase,
    color: "bg-sky-100 text-sky-700",
  },
  {
    value: "nautico-y-pesca",
    label: "Marine & fishing",
    labelEs: "Náutico y Pesca",
    icon: Ship,
    color: "bg-cyan-100 text-cyan-700",
  },
  {
    value: "moda-y-belleza",
    label: "Fashion & beauty",
    labelEs: "Moda y Belleza",
    icon: Shirt,
    color: "bg-pink-100 text-pink-700",
  },
  {
    value: "turismo-y-hospedaje",
    label: "Tourism & stays",
    labelEs: "Turismo y Hospedaje",
    icon: Hotel,
    color: "bg-orange-100 text-orange-700",
  },
  {
    value: "educacion-y-formacion",
    label: "Education",
    labelEs: "Educación y Formación",
    icon: GraduationCap,
    color: "bg-indigo-100 text-indigo-700",
  },
  {
    value: "mascotas-y-animales",
    label: "Pets & animals",
    labelEs: "Mascotas y Animales",
    icon: PawPrint,
    color: "bg-lime-100 text-lime-700",
  },
  {
    value: "deportes-y-fitness",
    label: "Sports & fitness",
    labelEs: "Deportes y Fitness",
    icon: Dumbbell,
    color: "bg-teal-100 text-teal-700",
  },
  {
    value: "negocios-e-industria",
    label: "Business & industry",
    labelEs: "Negocios e Industria",
    icon: Factory,
    color: "bg-stone-100 text-stone-700",
  },
  {
    value: "agro-y-campo",
    label: "Agriculture",
    labelEs: "Agro y Campo",
    icon: Sprout,
    color: "bg-green-100 text-green-700",
  },
  {
    value: "comunidad",
    label: "Community",
    labelEs: "Comunidad",
    icon: Users,
    color: "bg-teal-100 text-teal-700",
  },
  {
    value: "informacion-publica",
    label: "Public information",
    labelEs: "Información Pública",
    icon: Landmark,
    color: "bg-slate-100 text-slate-700",
  },
];

export const CITIES = [
  "Santa Marta",
  "Todo Colombia",
  "Barranquilla",
  "Cartagena",
  "Bogota",
  "Medellin",
  "Cali",
  "Bucaramanga",
  "Pereira",
];

const CITY_LABELS: Record<string, string> = {
  Bogota: "Bogotá",
  Medellin: "Medellín",
  "Todo Colombia": "Todo Colombia",
};

export function formatCityName(city: string): string {
  return CITY_LABELS[city] ?? city;
}

export const REPORT_REASONS = [
  { value: "scam", label: "Estafa / Scam" },
  { value: "inappropriate", label: "Contenido inapropiado" },
  { value: "spam", label: "Spam" },
  { value: "other", label: "Otro" },
] as const;

export function getCategoryInfo(category: string): CategoryInfo {
  return (
    CATEGORIES.find((c) => c.value === category) ??
    CATEGORIES.find((c) => c.value === "comunidad") ??
    CATEGORIES[0]
  );
}

export function formatPrice(price: number | null, priceType?: string): string {
  if (price === null || priceType === "contact") return "Consultar precio";
  if (price === 0 || priceType === "free") return "Gratis";
  return new Intl.NumberFormat("es-CO", {
    style: "currency",
    currency: "COP",
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(price);
}

export function timeAgo(dateString: string): string {
  const now = new Date();
  const date = new Date(dateString);
  const seconds = Math.floor((now.getTime() - date.getTime()) / 1000);

  if (seconds < 60) return "ahora";
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `hace ${minutes}m`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `hace ${hours}h`;
  const days = Math.floor(hours / 24);
  if (days < 30) return `hace ${days}d`;
  const months = Math.floor(days / 30);
  return `hace ${months} mes${months > 1 ? "es" : ""}`;
}

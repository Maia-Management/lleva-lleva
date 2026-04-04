import {
  ShoppingBag,
  Briefcase,
  Home,
  Wrench,
  Car,
  Calendar,
  Users,
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
    value: "buy_sell",
    label: "Buy & Sell",
    labelEs: "Compra y Venta",
    icon: ShoppingBag,
    color: "bg-amber-100 text-amber-700",
  },
  {
    value: "jobs",
    label: "Jobs",
    labelEs: "Empleos",
    icon: Briefcase,
    color: "bg-blue-100 text-blue-700",
  },
  {
    value: "housing",
    label: "Housing",
    labelEs: "Vivienda",
    icon: Home,
    color: "bg-emerald-100 text-emerald-700",
  },
  {
    value: "services",
    label: "Services",
    labelEs: "Servicios",
    icon: Wrench,
    color: "bg-purple-100 text-purple-700",
  },
  {
    value: "vehicles",
    label: "Vehicles",
    labelEs: "Vehiculos",
    icon: Car,
    color: "bg-red-100 text-red-700",
  },
  {
    value: "events",
    label: "Events",
    labelEs: "Eventos",
    icon: Calendar,
    color: "bg-pink-100 text-pink-700",
  },
  {
    value: "community",
    label: "Community",
    labelEs: "Comunidad",
    icon: Users,
    color: "bg-teal-100 text-teal-700",
  },
];

export const CITIES = [
  "Santa Marta",
  "Barranquilla",
  "Cartagena",
  "Bogota",
  "Medellin",
  "Cali",
  "Bucaramanga",
  "Pereira",
];

export const REPORT_REASONS = [
  { value: "scam", label: "Estafa / Scam" },
  { value: "inappropriate", label: "Contenido inapropiado" },
  { value: "spam", label: "Spam" },
  { value: "other", label: "Otro" },
] as const;

export function getCategoryInfo(category: Category): CategoryInfo {
  return CATEGORIES.find((c) => c.value === category) ?? CATEGORIES[0];
}

export function formatPrice(price: number | null): string {
  if (price === null || price === 0) return "Gratis";
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

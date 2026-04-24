export function formatCOP(amount: number | null | undefined): string {
  if (amount == null) return 'Consultar precio';
  return new Intl.NumberFormat('es-CO', {
    style: 'currency',
    currency: 'COP',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount);
}

export function slugify(text: string): string {
  return text
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9\s-]/g, '')
    .trim()
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-');
}

export function generateListingSlug(title: string, id: string): string {
  return `${slugify(title)}-${id.slice(0, 8)}`;
}

export function buildWhatsAppLink(phone: string, message: string): string {
  const cleaned = phone.replace(/\D/g, '');
  const number = cleaned.startsWith('57') ? cleaned : `57${cleaned}`;
  return `https://wa.me/${number}?text=${encodeURIComponent(message)}`;
}

export function buildWhatsAppMessage(
  listingTitle: string,
  listingId: string,
  listingSlug: string
): string {
  return `Hola! Vi tu anuncio '${listingTitle}' en LlevaLleva y estoy interesado. Ref: LL-${listingId.slice(0, 8).toUpperCase()}. https://llevalleva.co/listing/${listingSlug}`;
}

export function timeAgo(dateString: string): string {
  const date = new Date(dateString);
  const now = new Date();
  const diffMs = now.getTime() - date.getTime();
  const diffMins = Math.floor(diffMs / 60000);
  const diffHours = Math.floor(diffMins / 60);
  const diffDays = Math.floor(diffHours / 24);

  if (diffMins < 1) return 'Hace un momento';
  if (diffMins < 60) return `Hace ${diffMins} min`;
  if (diffHours < 24) return `Hace ${diffHours} h`;
  if (diffDays < 7) return `Hace ${diffDays} días`;
  return date.toLocaleDateString('es-CO', { day: 'numeric', month: 'short', year: 'numeric' });
}

export const CONDITION_LABELS: Record<string, string> = {
  new: 'Nuevo',
  like_new: 'Como nuevo',
  good: 'Buen estado',
  fair: 'Estado regular',
  for_parts: 'Para repuestos',
};

export const PRICE_TYPE_LABELS: Record<string, string> = {
  fixed: 'Precio fijo',
  negotiable: 'Negociable',
  free: 'Gratis',
  contact: 'A convenir',
};

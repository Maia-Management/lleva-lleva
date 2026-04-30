export type Locale = "es" | "en";

const translations = {
  // Navbar
  "nav.explore": { es: "Explorar", en: "Explore" },
  "nav.favorites": { es: "Favoritos", en: "Favorites" },
  "nav.publish": { es: "Publicar", en: "Post" },
  "nav.myProfile": { es: "Mi Perfil", en: "My Profile" },
  "nav.signOut": { es: "Cerrar Sesion", en: "Sign Out" },
  "nav.signIn": { es: "Ingresar", en: "Sign In" },

  // Hero
  "hero.title1": { es: "Compra y vende en ", en: "Buy and sell in " },
  "hero.title2": { es: "tu ciudad", en: "your city" },
  "hero.subtitle": {
    es: "Clasificados gratuitos para Colombia. Publica gratis, contacta por WhatsApp, negocia en persona. Simple y seguro.",
    en: "Free classifieds for Colombia. Post for free, contact via WhatsApp, negotiate in person. Simple and safe.",
  },
  "hero.explore": { es: "Explorar anuncios", en: "Browse listings" },
  "hero.postFree": { es: "Publicar gratis", en: "Post for free" },

  // Categories section
  "categories.title": { es: "Explora por categoria", en: "Browse by category" },
  "cat.buy_sell": { es: "Compra y Venta", en: "Buy & Sell" },
  "cat.jobs": { es: "Empleos", en: "Jobs" },
  "cat.housing": { es: "Vivienda", en: "Housing" },
  "cat.services": { es: "Servicios", en: "Services" },
  "cat.vehicles": { es: "Vehiculos", en: "Vehicles" },
  "cat.events": { es: "Eventos", en: "Events" },
  "cat.community": { es: "Comunidad", en: "Community" },

  // How it works
  "how.title": { es: "Como funciona", en: "How it works" },
  "how.step1.title": { es: "1. Encuentra lo que buscas", en: "1. Find what you need" },
  "how.step1.desc": {
    es: "Busca entre miles de anuncios en tu ciudad. Filtra por categoria, precio y ubicacion.",
    en: "Search thousands of listings in your city. Filter by category, price and location.",
  },
  "how.step2.title": { es: "2. Contacta por WhatsApp", en: "2. Contact via WhatsApp" },
  "how.step2.desc": {
    es: "Habla directamente con el vendedor por WhatsApp. Sin intermediarios, sin comisiones.",
    en: "Talk directly with the seller on WhatsApp. No middlemen, no commissions.",
  },
  "how.step3.title": { es: "3. Negocia seguro", en: "3. Deal safely" },
  "how.step3.desc": {
    es: "Vendedores verificados, sistema de reportes y calificaciones para tu tranquilidad.",
    en: "Verified sellers, report system and ratings for your peace of mind.",
  },

  // CTA
  "cta.title": {
    es: "Publica tu primer anuncio gratis",
    en: "Post your first listing for free",
  },
  "cta.subtitle": {
    es: "Unete a miles de colombianos que compran y venden en Lleva Lleva. Siempre gratis, siempre local.",
    en: "Join thousands of Colombians buying and selling on Lleva Lleva. Always free, always local.",
  },
  "cta.button": { es: "Publicar ahora", en: "Post now" },

  // Footer
  "footer.tagline": {
    es: "Clasificados gratuitos para Colombia. Compra, vende e intercambia en tu ciudad.",
    en: "Free classifieds for Colombia. Buy, sell and trade in your city.",
  },
  "footer.categories": { es: "Categorias", en: "Categories" },
  "footer.info": { es: "Informacion", en: "Information" },
  "footer.about": { es: "Sobre nosotros", en: "About us" },
  "footer.safety": { es: "Consejos de seguridad", en: "Safety tips" },
  "footer.terms": { es: "Terminos y condiciones", en: "Terms & conditions" },
  "footer.privacy": { es: "Privacidad", en: "Privacy" },
  "footer.contact": { es: "Contacto", en: "Contact" },
  "footer.copy": {
    es: "Lleva Lleva. Parte del ecosistema Maia Management Group.",
    en: "Lleva Lleva. Part of the Maia Management Group ecosystem.",
  },

  // Listings page
  "listings.title": { es: "Explorar anuncios", en: "Browse listings" },
  "listings.search": { es: "Buscar anuncios...", en: "Search listings..." },
  "listings.allCities": { es: "Todas las ciudades", en: "All cities" },
  "listings.all": { es: "Todos", en: "All" },
  "listings.empty": { es: "No se encontraron anuncios", en: "No listings found" },
  "listings.emptyHint": {
    es: "Intenta con otros filtros o publica el tuyo",
    en: "Try different filters or post your own",
  },
  "listings.featured": { es: "Destacado", en: "Featured" },

  // Listing detail
  "detail.description": { es: "Descripcion", en: "Description" },
  "detail.seller": { es: "Vendedor", en: "Seller" },
  "detail.verified": { es: "Verificado", en: "Verified" },
  "detail.contactWA": { es: "Contactar por WhatsApp", en: "Contact on WhatsApp" },
  "detail.edit": { es: "Editar", en: "Edit" },
  "detail.save": { es: "Guardar", en: "Save" },
  "detail.saved": { es: "Guardado", en: "Saved" },
  "detail.report": { es: "Reportar", en: "Report" },
  "detail.listings": { es: "Anuncios", en: "Listings" },
  "detail.noPhotos": { es: "Sin fotos", en: "No photos" },
  "detail.free": { es: "Gratis", en: "Free" },

  // Listing form
  "form.createTitle": { es: "Publicar anuncio", en: "Post listing" },
  "form.editTitle": { es: "Editar anuncio", en: "Edit listing" },
  "form.photos": { es: "Fotos (max 8)", en: "Photos (max 8)" },
  "form.maxImages": { es: "Maximo 8 imagenes por anuncio", en: "Maximum 8 images per listing" },
  "form.maxSize": { es: "Cada imagen debe ser menor a 5MB", en: "Each image must be under 5MB" },
  "form.uploadError": { es: "Error subiendo imagen", en: "Error uploading image" },
  "form.title": { es: "Titulo", en: "Title" },
  "form.titlePlaceholder": { es: "Ej: Sofa en buen estado", en: "E.g.: Sofa in good condition" },
  "form.description": { es: "Descripcion", en: "Description" },
  "form.descPlaceholder": {
    es: "Describe tu articulo, servicio o anuncio...",
    en: "Describe your item, service or listing...",
  },
  "form.price": { es: "Precio (COP)", en: "Price (COP)" },
  "form.priceFree": { es: "0 = Gratis", en: "0 = Free" },
  "form.category": { es: "Categoria", en: "Category" },
  "form.city": { es: "Ciudad", en: "City" },
  "form.whatsapp": { es: "WhatsApp", en: "WhatsApp" },
  "form.submit": { es: "Publicar anuncio", en: "Post listing" },
  "form.submitEdit": { es: "Guardar cambios", en: "Save changes" },
  "form.required": {
    es: "Completa todos los campos obligatorios",
    en: "Fill in all required fields",
  },

  // Auth
  "auth.loginTitle": { es: "Ingresar", en: "Sign In" },
  "auth.verifyTitle": { es: "Verificar codigo", en: "Verify code" },
  "auth.phoneLabel": { es: "Numero de celular", en: "Phone number" },
  "auth.phonePlaceholder": { es: "300 123 4567", en: "300 123 4567" },
  "auth.phoneHint": {
    es: "Ingresa tu numero de celular para continuar",
    en: "Enter your phone number to continue",
  },
  "auth.codeSent": { es: "Enviamos un codigo a", en: "We sent a code to" },
  "auth.sendCode": { es: "Enviar codigo", en: "Send code" },
  "auth.verify": { es: "Verificar", en: "Verify" },
  "auth.codeLabel": { es: "Codigo de verificacion", en: "Verification code" },
  "auth.changeNumber": { es: "Cambiar numero", en: "Change number" },
  "auth.terms": {
    es: "Al ingresar aceptas nuestros",
    en: "By signing in you accept our",
  },
  "auth.termsLink": { es: "terminos y condiciones", en: "terms & conditions" },

  // Profile
  "profile.myProfile": { es: "Mi Perfil", en: "My Profile" },
  "profile.myListings": { es: "Mis anuncios", en: "My listings" },
  "profile.newListing": { es: "+ Nuevo anuncio", en: "+ New listing" },
  "profile.noListings": { es: "No tienes anuncios aun", en: "You have no listings yet" },
  "profile.name": { es: "Nombre completo", en: "Full name" },
  "profile.namePlaceholder": { es: "Tu nombre", en: "Your name" },
  "profile.save": { es: "Guardar cambios", en: "Save changes" },
  "profile.saved": { es: "Guardado!", en: "Saved!" },
  "profile.since": { es: "Desde", en: "Since" },
  "profile.listingsOf": { es: "Anuncios de", en: "Listings by" },
  "profile.noActive": {
    es: "Este usuario no tiene anuncios activos",
    en: "This user has no active listings",
  },
  "profile.user": { es: "Usuario", en: "User" },

  // Favorites
  "favorites.title": { es: "Mis favoritos", en: "My favorites" },
  "favorites.empty": { es: "No tienes anuncios guardados", en: "No saved listings" },

  // Report
  "report.title": { es: "Reportar anuncio", en: "Report listing" },
  "report.reason": { es: "Razon", en: "Reason" },
  "report.details": { es: "Detalles (opcional)", en: "Details (optional)" },
  "report.detailsPlaceholder": { es: "Describe el problema...", en: "Describe the issue..." },
  "report.submit": { es: "Enviar reporte", en: "Submit report" },
  "report.success": { es: "Reporte enviado. Gracias por ayudar.", en: "Report sent. Thanks for helping." },
  "report.scam": { es: "Estafa / Scam", en: "Scam / Fraud" },
  "report.inappropriate": { es: "Contenido inapropiado", en: "Inappropriate content" },
  "report.spam": { es: "Spam", en: "Spam" },
  "report.other": { es: "Otro", en: "Other" },

  // Delete
  "delete.cancel": { es: "Cancelar", en: "Cancel" },
  "delete.confirm": { es: "Confirmar", en: "Confirm" },

  // Misc
  "loading": { es: "Cargando...", en: "Loading..." },
  "notFound.title": { es: "Pagina no encontrada", en: "Page not found" },
  "notFound.desc": {
    es: "Lo que buscas no existe o fue eliminado.",
    en: "What you're looking for doesn't exist or was removed.",
  },
  "notFound.home": { es: "Volver al inicio", en: "Back to home" },
  "time.now": { es: "ahora", en: "now" },
} as const;

export type TranslationKey = keyof typeof translations;

export function t(key: TranslationKey, locale: Locale): string {
  return translations[key]?.[locale] ?? key;
}

export function getCategoryLabel(
  category: string,
  locale: Locale
): string {
  const key = `cat.${category}` as TranslationKey;
  return t(key, locale);
}

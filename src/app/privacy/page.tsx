import type { Metadata } from "next";
import ContentPage from "@/components/static/ContentPage";

export const metadata: Metadata = {
  title: "Política de privacidad",
  description:
    "Cómo Lleva Lleva maneja datos, publicaciones, contacto entre usuarios y seguridad de cuenta.",
  alternates: {
    canonical: "/privacy",
  },
};

export default function PrivacyPage() {
  return (
    <ContentPage
      eyebrow="Privacidad"
      title="Política de privacidad"
      intro="Lleva Lleva es un marketplace de clasificados para Colombia. Usamos la información mínima necesaria para publicar anuncios, gestionar cuentas y ayudar a compradores y vendedores a contactarse con seguridad."
      sections={[
        {
          title: "Datos que usamos",
          body: "Podemos procesar tu nombre, datos de contacto, ciudad, contenido de anuncios, fotos, favoritos, reportes y datos técnicos básicos para mantener la plataforma segura y funcional.",
        },
        {
          title: "Finalidad",
          body: "Usamos estos datos para mostrar anuncios, permitir contacto entre usuarios, prevenir fraude, responder solicitudes, mejorar el servicio y cumplir obligaciones legales aplicables en Colombia.",
        },
        {
          title: "Terceros",
          body: "Podemos usar proveedores de infraestructura, autenticación, almacenamiento y analítica estrictamente necesarios para operar el servicio. No vendemos información personal.",
        },
        {
          title: "Tus derechos",
          body: "Puedes solicitar acceso, corrección, actualización o eliminación de tus datos escribiendo a hola@lleva-lleva.com. También puedes eliminar o actualizar tus anuncios desde tu cuenta.",
        },
      ]}
    />
  );
}

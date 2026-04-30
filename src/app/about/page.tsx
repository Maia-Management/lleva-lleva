import type { Metadata } from "next";
import ContentPage from "@/components/static/ContentPage";

export const metadata: Metadata = {
  title: "Sobre nosotros",
  description:
    "Lleva Lleva conecta compradores y vendedores locales con clasificados gratuitos para Colombia.",
  alternates: {
    canonical: "/about",
  },
};

export default function AboutPage() {
  return (
    <ContentPage
      eyebrow="Sobre Lleva Lleva"
      title="Clasificados locales, simples y gratuitos"
      intro="Lleva Lleva ayuda a personas y pequeños negocios en Colombia a publicar, encontrar y negociar sin comisiones ni barreras innecesarias."
      sections={[
        {
          title: "Qué hacemos",
          body: "Organizamos anuncios por ciudad y categoría para que sea más fácil encontrar productos, servicios, vivienda, empleo y oportunidades locales.",
        },
        {
          title: "Nuestra prioridad",
          body: "Priorizamos una experiencia rápida, clara y segura: publicación sencilla, contacto directo y herramientas de reporte para mantener la comunidad limpia.",
        },
        {
          title: "Parte del ecosistema Maia",
          body: "Lleva Lleva forma parte del ecosistema Maia Management Group, con foco en servicios útiles, responsables y preparados para crecer en Colombia.",
        },
      ]}
    />
  );
}

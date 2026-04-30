import type { Metadata } from "next";
import ContentPage from "@/components/static/ContentPage";

export const metadata: Metadata = {
  title: "Consejos de seguridad",
  description:
    "Buenas prácticas para comprar, vender y reunirse con otros usuarios en Lleva Lleva.",
  alternates: {
    canonical: "/safety",
  },
};

export default function SafetyPage() {
  return (
    <ContentPage
      eyebrow="Seguridad"
      title="Compra y vende con criterio"
      intro="La mejor transacción es clara antes de verse en persona. Verifica, pregunta, compara y evita cualquier operación que se sienta apresurada o poco transparente."
      sections={[
        {
          title: "Antes de reunirte",
          body: "Revisa fotos, descripción, precio, ubicación y reputación del usuario. Pide información adicional si algo no está claro.",
        },
        {
          title: "Durante la entrega",
          body: "Prefiere lugares públicos, ve acompañado si es posible y confirma el estado del producto antes de pagar o entregar.",
        },
        {
          title: "Pagos",
          body: "Evita anticipos a desconocidos. Si usas transferencia, confirma que el dinero esté recibido antes de cerrar la transacción.",
        },
        {
          title: "Reportes",
          body: "Reporta anuncios sospechosos, spam, intentos de estafa o usuarios abusivos para que podamos revisar y actuar rápido.",
        },
      ]}
    />
  );
}

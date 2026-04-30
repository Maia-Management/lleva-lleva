import type { Metadata } from "next";
import ContentPage from "@/components/static/ContentPage";

export const metadata: Metadata = {
  title: "Términos y condiciones",
  description:
    "Reglas de uso para publicar, comprar, vender y reportar anuncios en Lleva Lleva.",
  alternates: {
    canonical: "/terms",
  },
};

export default function TermsPage() {
  return (
    <ContentPage
      eyebrow="Condiciones"
      title="Términos y condiciones"
      intro="Al usar Lleva Lleva aceptas publicar información real, tratar a otros usuarios con respeto y hacer cada transacción con criterio, verificación y seguridad."
      sections={[
        {
          title: "Uso permitido",
          body: "Puedes publicar clasificados legítimos de productos, servicios, vivienda, empleo, vehículos, eventos y comunidad. No se permite contenido falso, ilegal, engañoso, discriminatorio o peligroso.",
        },
        {
          title: "Responsabilidad de usuarios",
          body: "Lleva Lleva facilita el contacto, pero cada comprador y vendedor es responsable de verificar identidad, estado del producto, precio, entrega, pago y cumplimiento de la negociación.",
        },
        {
          title: "Moderación",
          body: "Podemos retirar anuncios, suspender cuentas o limitar funcionalidades cuando detectemos fraude, spam, abuso, contenido prohibido o riesgo para otros usuarios.",
        },
        {
          title: "Seguridad",
          body: "Recomendamos reunirse en lugares públicos, evitar pagos anticipados no verificados y reportar cualquier comportamiento sospechoso desde la plataforma.",
        },
      ]}
    />
  );
}

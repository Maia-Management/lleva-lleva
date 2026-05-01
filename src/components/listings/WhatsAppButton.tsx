"use client";

import { MessageCircle } from "lucide-react";
import { useLocale } from "@/lib/locale-context";
import { buttonClassName } from "@/components/ui/Button";

interface WhatsAppButtonProps {
  phone: string;
  title: string;
}

export default function WhatsAppButton({ phone, title }: WhatsAppButtonProps) {
  const { t } = useLocale();
  const cleanPhone = phone.replace(/\D/g, "");
  const fullPhone = cleanPhone.startsWith("57")
    ? cleanPhone
    : `57${cleanPhone}`;
  const message = encodeURIComponent(
    `Hola! Me interesa tu anuncio en Lleva Lleva: "${title}"`
  );
  const url = `https://wa.me/${fullPhone}?text=${message}`;

  return (
    <a
      href={url}
      target="_blank"
      rel="noopener noreferrer"
      className={buttonClassName({
        variant: "whatsapp",
        size: "lg",
        className: "w-full",
      })}
    >
        <MessageCircle className="w-5 h-5" />
        {t("detail.contactWA")}
    </a>
  );
}

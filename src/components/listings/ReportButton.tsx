"use client";

import { useState } from "react";
import { Flag } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { useLocale } from "@/lib/locale-context";
import Button from "@/components/ui/Button";
import Modal from "@/components/ui/Modal";

interface ReportButtonProps {
  listingId: string;
}

export default function ReportButton({ listingId }: ReportButtonProps) {
  const [open, setOpen] = useState(false);
  const [reason, setReason] = useState("scam");
  const [description, setDescription] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const supabase = createClient();
  const { t } = useLocale();

  const reasons = [
    { value: "scam", label: t("report.scam") },
    { value: "inappropriate", label: t("report.inappropriate") },
    { value: "spam", label: t("report.spam") },
    { value: "other", label: t("report.other") },
  ];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      window.location.href = `/auth/login?redirect=/listings/${listingId}`;
      return;
    }

    setSubmitting(true);
    await supabase.from("reports").insert({
      listing_id: listingId,
      reporter_id: user.id,
      reason,
      description: description.trim() || null,
    });
    setSubmitting(false);
    setSubmitted(true);
    setTimeout(() => {
      setOpen(false);
      setSubmitted(false);
      setDescription("");
    }, 2000);
  };

  return (
    <>
      <Button variant="ghost" onClick={() => setOpen(true)}>
        <Flag className="w-4 h-4" />
        {t("detail.report")}
      </Button>

      <Modal
        open={open}
        onClose={() => setOpen(false)}
        title={t("report.title")}
      >
        {submitted ? (
          <div className="text-center py-4">
            <p className="text-emerald-600 font-medium">
              {t("report.success")}
            </p>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-navy-700 mb-1">
                {t("report.reason")}
              </label>
              <select
                value={reason}
                onChange={(e) => setReason(e.target.value)}
                className="w-full rounded-lg border border-navy-200 bg-white px-3 py-2 text-sm text-navy-700 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20"
              >
                {reasons.map((r) => (
                  <option key={r.value} value={r.value}>
                    {r.label}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-navy-700 mb-1">
                {t("report.details")}
              </label>
              <textarea
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                rows={3}
                maxLength={500}
                placeholder={t("report.detailsPlaceholder")}
                className="w-full rounded-lg border border-navy-200 bg-white px-3 py-2 text-sm text-navy-800 placeholder:text-navy-400 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-500/20 resize-none"
              />
            </div>
            <Button type="submit" loading={submitting} className="w-full">
              {t("report.submit")}
            </Button>
          </form>
        )}
      </Modal>
    </>
  );
}

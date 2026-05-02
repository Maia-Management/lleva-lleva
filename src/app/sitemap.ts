import type { MetadataRoute } from "next";
import { createClient } from "@/lib/supabase/server";

const staticRoutes = [
  "",
  "/listings",
  "/auth/login",
  "/about",
  "/safety",
  "/privacy",
  "/terms",
];

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const now = new Date();
  const supabase = await createClient();
  const { data: listings } = await supabase
    .from("listings")
    .select("slug, updated_at, created_at")
    .eq("status", "active")
    .order("created_at", { ascending: false })
    .limit(500);

  return [
    ...staticRoutes.map((route) => ({
      url: `https://lleva-lleva.com${route}`,
      lastModified: now,
      changeFrequency:
        route === "" || route === "/listings"
          ? ("daily" as const)
          : ("monthly" as const),
      priority: route === "" ? 1 : route === "/listings" ? 0.9 : 0.5,
    })),
    ...((listings ?? []).map((listing) => ({
      url: `https://lleva-lleva.com/listings/${listing.slug}`,
      lastModified: new Date(listing.updated_at ?? listing.created_at ?? now),
      changeFrequency: "weekly" as const,
      priority: 0.7,
    })) satisfies MetadataRoute.Sitemap),
  ];
}

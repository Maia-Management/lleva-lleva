import type { MetadataRoute } from "next";

const routes = [
  "",
  "/listings",
  "/auth/login",
  "/about",
  "/safety",
  "/privacy",
  "/terms",
];

export default function sitemap(): MetadataRoute.Sitemap {
  const now = new Date();

  return routes.map((route) => ({
    url: `https://lleva-lleva.com${route}`,
    lastModified: now,
    changeFrequency: route === "" || route === "/listings" ? "daily" : "monthly",
    priority: route === "" ? 1 : route === "/listings" ? 0.9 : 0.5,
  }));
}

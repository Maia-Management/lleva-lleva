import type { MetadataRoute } from 'next';

const SITE_URL = 'https://lleva-lleva.com';

// Estate standard (2026-05-23): allow all crawlers, including AI bots.
// Only genuinely private routes (auth, dashboard) are disallowed.
export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: '*',
        allow: '/',
        disallow: ['/auth/', '/dashboard/'],
      },
    ],
    sitemap: `${SITE_URL}/sitemap.xml`,
    host: SITE_URL,
  };
}

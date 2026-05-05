import { MetadataRoute } from 'next';

const BASE_URL = 'https://lleva-lleva.com';

const AI_TRAINING_BOTS = [
  'GPTBot',
  'ChatGPT-User',
  'Google-Extended',
  'CCBot',
  'anthropic-ai',
  'ClaudeBot',
  'Omgilibot',
  'FacebookBot',
];

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: '*',
        allow: '/',
        disallow: ['/auth/', '/dashboard/'],
      },
      ...AI_TRAINING_BOTS.map((userAgent) => ({
        userAgent,
        disallow: '/',
      })),
    ],
    sitemap: `${BASE_URL}/sitemap.xml`,
  };
}

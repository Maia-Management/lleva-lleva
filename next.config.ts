import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  poweredByHeader: false,
  turbopack: {
    root: process.cwd(),
  },
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "**.supabase.co",
      },
    ],
  },
  async redirects() {
    return [
      {
        source: "/index.html",
        destination: "/",
        permanent: true,
      },
    ];
  },
  async headers() {
    const securityHeaders = [
      {
        key: "Content-Security-Policy",
        value:
          "default-src 'self'; base-uri 'self'; object-src 'none'; frame-ancestors 'none'; script-src 'self' 'unsafe-inline'; connect-src 'self' https://*.supabase.co wss://*.supabase.co; img-src 'self' data: blob: https://*.supabase.co; style-src 'self' 'unsafe-inline'; font-src 'self' data:; form-action 'self'; upgrade-insecure-requests",
      },
      {
        key: "Permissions-Policy",
        value: "camera=(), microphone=(), geolocation=()",
      },
      {
        key: "Referrer-Policy",
        value: "strict-origin-when-cross-origin",
      },
      {
        key: "Strict-Transport-Security",
        value: "max-age=31536000; includeSubDomains; preload",
      },
      {
        key: "X-Content-Type-Options",
        value: "nosniff",
      },
      {
        key: "X-Frame-Options",
        value: "DENY",
      },
    ];
    const rootCacheHeaders = [
      {
        key: "Cache-Control",
        value: "no-store",
      },
      {
        key: "Netlify-CDN-Cache-Control",
        value: "no-store",
      },
    ];

    return [
      {
        source: "/:path*",
        headers: securityHeaders,
      },
      {
        source: "/",
        headers: rootCacheHeaders,
      },
    ];
  },
};

export default nextConfig;

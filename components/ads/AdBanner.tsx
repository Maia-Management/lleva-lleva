'use client';

import { useEffect, useRef } from 'react';

interface AdBannerProps {
  // Get slot IDs from your AdSense account: https://adsense.google.com → Ads → By ad unit → Display ads
  slot: string;
  format?: 'auto' | 'rectangle' | 'horizontal' | 'vertical';
  className?: string;
  fullWidthResponsive?: boolean;
}

declare global {
  interface Window {
    adsbygoogle: unknown[];
  }
}

const PUB_ID = 'ca-pub-2469196723812841';

/**
 * Reserve minimum height per format to prevent Cumulative Layout Shift (CLS).
 * The ad container must have a stable height before the ad loads so surrounding
 * content doesn't shift when the ad unit expands from 0px.
 * https://web.dev/cls/
 */
const MIN_HEIGHT: Record<string, number> = {
  horizontal: 90,   // Leaderboard (728×90) / mobile banner (320×50)
  vertical: 600,    // Wide skyscraper (160×600)
  rectangle: 250,   // Medium rectangle (300×250)
  auto: 90,         // Conservative fallback — auto-ads typically renders a banner first
};

export default function AdBanner({
  slot,
  format = 'auto',
  className = '',
  fullWidthResponsive = true,
}: AdBannerProps) {
  // Use 'auto' as fallback so auto-ads fills the slot when no specific unit ID is set
  const adSlot = slot || 'auto';
  const pushed = useRef(false);

  useEffect(() => {
    if (pushed.current) return;
    pushed.current = true;
    try {
      (window.adsbygoogle = window.adsbygoogle || []).push({});
    } catch {
      // adsbygoogle not yet loaded — auto-ads script will handle it
    }
  }, []);

  const minHeight = MIN_HEIGHT[format] ?? 90;

  return (
    <div
      className={`overflow-hidden text-center ${className}`}
      style={{ minHeight, contain: 'layout' }}
    >
      <ins
        className="adsbygoogle"
        style={{ display: 'block' }}
        data-ad-client={PUB_ID}
        data-ad-slot={adSlot}
        data-ad-format={format}
        data-full-width-responsive={fullWidthResponsive ? 'true' : 'false'}
      />
    </div>
  );
}

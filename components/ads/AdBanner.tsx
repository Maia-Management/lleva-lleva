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

export default function AdBanner({
  slot,
  format = 'auto',
  className = '',
  fullWidthResponsive = true,
}: AdBannerProps) {
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

  // Don't render if no slot provided
  if (!slot) return null;

  return (
    <div className={`overflow-hidden text-center ${className}`}>
      <ins
        className="adsbygoogle"
        style={{ display: 'block' }}
        data-ad-client={PUB_ID}
        data-ad-slot={slot}
        data-ad-format={format}
        data-full-width-responsive={fullWidthResponsive ? 'true' : 'false'}
      />
    </div>
  );
}

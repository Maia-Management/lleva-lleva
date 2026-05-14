'use client';

import { useEffect, useRef, useState } from 'react';

interface AdBannerProps {
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
const CONSENT_KEY = 'maia_consent';

const MIN_HEIGHT: Record<string, number> = {
  horizontal: 90,
  vertical: 600,
  rectangle: 250,
  auto: 90,
};

function hasAdsConsent() {
  try {
    const raw = window.localStorage.getItem(CONSENT_KEY);
    if (!raw) return false;
    return JSON.parse(raw)?.ads === true;
  } catch {
    return false;
  }
}

function ensureAdSenseScript() {
  if (document.getElementById('maia-adsense-script')) return;
  const script = document.createElement('script');
  script.id = 'maia-adsense-script';
  script.async = true;
  script.crossOrigin = 'anonymous';
  script.src = `https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${PUB_ID}`;
  document.head.appendChild(script);
}

export default function AdBanner({
  slot,
  format = 'auto',
  className = '',
  fullWidthResponsive = true,
}: AdBannerProps) {
  const adSlot = slot || 'auto';
  const pushed = useRef(false);
  const [adsAllowed, setAdsAllowed] = useState(false);
  const minHeight = MIN_HEIGHT[format] ?? 90;

  useEffect(() => {
    function syncConsent() {
      setAdsAllowed(hasAdsConsent());
    }

    syncConsent();
    window.addEventListener('maia-consent-updated', syncConsent);
    return () => window.removeEventListener('maia-consent-updated', syncConsent);
  }, []);

  useEffect(() => {
    if (!adsAllowed) return;
    if (pushed.current) return;
    pushed.current = true;
    ensureAdSenseScript();
    try {
      (window.adsbygoogle = window.adsbygoogle || []).push({});
    } catch {
      // The script may still be loading; AdSense will process the slot once ready.
    }
  }, [adsAllowed]);

  if (!adsAllowed) {
    return (
      <div
        className={`overflow-hidden text-center ${className}`}
        style={{ minHeight, contain: 'layout' }}
      />
    );
  }

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

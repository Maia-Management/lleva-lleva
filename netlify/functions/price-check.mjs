/**
 * Netlify Function v2: Price Check
 * Route: POST /api/price-check
 * Body:  { item: string, city?: string }
 * Returns: { low, mid, high, currency, count, sources, tip, updated }
 *
 * Calls Gemini 2.5 Flash with Google Search grounding to find
 * current asking prices on Colombian online marketplaces.
 */

const CORS_HEADERS = {
  'Content-Type': 'application/json',
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

export default async function handler(req) {
  // CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: CORS_HEADERS });
  }

  if (req.method !== 'POST') {
    return new Response(
      JSON.stringify({ error: 'Método no permitido' }),
      { status: 405, headers: CORS_HEADERS }
    );
  }

  let body;
  try {
    body = await req.json();
  } catch {
    return new Response(
      JSON.stringify({ error: 'JSON inválido en el cuerpo de la solicitud' }),
      { status: 400, headers: CORS_HEADERS }
    );
  }

  const { item, city } = body ?? {};

  if (!item || typeof item !== 'string' || item.trim().length === 0) {
    return new Response(
      JSON.stringify({ error: 'El campo "item" es obligatorio' }),
      { status: 400, headers: CORS_HEADERS }
    );
  }

  const apiKey = process.env.GEMINI_API_KEY;
  const model = process.env.GEMINI_MODEL || 'gemini-2.5-flash';

  if (!apiKey) {
    console.error('GEMINI_API_KEY is not set');
    return new Response(
      JSON.stringify({ error: 'Configuración del servidor incompleta' }),
      { status: 500, headers: CORS_HEADERS }
    );
  }

  const cityText =
    city && city !== 'nacional' ? ` en ${city}` : ' en Colombia';
  const today = new Date().toISOString().split('T')[0];

  const prompt = `Busca en los marketplaces colombianos en línea (Mercado Libre Colombia, Facebook Marketplace Colombia, OLX Colombia, Vibbo) anuncios actuales de venta de: "${item.trim()}"${cityText}.

Analiza los precios de venta actuales en Colombia en pesos colombianos (COP).

Responde ÚNICAMENTE con un objeto JSON válido y parseable, sin ningún texto antes ni después del JSON:
{
  "low": <número entero: percentil 20 de los precios encontrados>,
  "mid": <número entero: precio mediano>,
  "high": <número entero: percentil 80 de los precios encontrados>,
  "currency": "COP",
  "count": <número entero: cantidad estimada de anuncios analizados>,
  "sources": [<array de strings con los nombres de los marketplaces donde encontraste datos>],
  "tip": "<exactamente una oración en español con el consejo más útil para fijar el precio de este artículo específico en Colombia>",
  "updated": "${today}"
}

Reglas importantes:
- Todos los precios deben ser números enteros en COP (sin puntos ni comas).
- Si no hay suficientes datos reales, usa estimaciones razonables del mercado colombiano.
- El campo "tip" debe ser accionable y específico para este artículo.
- El JSON debe ser 100% válido y parseable con JSON.parse().`;

  try {
    const geminiRes = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          tools: [{ googleSearch: {} }],
          generationConfig: {
            temperature: 0.2,
            maxOutputTokens: 1024,
          },
        }),
      }
    );

    if (!geminiRes.ok) {
      const errText = await geminiRes.text();
      console.error('Gemini API error:', geminiRes.status, errText);
      return new Response(
        JSON.stringify({
          error: 'No se pudo consultar los precios en este momento. Inténtalo de nuevo.',
          fallback: true,
        }),
        { status: 502, headers: CORS_HEADERS }
      );
    }

    const geminiData = await geminiRes.json();
    const rawText =
      geminiData?.candidates?.[0]?.content?.parts?.[0]?.text ?? '';

    // Parse JSON defensively — Gemini sometimes wraps JSON in markdown fences
    let priceData = null;

    // 1. Try direct parse
    try {
      priceData = JSON.parse(rawText.trim());
    } catch {
      // 2. Strip markdown code fences and retry
      const stripped = rawText
        .replace(/```json\s*/gi, '')
        .replace(/```\s*/g, '')
        .trim();
      try {
        priceData = JSON.parse(stripped);
      } catch {
        // 3. Extract the first {...} block
        const jsonMatch = rawText.match(/\{[\s\S]*?\}/);
        if (jsonMatch) {
          try {
            priceData = JSON.parse(jsonMatch[0]);
          } catch {
            priceData = null;
          }
        }
      }
    }

    if (
      !priceData ||
      typeof priceData.low !== 'number' ||
      typeof priceData.mid !== 'number'
    ) {
      console.warn('Could not parse price data from Gemini response:', rawText);
      return new Response(
        JSON.stringify({
          error:
            'No se encontraron suficientes datos de precios para este artículo en Colombia. Intenta con un término más específico.',
          fallback: true,
        }),
        { status: 200, headers: CORS_HEADERS }
      );
    }

    const result = {
      low: Math.round(Number(priceData.low)),
      mid: Math.round(Number(priceData.mid)),
      high: Math.round(Number(priceData.high)),
      currency: 'COP',
      count: Math.round(Number(priceData.count)) || 0,
      sources: Array.isArray(priceData.sources)
        ? priceData.sources
        : ['Mercado Libre Colombia', 'OLX Colombia'],
      tip: typeof priceData.tip === 'string' ? priceData.tip : '',
      updated:
        typeof priceData.updated === 'string' ? priceData.updated : today,
    };

    return new Response(JSON.stringify(result), {
      status: 200,
      headers: {
        ...CORS_HEADERS,
        'Cache-Control':
          'public, max-age=3600, stale-while-revalidate=86400',
      },
    });
  } catch (err) {
    console.error('price-check function error:', err);
    return new Response(
      JSON.stringify({
        error: 'Error interno del servidor. Por favor intenta de nuevo.',
        fallback: true,
      }),
      { status: 500, headers: CORS_HEADERS }
    );
  }
}

export const config = {
  path: '/api/price-check',
};

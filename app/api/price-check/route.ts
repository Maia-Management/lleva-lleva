const JSON_HEADERS = {
  'Content-Type': 'application/json',
};

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: JSON_HEADERS,
  });
}

export async function POST(request: Request) {
  let body: { item?: unknown; city?: unknown };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'JSON invalido en el cuerpo de la solicitud' }, 400);
  }

  const item = typeof body.item === 'string' ? body.item.trim() : '';
  const city = typeof body.city === 'string' ? body.city : 'nacional';

  if (!item) {
    return json({ error: 'El campo "item" es obligatorio' }, 400);
  }

  const apiKey = process.env.GEMINI_API_KEY;
  const model = process.env.GEMINI_MODEL || 'gemini-2.5-flash';
  if (!apiKey) {
    console.error('GEMINI_API_KEY is not set');
    return json({ error: 'Configuracion del servidor incompleta', fallback: true }, 500);
  }

  const cityText = city !== 'nacional' ? ` en ${city}` : ' en Colombia';
  const today = new Date().toISOString().split('T')[0];
  const prompt = `Busca en marketplaces colombianos en linea anuncios actuales de venta de: "${item}"${cityText}.

Devuelve solo JSON valido:
{
  "low": <numero entero: percentil 20>,
  "mid": <numero entero: precio mediano>,
  "high": <numero entero: percentil 80>,
  "currency": "COP",
  "count": <numero entero>,
  "sources": [<marketplaces consultados>],
  "tip": "<una oracion util en espanol para fijar precio>",
  "updated": "${today}"
}

Reglas: precios enteros en COP, sin texto fuera del JSON. Si faltan datos, estima de forma razonable para Colombia.`;

  try {
    const geminiRes = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          tools: [{ googleSearch: {} }],
          generationConfig: { temperature: 0.2, maxOutputTokens: 1024 },
        }),
      }
    );

    if (!geminiRes.ok) {
      const errText = await geminiRes.text();
      console.error('Gemini API error:', geminiRes.status, errText);
      return json({
        error: 'No se pudo consultar precios en este momento. Intentalo de nuevo.',
        fallback: true,
      }, 502);
    }

    const geminiData = await geminiRes.json();
    const rawText = geminiData?.candidates?.[0]?.content?.parts?.[0]?.text ?? '';
    const stripped = String(rawText).replace(/```json\s*/gi, '').replace(/```\s*/g, '').trim();
    const jsonMatch = stripped.match(/\{[\s\S]*\}/);
    const priceData = JSON.parse(jsonMatch ? jsonMatch[0] : stripped);

    if (typeof priceData.low !== 'number' || typeof priceData.mid !== 'number') {
      return json({
        error: 'No se encontraron suficientes datos. Intenta con un termino mas especifico.',
        fallback: true,
      });
    }

    return json({
      low: Math.round(Number(priceData.low)),
      mid: Math.round(Number(priceData.mid)),
      high: Math.round(Number(priceData.high)),
      currency: 'COP',
      count: Math.round(Number(priceData.count)) || 0,
      sources: Array.isArray(priceData.sources) ? priceData.sources : ['Mercado Libre Colombia', 'OLX Colombia'],
      tip: typeof priceData.tip === 'string' ? priceData.tip : '',
      updated: typeof priceData.updated === 'string' ? priceData.updated : today,
    });
  } catch (err) {
    console.error('price-check route error:', err);
    return json({ error: 'Error interno del servidor. Por favor intenta de nuevo.', fallback: true }, 500);
  }
}


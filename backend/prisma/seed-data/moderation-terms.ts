/**
 * Términos iniciales del filtro de moderación (R3.3, R9.1, R9.2). ⚠️ PARA REVISIÓN:
 * lista inicial en español de Bolivia, pendiente de validación (docs/pendientes.md).
 *
 * Cómo funcionan (ADR-0018):
 * - El texto y los términos se normalizan igual: minúsculas, sin tildes, leet (c0c4 → coca),
 *   letras repetidas colapsadas y letras sueltas unidas (c.o.c.a → coca).
 * - `word`: una o más palabras que deben aparecer seguidas y completas. Un `*` al final de
 *   una palabra la hace prefijo: "prostitut*" coincide con "prostituta" y "prostitutas".
 * - `regex`: se aplica sobre el texto normalizado (sin tildes, en minúsculas, palabras
 *   separadas por un espacio). Máx. 100 caracteres, sin referencias, lookaround ni
 *   cuantificadores anidados.
 * - Una coincidencia NO rechaza: deja la solicitud "retenida" para revisión humana.
 *
 * Evitamos a propósito términos con usos legítimos frecuentes en servicios:
 * - "coca" sola (la hoja de coca es legal en Bolivia), "pistola" sola (pistola de calor,
 *   de silicona, de pintura), "revolver" (verbo), "granada" (fruta), "acompañante"
 *   (cuidado de adultos mayores), "prepago" solo (líneas de celular), "base" sola.
 *
 * El seed solo agrega términos que no existen (por term + kind). Para desactivar uno,
 * usar DELETE /admin/moderation-terms/:id (baja lógica); el seed no lo reactiva.
 */
export type ProhibitedCategory =
  'sexual' | 'drogas' | 'armas' | 'ilegal' | 'inmoral' | 'venta_productos';

export interface ModerationTermSeed {
  term: string;
  kind: 'word' | 'regex';
  category: ProhibitedCategory;
  note?: string;
}

const words = (
  category: ProhibitedCategory,
  terms: string[],
  note?: string,
): ModerationTermSeed[] => terms.map((term) => ({ term, kind: 'word', category, note }));

export const MODERATION_TERMS: ModerationTermSeed[] = [
  // Servicios sexuales (R9.1)
  ...words('sexual', [
    'prostitut*',
    'servicio sexual',
    'servicios sexuales',
    'trabajadora sexual',
    'sexo',
    'sexual*',
    'escort*',
    'dama de compania',
    'damas de compania',
    'chica prepago',
    'chicas prepago',
    'final feliz',
    'masaje erotico',
    'masajes eroticos',
    'erotic*',
    'kinesiolog*',
    'puta*',
    'webcam erotica',
  ]),

  // Drogas (R9.1). No incluye "coca" sola: la hoja de coca es legal en Bolivia.
  ...words('drogas', [
    'cocain*',
    'pichicata',
    'pasta base',
    'marihuan*',
    'mariguan*',
    'cannabis',
    'cripy',
    'cripi',
    'porro*',
    'extasis',
    'metanfetamin*',
    'lsd',
    'droga',
    'drogas',
    'merca',
    'clorhidrato',
  ]),

  // Armas (R9.1). Frases para no atrapar herramientas como la pistola de calor.
  ...words('armas', [
    'arma de fuego',
    'armas de fuego',
    'venta de armas',
    'vendo arma*',
    'alquilo arma*',
    'vendo pistola*',
    'alquilo pistola*',
    'municion*',
    'escopeta*',
    'fusil*',
    'metralleta*',
    'subametralladora*',
    'arma blanca',
  ]),

  // Actividades ilegales (R9.1)
  ...words('ilegal', [
    'sicario*',
    'documentos falsos',
    'documento falso',
    'carnet falso',
    'licencia falsa',
    'titulo falso',
    'billetes falsos',
    'falsificacion*',
    'falsificar',
    'contrabando',
    'lavado de dinero',
    'trata de personas',
    'hackear cuenta*',
    'hackeo de cuenta*',
    'robar',
  ]),

  // Actividades inmorales (R9.1). Lista corta: la mayoría cae en las categorías anteriores.
  ...words('inmoral', ['contenido para adultos', 'contenido adulto']),

  // Venta de productos (R2.3, R9.1): SISI solo publica servicios.
  ...words(
    'venta_productos',
    ['vendo', 'a la venta', 'en venta', 'al por mayor', 'remato', 'liquido stock'],
    'Puede atrapar servicios legítimos (p. ej. "ayudante en venta de..."); revisar en la cola de retenidas.',
  ),
  {
    term: String.raw`\b(?:bs|bolivianos) ?\d+ (?:c u|cada uno|cada una|la unidad|por unidad)\b`,
    kind: 'regex',
    category: 'venta_productos',
    note: 'Precio por unidad: típico de venta de productos ("Bs 50 c/u").',
  },
];

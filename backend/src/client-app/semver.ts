/** Compara versiones X.Y.Z (ignora "+build" y "-sufijo"). Negativo si a < b. */
export function compareVersions(a: string, b: string): number {
  const parts = (v: string) =>
    (v.split(/[+-]/)[0] ?? '').split('.').map((n) => Number.parseInt(n, 10) || 0);
  const [x, y] = [parts(a), parts(b)];
  for (let i = 0; i < 3; i++) {
    const d = (x[i] ?? 0) - (y[i] ?? 0);
    if (d !== 0) return d;
  }
  return 0;
}

export const APP_PLATFORMS = ['android', 'ios', 'web'] as const;
export type AppPlatform = (typeof APP_PLATFORMS)[number];
export const isAppPlatform = (v: unknown): v is AppPlatform =>
  typeof v === 'string' && (APP_PLATFORMS as readonly string[]).includes(v);

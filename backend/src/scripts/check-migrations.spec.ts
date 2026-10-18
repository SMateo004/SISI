import { findDestructive } from './check-migrations';

describe('check-migrations (ADR-0046)', () => {
  it('acepta migraciones aditivas', () => {
    expect(
      findDestructive(
        'ALTER TABLE "users" ADD COLUMN "deleted_at" TIMESTAMPTZ(3);\nCREATE INDEX "x" ON "users"("deleted_at");',
      ),
    ).toEqual([]);
  });

  it('rechaza DROP, RENAME, SET NOT NULL, TRUNCATE, cambios de tipo y DELETE', () => {
    const sql = [
      'ALTER TABLE "a" DROP COLUMN "b";',
      'ALTER TABLE "a" RENAME COLUMN "c" TO "d";',
      'ALTER TABLE "a" ALTER COLUMN "e" SET NOT NULL;',
      'TRUNCATE "a";',
      'ALTER TABLE "a" ALTER COLUMN "f" TYPE TEXT;',
      'DELETE FROM "a";',
    ].join('\n');
    expect(findDestructive(sql).map((p) => p.what)).toEqual([
      'DROP',
      'RENAME',
      'SET NOT NULL',
      'TRUNCATE',
      'cambio de tipo de columna',
      'DELETE',
    ]);
  });

  it('una marca contract en la línea anterior la permite; un comentario no cuenta', () => {
    expect(
      findDestructive(
        '-- contract: el código dejó de usar b en v0.10.0\nALTER TABLE "a" DROP COLUMN "b";',
      ),
    ).toEqual([]);
    expect(findDestructive('-- antes había un DROP COLUMN aquí\nSELECT 1;')).toEqual([]);
  });
});

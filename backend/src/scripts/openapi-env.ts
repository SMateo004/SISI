// Valores ficticios para armar el documento OpenAPI sin servicios reales.
process.env.DATABASE_URL ??= 'postgresql://openapi:openapi@localhost:5432/openapi';
process.env.REDIS_URL ??= 'redis://localhost:6379';
process.env.JWT_SECRET ??= 'openapi-export-'.padEnd(32, 'x');
process.env.JWT_REFRESH_SECRET ??= 'openapi-export-'.padEnd(32, 'y');
process.env.STORAGE_BUCKET ??= 'openapi';
process.env.STORAGE_ACCESS_KEY ??= 'openapi';
process.env.STORAGE_SECRET_KEY ??= 'openapi';

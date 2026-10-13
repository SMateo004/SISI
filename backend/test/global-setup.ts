import { execSync } from 'node:child_process';
import { applyE2eEnv } from './e2e-env';

/** Aplica las migraciones a la base de pruebas antes de correr los e2e. */
export default function globalSetup(): void {
  applyE2eEnv();
  execSync('npx prisma migrate deploy', { stdio: 'inherit', env: process.env });
}

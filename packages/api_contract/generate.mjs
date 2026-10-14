// Regenera el contrato: OpenAPI desde el backend y el cliente Dart `sisi_api` (ADR-0015).
// Uso (desde la raíz del repo): node packages/api_contract/generate.mjs
// Requiere Node 24, Docker (openapi-generator) y Dart/Flutter.
import { execFileSync } from 'node:child_process';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const repo = resolve(here, '../..');
const GENERATOR = 'openapitools/openapi-generator-cli:v7.25.0';
const isWindows = process.platform === 'win32';

const run = (cmd, args, cwd) => {
  console.log(`> ${cmd} ${args.join(' ')}`);
  execFileSync(cmd, args, { cwd, stdio: 'inherit', shell: isWindows });
};

run('npm', ['run', 'openapi:export'], join(repo, 'backend'));
run(
  'docker',
  [
    'run', '--rm',
    '-v', `${here}:/local`,
    GENERATOR, 'generate',
    '-i', '/local/openapi.json',
    '-g', 'dart-dio',
    '-o', '/local/dart',
    '--additional-properties=pubName=sisi_api,serializationLibrary=json_serializable',
  ],
  repo,
);
const dart = join(here, 'dart');
run('dart', ['pub', 'get'], dart);
run('dart', ['run', 'build_runner', 'build', '--delete-conflicting-outputs'], dart);
run('dart', ['analyze', '--no-fatal-warnings'], dart);
console.log('Contrato regenerado en packages/api_contract/');

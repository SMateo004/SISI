#!/bin/sh
# Crea los buckets locales y les aplica CORS. Se ejecuta en cada `docker compose up`.
set -eu
ENDPOINT="${S3_ENDPOINT:-http://storage:9000}"

for bucket in sisi-local sisi-test; do
  if aws --endpoint-url "$ENDPOINT" s3api head-bucket --bucket "$bucket" 2>/dev/null; then
    echo "Bucket $bucket ya existe"
  else
    aws --endpoint-url "$ENDPOINT" s3api create-bucket --bucket "$bucket"
    echo "Bucket $bucket creado"
  fi
  aws --endpoint-url "$ENDPOINT" s3api put-bucket-cors --bucket "$bucket" --cors-configuration file:///cors.json
done
echo "Almacenamiento listo"

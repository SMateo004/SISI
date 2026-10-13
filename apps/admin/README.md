# SISI · panel de administración

Flutter web (`admin` en Vercel). Riverpod + go_router + dio. Misma estructura que `apps/mobile` (ver ADR-0005).

## Comandos

```bash
flutter pub get
flutter run -d chrome --web-port 8081   # contra http://localhost:3000
flutter analyze
flutter test
flutter build web --release --dart-define=API_URL=https://api.ejemplo.bo
```

Variables por ambiente: ver `.env.example` (se pasan con `--dart-define`).

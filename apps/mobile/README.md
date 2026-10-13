# SISI · app (empleador + trabajador)

Flutter para Android, iOS y web (`app-web` en Vercel). Riverpod + go_router + dio.

```
lib/
├── app.dart            MaterialApp.router en español (Bolivia)
├── core/               config por ambiente, tema, rutas, cliente http
└── features/<feature>/ data/ y presentation/ por funcionalidad
```

## Comandos

```bash
flutter pub get
flutter run -d chrome --web-port 8080          # web contra http://localhost:3000
flutter run --dart-define=API_URL=http://10.0.2.2:3000   # emulador Android
flutter analyze
flutter test
```

Variables por ambiente: ver `.env.example` (se pasan con `--dart-define`).

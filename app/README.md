# igo_manager (app)

Este directorio contiene la aplicación Flutter usada por el proyecto `igo-manager-sunset`.

## Requisitos

- Flutter SDK (estable). Recomendado: Flutter 3.7+.
- Un emulador o dispositivo (Android, iOS, web o escritorio soportado).

## Instalación rápida

Desde la carpeta `app`:

```bash
flutter pub get
flutter run
```

Ejemplos para dispositivos específicos:

```bash
flutter run -d chrome
flutter run -d linux
flutter run -d windows
flutter run -d macos
flutter run -d emulator-5554
```

## Estructura relevante

- `lib/core/theme/app_theme.dart`: tema global y paleta Sunset.
- `lib/features/auth/screens`: pantallas de `login`, `register`, `profile` y `splash` (diseño actualizado).
- `lib/features/home/home_screen.dart`: navegación inferior y contenedor principal.
- `lib/features/iniciativas` y `lib/features/planes`: lógica funcional existente.

## Notas de diseño

La paleta "Sunset" introduce colores `violet`/`sunset`/`mint` y bordes más redondeados. El flujo y comandos se mantienen iguales al repositorio base; solo cambia la apariencia.

## Desarrollo

- Mantén tus credenciales de Supabase (si las usas) en variables de entorno.
- Para pruebas rápidas en web usa `flutter run -d chrome`.

Si necesitas que adapte más pantallas o genere assets (iconos, logos) dímelo y lo agrego.

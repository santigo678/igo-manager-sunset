# igo-manager-sunset

Una variante de diseño del repositorio original `ArizzaYF/igo-manager`, con una nueva paleta visual llamada **Sunset** y una interfaz más suave.

## Qué incluye

- Diseño renovado con colores cálidos y modernos.
- Tema principal personalizado en `app/lib/core/theme/app_theme.dart`.
- Interfaz actualizada en las pantallas de autenticación: `login`, `register`, `profile` y `splash`.
- Compatibilidad total con la misma estructura y comandos del repo base.
- Repositorio creado y publicado en GitHub: https://github.com/santigo678/igo-manager-sunset

## Comandos principales

Desde la carpeta `app`:

```bash
flutter pub get
flutter run
```

Para probar en un dispositivo específico, usa:

```bash
flutter run -d chrome
flutter run -d windows
flutter run -d linux
flutter run -d macos
flutter run -d emulator-5554
```

## Estructura del proyecto

- `app/lib/core/theme/app_theme.dart`: definición de paleta y estilos.
- `app/lib/features/auth/screens`: pantallas de login, registro, perfil y splash.
- `app/lib/features/home/home_screen.dart`: pantalla principal.
- `app/lib/features/iniciativas` y `app/lib/features/planes`: funcionalidades principales existentes.

## Cómo usar este repo

1. Clona o descarga `igo-manager-sunset`.
2. Abre la carpeta `app`.
3. Ejecuta `flutter pub get`.
4. Inicia con `flutter run`.

## Nota

Este proyecto mantiene el mismo flujo y comandos del repositorio original, pero con un diseño distinto y una paleta visual actualizada.

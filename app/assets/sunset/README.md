Assets for the Sunset theme

- `logo.svg`: SVG logo used in the app splash and headers.

Launcher icons and platform-specific icons are not replaced here. To generate native launcher icons using the same artwork, install `flutter_launcher_icons` and add a config to your `pubspec.yaml`, then run:

```bash
flutter pub run flutter_launcher_icons:main
```

Example `flutter_launcher_icons` config (add under `flutter_icons` in `pubspec.yaml`):

```yaml
flutter_icons:
  android: true
  ios: true
  image_path: "assets/sunset/logo.png" # provide a PNG for best results
```

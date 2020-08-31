# Tourist Flutter App

Aplicación para la gestión de sitios turísticos

## Plugins utilizados

- [global_configuration](https://pub.dev/packages/global_configuration)
- [scoped_model](https://pub.dev/packages/scoped_model)
- [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter)


## Compilación

En el archivo ubicado en /assets/cfg/app_settings.json se encuentra toda la parte de la configuración ya sea para producción, en dependencua de la opción a marcar va a ser la configuración del servidor que adopte la aplicación al compilar; en caso de cambiar la dirección IP.

flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi

### IDE

- Android Studio 4.0.1
- Plugins:
	- Dart
	- Flutter


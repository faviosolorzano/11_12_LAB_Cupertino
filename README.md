# Aula · Laboratorio 11 y 12

Aplicación de gestión de alumnos de la Sección A. Reinterpreta el laboratorio anterior con controles exclusivamente Cupertino y un diseño inspirado en Liquid Glass.

## Ejecutar

Desde `C:\AppMultiplataforma\lab11y12`:

```powershell
flutter pub get
flutter run
```

Selecciona tu emulador o dispositivo Android. También puedes ejecutar `flutter run -d chrome`. Si Flutter no está en el PATH de tu terminal, usa `C:\flutter\flutter\bin\flutter.bat` en su lugar.

## Acceso para la demostración

Pulsa **Explorar cuenta de prueba**. También puedes ingresar cualquier correo con formato válido y una contraseña de seis o más caracteres. Es una simulación local: no hay autenticación ni servidor. Los datos se conservan en memoria mientras la app está en ejecución y se reinician al reiniciarla. Los datos de contacto iniciales son de ejemplo y pueden editarse.

## Pantallas para tus capturas

1. **Login:** inicio y formulario con contraseña visible u oculta.
2. **Menú:** resumen de alumnos, aprobados y promedio; accesos a registro, lista y perfil.
3. **Alumnos:** búsqueda por nombre o apellido (ignora tildes y mayúsculas), filtros de estado y etiquetas de notas. Desliza a la izquierda o usa los tres puntos para eliminar con confirmación; después puedes deshacer la última eliminación. Arrastra hacia abajo para redibujar los datos locales.
4. **Registrar alumno:** nombres con letras, nota entera de 0 a 20 y validación. Una nota de 13 o más aprueba. Guardar abre la lista actualizada.
5. **Perfil:** información y edición mediante una ruta Cupertino presentada como diálogo de pantalla completa.

## Componentes del laboratorio

- Tema global: `CupertinoApp` y `CupertinoThemeData`.
- Rutas con nombre y transiciones Cupertino; al cerrar sesión se limpia el historial.
- Listas: `List<Alumno>`, `SliverList.builder`, `ListView`, búsqueda con `where`.
- Mapas: datos del perfil y opciones del control segmentado.
- Filas: `CupertinoListTile`, equivalente Cupertino de ListTile.
- Tarjetas: `GlassCard`, superficie propia con `BackdropFilter`, `ImageFilter.blur`, transparencia y bordes redondeados. No se usa Card de Material.
- Formularios: `CupertinoTextField`, formatos de entrada y validación.
- Alertas y menús: `CupertinoAlertDialog` y `CupertinoActionSheet`.
- Filtros y actualización: `CupertinoSlidingSegmentedControl` y `CupertinoSliverRefreshControl`.

El efecto de vidrio se realiza en Flutter; es una interpretación visual de Liquid Glass, sin depender de las APIs nativas de iOS 26. Funciona también en Android y web.

## Organización

- `lib/main.dart`: aplicación, tema y rutas.
- `lib/models/alumno.dart`: modelo y estado aprobado.
- `lib/data/app_store.dart`: lista, estadísticas y mapa de perfil.
- `lib/widgets/glass_ui.dart`: fondo, vidrio y controles reutilizables.
- `lib/screens/`: cinco pantallas principales y editor de perfil. Son partes de la biblioteca `screens.dart` y comparten sus utilidades privadas.
- `test/widget_test.dart`: pruebas de registro, límites de nota, búsqueda, eliminar/deshacer, perfil y sesión.

## Verificación

```powershell
flutter analyze
flutter test
flutter build web
```

Para entregar el código fuente incluye las carpetas `lib`, `android`, `ios`, `web`, `test`, el `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml`, `.metadata` y este README. No es necesario adjuntar `build`, `.dart_tool` ni `.idea`. Agrega tus propias capturas y el informe que solicite el docente.

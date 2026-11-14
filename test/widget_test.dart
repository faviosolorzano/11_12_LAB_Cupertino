import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11y12/main.dart';
import 'package:lab11y12/data/app_store.dart';

void main() {
  test('Notas, lista compartida y restauración', () {
    final store = AppStore();
    expect(store.aprobados, 4);
    store.agregar('José', 'Pérez', 13);
    expect(store.alumnos.last.aprobado, isTrue);
    final alumno = store.alumnos.last;
    final index = store.eliminar(alumno);
    expect(store.alumnos.contains(alumno), isFalse);
    store.restaurar(alumno, index);
    expect(store.alumnos.last, alumno);
    expect(() => store.alumnos.clear(), throwsUnsupportedError);
  });

  Future<void> setup(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    // Use installed fonts for readable local previews; behavioral tests also run without them.
    final fontFile = File('C:/Windows/Fonts/arial.ttf');
    if (fontFile.existsSync()) {
      final bytes = ByteData.sublistView(fontFile.readAsBytesSync());
      for (final family in [
        'Arial',
        'CupertinoSystemText',
        'CupertinoSystemDisplay',
      ]) {
        await (FontLoader(family)..addFont(Future.value(bytes))).load();
      }
    }
    await (FontLoader('packages/cupertino_icons/CupertinoIcons')..addFont(
          rootBundle.load('packages/cupertino_icons/assets/CupertinoIcons.ttf'),
        ))
        .load();
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
  }

  Future<void> shot(WidgetTester tester, String name) async {
    const directory = String.fromEnvironment('CAPTURE_DIR');
    if (directory.isEmpty) return;
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byType(RepaintBoundary).first,
    );
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File('$directory/$name.png');
      await file.writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
  }

  testWidgets(
    'Recorrido completo: login, registrar, buscar, eliminar y deshacer',
    (tester) async {
      await setup(tester);
      await shot(tester, '01-login');
      await tester.tap(find.text('Ingresar'));
      await tester.pumpAndSettle();
      expect(find.text('Revisa tus datos'), findsOneWidget);
      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Explorar cuenta de prueba'));
      await tester.pumpAndSettle();
      expect(find.text('Tu aula, en un lugar.'), findsOneWidget);
      await shot(tester, '02-menu');
      await tester.tap(find.text('Registrar alumno'));
      await tester.pumpAndSettle();
      await shot(tester, '04-registro');
      await tester.tap(find.text('Guardar alumno'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Completa nombre'), findsOneWidget);
      final fields = find.byType(CupertinoTextField);
      await tester.enterText(fields.at(0), 'José');
      await tester.enterText(fields.at(1), 'Pérez');
      await tester.enterText(fields.at(2), '99');
      await tester.tap(find.text('Guardar alumno'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Completa nombre'), findsOneWidget);
      await tester.enterText(fields.at(2), '13');
      await tester.tap(find.text('Guardar alumno'));
      await tester.pumpAndSettle();
      expect(find.text('Cada alumno cuenta.'), findsOneWidget);
      await shot(tester, '03-alumnos');
      await tester.enterText(find.byType(CupertinoTextField).first, 'jose');
      await tester.pumpAndSettle();
      expect(find.text('José Pérez'), findsOneWidget);
      expect(find.text('Ana Torres'), findsNothing);
      await tester.drag(find.byType(Dismissible).first, const Offset(-450, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(CupertinoDialogAction, 'Eliminar'));
      await tester.pumpAndSettle();
      expect(find.text('No hay alumnos para mostrar'), findsOneWidget);
      await tester.tap(find.text('Deshacer'));
      await tester.pumpAndSettle();
      expect(find.text('José Pérez'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Editar perfil y cerrar sesión borra el historial', (
    tester,
  ) async {
    await setup(tester);
    await tester.tap(find.text('Explorar cuenta de prueba'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mi perfil'));
    await tester.pumpAndSettle();
    await shot(tester, '05-perfil');
    await tester.ensureVisible(find.text('Editar perfil'));
    await tester.tap(find.text('Editar perfil'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(CupertinoTextField).first, 'Ana Torres');
    await tester.ensureVisible(find.text('Guardar cambios'));
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();
    expect(find.text('Ana Torres'), findsNWidgets(2));
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    navigator.pop();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Cerrar sesión'));
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(CupertinoDialogAction, 'Cerrar sesión'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(navigator.canPop(), isFalse);
    expect(tester.takeException(), isNull);
  });
}

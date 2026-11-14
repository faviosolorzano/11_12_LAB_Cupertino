import 'package:flutter/cupertino.dart';
import 'data/app_store.dart';
import 'screens/screens.dart';
import 'widgets/glass_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key, AppStore? store}) : store = store ?? AppStore();
  final AppStore store;
  @override
  Widget build(BuildContext context) => CupertinoApp(
    title: 'Aula · Alumnos',
    debugShowCheckedModeBanner: false,
    theme: const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.violet,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.violet,
        textStyle: TextStyle(
          fontFamily: 'Arial',
          fontSize: 16,
          color: AppColors.ink,
        ),
      ),
    ),
    initialRoute: '/',
    routes: {
      '/': (_) => LoginScreen(store: store),
      '/login': (_) => LoginScreen(store: store),
      '/menu': (_) => MenuScreen(store: store),
      '/alumnos': (_) => AlumnosScreen(store: store),
      '/registrar': (_) => RegistroScreen(store: store),
      '/perfil': (_) => PerfilScreen(store: store),
    },
  );
}

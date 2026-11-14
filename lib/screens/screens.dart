import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../data/app_store.dart';
import '../models/alumno.dart';
import '../widgets/glass_ui.dart';

part 'login_screen.dart';
part 'menu_screen.dart';
part 'alumnos_screen.dart';
part 'registro_screen.dart';
part 'perfil_screen.dart';
part 'editar_perfil_screen.dart';

const _pagePadding = EdgeInsets.fromLTRB(22, 22, 22, 30);
const _muted = TextStyle(color: AppColors.muted, fontSize: 13, height: 1.5);
final _letters = FilteringTextInputFormatter.allow(
  RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]'),
);
bool _validEmail(String value) =>
    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);

import 'package:flutter/foundation.dart';
import '../models/alumno.dart';

/// Datos compartidos en memoria. Se reinician al cerrar la aplicación.
class AppStore extends ChangeNotifier {
  final List<Alumno> _alumnos = [
    const Alumno(id: 1, nombre: 'Ana', apellido: 'Torres', nota: 18),
    const Alumno(id: 2, nombre: 'Luis', apellido: 'García', nota: 12),
    const Alumno(id: 3, nombre: 'María', apellido: 'López', nota: 9),
    const Alumno(id: 4, nombre: 'Carlos', apellido: 'Ruiz', nota: 16),
    const Alumno(id: 5, nombre: 'Lucía', apellido: 'Mendoza', nota: 20),
    const Alumno(id: 6, nombre: 'Diego', apellido: 'Flores', nota: 15),
  ];
  int _nextId = 7;
  final Map<String, String> perfil = {
    'nombre': 'Favio Solorzano Cardenas',
    'correo': 'favio.solorzano@tecsup.edu.pe',
    'telefono': '987 654 321',
    'rol': 'Estudiante',
  };
  List<Alumno> get alumnos => List.unmodifiable(_alumnos);
  int get aprobados => _alumnos.where((a) => a.aprobado).length;
  double get promedio => _alumnos.isEmpty
      ? 0
      : _alumnos.fold<int>(0, (s, a) => s + a.nota) / _alumnos.length;
  void agregar(String nombre, String apellido, int nota) {
    _alumnos.add(
      Alumno(id: _nextId++, nombre: nombre, apellido: apellido, nota: nota),
    );
    notifyListeners();
  }

  int eliminar(Alumno alumno) {
    final index = _alumnos.indexOf(alumno);
    if (index >= 0) {
      _alumnos.removeAt(index);
      notifyListeners();
    }
    return index;
  }

  void restaurar(Alumno alumno, int index) {
    if (_alumnos.any((a) => a.id == alumno.id)) return;
    _alumnos.insert(index.clamp(0, _alumnos.length), alumno);
    notifyListeners();
  }

  void editarPerfil(Map<String, String> datos) {
    perfil.addAll(datos);
    notifyListeners();
  }
}

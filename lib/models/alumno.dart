class Alumno {
  const Alumno({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.nota,
  });
  final int id;
  final String nombre, apellido;
  final int nota;
  bool get aprobado => nota >= 13;
  String get nombreCompleto => '$nombre $apellido';
  String get iniciales => '${nombre[0]}${apellido[0]}'.toUpperCase();
}

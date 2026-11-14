part of 'screens.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key, required this.store});
  final AppStore store;
  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final nombre = TextEditingController(),
      apellido = TextEditingController(),
      nota = TextEditingController();
  String? error;
  @override
  void dispose() {
    nombre.dispose();
    apellido.dispose();
    nota.dispose();
    super.dispose();
  }

  void save() {
    final grade = int.tryParse(nota.text);
    if (nombre.text.trim().isEmpty ||
        apellido.text.trim().isEmpty ||
        grade == null ||
        grade < 0 ||
        grade > 20) {
      setState(
        () => error =
            'Completa nombre y apellido. La nota debe estar entre 0 y 20.',
      );
      return;
    }
    widget.store.agregar(nombre.text.trim(), apellido.text.trim(), grade);
    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/alumnos',
      ModalRoute.withName('/menu'),
    );
  }

  @override
  Widget build(BuildContext context) => GlassPage(
    title: 'Registrar alumno',
    child: ListView(
      padding: _pagePadding,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        const PageHeading(
          'Un nuevo comienzo.',
          'Agrega un alumno y registra su primera nota.',
          eyebrow: 'NUEVO ALUMNO',
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  IconBadge(CupertinoIcons.person_badge_plus),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Información del alumno',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              LabeledField(
                'Nombre',
                controller: nombre,
                placeholder: 'Ej. Ana',
                keyboardType: TextInputType.name,
                formatters: [_letters, LengthLimitingTextInputFormatter(40)],
              ),
              LabeledField(
                'Apellido',
                controller: apellido,
                placeholder: 'Ej. Torres',
                keyboardType: TextInputType.name,
                formatters: [_letters, LengthLimitingTextInputFormatter(50)],
              ),
              LabeledField(
                'Nota final',
                controller: nota,
                placeholder: 'De 0 a 20',
                keyboardType: TextInputType.number,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                last: true,
                onSubmitted: (_) => save(),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    error!,
                    style: const TextStyle(
                      color: AppColors.red,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              PrimaryButton(
                'Guardar alumno',
                onPressed: save,
                icon: CupertinoIcons.check_mark,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const GlassCard(
          padding: EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                CupertinoIcons.info_circle,
                color: AppColors.violet,
                size: 19,
              ),
              SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Una nota de 13 o más se considera aprobatoria. El estado se asigna automáticamente.',
                  style: _muted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Los datos se conservan durante esta sesión.',
          textAlign: TextAlign.center,
          style: _muted,
        ),
      ],
    ),
  );
}

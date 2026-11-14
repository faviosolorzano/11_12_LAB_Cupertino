part of 'screens.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key, required this.store});
  final AppStore store;
  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  late final nombre = TextEditingController(
    text: widget.store.perfil['nombre'],
  );
  late final correo = TextEditingController(
    text: widget.store.perfil['correo'],
  );
  late final telefono = TextEditingController(
    text: widget.store.perfil['telefono'],
  );
  String? error;
  @override
  void dispose() {
    nombre.dispose();
    correo.dispose();
    telefono.dispose();
    super.dispose();
  }

  void save() {
    if (nombre.text.trim().isEmpty ||
        !_validEmail(correo.text.trim()) ||
        telefono.text.replaceAll(' ', '').length < 9) {
      setState(
        () => error =
            'Ingresa tu nombre, un correo válido y un teléfono de al menos 9 dígitos.',
      );
      return;
    }
    widget.store.editarPerfil({
      'nombre': nombre.text.trim(),
      'correo': correo.text.trim(),
      'telefono': telefono.text.trim(),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => GlassPage(
    title: 'Editar perfil',
    child: ListView(
      padding: _pagePadding,
      children: [
        const PageHeading('Hagámoslo tuyo.', 'Actualiza tus datos personales.'),
        GlassCard(
          child: Column(
            children: [
              LabeledField(
                'Nombre completo',
                controller: nombre,
                placeholder: 'Tu nombre',
                keyboardType: TextInputType.name,
                formatters: [_letters, LengthLimitingTextInputFormatter(80)],
              ),
              LabeledField(
                'Correo electrónico',
                controller: correo,
                placeholder: 'nombre@correo.com',
                keyboardType: TextInputType.emailAddress,
              ),
              LabeledField(
                'Teléfono',
                controller: telefono,
                placeholder: '987 654 321',
                keyboardType: TextInputType.phone,
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                  LengthLimitingTextInputFormatter(18),
                ],
                last: true,
                onSubmitted: (_) => save(),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    error!,
                    style: const TextStyle(color: AppColors.red, fontSize: 13),
                  ),
                ),
              PrimaryButton(
                'Guardar cambios',
                onPressed: save,
                icon: CupertinoIcons.check_mark,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

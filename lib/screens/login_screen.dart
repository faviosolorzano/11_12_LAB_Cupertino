part of 'screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.store});
  final AppStore store;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(), password = TextEditingController();
  bool visible = false;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login({bool demo = false}) {
    if (!demo &&
        (!_validEmail(email.text.trim()) || password.text.length < 6)) {
      showMessage(
        context,
        'Revisa tus datos',
        'Ingresa un correo válido y una contraseña de al menos 6 caracteres.',
      );
      return;
    }
    FocusScope.of(context).unfocus();
    Navigator.pushNamedAndRemoveUntil(context, '/menu', (_) => false);
  }

  @override
  Widget build(BuildContext context) => GlassPage(
    title: 'Aula',
    back: false,
    child: ListView(
      padding: _pagePadding,
      children: [
        const SizedBox(height: 22),
        Center(
          child: GlassCard(
            padding: const EdgeInsets.all(22),
            child: const Icon(
              CupertinoIcons.square_stack_3d_up_fill,
              color: AppColors.violet,
              size: 46,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'A U L A',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.violet,
              letterSpacing: 4,
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Todo empieza\ncon aprender.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.3,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tu espacio para gestionar alumnos.',
          textAlign: TextAlign.center,
          style: _muted,
        ),
        const SizedBox(height: 28),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Iniciar sesión',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
              ),
              const SizedBox(height: 22),
              LabeledField(
                'Correo electrónico',
                controller: email,
                placeholder: 'nombre@correo.com',
                keyboardType: TextInputType.emailAddress,
              ),
              LabeledField(
                'Contraseña',
                controller: password,
                placeholder: 'Mínimo 6 caracteres',
                obscure: !visible,
                last: true,
                onSubmitted: (_) => login(),
                suffix: CupertinoButton(
                  padding: const EdgeInsets.all(10),
                  onPressed: () => setState(() => visible = !visible),
                  child: Icon(
                    visible ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                    size: 19,
                  ),
                ),
              ),
              PrimaryButton('Ingresar', onPressed: login),
            ],
          ),
        ),
        const SizedBox(height: 10),
        CupertinoButton(
          onPressed: () => login(demo: true),
          child: const Text(
            'Explorar cuenta de prueba',
            style: TextStyle(fontSize: 14),
          ),
        ),
        const Text(
          'Laboratorio 11 y 12 · Sección A\nAcceso de demostración, sin servidor.',
          textAlign: TextAlign.center,
          style: _muted,
        ),
      ],
    ),
  );
}

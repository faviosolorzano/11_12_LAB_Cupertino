part of 'screens.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key, required this.store});
  final AppStore store;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) => GlassPage(
      title: 'Mi perfil',
      child: ListView(
        padding: _pagePadding,
        children: [
          const PageHeading(
            'Este es tu espacio.',
            'Tu información, siempre a la mano.',
            eyebrow: 'MI CUENTA',
          ),
          GlassCard(
            child: Column(
              children: [
                const SizedBox(height: 6),
                Container(
                  width: 90,
                  height: 90,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9683ED), AppColors.violet],
                    ),
                    border: Border.all(color: CupertinoColors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x336551D9),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    store.perfil['nombre']!
                        .trim()
                        .split(RegExp(r'\s+'))
                        .take(2)
                        .map((s) => s[0])
                        .join()
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  store.perfil['nombre']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.6,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.violet.withValues(alpha: .09),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${store.perfil['rol']} · Sección A',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.violet,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'INFORMACIÓN PERSONAL',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              children: [
                _info(
                  CupertinoIcons.person,
                  'Nombre completo',
                  store.perfil['nombre']!,
                ),
                _info(
                  CupertinoIcons.mail,
                  'Correo electrónico',
                  store.perfil['correo']!,
                ),
                _info(
                  CupertinoIcons.phone,
                  'Teléfono',
                  store.perfil['telefono']!,
                ),
                _info(CupertinoIcons.briefcase, 'Rol', store.perfil['rol']!),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            'Editar perfil',
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute<void>(
                fullscreenDialog: true,
                builder: (_) => EditarPerfilScreen(store: store),
              ),
            ),
            icon: CupertinoIcons.pencil,
          ),
          const SizedBox(height: 20),
          const Text(
            'Aprender. Organizar. Crecer.',
            textAlign: TextAlign.center,
            style: _muted,
          ),
        ],
      ),
    ),
  );
  Widget _info(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 13),
    child: Row(
      children: [
        Icon(icon, color: AppColors.violet, size: 21),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
              const SizedBox(height: 5),
              Text(value, style: const TextStyle(fontSize: 14, height: 1.4)),
            ],
          ),
        ),
      ],
    ),
  );
}

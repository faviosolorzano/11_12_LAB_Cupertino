part of 'screens.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.store});
  final AppStore store;
  Future<void> logout(BuildContext context) async {
    if (await confirmAction(
          context,
          'Cerrar sesión',
          '¿Deseas volver a la pantalla de inicio?',
          'Cerrar sesión',
        ) &&
        context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) => GlassPage(
      title: 'Inicio',
      back: false,
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pushNamed(context, '/perfil'),
        child: const Icon(CupertinoIcons.person_crop_circle, size: 27),
      ),
      child: ListView(
        padding: _pagePadding,
        children: [
          const PageHeading(
            'Tu aula, en un lugar.',
            'Organiza, registra y acompaña el aprendizaje.',
            eyebrow: 'ESPACIO ACADÉMICO',
          ),
          GlassCard(
            tint: const Color(0x9CFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const IconBadge(CupertinoIcons.person_fill, size: 48),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Qué gusto verte,', style: _muted),
                          const SizedBox(height: 3),
                          Text(
                            store.perfil['nombre']!.split(' ').first,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      CupertinoIcons.sparkles,
                      color: AppColors.violet,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _stat('${store.alumnos.length}', 'Alumnos'),
                    ),
                    Expanded(child: _stat('${store.aprobados}', 'Aprobados')),
                    Expanded(
                      child: _stat(
                        store.promedio.toStringAsFixed(1),
                        'Promedio',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 27),
          const Text(
            'GESTIONA TU AULA',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.6,
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                _option(
                  context,
                  CupertinoIcons.person_badge_plus,
                  'Registrar alumno',
                  'Un nuevo integrante para tu aula',
                  '/registrar',
                  AppColors.violet,
                ),
                _option(
                  context,
                  CupertinoIcons.person_2_fill,
                  'Listar alumnos',
                  'Consulta las notas y su progreso',
                  '/alumnos',
                  AppColors.green,
                ),
                _option(
                  context,
                  CupertinoIcons.person_crop_rectangle,
                  'Mi perfil',
                  'Tu información personal',
                  '/perfil',
                  const Color(0xFF5783C6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            padding: EdgeInsets.zero,
            child: CupertinoListTile(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              leading: const Icon(
                CupertinoIcons.square_arrow_right,
                color: AppColors.red,
              ),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: AppColors.red, fontSize: 15),
              ),
              trailing: const CupertinoListTileChevron(),
              onTap: () => logout(context),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'AULA  /  SECCIÓN A',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 2,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    ),
  );
  Widget _stat(String number, String label) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        number,
        style: const TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.w700,
          color: AppColors.violet,
        ),
      ),
      const SizedBox(height: 5),
      Text(label, style: _muted),
    ],
  );
  Widget _option(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String route,
    Color color,
  ) => CupertinoListTile(
    leadingSize: 44,
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    leading: IconBadge(icon, color: color),
    title: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    subtitle: Text(
      subtitle,
      style: const TextStyle(fontSize: 12, color: AppColors.muted),
    ),
    trailing: const CupertinoListTileChevron(),
    onTap: () => Navigator.pushNamed(context, route),
  );
}

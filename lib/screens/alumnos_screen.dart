part of 'screens.dart';

class AlumnosScreen extends StatefulWidget {
  const AlumnosScreen({super.key, required this.store});
  final AppStore store;
  @override
  State<AlumnosScreen> createState() => _AlumnosScreenState();
}

class _AlumnosScreenState extends State<AlumnosScreen> {
  String query = '';
  int filter = 0;
  Alumno? removed;
  int removedIndex = 0;
  String normalize(String text) {
    var result = text.toLowerCase();
    const accents = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'ü': 'u',
    };
    accents.forEach((a, b) => result = result.replaceAll(a, b));
    return result;
  }

  void delete(Alumno alumno) {
    final index = widget.store.eliminar(alumno);
    setState(() {
      removed = alumno;
      removedIndex = index;
    });
  }

  Future<void> actions(Alumno alumno) async {
    final selected = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(alumno.nombreCompleto),
        message: Text(
          'Nota: ${alumno.nota}/20 · ${alumno.aprobado ? 'Aprobado' : 'Desaprobado'}',
        ),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar alumno'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
      ),
    );
    if (selected == true &&
        mounted &&
        await confirmAction(
          context,
          'Eliminar alumno',
          '¿Eliminar a ${alumno.nombreCompleto}? Podrás deshacer esta acción.',
          'Eliminar',
        ) &&
        mounted) {
      delete(alumno);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.store,
    builder: (context, _) {
      final alumnos = widget.store.alumnos
          .where(
            (a) =>
                normalize(a.nombreCompleto).contains(normalize(query)) &&
                (filter == 0 || (filter == 1 ? a.aprobado : !a.aprobado)),
          )
          .toList();
      return GlassPage(
        title: 'Alumnos',
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pushNamed(context, '/registrar'),
          child: const Icon(CupertinoIcons.add_circled_solid, size: 27),
        ),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      await Future<void>.delayed(
                        const Duration(milliseconds: 400),
                      );
                      if (mounted) setState(() {});
                    },
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PageHeading(
                            'Cada alumno cuenta.',
                            '${widget.store.alumnos.length} alumnos · Nota mínima aprobatoria: 13',
                            eyebrow: 'SECCIÓN A',
                          ),
                          CupertinoSearchTextField(
                            placeholder: 'Buscar por nombre o apellido',
                            onChanged: (value) => setState(() => query = value),
                            padding: const EdgeInsets.all(13),
                            backgroundColor: const Color(0xB3FFFFFF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: CupertinoSlidingSegmentedControl<int>(
                              groupValue: filter,
                              onValueChanged: (value) =>
                                  setState(() => filter = value ?? 0),
                              backgroundColor: const Color(0x126551D9),
                              children: const {
                                0: Text(
                                  'Todos',
                                  style: TextStyle(fontSize: 13),
                                ),
                                1: Text(
                                  'Aprobados',
                                  style: TextStyle(fontSize: 13),
                                ),
                                2: Text(
                                  'Desaprobados',
                                  style: TextStyle(fontSize: 13),
                                ),
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'LISTA DE ALUMNOS',
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1.5,
                                  color: AppColors.muted,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${alumnos.length} resultados',
                                style: _muted,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  if (alumnos.isEmpty)
                    const SliverPadding(
                      padding: EdgeInsets.all(22),
                      sliver: SliverToBoxAdapter(
                        child: GlassCard(
                          child: Column(
                            children: [
                              IconBadge(CupertinoIcons.search),
                              SizedBox(height: 16),
                              Text('No hay alumnos para mostrar'),
                              SizedBox(height: 8),
                              Text(
                                'Prueba otra búsqueda o registra un alumno.',
                                textAlign: TextAlign.center,
                                style: _muted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    sliver: SliverList.builder(
                      itemCount: alumnos.length,
                      itemBuilder: (context, index) {
                        final a = alumnos[index];
                        final color = a.aprobado
                            ? AppColors.green
                            : AppColors.red;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Dismissible(
                            key: ValueKey(a.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) => confirmAction(
                              context,
                              'Eliminar alumno',
                              '¿Eliminar a ${a.nombreCompleto}?',
                              'Eliminar',
                            ),
                            onDismissed: (_) => delete(a),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: const Icon(
                                CupertinoIcons.delete,
                                color: CupertinoColors.white,
                              ),
                            ),
                            child: GlassCard(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 43,
                                    height: 43,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.violet.withValues(
                                        alpha: .1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      a.iniciales,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.violet,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          a.nombreCompleto,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Nota ${a.nota.toString().padLeft(2, '0')} / 20',
                                          style: _muted,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: .1),
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Text(
                                      a.aprobado ? 'Aprobado' : 'Desaprobado',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: color,
                                      ),
                                    ),
                                  ),
                                  CupertinoButton(
                                    padding: const EdgeInsets.only(left: 9),
                                    minimumSize: const Size(30, 44),
                                    onPressed: () => actions(a),
                                    child: const Icon(
                                      CupertinoIcons.ellipsis_vertical,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Desliza a la izquierda para eliminar.\nArrastra hacia abajo para actualizar.',
                        textAlign: TextAlign.center,
                        style: _muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (removed != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 3,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Alumno eliminado',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          widget.store.restaurar(removed!, removedIndex);
                          setState(() => removed = null);
                        },
                        child: const Text(
                          'Deshacer',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:proto_segui/data/estudiante_controllers/estudiante_vacantes_controller.dart';
import 'package:proto_segui/models/vacancy.dart';
import 'package:proto_segui/screens/estudiante/Vacantes/widgets/estudiante_widgets.dart';
import 'package:proto_segui/utils/colores.dart';
import '../../routes/pages.dart';

class InstitucionMainScreen extends StatefulWidget {
  const InstitucionMainScreen({super.key});

  @override
  State<InstitucionMainScreen> createState() => _InstitucionMainScreenState();
}

class _InstitucionMainScreenState extends State<InstitucionMainScreen> {
  final EstudianteVacantesController _controller =
      EstudianteVacantesController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: borderC,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryC),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Scaffold(
            body: SafeArea(
              child: IndexedStack(
                index: _controller.selectedIndex,
                children: [
                  _buildHomeTab(),
                  _buildVacanciesTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
            bottomNavigationBar: EstudianteNavBar(
              selectedIndex: _controller.selectedIndex,
              onSelect: _controller.setIndex,
              homeBadge: _controller.newApplicantsCount,
              vacanciesBadge: _controller.companyVacancies.length,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        _solidSliverAppBar(
          title: "Panel",
          actions: [
            IconButton(
              tooltip: "Notificaciones",
              icon: IconosNav(
                icon: Icons.notifications_none_rounded,
                count: _controller.newApplicantsCount,
              ),
              onPressed: () => _controller.openNotifications(context),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CompanyGradientHero(
                  title: _controller.companyName,
                  subtitle: "Gestiona vacantes con un estilo profesional.",
                  icon: Icons.business_rounded,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: CompanyStatCard(
                        title: "Vacantes",
                        value: "${_controller.companyVacancies.length}",
                        icon: Icons.work_outline_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CompanyStatCard(
                        title: "Postulantes",
                        value:
                            "${_controller.newApplicantsCount == 0 ? 3 : _controller.newApplicantsCount}",
                        icon: Icons.people_alt_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  "Acciones rápidas",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: textDarkC,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _controller.openCreateVacancy(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryC,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text(
                          "Crear vacante",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _controller.setIndex(1),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: borderC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(
                          Icons.list_alt_rounded,
                          color: textDarkC,
                        ),
                        label: const Text(
                          "Ver vacantes",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: textDarkC,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVacanciesTab() {
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        _solidSliverAppBar(
          title: "Vacantes",
          actions: [
            IconButton(
              tooltip: "Notificaciones",
              icon: IconosNav(
                icon: Icons.notifications_none_rounded,
                count: _controller.newApplicantsCount,
              ),
              onPressed: () => _controller.openNotifications(context),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BarraBusqueda(
                  controller: _controller.searchCtrl,
                  hintText: "Buscar por título, modalidad o ubicación…",
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Mis vacantes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: textDarkC,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => _controller.openCreateVacancy(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: textDarkC,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text(
                        "Crear",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "${_controller.foundVacancies.length} resultado(s)",
                  style: const TextStyle(
                    color: textMutedC,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_controller.foundVacancies.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: CompanyEmptyState(
              icon: Icons.work_off_rounded,
              title: "No hay vacantes",
              subtitle: "Crea una vacante o ajusta tu búsqueda.",
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final v = _controller.foundVacancies[index];
                return TarjetaVacantes(
                  vacancy: v,
                  onOpen: () => Navigator.pushNamed(
                    context,
                    APPpages.estudiantePostulacion,
                    arguments: v,
                  ),
                  onEdit: () => _controller.editVacancy(context, v),
                  onDelete: () => _showDeleteDialog(v),
                );
              }, childCount: _controller.foundVacancies.length),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileTab() {
    return CustomScrollView(
      slivers: [
        _solidSliverAppBar(
          title: "Perfil",
          actions: [
            IconButton(
              tooltip: "Editar Perfil",
              icon: const Icon(Icons.edit_rounded, color: textDarkC),
              onPressed: () {
                Navigator.pushNamed(context, APPpages.institucionEditarPerfil);
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
            child: Column(
              children: [
                CompanyGradientHero(
                  title: _controller.companyName,
                  subtitle: "Financiera • Cuenta empresa",
                  icon: Icons.apartment_rounded,
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderC),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .04),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Configuración",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: textDarkC,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Administra tu cuenta y vacantes publicadas.",
                        style: TextStyle(color: textMutedC, height: 1.25),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () => _controller.logout(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE11D48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text(
                      "Cerrar sesión",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Funciones auxiliares para la UI ---

  SliverAppBar _solidSliverAppBar({
    required String title,
    List<Widget> actions = const [],
  }) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 8,
      backgroundColor: backgroundC,
      surfaceTintColor: backgroundC,
      shadowColor: Colors.black.withOpacity(.12),
      titleSpacing: 16,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w900, color: textDarkC),
      ),
      actions: [...actions, const SizedBox(width: 6)],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: borderC),
      ),
    );
  }

  void _showDeleteDialog(Vacancy v) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          "Eliminar vacante",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: Text("¿Seguro que deseas eliminar '${v.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar", style: TextStyle(color: textMutedC)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              _controller.deleteVacancy(context, v);
              Navigator.pop(ctx);
            },
            child: const Text(
              "Eliminar",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

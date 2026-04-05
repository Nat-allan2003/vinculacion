import 'package:flutter/material.dart';
import 'package:proto_segui/data/estudiante_controllers/estudiante_main_controller.dart';
import 'package:proto_segui/routes/router.dart';
import 'package:proto_segui/screens/estudiante/perfil/widgets/perfil_widgets.dart';
import 'package:proto_segui/screens/professional/cv_simulation_screen.dart';
import 'package:proto_segui/screens/professional/professional_profile_screen.dart';
import 'package:proto_segui/utils/colores.dart';

import '../../routes/pages.dart';

class EstudianteMainScreen extends StatefulWidget {
  final Map<String, dynamic>? loginData;

  const EstudianteMainScreen({super.key, this.loginData});

  @override
  State<EstudianteMainScreen> createState() => _EstudianteMainScreenState();
}

class _EstudianteMainScreenState extends State<EstudianteMainScreen> {
  final EstudianteMainController _controller = EstudianteMainController();

  @override
  void initState() {
    super.initState();
    _controller.init(widget.loginData);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.bootstrapNavigation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Lógica dinámica de la UI: Genera las pestañas según lo que diga el controlador
  List<NavItemData> _getNavItems() {
    if (_controller.subMenus.isEmpty) {
      return [
        NavItemData(
          label: "Home",
          icon: Icons.home_rounded,
          builder: _buildHomeTab,
        ),
        NavItemData(
          label: "Postulación",
          icon: Icons.people_alt_rounded,
          builder: _buildApplicationsTab,
        ),
        NavItemData(
          label: "Favoritos",
          icon: Icons.bookmark_rounded,
          builder: _buildFavoritesTab,
        ),
        NavItemData(
          label: "Perfil",
          icon: Icons.person_rounded,
          builder: _buildProfileTab,
        ),
      ];
    }

    return _controller.subMenus.map((it) {
      final label = it.nombre;
      final icon = _getIconFromFa(it.icono);
      final rk = it.rutaForma.split('|').first.trim().toLowerCase();

      Widget builder() {
        if (it.iframe.trim() == "1") {
          return _buildPlaceholderTab(label, "iframe=1 • $rk");
        }
        if (rk == "menuestudiante/index") return _buildHomeTab();
        if (rk == "mispostulaciones/mispostulaciones") {
          return _buildApplicationsTab();
        }
        if (rk == "informacionpersonal/index") return _buildProfileTab();
        return _buildPlaceholderTab(label, rk);
      }

      return NavItemData(label: label, icon: icon, builder: builder);
    }).toList();
  }

  IconData _getIconFromFa(String fa) {
    final s = fa.toLowerCase();
    if (s.contains("paper-plane")) return Icons.send_rounded;
    if (s.contains("id-card")) return Icons.badge_outlined;
    if (s.contains("check-square")) return Icons.check_box_outlined;
    if (s.contains("building")) return Icons.apartment_rounded;
    if (s.contains("tasks")) return Icons.task_alt_rounded;
    if (s.contains("list-alt")) return Icons.fact_check_rounded;
    return Icons.circle_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Theme(
        data: Theme.of(context).copyWith(
          useMaterial3: true,
          scaffoldBackgroundColor: borderC,
          colorScheme: ColorScheme.fromSeed(seedColor: primaryC),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final items = _getNavItems();
            final safeIndex =
                (_controller.selectedIndex >= 0 &&
                    _controller.selectedIndex < items.length)
                ? _controller.selectedIndex
                : 0;

            return Scaffold(
              body: SafeArea(
                child: Stack(
                  children: [
                    IndexedStack(
                      index: safeIndex,
                      children: items.map((e) => e.builder()).toList(),
                    ),
                    if (_controller.navLoading)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            color: Colors.white.withValues(alpha: .55),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                    if (_controller.navError != null)
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 92,
                        child: Material(
                          color: Colors.red.withValues(alpha: .92),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _controller.navError!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _controller.bootstrapNavigation,
                                  child: const Text(
                                    "Reintentar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              bottomNavigationBar: DynamicIslandNavBar(
                selectedIndex: safeIndex,
                onSelect: _controller.setIndex,
                items: items,
              ),
            );
          },
        ),
      ),
    );
  }

  // ======================= PESTAÑAS =======================

  Widget _buildHomeTab() {
    final moduleName = _controller.activeMenu?.nombre.trim().isNotEmpty == true
        ? _controller.activeMenu!.nombre
        : "Inicio";
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        _buildSolidSliverAppBar("Hola, ${_controller.pNombres}", moduleName),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: borderC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextField(
                    controller: _controller.searchController,
                    onChanged: _controller.runFilter,
                    decoration: const InputDecoration(
                      hintText: "Buscar...",
                      prefixIcon: Icon(Icons.search_rounded),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: true,
                      label: Text("Vacantes"),
                      icon: Icon(Icons.work_outline_rounded),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text("Empresas"),
                      icon: Icon(Icons.apartment_rounded),
                    ),
                  ],
                  selected: {_controller.showVacanciesTab},
                  onSelectionChanged: (s) =>
                      _controller.toggleVacanciesTab(s.first),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      ProfGhostChip(
                        icon: Icons.place_rounded,
                        label: "Ubicación",
                      ),
                      SizedBox(width: 10),
                      ProfGhostChip(
                        icon: Icons.laptop_mac_rounded,
                        label: "Modalidad",
                      ),
                      SizedBox(width: 10),
                      ProfGhostChip(
                        icon: Icons.star_rounded,
                        label: "Mejor valoradas",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _controller.showVacanciesTab
                      ? "Recomendadas para ti"
                      : "Empresas destacadas",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: textDarkC,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        if (_controller.showVacanciesTab)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => VacancyCard(
                vacancy: _controller.foundVacancies[index],
                isFavorite: _controller.favoriteVacancies.contains(
                  _controller.foundVacancies[index],
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    APPpages.estudianteDettalleOferta,
                    arguments: VacanteDetalleArgs(
                      vacancy: _controller.foundVacancies[index],
                      onPostulate: () => _controller.postulate(
                        _controller.foundVacancies[index],
                      ),
                    ),
                  );
                },
                onFavoriteToggle: () => _controller.toggleFavVacancy(
                  context,
                  _controller.foundVacancies[index],
                ),
              ),
              childCount: _controller.foundVacancies.length,
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => CompanyCard(
                company: _controller.foundCompanies[index],
                isFollowed: _controller.followedCompanies.contains(
                  _controller.foundCompanies[index],
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    APPpages.estudianteRatingEmpresa,
                    arguments: _controller.foundCompanies[index],
                  );
                },
                onFollowToggle: () => _controller.toggleFollowCompany(
                  _controller.foundCompanies[index],
                ),
              ),
              childCount: _controller.foundCompanies.length,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 110)),
      ],
    );
  }

  Widget _buildApplicationsTab() {
    return CustomScrollView(
      slivers: [
        _buildSolidSliverAppBar(
          "Hola, ${_controller.pNombres}",
          "Mis postulaciones",
        ),
        if (_controller.applications.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: ProfEmptyState(
              icon: Icons.folder_open_rounded,
              title: "Aún no tienes postulaciones",
              subtitle: "Cuando te postules a una vacante, aparecerá aquí.",
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => VacancyCard(
                  vacancy: _controller.applications[index],
                  isFavorite: _controller.favoriteVacancies.contains(
                    _controller.applications[index],
                  ),
                  onTap: () {},
                  onFavoriteToggle: () => _controller.toggleFavVacancy(
                    context,
                    _controller.applications[index],
                  ),
                ),
                childCount: _controller.applications.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    return CustomScrollView(
      slivers: [
        _buildSolidSliverAppBar("Hola, ${_controller.pNombres}", "Favoritos"),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  label: Text("Vacantes"),
                  icon: Icon(Icons.bookmark_outline_rounded),
                ),
                ButtonSegment(
                  value: false,
                  label: Text("Empresas"),
                  icon: Icon(Icons.corporate_fare_rounded),
                ),
              ],
              selected: {_controller.showFavVacancies},
              onSelectionChanged: (s) => _controller.toggleFavTab(s.first),
            ),
          ),
        ),
        if (_controller.showFavVacancies)
          (_controller.favoriteVacancies.isEmpty
              ? const SliverFillRemaining(
                  hasScrollBody: false,
                  child: ProfEmptyState(
                    icon: Icons.star_border_rounded,
                    title: "Sin vacantes favoritas",
                    subtitle: "Marca una vacante con ⭐ y aparecerá aquí.",
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => VacancyCard(
                        vacancy: _controller.favoriteVacancies[i],
                        isFavorite: true,
                        onTap: () {},
                        onFavoriteToggle: () => _controller.toggleFavVacancy(
                          context,
                          _controller.favoriteVacancies[i],
                        ),
                      ),
                      childCount: _controller.favoriteVacancies.length,
                    ),
                  ),
                ))
        else
          (_controller.followedCompanies.isEmpty
              ? const SliverFillRemaining(
                  hasScrollBody: false,
                  child: ProfEmptyState(
                    icon: Icons.groups_2_rounded,
                    title: "No sigues empresas",
                    subtitle: "Pulsa “Seguir” en una empresa y aparecerá aquí.",
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => CompanyCard(
                        company: _controller.followedCompanies[i],
                        isFollowed: true,
                        onTap: () {},
                        onFollowToggle: () => _controller.toggleFollowCompany(
                          _controller.followedCompanies[i],
                        ),
                      ),
                      childCount: _controller.followedCompanies.length,
                    ),
                  ),
                )),
      ],
    );
  }

  Widget _buildProfileTab() {
    return ProfessionalProfileScreen(
      cedula: _controller.pCedula,
      fallbackNombres: _controller.pNombres,
      fallbackApellidos: _controller.pApellidos,
      fallbackCelular: _controller.pCelular,
      fallbackCorreoInst: _controller.pCorreoInst,
      fallbackPais: _controller.pPaisRes,
      fallbackCiudad: _controller.pCiudadRes,
      modulePickerAction: _buildModulePickerAction(),
      onLogout: () => _controller.logout(context),
      onViewCv: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CvSimulationScreen(
            cedula: _controller.pCedula,
            nombres: _controller.pNombres,
            apellidos: _controller.pApellidos,
            nacionalidad: "ECUATORIANA",
            correo: _controller.pCorreoInst,
            telf: "",
            celular: _controller.pCelular,
            ciudad: _controller.pCiudadRes,
            pais: _controller.pPaisRes,
            fechaNac: "",
            edad: "",
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String title, String subtitle) {
    return CustomScrollView(
      slivers: [
        _buildSolidSliverAppBar("Hola, ${_controller.pNombres}", title),
        SliverFillRemaining(
          hasScrollBody: false,
          child: ProfEmptyState(
            icon: Icons.construction_rounded,
            title: "Pantalla pendiente",
            subtitle: subtitle,
          ),
        ),
      ],
    );
  }

  //Menu flotante
  SliverAppBar _buildSolidSliverAppBar(String title, String subtitle) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 6,
      backgroundColor: borderC,
      surfaceTintColor: borderC,
      automaticallyImplyLeading: false,
      leading: const SizedBox.shrink(),
      centerTitle: false,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: textDarkC,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textMutedC.withValues(alpha: .95),
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
      actions: [_buildModulePickerAction(), const SizedBox(width: 6)],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: borderC),
      ),
    );
  }

  Widget _buildModulePickerAction() {
    if (_controller.menus.isEmpty || _controller.activeMenu == null) {
      return const SizedBox.shrink();
    }
    return Builder(
      builder: (btnCtx) => IconButton(
        tooltip: "Cambiar módulo",
        icon: const Icon(Icons.dashboard_customize_rounded, color: textDarkC),
        onPressed: _controller.navLoading
            ? null
            : () => _openGlassModuleMenu(btnCtx),
      ),
    );
  }

  Future<void> _openGlassModuleMenu(BuildContext anchorContext) async {
    final overlayState = Overlay.of(anchorContext);
    final overlayBox = overlayState.context.findRenderObject();
    final buttonBox = anchorContext.findRenderObject();
    if (overlayBox is! RenderBox || buttonBox is! RenderBox) return;

    final btnBottomRight = buttonBox.localToGlobal(
      buttonBox.size.bottomRight(Offset.zero),
      ancestor: overlayBox,
    );
    final left = (btnBottomRight.dx - 320).clamp(
      12.0,
      overlayBox.size.width - 320 - 12,
    );
    final top = (btnBottomRight.dy + 8).clamp(
      12.0,
      overlayBox.size.height - 360 - 12,
    );

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "menu",
      barrierColor: Colors.black.withValues(alpha: .08),
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (ctx, a1, a2) => SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              child: GlassModuleMenu(
                menus: _controller.menus,
                activeId: _controller.activeMenu!.moduloId,
                iconResolver: (fa) => _getIconFromFa(fa),
                onPick: (m) {
                  Navigator.of(ctx).pop();
                  if (m.nombre.toLowerCase().contains("institución") ||
                      m.nombre.toLowerCase().contains("institucion")) {
                    Navigator.pushReplacementNamed(
                      context,
                      APPpages.institucionOfertas,
                    );
                  } else {
                    _controller.setActiveMenu(m);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      transitionBuilder: (ctx, anim, sec, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        child: Transform.translate(
          offset: Offset(
            0,
            Tween<double>(begin: -12, end: 0)
                .animate(
                  CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                )
                .value,
          ),
          child: Transform.scale(
            scale: Tween<double>(begin: 0.92, end: 1.0)
                .animate(
                  CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                )
                .value,
            alignment: Alignment.topRight,
            child: child,
          ),
        ),
      ),
    );
  }
}

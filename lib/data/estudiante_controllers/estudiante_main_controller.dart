import 'package:flutter/material.dart';
import 'package:proto_segui/models/company.dart';
import 'package:proto_segui/models/vacancy.dart';
import 'package:proto_segui/network/ug/ug_models.dart';
import 'package:proto_segui/network/ug_client.dart';
import 'package:proto_segui/screens/auth/login_gateway_screen.dart';

class EstudianteMainController extends ChangeNotifier {
  // --- Estados de la UI ---
  int selectedIndex = 0;
  bool showVacanciesTab = true;
  bool showFavVacancies = true;
  final TextEditingController searchController = TextEditingController();

  // --- Datos del Usuario (Perfil) ---
  String pCedula = "092085173";
  String pNombres = "Usuario";
  String pApellidos = "";
  String pCelular = "";
  String pCorreoInst = "";
  String pPaisRes = "ECUADOR";
  String pCiudadRes = "GUAYAQUIL";

  // --- Navegación Dinámica API ---
  bool navLoading = false;
  String? navError;
  String? sessionUsuario;
  int? sessionSistema;

  List<UgMenuItem> menus = [];
  UgMenuItem? activeMenu;
  List<UgSubMenuItem> subMenus = [];
  bool bootstrapped = false;

  final List<Vacancy> _allVacancies = [
    Vacancy(
      id: '1',
      title: 'Desarrollador Backend',
      companyName: 'Bangara S.A',
      location: 'Guayaquil, Guayas',
      modality: 'Presencial',
      description: 'Buscamos experto en Node.js y SQL.',
      rating: 4.2,
      postedDate: 'Hace 3 días',
    ),
    Vacancy(
      id: '2',
      title: 'Desarrollador Java',
      companyName: 'Banco Pichincha',
      location: 'Quito, Pichincha',
      modality: 'Híbrido',
      description: 'Desarrollador Full Stack con Spring Boot.',
      rating: 4.5,
      postedDate: 'Hace 1 día',
    ),
    Vacancy(
      id: '3',
      title: 'Analista QA',
      companyName: 'TATA Consultancy',
      location: 'Guayaquil',
      modality: 'Remoto',
      description: 'Pruebas manuales y automatizadas.',
      rating: 3.8,
      postedDate: 'Hace 5 días',
    ),
  ];

  final List<Company> _allCompanies = [
    Company(
      id: 'c1',
      name: 'Bangara S.A',
      industry: 'Financiera',
      location: 'Guayaquil',
      description: 'Líder en tecnología financiera...',
      rating: 4.2,
      employeeCount: 50,
    ),
    Company(
      id: 'c2',
      name: 'Banco Pichincha',
      industry: 'Banca',
      location: 'Quito',
      description: 'El banco más grande del Ecuador...',
      rating: 4.5,
      employeeCount: 5000,
    ),
  ];

  List<Vacancy> foundVacancies = [];
  List<Company> foundCompanies = [];
  final List<Vacancy> favoriteVacancies = [];
  final List<Company> followedCompanies = [];
  final List<Vacancy> applications = [];

  // --- Inicialización ---
  void init(Map<String, dynamic>? loginData) {
    foundVacancies = List.of(_allVacancies);
    foundCompanies = List.of(_allCompanies);

    if (loginData != null) {
      final cedula = (loginData["cedula"] ?? loginData["username"])?.toString();
      final sistemaId = int.tryParse((loginData["sistemaId"] ?? "").toString());

      if (cedula != null && cedula.isNotEmpty) {
        pCedula = cedula;
        sessionUsuario = cedula;
      }
      if (sistemaId != null) sessionSistema = sistemaId;

      pNombres = loginData["nombre"]?.toString() ?? pNombres;
      pApellidos = loginData["apellidos"]?.toString() ?? pApellidos;
      pCorreoInst = loginData["emailAddress"]?.toString() ?? pCorreoInst;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // --- Lógica de Filtros e Interacciones ---
  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void toggleVacanciesTab(bool value) {
    showVacanciesTab = value;
    searchController.clear();
    runFilter("");
  }

  void toggleFavTab(bool isVacancies) {
    showFavVacancies = isVacancies;
    notifyListeners();
  }

  void runFilter(String keyword) {
    final k = keyword.trim().toLowerCase();
    if (showVacanciesTab) {
      foundVacancies = k.isEmpty
          ? _allVacancies
          : _allVacancies
                .where((v) => v.title.toLowerCase().contains(k))
                .toList();
    } else {
      foundCompanies = k.isEmpty
          ? _allCompanies
          : _allCompanies
                .where((c) => c.name.toLowerCase().contains(k))
                .toList();
    }
    notifyListeners();
  }

  void toggleFavVacancy(BuildContext context, Vacancy v) {
    if (favoriteVacancies.contains(v)) {
      favoriteVacancies.remove(v);
      _showSnack(context, "Eliminado de favoritos");
    } else {
      favoriteVacancies.add(v);
      _showSnack(context, "Agregado a favoritos");
    }
    notifyListeners();
  }

  void toggleFollowCompany(Company c) {
    if (followedCompanies.contains(c)) {
      followedCompanies.remove(c);
    } else {
      followedCompanies.add(c);
    }
    notifyListeners();
  }

  void postulate(Vacancy vacancy) {
    if (!applications.contains(vacancy)) {
      applications.add(vacancy);
      notifyListeners();
    }
  }

  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginGatewayScreen()),
      (route) => false,
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(milliseconds: 650)),
    );
  }

  // --- Lógica de API (Menús de UG) ---
  Future<void> bootstrapNavigation() async {
    if (bootstrapped || sessionUsuario == null || sessionSistema == null) {
      return;
    }
    bootstrapped = true;

    navLoading = true;
    navError = null;
    notifyListeners();

    try {
      final resMenus = await UgClient.instance.obtenerMenu(
        usuario: sessionUsuario!,
        sistema: sessionSistema!,
      );
      UgMenuItem? active = resMenus.where((m) => m.moduloId == 1091).isNotEmpty
          ? resMenus.firstWhere((m) => m.moduloId == 1091)
          : (resMenus.isNotEmpty ? resMenus.first : null);

      if (active == null) throw Exception("No hay módulos disponibles.");

      final sub = await UgClient.instance.obtenerSubMenu(
        usuario: sessionUsuario!,
        sistema: sessionSistema!,
        moduloId: active.moduloId,
      );

      menus = resMenus;
      activeMenu = active;
      subMenus = sub;
      selectedIndex = 0;
      navLoading = false;
      notifyListeners();
    } catch (e) {
      navError = e.toString();
      navLoading = false;
      notifyListeners();
    }
  }

  Future<void> setActiveMenu(UgMenuItem menu) async {
    if (sessionUsuario == null || sessionSistema == null) return;

    navLoading = true;
    navError = null;
    activeMenu = menu;
    selectedIndex = 0;
    notifyListeners();

    try {
      final sub = await UgClient.instance.obtenerSubMenu(
        usuario: sessionUsuario!,
        sistema: sessionSistema!,
        moduloId: menu.moduloId,
      );
      subMenus = sub;
      navLoading = false;
      notifyListeners();
    } catch (e) {
      navError = e.toString();
      navLoading = false;
      notifyListeners();
    }
  }
}

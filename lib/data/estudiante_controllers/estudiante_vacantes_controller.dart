import 'package:flutter/material.dart';
import 'package:proto_segui/models/vacancy.dart';
import 'package:proto_segui/screens/auth/login_gateway_screen.dart';
import 'package:proto_segui/screens/estudiante/Vacantes/create_vacancy_screen.dart';
import 'package:proto_segui/screens/estudiante/Vacantes/edit_vacancy_screen.dart';

class EstudianteVacantesController extends ChangeNotifier {
  int selectedIndex = 1;
  final String companyName = "Bangara S.A";
  int newApplicantsCount = 3;

  final TextEditingController searchCtrl = TextEditingController();

  // Datos simulados
  final List<Vacancy> companyVacancies = [
    Vacancy(
      id: '1',
      title: 'Desarrollador Backend',
      companyName: 'Bangara S.A',
      location: 'Guayaquil, Guayas',
      modality: 'Presencial',
      description: 'Experiencia en Node.js, SQL y NoSQL.',
      rating: 4.2,
      postedDate: 'Hace 3 días',
    ),
    Vacancy(
      id: '2',
      title: 'Analista de Datos',
      companyName: 'Bangara S.A',
      location: 'Quito',
      modality: 'Híbrido',
      description: 'Python, PowerBI y análisis financiero.',
      rating: 4.5,
      postedDate: 'Hace 1 día',
    ),
  ];

  List<Vacancy> foundVacancies = [];

  EstudianteController() {
    foundVacancies = List.of(companyVacancies);
    searchCtrl.addListener(() => runVacancyFilter(searchCtrl.text));
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginGatewayScreen()),
      (route) => false,
    );
  }

  void runVacancyFilter(String keyword) {
    final k = keyword.trim().toLowerCase();
    if (k.isEmpty) {
      foundVacancies = List.of(companyVacancies);
    } else {
      foundVacancies = companyVacancies.where((v) {
        return v.title.toLowerCase().contains(k) ||
            v.location.toLowerCase().contains(k) ||
            v.modality.toLowerCase().contains(k);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> openCreateVacancy(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateVacancyScreen(companyName: companyName),
      ),
    );

    if (result is Vacancy) {
      companyVacancies.insert(0, result);
      runVacancyFilter(searchCtrl.text);
      _showSnackbar(context, "Vacante creada y publicada ✅");
    }
  }

  void openNotifications(BuildContext context) {
    if (newApplicantsCount > 0) {
      _showSnackbar(context, "Tienes $newApplicantsCount nuevos postulantes");
      newApplicantsCount = 0;
      notifyListeners();
    } else {
      _showSnackbar(context, "Sin notificaciones nuevas");
    }
  }

  void deleteVacancy(BuildContext context, Vacancy v) {
    companyVacancies.removeWhere((x) => x.id == v.id);
    runVacancyFilter(searchCtrl.text);
    _showSnackbar(context, "Vacante eliminada");
  }

  Future<void> editVacancy(BuildContext context, Vacancy v) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditVacancyScreen(vacancy: v)),
    );

    if (result is Vacancy) {
      final i = companyVacancies.indexWhere((x) => x.id == v.id);
      if (i != -1) companyVacancies[i] = result;
      runVacancyFilter(searchCtrl.text);
      _showSnackbar(context, "Vacante actualizada ✨");
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(message),
      ),
    );
  }
}

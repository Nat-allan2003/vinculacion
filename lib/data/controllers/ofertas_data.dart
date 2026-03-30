import 'package:flutter/material.dart';
import 'package:proto_segui/screens/auth/login_gateway_screen.dart';
import '../../models/institucion_oferta.dart';

class OfertasData extends ChangeNotifier {
  int selectedIndex = 0;
  List<InstitucionOferta> foundOffers = [];

  // Datos dummy simulando una base de datos o API
  final List<InstitucionOferta> _allOffers = [
    InstitucionOferta(
      id: "1",
      title: "Ayudantía de Cátedra - Programación OOP",
      type: "Ayudantía",
      department: "Facultad de Ciencias Matemáticas y Físicas",
      date: "Hace 2 días",
      description:
          "Se requiere estudiante de 6to semestre en adelante para apoyo en revisión de talleres y tutorías.",
    ),
    InstitucionOferta(
      id: "2",
      title: "Proyecto de Vinculación: App Comunitaria",
      type: "Vinculación",
      department: "Dirección de Vinculación",
      date: "Hoy",
      description:
          "Participa en el desarrollo de una aplicación móvil para la gestión de reciclaje en la comunidad.",
    ),
    InstitucionOferta(
      id: "3",
      title: "Prácticas Internas - Soporte Técnico",
      type: "Prácticas Internas",
      department: "Departamento de TICs",
      date: "Hace 1 semana",
      description:
          "Apoyo en el mantenimiento preventivo y correctivo de los laboratorios de computación.",
    ),
  ];

  OfertasData() {
    foundOffers = List.of(_allOffers);
  }

  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  // 1. Nueva variable para saber si estamos viendo vigentes o vencidas
  bool showVigentes = true;
  String _lastKeyword = "";

  // 2. Método para cambiar el filtro (Vigentes vs Vencidas)
  void setVigentesFilter(bool value) {
    showVigentes = value;
    runFilter(
      _lastKeyword,
    ); // Volvemos a filtrar usando la última palabra buscada
  }

  // 3. Actualiza tu método runFilter actual por este:
  void runFilter(String keyword) {
    _lastKeyword = keyword.trim().toLowerCase();

    foundOffers = _allOffers.where((o) {
      // Filtro de texto
      bool matchText =
          _lastKeyword.isEmpty ||
          o.title.toLowerCase().contains(_lastKeyword) ||
          o.type.toLowerCase().contains(_lastKeyword);

      // Filtro de estado (Simulado: si dice "Cerrada" o "Vencida", no es vigente)
      // Nota: Si tu modelo de base de datos tiene un campo exacto para esto, úsalo aquí.
      bool isOfferVigente =
          o.description.toLowerCase().contains("vencida") == false;

      bool matchStatus = showVigentes ? isOfferVigente : !isOfferVigente;

      return matchText && matchStatus;
    }).toList();

    notifyListeners();
  }

  void logout(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginGatewayScreen()),
          (route) => false,
        );
      }
    });
  }
}

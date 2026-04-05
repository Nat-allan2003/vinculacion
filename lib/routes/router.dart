import 'package:flutter/material.dart';
import 'package:proto_segui/models/company.dart';
import 'package:proto_segui/models/vacancy.dart';
import 'package:proto_segui/routes/pages.dart';
import 'package:proto_segui/screens/auth/login_gateway_screen.dart';
import 'package:proto_segui/screens/auth/login_screen.dart';
import 'package:proto_segui/screens/estudiante/Vacantes/postulantes_screen.dart';
import 'package:proto_segui/screens/institucion/institucion_main_screen.dart';
import 'package:proto_segui/screens/estudiante/estudiante_main_screen.dart';
import 'package:proto_segui/screens/institucion/Ofertas/editar_oferta_screen.dart';
import 'package:proto_segui/screens/institucion/Ofertas/ofertas_main_screen.dart';
import 'package:proto_segui/screens/institucion/Ofertas/publicar_Oferta_screen.dart';
import 'package:proto_segui/screens/institucion/perfilInstitucion/perfil_institucion.dart';
import 'package:proto_segui/screens/professional/company_detail_screen.dart';
import 'package:proto_segui/screens/professional/vacancy_detail_screen.dart';

class APPRouter {
  static Route<dynamic> generadorRutas(RouteSettings config) {
    switch (config.name) {
      case APPpages.inicio:
        return MaterialPageRoute(builder: (_) => LoginGatewayScreen());
      case APPpages.login:
        final role = config.arguments as String;
        return MaterialPageRoute(builder: (_) => LoginScreen(role: role));

      //Case estudiantes
      case APPpages.estudianteHome:
        final loginData = config.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EstudianteMainScreen(loginData: loginData),
        );
      case APPpages.estudiantePostulacion:
        final vacante = config.arguments as Vacancy;
        return MaterialPageRoute(
          builder: (_) => PostulantesScreen(vacancy: vacante),
        );
      case APPpages.estudianteDettalleOferta:
        final vacante = config.arguments as VacanteDetalleArgs;
        return MaterialPageRoute(
          builder: (_) => VacancyDetailScreen(
            vacancy: vacante.vacancy,
            onPostulate: vacante.onPostulate,
          ),
        );
      case APPpages.estudianteRatingEmpresa:
        final vacante = config.arguments as Company;
        return MaterialPageRoute(
          builder: (_) => CompanyDetailScreen(company: vacante),
        );

      // Case Institucione
      case APPpages.institucionHome:
        return MaterialPageRoute(builder: (_) => InstitucionMainScreen());
      case APPpages.institucionOfertas:
        return MaterialPageRoute(builder: (_) => OfertasMainScreen());
      case APPpages.institucionEditarOferta:
        final oferta = config.arguments as dynamic;
        return MaterialPageRoute(
          builder: (_) => EditarOfertaScreen(offer: oferta),
        );
      case APPpages.institucionPublicarOferta:
        return MaterialPageRoute(builder: (_) => PublicarOfertaScreen());
      case APPpages.institucionEditarPerfil:
        return MaterialPageRoute(builder: (_) => PerfilInstitucion());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(child: Text('No existe la ruta: ${config.name}')),
          ),
        );
    }
  }
}

class VacanteDetalleArgs {
  final Vacancy vacancy;
  final VoidCallback onPostulate;

  VacanteDetalleArgs({required this.vacancy, required this.onPostulate});
}

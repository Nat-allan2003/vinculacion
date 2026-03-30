import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditarOferta extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String offerId;

  final TextEditingController cargoCtrl = TextEditingController();
  final TextEditingController areaCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  // Valores de Dropdowns y Selectores
  String? tipoOferta;
  DateTime? expiracion;
  int? numPostulantes;
  TimeOfDay? horarioEntrada;
  TimeOfDay? horarioSalida;
  String? salario;
  String? modalidad;
  String? estadoVacante;
  bool conExperiencia = false;

  // Listas para los dropdowns
  final List<String> tiposOferta = [
    "Pasantía",
    "Práctica Pre Profesional",
    "Empleo Fijo",
    "Ayudantía",
    "Vinculación",
    "Prácticas Internas",
  ];
  final List<int> postulantesOpciones = [1, 2, 3, 4, 5, 10, 20, 50];
  final List<String> salarios = [
    "No remunerado",
    "Básico (\$460)",
    "\$500 - \$800",
    "+\$800",
  ];
  final List<String> modalidades = ["Presencial", "Remoto", "Híbrido"];
  final List<String> estados = ["Disponible", "Pausada", "Cerrada"];

  // Cargar los datos de la oferta existente
  void initData(dynamic offer) {
    offerId = offer.id;
    cargoCtrl.text = offer.title;
    areaCtrl.text = offer.department;
    descCtrl.text = offer.description;

    tipoOferta = tiposOferta.contains(offer.type)
        ? offer.type
        : tiposOferta.first;
    estadoVacante = "Disponible";
    modalidad = "Presencial";
    numPostulantes = 1;

    expiracion = DateTime.now().add(const Duration(days: 15));
    horarioEntrada = const TimeOfDay(hour: 8, minute: 0);
    horarioSalida = const TimeOfDay(hour: 17, minute: 0);
  }

  @override
  void dispose() {
    cargoCtrl.dispose();
    areaCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  void toggleExperiencia(bool? value) {
    conExperiencia = value ?? false;
    notifyListeners();
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: expiracion ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      expiracion = picked;
      notifyListeners();
    }
  }

  Future<void> pickTime(BuildContext context, bool isEntrada) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isEntrada
          ? (horarioEntrada ?? const TimeOfDay(hour: 8, minute: 0))
          : (horarioSalida ?? const TimeOfDay(hour: 17, minute: 0)),
    );
    if (picked != null) {
      if (isEntrada) {
        horarioEntrada = picked;
      } else {
        horarioSalida = picked;
      }
      notifyListeners();
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "dd/mm/aaaa";
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return "--:--";
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  // Devuelve los datos actualizados
  Map<String, dynamic>? saveChanges() {
    if (!formKey.currentState!.validate()) return null;
    if (expiracion == null || horarioEntrada == null || horarioSalida == null)
      return null;

    // Aquí devuelves tu objeto actualizado
    return {
      "id": offerId,
      "title": cargoCtrl.text.trim(),
      "type": tipoOferta!,
      "department": areaCtrl.text.trim(),
      "description": descCtrl.text.trim(),
      "date": "Actualizado recién",
    };
  }
}

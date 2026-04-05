import 'package:flutter/material.dart';
import 'package:proto_segui/utils/colores.dart';
import '../../../models/vacancy.dart';

class CreateVacancyScreen extends StatefulWidget {
  final String companyName;
  const CreateVacancyScreen({super.key, required this.companyName});

  @override
  State<CreateVacancyScreen> createState() => _CreateVacancyScreenState();
}

class _CreateVacancyScreenState extends State<CreateVacancyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String? _location;
  String? _modality;

  final List<String> _locations = const [
    "Guayaquil, Guayas",
    "Quito, Pichincha",
    "Cuenca, Azuay",
    "Remoto",
  ];
  final List<String> _modalities = const ["Presencial", "Híbrido", "Remoto"];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final vacancy = Vacancy(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      companyName: widget.companyName,
      location: _location!,
      modality: _modality!,
      description: _descCtrl.text.trim(),
      rating: 0.0,
      postedDate: "Hoy",
    );

    Navigator.pop(context, vacancy);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundC,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryC),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: generalWhite,
          labelStyle: const TextStyle(
            color: textMutedC,
            fontWeight: FontWeight.w700,
          ),
          floatingLabelStyle: const TextStyle(
            color: primaryC,
            fontWeight: FontWeight.w900,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: borderC),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryC, width: 1.6),
          ),
        ),
      ),
      child: Scaffold(
        body: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            _header(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderC),
                      boxShadow: [
                        BoxShadow(
                          color: generalDark.withOpacity(.04),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Crea una vacante",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: textDarkC,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Título claro + buena descripción = más postulaciones.",
                          style: TextStyle(
                            color: textMutedC,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _titleCtrl,
                          decoration: const InputDecoration(
                            labelText: "Título",
                            hintText: "Ej. Desarrollador Backend",
                            prefixIcon: Icon(Icons.badge_rounded),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return "Ingresa un título";
                            if (v.trim().length < 6)
                              return "El título es muy corto";
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        DropdownButtonFormField<String>(
                          value: _location,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: "Ubicación",
                            prefixIcon: Icon(Icons.location_on_rounded),
                          ),
                          items: _locations
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _location = v),
                          validator: (v) => (v == null || v.isEmpty)
                              ? "Selecciona una ubicación"
                              : null,
                        ),
                        const SizedBox(height: 14),

                        DropdownButtonFormField<String>(
                          value: _modality,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: "Modalidad",
                            prefixIcon: Icon(Icons.laptop_mac_rounded),
                          ),
                          items: _modalities
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _modality = v),
                          validator: (v) => (v == null || v.isEmpty)
                              ? "Selecciona una modalidad"
                              : null,
                        ),
                        const SizedBox(height: 14),

                        TextFormField(
                          controller: _descCtrl,
                          minLines: 5,
                          maxLines: 7,
                          decoration: const InputDecoration(
                            labelText: "Descripción",
                            hintText:
                                "Responsabilidades, requisitos, beneficios...",
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(bottom: 70),
                              child: Icon(Icons.subject_rounded),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return "Escribe una descripción";
                            if (v.trim().length < 30)
                              return "Agrega más detalle (mínimo 30 caracteres)";
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: borderC.withOpacity(.95))),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 22,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: primaryC,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.save_rounded),
                label: const Text(
                  "Guardar vacante",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _header(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 10,
      backgroundColor: backgroundC,
      surfaceTintColor: backgroundC,
      automaticallyImplyLeading: false,
      expandedHeight: 92,
      collapsedHeight: 92,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [secondaryC, secondary2C],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                _RoundIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Center(
                    child: Text(
                      "Crear Vacante",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: generalWhite.withOpacity(.96),
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _RoundIconButton(
                  icon: Icons.info_outline_rounded,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Completa el formulario y guarda la vacante.",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: generalWhite.withOpacity(.16),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: generalWhite.withOpacity(.22)),
          ),
          child: Icon(icon, color: generalWhite),
        ),
      ),
    );
  }
}

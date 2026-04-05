import 'package:flutter/material.dart';
import 'package:proto_segui/routes/pages.dart';
import 'package:proto_segui/routes/router.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seguimiento Graduados',
      theme: AppTheme.getTheme(),
      initialRoute: APPpages.inicio,
      onGenerateRoute: APPRouter.generadorRutas,
    );
  }
}

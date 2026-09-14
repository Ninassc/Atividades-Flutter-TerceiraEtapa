import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'pages/pagina_inicial.dart';
import 'viewmodels/tarefa_viewmodel.dart';

void main() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  runApp(
    DevicePreview(
      builder: (context) => const MeuApp(),
    ),
  );
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Disponibiliza a TarefaViewModel
    // para os widgets abaixo.
    return ChangeNotifierProvider(
      create: (context) => TarefaViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // Integra o MaterialApp ao DevicePreview.
        builder: DevicePreview.appBuilder,

        locale: DevicePreview.locale(context),

        home: const PaginaInicial(),
      ),
    );
  }
}

import 'package:controle_estoque/pages/login_page.dart';
import 'package:controle_estoque/viewmodels/produto_viewmodel.dart';
import 'package:controle_estoque/viewmodels/usuario_viewmodel.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(
    DevicePreview(
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProdutoViewmodel()),
          ChangeNotifierProvider(create: (_) => UsuarioViewmodel()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color.fromARGB(255, 61, 61, 61),
          textTheme: TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
            bodyLarge: TextStyle(color: Colors.white),
            bodySmall: TextStyle(color: Colors.white),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color.fromARGB(255, 34, 34, 34),
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange),
                iconTheme: IconThemeData(
                  color: Colors.white
                ),
          )),
      home: LoginPage(),
    );
  }
}

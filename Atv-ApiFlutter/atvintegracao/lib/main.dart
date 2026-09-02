import 'package:atvintegracao/pages/home_page.dart';
import 'package:atvintegracao/providers/voo_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(DevicePreview(
      builder: (context) => ChangeNotifierProvider(
            create: (context) => VooProvider(),
            child: MyApp(),
          )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 27, 27, 27),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 27, 27, 27),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 30,
            color: const Color.fromARGB(255, 247, 237, 237),
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color.fromARGB(255, 247, 237, 237)),
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 48, 47, 47),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Color.fromARGB(255, 247, 237, 237),
            fontSize: 18,
          ),
          bodyLarge: TextStyle(color: Color.fromARGB(255, 247, 237, 237)),
          bodySmall: TextStyle(color: Color.fromARGB(255, 247, 237, 237)),
        ),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 247, 237, 237)),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 247, 237, 237)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 243, 221, 221)),
          ),
          labelStyle: TextStyle(color: Color.fromARGB(207, 218, 214, 214)),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.grey,
          contentTextStyle: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 247, 237, 237),
          ),
        ),
        cardTheme: CardThemeData(
          color: Color.fromARGB(255, 27, 27, 27).withAlpha(100),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 27, 27, 27), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:your_app_buscacep/screen/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busca Cep',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 86, 235, 66)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Busca CEP'),
    );
  }
}

import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Crop Yield Predictor",
      theme: ThemeData(primarySwatch: Colors.green),
      routes: {
        '/': (context) => const HomePage(),
        '/about': (context) => const AboutPage(),
      },
      initialRoute: '/',
    );
  }
}

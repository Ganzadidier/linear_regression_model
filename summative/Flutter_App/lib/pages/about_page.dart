import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "This app predicts crop yield using ML model via FastAPI backend.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

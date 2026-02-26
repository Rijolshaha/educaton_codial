import 'package:flutter/material.dart';

class AuksionPage extends StatefulWidget {
  const AuksionPage({super.key});

  @override
  State<AuksionPage> createState() => _AuksionPageState();
}

class _AuksionPageState extends State<AuksionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Auksion page"),
      ),
    );
  }
}

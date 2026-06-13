import 'package:educaton_codial/pages/auth_gate.dart';

import 'package:flutter/material.dart';



void main() {

  ErrorWidget.builder = (FlutterErrorDetails details) {

    return Container(

      padding: const EdgeInsets.all(12),

      color: const Color(0xFFFFF1F2),

      alignment: Alignment.center,

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          const Icon(Icons.error_outline_rounded,

              color: Color(0xFFDC2626), size: 28),

          const SizedBox(height: 6),

          Text(

            details.exceptionAsString(),

            textAlign: TextAlign.center,

            style: const TextStyle(

              color: Color(0xFFB91C1C),

              fontSize: 11,

              fontWeight: FontWeight.w600,

            ),

          ),

        ],

      ),

    );

  };



  runApp(const MyApp());

}



class MyApp extends StatelessWidget {

  const MyApp({super.key});



  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      home: const AuthGate(),

    );

  }

}



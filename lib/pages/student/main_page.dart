import 'package:educaton_codial/pages/student/auksion_page.dart';
import 'package:educaton_codial/pages/student/book_page.dart';
import 'package:educaton_codial/pages/student/home_page.dart';
import 'package:educaton_codial/pages/student/rating_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currentIndex = 0;
  List<Widget> list = [
    HomePage(),
    RatingPage(),
    BookPage(),
    AuksionPage()
  ];

  void onTap(int index){
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
          items: [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard),label: "Bosh sahifa"),
        BottomNavigationBarItem(icon: Icon(Icons.cloud_upload),label: "Bosh sahifa"),
        BottomNavigationBarItem(icon: Icon(Icons.book),label: "Bosh sahifa"),
        BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Bosh sahifa"),
      ]),
    );
  }
}

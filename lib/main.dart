import 'package:flutter/material.dart';
import '../screens/home_page.dart';
// Main - Włączenie aplikacji
void main() {
  runApp(const MyApp());
}
final ButtonStyle globalButtonStyle = ElevatedButton.styleFrom(
  padding: EdgeInsets.zero,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  backgroundColor: Colors.grey.shade800,
  foregroundColor: Colors.white,
  elevation: 2,
  shadowColor: Colors.white,
);
// Style aplikacji i takie tam
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Material app - materiał aplikacji, czyli tytuł podstawowe parametry
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalkulator',
      // theme- styl domyślny/główny
      theme: ThemeData(
        // Styl dla przycisków
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: globalButtonStyle
        ),


        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade800),
      ),
      home: const HomePage(title: 'Kalkulator'),
    );
  }
}
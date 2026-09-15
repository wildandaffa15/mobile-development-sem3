import 'package:flutter/material.dart';
// import 'package:profil_mahasiswa/modul_01/profile_screen.dart';
// import 'package:profil_mahasiswa/modul_02/academic_dashboard_screen.dart';
import 'modul_02/studi_kasus/ruang_praktikum.dart';

void main() {
  runApp(const PoliwangiApp());
}

class PoliwangiApp extends StatelessWidget {
  const PoliwangiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ruang Praktikum',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
        ),
        useMaterial3: true,
      ),
      home: const RuangPraktikum(),
    );
  }
}
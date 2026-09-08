import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profil_mahasiswa/modul_01/profile_screen.dart';

void main() {
  testWidgets('Modul 01 - Profil Mahasiswa tampil dengan benar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    // Memastikan judul AppBar tampil
    expect(find.text('Profil Mahasiswa'), findsOneWidget);

    // Memastikan nama mahasiswa tampil
    expect(find.text('Wildan Daffa Akmal Putra'), findsOneWidget);

    // Memastikan NIM tampil
    expect(find.text('NIM: 362558302098'), findsOneWidget);

    // Memastikan jurusan tampil
    expect(find.text('Bisnis dan Informatika'), findsOneWidget);

    // Memastikan program studi tampil
    expect(find.text('Sarjana Terapan TRPL'), findsOneWidget);

    // Memastikan kampus tampil
    expect(find.text('Politeknik Negeri Banyuwangi'), findsOneWidget);

    // Memastikan semester tampil
    expect(find.text('Semester 3 (2026/2027)'), findsOneWidget);
  });
}

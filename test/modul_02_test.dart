import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:profil_mahasiswa/modul_02/models/course.dart';
import 'package:profil_mahasiswa/modul_02/widgets/course_card.dart';
import 'package:profil_mahasiswa/modul_02/academic_dashboard_screen.dart';

void main() {
  group('Modul 02 Autograding: Declarative UI & Responsive Layout', () {
    // ===============================================================
    // TEST 1
    // ===============================================================

    test('1. Model Course mengembalikan daftar data sample valid', () {
      final sample = Course.getSampleCourses();

      expect(sample.length, greaterThanOrEqualTo(4));

      expect(sample.first.code, equals('TRPL501'));

      expect(sample.first.sks, greaterThan(0));

      // Memastikan kategori tersedia
      expect(sample.first.category, isNotEmpty);
    });

    // ===============================================================
    // TEST 2
    // ===============================================================

    testWidgets(
      '2. CourseCard merender nama mata kuliah, dosen, dan badge SKS',
      (WidgetTester tester) async {
        const course = Course(
          code: 'TEST101',
          name: 'Algoritma Pemrograman',
          lecturer: 'Dosen Penguji',
          sks: 3,
          progress: 0.5,
          category: 'Teori',
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: CourseCard(course: course)),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('TEST101'), findsOneWidget);

        expect(find.text('Algoritma Pemrograman'), findsOneWidget);

        expect(find.text('Dosen Penguji'), findsOneWidget);

        expect(find.text('3 SKS'), findsOneWidget);

        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      },
    );

    // ===============================================================
    // TEST 3
    // ===============================================================

    testWidgets('3. AcademicDashboardScreen adaptif terhadap ukuran layar', (
      WidgetTester tester,
    ) async {
      // -------------------------------------------------------------
      // MOBILE
      // -------------------------------------------------------------

      tester.view.physicalSize = const Size(400, 800);

      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(home: AcademicDashboardScreen()),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);

      expect(find.byType(GridView), findsNothing);

      // -------------------------------------------------------------
      // TABLET / DESKTOP
      // -------------------------------------------------------------

      tester.view.physicalSize = const Size(800, 600);

      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(home: AcademicDashboardScreen()),
      );

      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);

      expect(find.byType(ListView), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);

      addTearDown(tester.view.resetDevicePixelRatio);
    });

    // ===============================================================
    // TEST 4 - TANTANGAN 1
    // ===============================================================

    testWidgets('4. Filter kategori menggunakan Wrap dan ChoiceChip', (
      WidgetTester tester,
    ) async {
      // Gunakan ukuran mobile agar ListView mudah dites.
      tester.view.physicalSize = const Size(400, 800);

      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(home: AcademicDashboardScreen()),
      );

      await tester.pumpAndSettle();

      // -----------------------------------------------------------
      // Pastikan 3 ChoiceChip tersedia
      // -----------------------------------------------------------

      expect(find.byType(ChoiceChip), findsNWidgets(3));

      expect(find.text('Semua'), findsOneWidget);

      expect(find.text('Teori'), findsOneWidget);

      expect(find.text('Praktikum'), findsOneWidget);

      // -----------------------------------------------------------
      // Kondisi awal = Semua
      // -----------------------------------------------------------

      expect(find.text('TRPL501'), findsOneWidget);

      expect(find.text('TRPL502'), findsOneWidget);

      expect(find.text('TRPL503'), findsOneWidget);

      expect(find.text('TRPL504'), findsOneWidget);

      // -----------------------------------------------------------
      // Klik filter Teori
      // -----------------------------------------------------------

      await tester.tap(find.widgetWithText(ChoiceChip, 'Teori'));

      await tester.pumpAndSettle();

      // Mata kuliah Teori harus tampil
      expect(find.text('TRPL502'), findsOneWidget);

      expect(find.text('TRPL503'), findsOneWidget);

      // Mata kuliah Praktikum harus hilang
      expect(find.text('TRPL501'), findsNothing);

      expect(find.text('TRPL504'), findsNothing);

      // -----------------------------------------------------------
      // Klik filter Praktikum
      // -----------------------------------------------------------

      await tester.tap(find.widgetWithText(ChoiceChip, 'Praktikum'));

      await tester.pumpAndSettle();

      // Mata kuliah Praktikum harus tampil
      expect(find.text('TRPL501'), findsOneWidget);

      expect(find.text('TRPL504'), findsOneWidget);

      // Mata kuliah Teori harus hilang
      expect(find.text('TRPL502'), findsNothing);

      expect(find.text('TRPL503'), findsNothing);

      // -----------------------------------------------------------
      // Kembali ke Semua
      // -----------------------------------------------------------

      await tester.tap(find.widgetWithText(ChoiceChip, 'Semua'));

      await tester.pumpAndSettle();

      expect(find.text('TRPL501'), findsOneWidget);

      expect(find.text('TRPL502'), findsOneWidget);

      expect(find.text('TRPL503'), findsOneWidget);

      expect(find.text('TRPL504'), findsOneWidget);

      // Reset ukuran layar
      addTearDown(tester.view.resetPhysicalSize);

      addTearDown(tester.view.resetDevicePixelRatio);
    });
  });
}

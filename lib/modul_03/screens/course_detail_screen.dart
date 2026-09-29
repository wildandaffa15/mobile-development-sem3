import 'package:flutter/material.dart';

import '../models/krs_course.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({
    super.key,
    this.course,
    this.courseCode,
  }) : assert(course != null || courseCode != null);

  final KrsCourse? course;
  final String? courseCode;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool _hasError = false;

  KrsCourse get _course {
    if (widget.course != null) return widget.course!;

    return KrsCourse.getInitialCourses().firstWhere(
      (course) => course.code == widget.courseCode,
      orElse: () => const KrsCourse(
        code: 'TRPL501',
        name: 'Pemrograman Perangkat Bergerak',
        lecturer: 'Sepyan Purnama Kristanto, M.Kom.',
        sks: 3,
      ),
    );
  }

  void _simulasikanError() {
    setState(() => _hasError = true);
  }

  void _cobaLagi() {
    setState(() => _hasError = false);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final course = _course;

    return Scaffold(
      appBar: AppBar(title: Text(course.code)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _hasError
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    const Text('Gagal Mengambil Data Silabus'),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _cobaLagi,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi (Retry)'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('${course.sks} SKS'),
                  const SizedBox(height: 8),
                  Text(
                    course.lecturer,
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    course.description.isNotEmpty
                        ? course.description
                        : 'Belum ada deskripsi silabus untuk mata kuliah ini.',
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: _simulasikanError,
                    icon: const Icon(Icons.bug_report),
                    label: const Text('Simulasikan Error'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali ke Daftar KRS'),
                  ),
                ],
              ),
      ),
    );
  }
}
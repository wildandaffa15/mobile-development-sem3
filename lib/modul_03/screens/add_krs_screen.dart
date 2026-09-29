import 'package:flutter/material.dart';

import '../models/krs_course.dart';

class AddKrsScreen extends StatefulWidget {
  const AddKrsScreen({super.key});

  @override
  State<AddKrsScreen> createState() => _AddKrsScreenState();
}

class _AddKrsScreenState extends State<AddKrsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lecturerController = TextEditingController();
  final TextEditingController _sksController = TextEditingController(text: '3');

  @override
  void dispose() {
    // Wajib: setiap controller harus dibebaskan agar tidak bocor memori.
    _codeController.dispose();
    _nameController.dispose();
    _lecturerController.dispose();
    _sksController.dispose();

    super.dispose();
  }

  void _simpan() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final KrsCourse courseBaru = KrsCourse(
      code: _codeController.text.trim().toUpperCase(),
      name: _nameController.text.trim(),
      lecturer: _lecturerController.text.trim(),
      sks: int.tryParse(_sksController.text.trim()) ?? 3,
    );

    Navigator.pop(context, courseBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Mata Kuliah')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Kode Mata Kuliah',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Kode mata kuliah wajib diisi.';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Mata Kuliah',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama mata kuliah wajib diisi.';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _lecturerController,
              decoration: const InputDecoration(
                labelText: 'Dosen',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama dosen wajib diisi.';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _sksController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'SKS',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'SKS wajib diisi.';
                }

                final int? sks = int.tryParse(value.trim());

                if (sks == null) {
                  return 'SKS harus berupa angka.';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _simpan,
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

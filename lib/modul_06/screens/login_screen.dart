import 'package:flutter/material.dart';

import '../models/sesi_pengguna.dart';
import '../services/auth_api.dart';
import '../services/sesi_memori.dart';
import '../widgets/field_kata_sandi.dart';
import '../widgets/kartu_sesi.dart';

class LoginScreen extends StatefulWidget {
  final AuthApi api;
  final SesiMemori sesiMemori;
  final DateTime Function() jam;

  const LoginScreen({
    super.key,
    required this.api,
    required this.sesiMemori,
    this.jam = DateTime.now,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _sandi = TextEditingController();

  StatusAuth _status = StatusAuth.memeriksa;
  String? _pesanGagal;
  SesiPengguna? _sesi;
  bool _sedangKeluar = false;

  @override
  void initState() {
    super.initState();
    _pulihkanSesi(); // Didefinisikan pada langkah 7.
  }

  @override
  void dispose() {
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modul 06 — Login & Session Dasar'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(child: _bangunIsi()),
    );
  }

  /// Satu-satunya tempat yang memutuskan layar mana yang tampil.
  Widget _bangunIsi() {
    switch (_status) {
      case StatusAuth.memeriksa:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memeriksa sesi tersimpan…'),
            ],
          ),
        );
      case StatusAuth.masuk:
        final SesiPengguna? sesi = _sesi;
        if (sesi == null) {
          return _bangunForm();
        }
        return _bangunBeranda(sesi);
      case StatusAuth.keluar:
      case StatusAuth.memproses:
      case StatusAuth.gagal:
        return _bangunForm();
    }
  }

  Future<void> _pulihkanSesi() async {
    final SesiPengguna? tersimpan = widget.sesiMemori.baca();
    if (!mounted) return;

    if (tersimpan == null) {
      setState(() => _status = StatusAuth.keluar);
      return;
    }

    if (tersimpan.sudahKedaluwarsa(widget.jam())) {
      await widget.sesiMemori.hapus();
      if (!mounted) return;
      setState(() {
        _status = StatusAuth.gagal;
        _pesanGagal = 'Sesi sebelumnya sudah berakhir. Silakan masuk lagi.';
      });
      return;
    }

    setState(() {
      _sesi = tersimpan;
      _status = StatusAuth.masuk;
    });
  }

  Widget _bangunForm() {
    final bool memproses = _status == StatusAuth.memproses;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Icon(Icons.lock_person_outlined, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Masuk ke Ruang Praktikum',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gunakan email dan kata sandi untuk membuat sesi simulasi.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _email,
                  enabled: !memproses,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[AutofillHints.username],
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    final String email = value?.trim() ?? '';
                    if (email.isEmpty) return 'Email wajib diisi.';
                    if (!email.contains('@') || email.startsWith('@')) {
                      return 'Masukkan alamat email yang valid.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FieldKataSandi(
                  controller: _sandi,
                  enabled: !memproses,
                  onSubmitted: memproses ? null : _kirim,
                  validator: (String? value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Kata sandi wajib diisi.';
                    }
                    if (value!.trim().length < 6) {
                      return 'Kata sandi minimal 6 karakter.';
                    }
                    return null;
                  },
                ),
                if (_pesanGagal != null) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(
                    _pesanGagal!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: memproses ? null : _kirim,
                  icon: memproses
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.login),
                  label: Text(memproses ? 'Memproses…' : 'Masuk'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Mode simulasi: email valid dan kata sandi minimal 6 karakter.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bangunBeranda(SesiPengguna sesi) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        const Icon(Icons.verified_user_outlined, size: 56),
        const SizedBox(height: 12),
        Text(
          'Berhasil masuk',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        KartuSesi(
          sesi: sesi,
          sekarang: widget.jam(),
          sedangKeluar: _sedangKeluar,
          onKeluar: _sedangKeluar ? null : _keluar,
        ),
      ],
    );
  }

  Future<void> _kirim() async {
    if (_status == StatusAuth.memproses) return; // Cegah kirim ganda.
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _status = StatusAuth.memproses;
      _pesanGagal = null;
    });

    try {
      final SesiPengguna hasil = await widget.api.masuk(
        email: _email.text,
        sandi: _sandi.text,
      );
      await widget.sesiMemori.simpan(hasil);
      if (!mounted) return;
      setState(() {
        _sesi = hasil;
        _status = StatusAuth.masuk;
        _sandi.clear();
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _status = StatusAuth.gagal;
        _pesanGagal = e.pesan;
      });
    } catch (e) {
      // Kesalahan tak terduga TIDAK dibocorkan ke layar.
      if (!mounted) return;
      setState(() {
        _status = StatusAuth.gagal;
        _pesanGagal = 'Terjadi kesalahan tak terduga. Coba lagi.';
      });
      debugPrint('Login gagal tak terduga: $e');
    }
  }

  Future<void> _keluar() async {
    setState(() => _sedangKeluar = true);
    await widget.sesiMemori.hapus();
    if (!mounted) return;
    setState(() {
      _sesi = null;
      _status = StatusAuth.keluar; // Bukan StatusAuth.gagal.
      _pesanGagal = null;
      _sedangKeluar = false;
      _email.clear();
      _sandi.clear();
    });
  }
}

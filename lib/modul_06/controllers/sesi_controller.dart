import 'package:flutter/foundation.dart';

import '../models/sesi_pengguna.dart';
import '../services/auth_api.dart';
import '../repositories/sesi_repository.dart';

enum StatusSesi { memeriksa, keluar, memproses, masuk, gagal, kedaluwarsa }

class SesiController extends ChangeNotifier {
  final SesiRepository repository;
  final AuthApi api;
  final DateTime Function() jam;

  SesiController({
    required this.repository,
    required this.api,
    DateTime Function()? jam,
  }) : jam = jam ?? DateTime.now;

  StatusSesi _status = StatusSesi.memeriksa;
  SesiPengguna? _sesi;
  String? _pesan;

  StatusSesi get status => _status;
  SesiPengguna? get sesi => _sesi;
  String? get pesan => _pesan;

  void _ubah(
    StatusSesi status, {
    SesiPengguna? sesi,
    String? pesan,
    bool bersihkanPesan = false,
  }) {
    _status = status;
    if (sesi != null || status == StatusSesi.keluar ||
        status == StatusSesi.kedaluwarsa) {
      _sesi = sesi;
    }
    if (bersihkanPesan) _pesan = null;
    if (pesan != null) _pesan = pesan;
    notifyListeners();
  }

  Future<void> pulihkan() async {
    _ubah(StatusSesi.memeriksa, bersihkanPesan: true);
    final SesiPengguna? tersimpan = await repository.baca();

    if (tersimpan == null) {
      _ubah(StatusSesi.keluar, sesi: null);
      return;
    }

    if (tersimpan.sudahKedaluwarsa(jam())) {
      await repository.hapus();
      _ubah(
        StatusSesi.kedaluwarsa,
        sesi: null,
        pesan: 'Sesi Anda sudah berakhir. Silakan masuk kembali.',
      );
      return;
    }

    _ubah(StatusSesi.masuk, sesi: tersimpan);
  }

  Future<void> masuk({
    required String email,
    required String sandi,
  }) async {
    _ubah(StatusSesi.memproses, bersihkanPesan: true);
    try {
      final SesiPengguna hasil =
          await api.masuk(email: email, sandi: sandi);
      await repository.simpan(hasil);
      _ubah(StatusSesi.masuk, sesi: hasil);
    } on AuthException catch (e) {
      _ubah(StatusSesi.gagal, pesan: e.pesan);
    } catch (_) {
      _ubah(
        StatusSesi.gagal,
        pesan: 'Terjadi kesalahan tak terduga. Coba lagi.',
      );
    }
  }

  Future<void> keluar() async {
    await repository.hapus();
    _ubah(StatusSesi.keluar, sesi: null, bersihkanPesan: true);
  }

  Future<void> perbaruiSesi({
    Duration masaBerlaku = const Duration(hours: 2),
  }) async {
    final SesiPengguna? sekarang = _sesi;
    if (sekarang == null) return;

    if (sekarang.sudahKedaluwarsa(jam())) {
      await repository.hapus();
      _ubah(
        StatusSesi.kedaluwarsa,
        sesi: null,
        pesan: 'Sesi sudah berakhir dan tidak dapat diperbarui.',
      );
      return;
    }

    try {
      final SesiPengguna baru =
          await api.perbaruiSesi(sekarang, masaBerlaku: masaBerlaku);
      await repository.simpan(baru);
      _ubah(StatusSesi.masuk, sesi: baru);
    } on AuthException catch (e) {
      _ubah(StatusSesi.gagal, pesan: e.pesan);
    }
  }
}

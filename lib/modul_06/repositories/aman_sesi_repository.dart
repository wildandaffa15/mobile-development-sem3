import 'dart:convert';

import '../models/sesi_pengguna.dart';
import '../storage/penyimpanan_aman.dart';
import 'sesi_repository.dart';

class AmanSesiRepository implements SesiRepository {
  static const String kunciSesi = 'sesi_pengguna';
  final PenyimpananAman penyimpanan;

  const AmanSesiRepository({required this.penyimpanan});

  @override
  String get nama => 'Penyimpanan Aman';

  @override
  String get keterangan => 'Menyimpan data sesi melalui adapter penyimpanan aman.';

  @override
  bool get bertahanSetelahRestart => true;

  @override
  Future<SesiPengguna?> baca() async {
    final String? mentah = await penyimpanan.baca(kunciSesi);
    if (mentah == null || mentah.isEmpty) return null;
    try {
      final Object? hasil = jsonDecode(mentah);
      if (hasil is! Map<String, dynamic>) return null;
      return SesiPengguna.fromJson(hasil);
    } on FormatException {
      await hapus();
      return null;
    }
  }

  @override
  Future<void> simpan(SesiPengguna sesi) {
    return penyimpanan.tulis(kunciSesi, jsonEncode(sesi.toJson()));
  }

  @override
  Future<void> hapus() => penyimpanan.hapus(kunciSesi);

  @override
  Future<bool> adaSesi() async => await baca() != null;

  @override
  Future<String?> intipMentah() => penyimpanan.bacaMentah(kunciSesi);
}

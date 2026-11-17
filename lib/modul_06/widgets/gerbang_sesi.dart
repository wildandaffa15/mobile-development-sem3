import 'package:flutter/material.dart';

import '../models/sesi_pengguna.dart';

class GerbangSesi extends StatelessWidget {
  final WidgetBuilder form;
  final Widget Function(BuildContext context, SesiPengguna sesi) beranda;
  final bool sedangMemeriksa;
  final SesiPengguna? sesi;

  const GerbangSesi({
    super.key,
    required this.form,
    required this.beranda,
    this.sedangMemeriksa = false,
    this.sesi,
  });

  @override
  Widget build(BuildContext context) {
    if (sedangMemeriksa) {
      return const Center(child: CircularProgressIndicator());
    }
    final SesiPengguna? sesiAktif = sesi;
    if (sesiAktif == null) return form(context);
    return beranda(context, sesiAktif);
  }
}

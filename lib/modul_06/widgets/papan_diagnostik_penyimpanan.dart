import 'package:flutter/material.dart';

import '../repositories/sesi_repository.dart';

class PapanDiagnostikPenyimpanan extends StatefulWidget {
  final SesiRepository repository;

  const PapanDiagnostikPenyimpanan({
    super.key,
    required this.repository,
  });

  @override
  State<PapanDiagnostikPenyimpanan> createState() =>
      _PapanDiagnostikPenyimpananState();
}

class _PapanDiagnostikPenyimpananState
    extends State<PapanDiagnostikPenyimpanan> {
  bool _sedangMengintip = false;
  bool _sudahMengintip = false;
  String? _hasilIntip;

  Future<void> _intip() async {
    setState(() => _sedangMengintip = true);
    try {
      final String? hasil = await widget.repository.intipMentah();
      if (!mounted) return;
      setState(() {
        _hasilIntip = hasil;
        _sudahMengintip = true;
        _sedangMengintip = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasilIntip = null;
        _sudahMengintip = true;
        _sedangMengintip = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Diagnostik Penyimpanan',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Adapter: ${widget.repository.nama}'),
            Text(widget.repository.keterangan),
            Text(widget.repository.bertahanSetelahRestart
                ? 'Sesi dirancang bertahan setelah aplikasi dimulai ulang.'
                : 'Sesi hanya tersedia selama aplikasi berjalan.'),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _sedangMengintip ? null : _intip,
              child: Text(_sedangMengintip ? 'Memeriksa…' : 'Periksa API mentah'),
            ),
            if (_sudahMengintip)
              SelectableText(_hasilIntip ?? 'Tidak tersedia melalui adapter ini.'),
          ],
        ),
      ),
    );
  }
}

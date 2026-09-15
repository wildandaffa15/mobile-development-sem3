import 'package:flutter/material.dart';

class RuangPraktikum extends StatefulWidget {
  const RuangPraktikum({super.key});

  @override
  State<RuangPraktikum> createState() => _RuangPraktikumState();
}

class _RuangPraktikumState extends State<RuangPraktikum> {
  bool dark = false;

  final sesi = [
    {
      'nama': 'Mobile Programming',
      'jam': '08.00 - 10.00',
      'lokasi': 'Lab 1',
      'status': 'Berlangsung',
      'type': 'ongoing',
      'pesan': 'Sedang digunakan oleh praktikan',
    },
    {
      'nama': 'Rekayasa Perangkat Lunak',
      'jam': '10.00 - 12.00',
      'lokasi': 'Lab 2',
      'status': 'Akan datang',
      'type': 'upcoming',
      'pesan': 'Sesi akan dimulai sebentar lagi',
    },
    {
      'nama': 'Basis Data',
      'jam': '13.00 - 15.00',
      'lokasi': 'Lab 3',
      'status': 'Selesai',
      'type': 'finished',
      'pesan': 'Sesi telah selesai',
    },
    {
      'nama': 'Lab 2',
      'jam': '',
      'lokasi': '',
      'status': 'Tersedia',
      'type': 'available',
      'pesan': 'Ruang tersedia di luar jadwal sesi',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          brightness: dark ? Brightness.dark : Brightness.light,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ruang Praktikum',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF0284C7),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () => setState(() => dark = !dark),
              icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, c) {
            final width = c.maxWidth;
            final padding = width < 600 ? 16.0 : 24.0;
            final columns = width < 600 ? 1 : width < 1000 ? 2 : 3;
            final cardWidth =
                (width - padding * 2 - 12 * (columns - 1)) / columns;

            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ruang Praktikum Hari Ini',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          _badge(Icons.calendar_month, '3 sesi'),
                          _badge(Icons.meeting_room, '1 ruang tersedia'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: sesi
                            .map(
                              (item) => SizedBox(
                                width: cardWidth,
                                child: _card(item),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _badge(IconData icon, String text) {
    return Chip(
      avatar: Icon(
        icon,
        size: 18,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(text),
    );
  }

  Widget _card(Map<String, String> item) {
    final type = item['type']!;
    final theme = Theme.of(context);

    final colors = {
      'ongoing': (
        bg: Colors.blue,
        fg: Colors.white,
        info: Colors.blue.shade50,
        infoFg: Colors.blue.shade800,
        icon: Icons.groups_rounded,
      ),
      'upcoming': (
        bg: Colors.amber,
        fg: Colors.black,
        info: Colors.amber.shade50,
        infoFg: Colors.amber.shade900,
        icon: Icons.access_time_rounded,
      ),
      'finished': (
        bg: Colors.grey,
        fg: Colors.white,
        info: Colors.grey.shade200,
        infoFg: Colors.grey.shade800,
        icon: Icons.check_circle_rounded,
      ),
      'available': (
        bg: Colors.green,
        fg: Colors.white,
        info: Colors.green.shade50,
        infoFg: Colors.green.shade800,
        icon: Icons.meeting_room_rounded,
      ),
    }[type]!;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: () => _detail(item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 95),
                child: Text(
                  item['nama']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Positioned(
                top: 0,
                right: 0,
                child: _status(
                  item['status']!,
                  colors.bg,
                  colors.fg,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item['jam']!.isNotEmpty) ...[
                      _info(
                        Icons.access_time_rounded,
                        item['jam']!,
                      ),
                      const SizedBox(height: 7),
                      _info(
                        Icons.location_on_rounded,
                        item['lokasi']!,
                      ),
                    ],
                    const SizedBox(height: 12),
                    _infoBox(
                      colors.icon,
                      item['pesan']!,
                      colors.info,
                      colors.infoFg,
                    ),
                    if (type == 'available') ...[
                      const SizedBox(height: 8),
                      _infoBox(
                        Icons.meeting_room_rounded,
                        'Siap digunakan\nuntuk praktikum lain',
                        theme.colorScheme.secondaryContainer,
                        theme.colorScheme.onSecondaryContainer,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _status(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _infoBox(
    IconData icon,
    String text,
    Color bg,
    Color fg,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: fg),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                height: 1.25,
                fontWeight: FontWeight.w500,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _detail(Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detail Praktikum',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item['nama']!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (item['jam']!.isNotEmpty)
                _detailItem(
                  Icons.access_time,
                  'Jam',
                  item['jam']!,
                ),
              if (item['lokasi']!.isNotEmpty)
                _detailItem(
                  Icons.location_on,
                  'Lokasi',
                  item['lokasi']!,
                ),
              _detailItem(
                Icons.info,
                'Status',
                item['status']!,
              ),
              _detailItem(
                Icons.notes,
                'Keterangan',
                item['pesan']!,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  softWrap: true,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
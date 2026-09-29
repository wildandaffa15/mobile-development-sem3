class KrsCourse {
  const KrsCourse({
    required this.code,
    required this.name,
    required this.lecturer,
    required this.sks,
    this.description = '',
  });

  final String code;
  final String name;
  final String lecturer;
  final int sks;
  final String description;

  static List<KrsCourse> getInitialCourses() {
    return const [
      KrsCourse(
        code: 'TRPL501',
        name: 'Pemrograman Perangkat Bergerak',
        lecturer: 'Sepyan Purnama Kristanto, M.Kom.',
        sks: 3,
      ),
      KrsCourse(
        code: 'TRPL502',
        name: 'Rekayasa Perangkat Lunak',
        lecturer: 'Dosen RPL',
        sks: 3,
      ),
      KrsCourse(
        code: 'TRPL503',
        name: 'Basis Data',
        lecturer: 'Dosen Basis Data',
        sks: 3,
      ),
    ];
  }
}

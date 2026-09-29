# Laporan Praktikum Modul 03: Navigation & State Management

- **Nama**: Wildan Daffa AKmal Putra
- **NIM**: 362558302097
- **Kelas / Prodi**: 2C / Sarjana Terapan TRPL
- **Mata Kuliah**: Pemrograman Perangkat Bergerak (Semester 3)

---

## 1. Ringkasan Implementasi
Pada praktikum ini, aplikasi Rencana Studi (KRS) dibangun untuk mendemonstrasikan dua pendekatan navigasi dan manajemen *state* di Flutter. Pada Fase A (Fundamental), aplikasi menggunakan navigasi bawaan `Navigator.push` dan `Navigator.pop` dengan struktur *stack* (tumpukan), serta `setState` murni untuk mengelola daftar mata kuliah secara lokal. Pengiriman data antar layar dilakukan secara langsung melalui passing konstruktor. Pada Fase B (Pengayaan), arsitektur aplikasi dirombak menggunakan pendekatan deklaratif dengan `go_router` untuk pemetaan rute, dan `Riverpod` (`NotifierProvider`) untuk memisahkan *state* logika bisnis (seperti batas 24 SKS) agar berada di luar siklus hidup widget UI. Aplikasi juga mengimplementasikan validasi form input menggunakan `GlobalKey<FormState>`.

## 2. Bukti Tangkapan Layar (Running App)
| Daftar KRS Utama | Detail Mata Kuliah | Form Tambah KRS |
|---|---|---|
| ![List](./screenshots/krs_list.png) | ![Detail](./screenshots/krs_detail.png) | ![Add Form](./screenshots/krs_add.png) |

## 3. Kendala Praktikum yang Dihadapi & Solusinya
- **Kendala**: Aplikasi mengalami *crash* dengan pesan `UnsupportedError: Cannot add to an unmodifiable list` saat mencoba menyimpan mata kuliah baru melalui form.
- **Solusi**: Error ini terjadi karena fungsi `getInitialCourses()` mengembalikan daftar yang berstatus `const` (kaku/immutable). Solusinya adalah menyalin daftar tersebut menjadi daftar baru yang fleksibel menggunakan sintaks `List<KrsCourse>.of(KrsCourse.getInitialCourses())` di dalam pendefinisian *state*.
- **Kendala**: *Autograder* pada file test melempar *exception* `Exception: Mata kuliah tidak ditemukan` dan `Found 0 widgets with text "3 SKS"`.
- **Solusi**: Menyesuaikan data *dummy* pada model agar `TRPL501` berada di urutan pertama (sesuai ekspektasi test). Selanjutnya, merapikan format tipografi pada UI layar detail agar merender tulisan persis seperti yang diuji tester, yaitu `Text('${course.sks} SKS')`.
- **Kendala**: Terjadi peringatan linter `avoid_relative_lib_imports` dari `flutter analyze` pada file pengujian (`test/modul_03_test.dart`).
- **Solusi**: Peringatan ini muncul karena file di luar folder `lib` tidak boleh menggunakan path relatif `../lib/`. Solusinya adalah mengubah seluruh *import* relatif menjadi *package import* menggunakan format `package:modul_03/nama_folder/nama_file.dart`.

## 4. Jawaban Pertanyaan Refleksi
1. **Pemindahan State ke KrsNotifier (Fase A vs Fase B)**: Hal yang menjadi lebih mudah adalah pemisahan antara antarmuka (UI) dan logika bisnis; validasi SKS dan pengecekan duplikasi dapat diuji sepenuhnya tanpa perlu me-render widget apa pun. Sebaliknya, hal yang menjadi lebih sulit adalah pemahaman alur sistem di awal karena *boilerplate* kode bertambah (penggunaan `ConsumerWidget` dan `ref.watch`), dan alur eksekusinya tidak lagi linier sejelas melempar variabel melalui konstruktor.
2. **Perubahan Layar Detail menjadi StatefulWidget (Latihan 1)**: Pada konsep awal, layar detail bersifat pasif (hanya mencetak data statis dari konstruktor). Namun, saat ditambahkan fitur "Ubah Bobot SKS" yang diakses langsung dari layar detail, nilai SKS pada tampilan harus dirender ulang secara *real-time* untuk merespons pilihan baru pengguna *sebelum* nilai tersebut dikembalikan via `pop()`. Kebutuhan untuk merubah wujud tampilan secara internal dan dinamis inilah yang membatalkan simpulan awal dan mewajibkan penggunaan `StatefulWidget`.
3. **Efektivitas go_router dan Riverpod untuk Aplikasi 3 Layar**: Jika aplikasi selamanya hanya memiliki tiga layar, menambahkan `go_router` dan `Riverpod` sama sekali tidak sepadan. Implementasinya mengharuskan pembuatan 2-3 file tambahan khusus (*provider* dan konfigurasi *router*), serta modifikasi pada setiap widget pembungkus. Hal ini akan menambah puluhan baris kode (*Lines of Code*) tanpa memberikan keuntungan arsitektural yang signifikan dibandingkan `Navigator.push` dan `setState` murni yang jauh lebih ringkas.
4. **Alasan Alat Analisis Statis Gagal Menangkap Jebakan Const List**: Alat `flutter analyze` beroperasi dengan mengecek deklarasi tipe data pada saat kompilasi, bukan mensimulasikan perilaku aplikasi saat *runtime*. Deklarasi `final List<KrsCourse> _courses = getInitialCourses();` dianggap sah secara sintaksis karena tipe kembaliannya cocok sebagai `List`. Linter tidak mendeteksi sifat bawaan *immutable* dari *list* tersebut hingga terjadi operasi modifikasi (seperti `.add()`) yang meledak saat program berjalan. Usulan untuk menangkap masalah ini lebih awal adalah dengan menulis *Unit Test* yang secara otomatis menyimulasikan operasi penambahan data ke dalam *state* tersebut.
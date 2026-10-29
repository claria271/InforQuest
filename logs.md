# 📋 Log Aktivitas & Perubahan Pengembangan InfoQuest

Dokumen ini mencatat secara terperinci setiap langkah implementasi, berkas baru yang dibuat, pembaruan kode, serta hasil verifikasi dan pengujian sesuai dengan spesifikasi [Perintah.md](file:///d:/InforQuest/Perintah.md).

---

## Ringkasan Eksekutif Pengembangan

| Parameter | Status | Keterangan |
|---|---|---|
| **Platform Target** | Android / Multiplatform | Flutter 3.24.3, Dart 3.5.3, Material 3 |
| **State Management** | Selesai | Riverpod (`flutter_riverpod: ^2.6.1`) |
| **Penyimpanan Lokal** | Selesai | Offline-first via `shared_preferences: ^2.5.3` |
| **Kurikulum Belajar** | Selesai | 10 Level Lengkap (Materi, Kuis, Tantangan Interaktif) |
| **Logika Gamifikasi** | Selesai | Gerbang kelulusan skor 80, 3 nyawa, anti-farming XP/koin, streak harian, 8 lencana |
| **Analisis Statis (`flutter analyze`)** | **Lulus** | 0 error, 0 warning ("No issues found!") |
| **Pengujian Otomatis (`flutter test`)** | **Lulus (17/17)** | Unit tests, provider tests, dan widget tests lulus 100% |

---

## 1. Pembuatan Struktur Proyek & Dependensi

### Berkas Konfigurasi
- **`pubspec.yaml`**:
  - Didaftarkan pustaka pihak ketiga: `flutter_riverpod`, `shared_preferences`, `google_fonts`, `confetti`, `fl_chart`.
  - Didaftarkan jalur aset lokal:
    - `assets/data/`
    - `assets/data/materials/`
    - `assets/data/questions/`

---

## 2. Dataset Kurikulum & Konten Pembelajaran (JSON)

Seluruh konten disimpan dalam format JSON terstruktur di direktori `assets/data/`:

| Berkas | Deskripsi Konten |
|---|---|
| [`assets/data/levels.json`](file:///d:/InforQuest/assets/data/levels.json) | Definisi 10 level: judul, tujuan pembelajaran, jumlah soal, pass score (80), hadiah XP & koin, tingkat kesulitan, serta tipe tantangan mini-game. |
| [`assets/data/materials/level_01.json`](file:///d:/InforQuest/assets/data/materials/level_01.json) | Materi Level 1: Pengenalan Informatika, bidang kajian, dampak sosial & etika digital (3 bagian). |
| [`assets/data/materials/level_02.json`](file:///d:/InforQuest/assets/data/materials/level_02.json) | Materi Level 2: Berpikir Komputasional (Dekomposisi, Pola, Abstraksi, Algoritma) (4 bagian). |
| [`assets/data/materials/level_03.json`](file:///d:/InforQuest/assets/data/materials/level_03.json) | Materi Level 3: Algoritma dan Pemrograman (Flowchart, variabel, branching, loops, functions) (5 bagian). |
| [`assets/data/materials/level_04.json`](file:///d:/InforQuest/assets/data/materials/level_04.json) | Materi Level 4: Struktur Data Dasar (Array/List, Stack LIFO, Queue FIFO, Tree & Graph) (4 bagian). |
| [`assets/data/materials/level_05.json`](file:///d:/InforQuest/assets/data/materials/level_05.json) | Materi Level 5: Sistem Komputer (Von Neumann, CPU, RAM vs Storage, OS, siklus instruksi) (4 bagian). |
| [`assets/data/materials/level_06.json`](file:///d:/InforQuest/assets/data/materials/level_06.json) | Materi Level 6: Jaringan Komputer dan Internet (Topologi, TCP/IP, IPv4/IPv6, HTTP/HTTPS, DNS) (5 bagian). |
| [`assets/data/materials/level_07.json`](file:///d:/InforQuest/assets/data/materials/level_07.json) | Materi Level 7: Basis Data (Relasional, tabel, field & record, Primary/Foreign Key, query SQL) (4 bagian). |
| [`assets/data/materials/level_08.json`](file:///d:/InforQuest/assets/data/materials/level_08.json) | Materi Level 8: Keamanan Digital (Malware, phishing, kata sandi kuat, 2FA, enkripsi data) (4 bagian). |
| [`assets/data/materials/level_09.json`](file:///d:/InforQuest/assets/data/materials/level_09.json) | Materi Level 9: Data dan Kecerdasan Buatan (Big Data 5V, Machine Learning, Neural Networks, etika AI) (4 bagian). |
| [`assets/data/materials/level_10.json`](file:///d:/InforQuest/assets/data/materials/level_10.json) | Materi Level 10: Rangkuman komprehensif seluruh topik persiapan tantangan akhir (1 bagian rangkuman). |
| [`assets/data/questions/level_01.json`](file:///d:/InforQuest/assets/data/questions/level_01.json) | 10 soal kuis pilihan ganda + mini-game pencocokan istilah informatika. |
| [`assets/data/questions/level_02.json`](file:///d:/InforQuest/assets/data/questions/level_02.json) | 10 soal kuis pilihan ganda + mini-game pengurutan 4 pilar computational thinking. |
| [`assets/data/questions/level_03.json`](file:///d:/InforQuest/assets/data/questions/level_03.json) | 10 soal kuis pilihan ganda + mini-game penyusunan blok kode perulangan while loop. |
| [`assets/data/questions/level_04.json`](file:///d:/InforQuest/assets/data/questions/level_04.json) | 10 soal kuis pilihan ganda + mini-game simulasi push & pop stack (LIFO). |
| [`assets/data/questions/level_05.json`](file:///d:/InforQuest/assets/data/questions/level_05.json) | 10 soal kuis pilihan ganda + mini-game pengelompokan komponen sistem komputer. |
| [`assets/data/questions/level_06.json`](file:///d:/InforQuest/assets/data/questions/level_06.json) | 10 soal kuis pilihan ganda + mini-game alur transmisi paket jaringan client-to-server. |
| [`assets/data/questions/level_07.json`](file:///d:/InforQuest/assets/data/questions/level_07.json) | 10 soal kuis pilihan ganda + mini-game penyusunan kueri SQL SELECT-WHERE-ORDER BY. |
| [`assets/data/questions/level_08.json`](file:///d:/InforQuest/assets/data/questions/level_08.json) | 10 soal kuis pilihan ganda + mini-game deteksi URL dan tanda serangan phishing. |
| [`assets/data/questions/level_09.json`](file:///d:/InforQuest/assets/data/questions/level_09.json) | 10 soal kuis pilihan ganda + mini-game klasifikasi paradigma machine learning. |
| [`assets/data/questions/level_10.json`](file:///d:/InforQuest/assets/data/questions/level_10.json) | 20 soal kuis integratif tingkat mahir + tantangan akhir arsitektur sistem pintar. |

---

## 3. Lapisan Model Data (`lib/models/`)

- [`lib/models/user.dart`](file:///d:/InforQuest/lib/models/user.dart): Model profil pemain (`id`, `name`, `avatar`, `createdAt`).
- [`lib/models/level.dart`](file:///d:/InforQuest/lib/models/level.dart): Model spesifikasi level (`id`, `title`, `objective`, `passScore`, `rewardXp`, `rewardCoins`, dll.).
- [`lib/models/material_section.dart`](file:///d:/InforQuest/lib/models/material_section.dart): Model bagian materi pembelajaran per bab.
- [`lib/models/question.dart`](file:///d:/InforQuest/lib/models/question.dart): Model butir soal kuis (teks soal, 4 opsi, indeks benar, pembahasan lengkap).
- [`lib/models/quiz_result.dart`](file:///d:/InforQuest/lib/models/quiz_result.dart): Model riwayat hasil percobaan kuis (`score`, `passed`, `livesLeft`, `xpEarned`, `coinsEarned`, `takenAt`, `newBadges`).
- [`lib/models/user_progress.dart`](file:///d:/InforQuest/lib/models/user_progress.dart): Model status progres (`totalXp`, `coins`, `streak`, `longestStreak`, status per level `LevelProgress`, `earnedAchievements`).
- [`lib/models/achievement.dart`](file:///d:/InforQuest/lib/models/achievement.dart): Model definisi lencana penghargaan.

---

## 4. Lapisan Logika & Layanan Bisnis (`lib/services/` & `lib/data/`)

- [`lib/data/achievement_definitions.dart`](file:///d:/InforQuest/lib/data/achievement_definitions.dart):
  Definisi 8 lencana penghargaan gamifikasi:
  1. 🥇 *Langkah Pertama* (Lulus Level 1)
  2. 🧠 *Berpikir Komputasional* (Lulus Level 2)
  3. ⭐ *Sempurna!* (Skor 100 pada level mana pun)
  4. 🔥 *Konsisten 3* (Streak 3 hari)
  5. 🔥🔥 *Konsisten 7* (Streak 7 hari)
  6. 📚 *Kutu Buku* (Membaca seluruh materi di 5 level)
  7. 💪 *Pantang Menyerah* (Lulus level setelah gagal ≥ 3 kali)
  8. 🏆 *Penakluk Informatika* (Lulus Level 10)

- [`lib/services/game_engine.dart`](file:///d:/InforQuest/lib/services/game_engine.dart):
  Pusat aturan permainan murni:
  - Perhitungan skor kelulusan: `(correct / total * 100).round() >= 80`.
  - Aturan **anti-farming**: XP dan koin hanya diberikan untuk selisih peningkatan skor terbaik (`newCorrect = max(0, correct - bestCorrect)`). Pengulangan tanpa peningkatan skor menghasilkan 0 XP.
  - Hadiah kelulusan pertama (`rewardXp`, `rewardCoins`).
  - Bonus nilai sempurna (+30 XP jika skor 100).
  - Mekanisme streak harian (`5 * min(streak, 7)` bonus XP saat kuis pertama hari itu).
  - Syarat pembukaan level berikutnya: Level *N-1* lulus (skor ≥ 80) DAN semua materi Level *N-1* telah dibaca tuntas.

- [`lib/services/achievement_service.dart`](file:///d:/InforQuest/lib/services/achievement_service.dart):
  Pengecekan otomatis kondisi pencapaian lencana dan pemberian bonus XP/koin.

- [`lib/services/storage_service.dart`](file:///d:/InforQuest/lib/services/storage_service.dart):
  Layanan persistensi lokal offline menggunakan `SharedPreferences` (profil pengguna, kemajuan level, riwayat kuis, preferensi tema dan suara).

- [`lib/services/content_service.dart`](file:///d:/InforQuest/lib/services/content_service.dart):
  Layanan pembaca aset JSON dengan sistem caching memori berkinerja tinggi.

---

## 5. Lapisan Pengelolaan State Riverpod (`lib/providers/`)

- [`lib/providers/settings_provider.dart`](file:///d:/InforQuest/lib/providers/settings_provider.dart): State tema gelap/terang, suara, getaran, status onboarding.
- [`lib/providers/user_provider.dart`](file:///d:/InforQuest/lib/providers/user_provider.dart): State data profil pemain aktif.
- [`lib/providers/progress_provider.dart`](file:///d:/InforQuest/lib/providers/progress_provider.dart): State progres bermain, rekaman kuis, penandaan bacaan, dan riwayat percobaan.
- [`lib/providers/quiz_provider.dart`](file:///d:/InforQuest/lib/providers/quiz_provider.dart): State interaktif kuis yang sedang berjalan (3 nyawa, nomor soal, feedback instan, dan penanganan akhir sesi).

---

## 6. Komponen UI Reusable (`lib/widgets/`)

- [`lib/widgets/xp_bar.dart`](file:///d:/InforQuest/lib/widgets/xp_bar.dart): Visualisasi XP, gelar peringkat petualang, dan progress bar rank.
- [`lib/widgets/streak_chip.dart`](file:///d:/InforQuest/lib/widgets/streak_chip.dart): Chip indikator api streak belajar harian.
- [`lib/widgets/heart_indicator.dart`](file:///d:/InforQuest/lib/widgets/heart_indicator.dart): Indikator nyawa 3 hati (❤️❤️❤️).
- [`lib/widgets/answer_option.dart`](file:///d:/InforQuest/lib/widgets/answer_option.dart): Kartu opsi jawaban kuis dengan animasi transisi status (idle, selected, correct green, wrong red).
- [`lib/widgets/level_node.dart`](file:///d:/InforQuest/lib/widgets/level_node.dart): Node jalur petualangan (status gembok terkunci, status aktif, status lulus dengan bintang).
- [`lib/widgets/badge_tile.dart`](file:///d:/InforQuest/lib/widgets/badge_tile.dart): Kartu lencana koleksi pada gridview.
- [`lib/widgets/result_star_rating.dart`](file:///d:/InforQuest/lib/widgets/result_star_rating.dart): Bintang penghargaan hasil skor.
- [`lib/widgets/locked_dialog.dart`](file:///d:/InforQuest/lib/widgets/locked_dialog.dart): Dialog interaktif menampilkan syarat pembukaan level yang belum terpenuhi.

---

## 7. Halaman Aplikasi (`lib/screens/`)

1. [`lib/screens/splash/splash_screen.dart`](file:///d:/InforQuest/lib/screens/splash/splash_screen.dart): Animasi logo pembuka dan routing pintar (Onboarding / Auth / Beranda).
2. [`lib/screens/onboarding/onboarding_screen.dart`](file:///d:/InforQuest/lib/screens/onboarding/onboarding_screen.dart): 3 halaman panduan konsep jalur petualangan, XP/lencana, dan gerbang kelulusan skor 80.
3. [`lib/screens/auth/auth_screen.dart`](file:///d:/InforQuest/lib/screens/auth/auth_screen.dart): Pembuatan profil pemain lokal dengan pemilihan avatar dan validasi nama panggilan.
4. [`lib/screens/main_shell.dart`](file:///d:/InforQuest/lib/screens/main_shell.dart): Navigasi bawah 4 tab (*Beranda*, *Peta*, *Badge*, *Profil*).
5. [`lib/screens/home/home_screen.dart`](file:///d:/InforQuest/lib/screens/home/home_screen.dart): Dashboard utama, kartu "Lanjutkan Belajar", statistik ringkas, dan pintasan fitur.
6. [`lib/screens/level_map/level_map_screen.dart`](file:///d:/InforQuest/lib/screens/level_map/level_map_screen.dart): Peta vertikal 10 node petualangan linear dengan status visual interaktif.
7. [`lib/screens/level_detail/level_detail_screen.dart`](file:///d:/InforQuest/lib/screens/level_detail/level_detail_screen.dart): Rincian level, tujuan pembelajaran, checklist bacaan materi, rekor nilai terbaik, dan tombol aksi.
8. [`lib/screens/material/material_screen.dart`](file:///d:/InforQuest/lib/screens/material/material_screen.dart): Pembaca materi bab per bagian dengan penandaan otomatis "dibaca".
9. [`lib/screens/quiz/quiz_screen.dart`](file:///d:/InforQuest/lib/screens/quiz/quiz_screen.dart): Sesi kuis interaktif 1 soal per layar, indikator 3 nyawa, feedback getar/warna, pembahasan langsung, dan konfirmasi pencegahan keluar tak sengaja (`PopScope`).
10. [`lib/screens/challenge/challenge_screen.dart`](file:///d:/InforQuest/lib/screens/challenge/challenge_screen.dart): Mini-game interaktif drag-and-drop / reorderable berhadiah +20 XP.
11. [`lib/screens/result/result_screen.dart`](file:///d:/InforQuest/lib/screens/result/result_screen.dart): Tampilan hasil skor, animasi confetti saat lulus, perolehan XP/koin/lencana baru, serta pembahasan lengkap setiap butir soal.
12. [`lib/screens/profile/profile_screen.dart`](file:///d:/InforQuest/lib/screens/profile/profile_screen.dart): Profil pengguna, statistik XP/koin/streak, dan dialog pengubahan avatar/nama.
13. [`lib/screens/history/history_screen.dart`](file:///d:/InforQuest/lib/screens/history/history_screen.dart): Riwayat seluruh percobaan kuis lengkap dengan tanggal, skor, dan status kelulusan.
14. [`lib/screens/statistics/statistics_screen.dart`](file:///d:/InforQuest/lib/screens/statistics/statistics_screen.dart): Grafik batang nilai terbaik per level (`fl_chart`), akurasi rata-rata, dan kalender streak.
15. [`lib/screens/achievements/achievements_screen.dart`](file:///d:/InforQuest/lib/screens/achievements/achievements_screen.dart): Galeri 8 lencana penghargaan lengkap dengan bottom sheet keterangan syarat.
16. [`lib/screens/settings/settings_screen.dart`](file:///d:/InforQuest/lib/screens/settings/settings_screen.dart): Pengaturan tema terang/gelap, efek suara, getaran, reset progres aman dengan dialog konfirmasi, dan informasi aplikasi.

---

## 8. Utilitas, Tema, dan Inisialisasi

- [`lib/utils/constants.dart`](file:///d:/InforQuest/lib/utils/constants.dart): Nilai konstanta aturan kelulusan, nyawa, XP, koin, dan peringkat pemain.
- [`lib/utils/app_theme.dart`](file:///d:/InforQuest/lib/utils/app_theme.dart): Palet warna Material 3 (Indigo, Teal, Amber, Green, Red) serta tema terang dan gelap dengan tipografi Poppins & Inter.
- [`lib/utils/routes.dart`](file:///d:/InforQuest/lib/utils/routes.dart): Definisi rute navigasi aplikasi.
- [`lib/utils/helpers.dart`](file:///d:/InforQuest/lib/utils/helpers.dart): Fungsi pembantu tanggal dan bintang nilai.
- [`lib/app.dart`](file:///d:/InforQuest/lib/app.dart): Konfigurasi `MaterialApp`, generator rute, dan adaptasi tema reaktif.
- [`lib/main.dart`](file:///d:/InforQuest/lib/main.dart): Titik masuk aplikasi menginisialisasi penyimpanan lokal dan `ProviderScope`.

---

## 9. Hasil Pengujian Otomatis (`test/`)

Pengujian dilakukan mencakup seluruh skenario uji pada Bab 12 `Perintah.md`:

| ID Uji | Skenario Pengujian | Berkas Uji | Hasil |
|---|---|---|---|
| **T03** | Level 2 terkunci saat Level 1 belum lulus | `game_engine_test.dart` | **LULUS** |
| **T04** | Level 2 tetap terkunci jika Level 1 lulus tapi materi belum dibaca semua | `game_engine_test.dart` | **LULUS** |
| **T05** | Jawab 8 benar dari 10 soal -> Skor 80, Lulus | `game_engine_test.dart` | **LULUS** |
| **T06** | Jawab 7 benar dari 10 soal -> Skor 70, Tidak Lulus | `game_engine_test.dart` | **LULUS** |
| **T07** | Salah menjawab 3 kali -> Nyawa habis (livesLeft = 0) | `game_engine_test.dart` | **LULUS** |
| **T08** | Pertama kali 8 benar -> Mendapat XP jawaban + hadiah lulus + bonus streak | `game_engine_test.dart` | **LULUS** |
| **T09** | Mengulang kuis dengan skor sama (8 benar) -> Tambahan XP/koin = 0 (Anti-Farming) | `game_engine_test.dart` | **LULUS** |
| **T10** | Meningkatkan skor dari 8 ke 10 benar -> Mendapat selisih XP + bonus sempurna 30 | `game_engine_test.dart` | **LULUS** |
| **T13** | Lulus kuis + semua materi tuntas dibaca -> Level 2 terbuka otomatis | `game_engine_test.dart` | **LULUS** |
| **T14** | Streak bertambah setiap hari berturut-turut; melompati hari mereset streak | `game_engine_test.dart` | **LULUS** |
| **T-P1** | Serialisasi & deserialisasi `UserProgress` ke format JSON tanpa kehilangan data | `progress_provider_test.dart` | **LULUS** |
| **T-P2** | Evaluasi lencana otomatis (*Langkah Pertama*, *Pantang Menyerah*, dll.) | `progress_provider_test.dart` | **LULUS** |
| **T-W1** | Rendering widget `HeartIndicator` (3 hati sesuai sisa nyawa) | `widget_test.dart` | **LULUS** |
| **T-W2** | Rendering widget `StreakChip` (simbol api & jumlah hari) | `widget_test.dart` | **LULUS** |
| **T-W3** | Rendering widget `XpBar` (peringkat petualang & total XP) | `widget_test.dart` | **LULUS** |
| **T-W4** | Rendering kartu `AnswerOptionCard` dan interaksi ketukan pilihan | `widget_test.dart` | **LULUS** |

**Keluaran Terminal Uji:**
```text
00:03 +17: All tests passed!
```
Semua 17 pengujian unit dan widget berhasil lulus 100%.

---

## 10. Eksekusi & Verifikasi Aplikasi Langsung (Live Execution)

- **Perintah Jalankan**: `flutter run -d chrome --web-port 8080`
- **Status Server**: Aktif berjalan di `http://localhost:8080`
- **Uji Interaksi Langsung**:
  1. **Splash Screen**: Berhasil memuat animasi transisi logo InfoQuest.
  2. **Onboarding**: Berhasil menavigasikan 3 kartu pengenalan konsep dan interaksi tombol *Lanjut* / *Mulai Petualangan*.
  3. **Pembuatan Profil (`/#/auth`)**: Memasukkan nama pemain `"Budi Penjelajah"`, memilih avatar, dan menekan *Mulai Belajar*.
  4. **Dashboard Utama (`/#/main`)**:
     - Menampilkan salam *"Halo, Budi Penjelajah!"*
     - Menampilkan indikator peringkat (*"Pemula Digital"*), XP tracker, koin, dan streak belajar.
     - Kartu level aktif menampilkan **Level 1: Pengenalan Informatika** dengan tombol *"Lanjutkan Belajar"*.
     - 4 tab navigasi bawah (*Beranda*, *Peta*, *Badge*, *Profil*) siap digunakan.

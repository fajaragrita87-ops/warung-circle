# 📄 PRD: WARUNG CIRCLE

## 📌 PROJECT OVERVIEW

| Item | Detail |
|------|--------|
| **Nama App** | Warung Circle |
| **Tagline** | "Kampung Digital Gen Z — Curhat, Tuker Skill, Cari Genk" |
| **Platform** | Flutter (Android + iOS) |
| **Target User** | Gen Z & Millennial Indo (18-30 tahun) |
| **Vibe** | Tongkrongan Warung Kopi Kekinian — Warm, Rame, Kocak, Interaktif |
| **Monetisasi** | Top Up Kopi + Komisi Lapak + Premium Badge |
| **Backend** | Firebase (Auth, Firestore, Storage) |
| **AI Engine** | Gemini API (Free Tier) — untuk Teh Erni, AI Filter, Titip Cerita |

---

## 🎨 SECTION 1: DESIGN SYSTEM (sesuai permintaan)

### 1.1 COLOR PALETTE — "Warm Tongkrongan"



### 1.2 TYPOGRAPHY sesuai permintaan terakhir 



### 1.3 UI COMPONENTS STYLE sesuai permintaan terakhir


## 🎭 SECTION 2: KARAKTER & FUNGSI (Wajib Dipatuhi)

| No | Karakter | Nama | Warna Neon | Icon Style | Fungsi Utama |
|----|----------|------|------------|------------|--------------|
| 1 | 🍵 | **Teh Erni** | Coral `#FF6B8A` + Gold | Tante sassy, rambut keriting, pegang kopi | Admin Warung, Chatbot AI, Nyapa user baru, Kasih saran |
| 2 | 👮 | **Pak RT** | Blue `#00B4D8` + White | Bapak gagah, peci neon, tangan pinggang | Satpam Lingkungan, Tegur pelanggar ringan, Kasih peringatan |
| 3 | 🚨 | **Hansip** | Red `#FF003C` + Black | Satpam cyber, helm neon, tongkat | Gerebek konten ilegal (NSFW/SARA), Block user |
| 4 | 🕌 | **Ustad** | Green `#00E676` + Gold | Ustad bijak, sorban neon, buku | Tenangin yang ribut, Kasih nasihat bijak, Pencegah toxic |
| 5 | 🏪 | **Abang Lapak** | Gold `#FFD700` + Orange | Abang jualan, pegang kardus, keringetan | Seller/Sales, Jualan di Warung, Sewa Meja, Transaksi Kopi |
| 6 | 🐱 | **Kucing Warung** | Purple `#9B59B6` + Pink | Kucing gemuk, pegang ikan, muka manja | Maskot, Reaksi otomatis, Bagi Kopi gratis random, Notifikasi lucu |

### FUNGSI DETAIL TIAP KARAKTER:

#### 🍵 TEH ERNI — Admin & Chatbot
| Fitur | Detail |
|-------|--------|
| Onboarding | Nyapa user baru, tanya mood, kasih 15 Kopi gratis |
| Chat Pribadi | User bisa chat kapan aja, Teh Erni jawab dengan gaya sassy |
| Peringatan Kasbon | "Kopi lo tinggal 2, bro. Mau kasbon? Pak RT catet ya..." |
| Traktir Reminder | "Bro, @Budi traktir lo 5 Kopi kemarin. Balas dong biar karma naik 🥹" |
| Daily Reward | "Pagi bro! Nih kopi login harian lo. Rajin amat ☕" |

#### 👮 PAK RT — Satpam Ringan
| Fitur | Detail |
|-------|--------|
| Peringatan Spam | "Woi! Jangan spam warung orang! Hapus atau saya laporin Hansip!" |
| Peringatan Roasting | "Roasting boleh, tapi jangan nyeret nama orang. Kasihan bro." |
| Kasbon Reminder | "Bro, hutang lo 3 Kopi udah 7 hari. Bayar dong, jangan lari-lari 😂" |
| Welcome New | "Woi ada warga baru! Seneng warung rame. Sini gabung!" |

#### 🚨 HANSIP — Satpam Berat
| Fitur | Detail |
|-------|--------|
| Block NSFW | "Simpan bokep-nya bro! Ini warung bukan bioskop. Hansip gerebek nih! 🚨" |
| Block SARA | "Woi! SARA? Di warung ini gak boleh! Account lo saya tahan 7 hari!" |
| Block Spam/Scam | "Link phishing? Jangan bego bro! Hansip udah catet nama lo 👮" |
| Auto Report | User bisa report → Hansip review → Putuskan block/warning |

#### 🕌 USTAD — Penegak Moral
| Fitur | Detail |
|-------|--------|
| Tenangin Toxic | "Astaghfirullah... sabar dikit napa. Yuk ngopi biar adem. Kopi gratis nih 🤲" |
| Nasihat Curhat | "Sabar ya Nak, hidup itu ujian. Tapi curhat di sini boleh, Teh Erni dengerin ☕" |
| Pencegahan | Muncul sebelum user post konten sensitif: "Nak, pikirin dulu ya sebelum post..." |

#### 🏪 ABANG LAPAK — Seller/Sales
| Fitur | Detail |
|-------|--------|
| Buka Lapak | User jadi seller, pasang produk/jasa, harga dalam Kopi |
| Sewa Meja | Bayar 20 Kopi = Lapak muncul di Feed Posko selama 1 hari |
| Transaksi | Pembeli bayar Kopi → Abang dapat Kopi (dikurangi komisi 15%) |
| Rating Lapak | Pembeli kasih rating → Rating jelek = Pak RT tegur |
| Komisi Warung | Setiap transaksi, Warung Circle dapat 15% komisi (masuk kas Warung) |

#### 🐱 KUCING WARUNG — Maskot
| Fitur | Detail |
|-------|--------|
| Reaksi Otomatis | Setiap post → Kucing kasih reaksi random: "Meow~ Bagus!" / "Meow~ 😂" |
| Kopi Gratis Random | Tiap hari, Kucing kasih 1-10 Kopi gratis ke user aktif |
| Mood Berubah | Pagi 😺 → Siang 😸 → Sore 🙀 → Malam 😴 |
| Notifikasi Lucu | "Meow~ Teh Erni nyariin lo. Kasbon lo belum dibayar 🙀" |

---

## 🔄 SECTION 3: USER FLOW (Login → Logout)

### PHASE 1: LOGIN / REGISTER

| Step | Screen | Detail |
|------|--------|--------|
| 1 | Splash Screen | Logo Warung Circle (Neon Glow) + "Masuk Warung 🔥" |
| 2 | Login | Pilih: Google / Firebase Auth / Guest (tanpa login, tapi fitur terbatas) |
| 3 | Register | Nama, Tanggal Lahir, Pilih Mood (Santai/Serius/Emosional/Ambisius) |
| 4 | Onboarding Teh Erni | Teh Erni nyapa → 4 pertanyaan singkat → Kasih 15 Kopi gratis + Badge "Anak Baru" |
| 5 | Match 3 User | Sistem otomatis match 3 user yang cocok → Muncul di feed |
| 6 | MASUK POSKO | ✅ Selesai Onboarding |

### PHASE 2: HOME FEED (POSKO)

| Step | Screen | Detail |
|------|--------|--------|
| 1 | Scroll Feed | Sticky Notes warna-warni (Kuning=Ruang Tengah, Pink=Titip Cerita, Hijau=Open Circle, Merah=Curhat) |
| 2 | Reaksi | 😂 👏 🥲 🫣 (bukan cuma love) |
| 3 | Komen | Chat singkat di bawah post |
| 4 | Share | Klik → Pilih: WA Story / IG Story / Copy Text (butuh Kopi) |
| 5 | FAB (+) | Muncul tombol besar: 📝 Titip Cerita / 🛋️ Titip Skill / 🪑 Buka Circle / 🏪 Buka Lapak |

### PHASE 3: FITUR UTAMA (5 Tab)

| Tab | Nama | Fungsi |
|-----|------|--------|
| 🏠 | **Posko** | Feed utama, semua postingan nyampur |
| 🛋️ | **Ruang Tengah** | Skill Swap — Titip Skill, Cari Partner, Rating |
| 📝 | **Titip Cerita** | Gila Text AI — Input masalah → AI generate teks lebay → Share card |
| 🪑 | **Open Circle** | Cari Genk — Buka Circle aktivitas → Orang lain gabung → Rating |
| 🍵 | **Dapur Erni** | Profil — Dompet Kopi, Chat Teh Erni, Badge, Riwayat |

### PHASE 4: EKONOMI (Kopi System)

| Fitur | Detail |
|-------|--------|
| Top Up | Rp 10rb = 15 Kopi, Rp 25rb = 40 Kopi, Rp 50rb = 90 Kopi, Rp 100rb = 200 Kopi, Rp 250rb = 550 Kopi |
| Kasbon | Fitur jalan, hutang tercatat, bayar pas top up |
| Traktir | Minta temen bayarin → Viral loop + Karma |
| Earn Kopi | Login harian +1, Post +1, Rating +1, Share +2, Referral +10 |
| Bon Warung | Menu belanja: Gorengan 2 Kopi, Buka Chat 5 Kopi, Skill Verified 10 Kopi, dll |

### PHASE 5: LOGOUT

| Step | Screen | Detail |
|------|--------|--------|
| 1 | Profil → Settings | Tombol "Keluar Warung" |
| 2 | Konfirmasi Teh Erni | "Yakin mau keluar bro? Kopi lo masih ada lho. Yakin? ☕" |
| 3 | Logout | Firebase Auth logout → Ke Splash Screen |

---

## 📂 SECTION 4: FILE STRUCTURE (Wajib Dipatuhi)

lib/
├── main.dart
├── theme/
│ ├── warung_colors.dart (Semua warna warung)
│ └── warung_theme.dart (ThemeData lengkap)
├── models/
│ ├── user_model.dart (Nama, Karma, Badge, Kopi)
│ ├── post_model.dart (Teks, Tag, Reaksi, Komen)
│ ├── skill_model.dart (Skill bisa/mau, Rating)
│ ├── kopi_model.dart (Saldo, Hutang, Traktir)
│ └── lapak_model.dart (Produk, Harga Kopi, Rating)
├── screens/
│ ├── splash_screen.dart
│ ├── onboarding_screen.dart (Teh Erni chat)
│ ├── home_screen.dart (Posko - Feed)
│ ├── ruang_tengah_screen.dart (Skill Swap)
│ ├── titip_cerita_screen.dart (Gila Text AI)
│ ├── open_circle_screen.dart (Cari Genk)
│ ├── dapur_erni_screen.dart (Profil + Dompet)
│ ├── lapak_screen.dart (Abang Lapak)
│ └── chat_screen.dart (Chat Teh Erni / Pak RT / Hansip)
├── widgets/
│ ├── bottom_nav_bar.dart (5 Tab Floating Pill)
│ ├── post_card.dart (Sticky Note Style)
│ ├── kopi_button.dart (Tombol Pill Gradient)
│ ├── warung_fab.dart (FAB +)
│ ├── neon_icon.dart (Custom Icon Karakter)
│ └── bon_warung_card.dart (Menu Kopi)
├── services/
│ ├── firebase_service.dart
│ ├── gemini_service.dart (AI Teh Erni + Titip Cerita + Filter)
│ └── kopi_service.dart (Top Up, Kasbon, Traktir)
└── utils/
├── constants.dart
└── helpers.dart


---

## 🛠️ SECTION 5: FITUR DETAIL (Satu Per Satu)

### 5.1 🏠 POSKO (Home Feed)

| Fitur | Detail |
|-------|--------|
| Feed Style | Sticky Notes warna-warni (Kuning=Skill, Pink=Cerita, Hijau=Circle, Merah=Curhat) |
| Filter Tab | [Semua] [Ruang Tengah] [Titip Cerita] [Open Circle] [Curhat] |
| Reaksi | 😂 👏 🥲 🫣 (bukan love doang) |
| Share | WA Story / IG Story / Copy (butuh 2-3 Kopi) |
| FAB | 📝 Titip Cerita / 🛋️ Titip Skill / 🪑 Buka Circle / 🏪 Buka Lapak |
| Trending | "🔥 Paling Rame Hari Ini" — Top 5 post with most reactions |

### 5.2 🛋️ RUANG TENGAH (Skill Swap)

| Fitur | Detail |
|-------|--------|
| Titip Skill | User input: Skill bisa ngajarin + Skill mau belajar |
| Cari Partner | Sistem match otomatis (kebalikan skill) |
| Nyambung | Klik → Masuk chat → Janjian ketemu |
| Rating | ⭐⭐⭐⭐⭐ setelah sesi selesai |
| Barter Points | +10 tiap ngajar, -10 tiap belajar, +5 tiap rating 5 bintang |
| Badge | 5 swap = "Sultan Skill", 10 swap = "Pak RT Skill" |

### 5.3 📝 TITIP CERITA 

| Fitur | Detail |
|-------|--------|
| Input | User tulis masalah (contoh: "Ditinggalin pas ultah") |
| AI Generate | Gemini API → Teks lebay lucu (contoh: "Ultah lo ditinggalin? Berarti dia gak level sama lo, sis. Next! 🎂🔥") |
| Share Card | Hasil dibungkus kartu estetik → Tombol "Sebarin Gosip Ini 🗣️" |
| Viral | Share ke WA/IG → User dapat 2 Kopi gratis |
| History | Semua titipan tersimpan di profil |

### 5.4 🪑 OPEN CIRCLE (Cari Genk)

| Fitur | Detail |
|-------|--------|
| Buka Circle | User buat aktivitas: "Makan Bakso Jam 10, Butuh 2 Orang" |
| Gabung | Orang lain klik "Gabung" → Masuk group chat |
| Rating | Setelah nongkrong → Kasih bintang ⭐ |
| Rules | No dating, no chat panjang, cuma ketemu → aktivitas → bubar |
| Pak RT Patrol | Kalau circle isinya aneh → Pak RT muncul: "Woi, ini circle makan atau circle jodoh? 😂" |

### 5.5 🍵 DAPUR ERNI (Profil)

| Fitur | Detail |
|-------|--------|
| Dompet Kopi | Saldo Kopi, Riwayat Top Up, Hutang Kasbon, Traktiran Masuk |
| Chat Teh Erni | Chat AI kapan aja, gaya sassy |
| Badge | Anak Baru, Sultan Kopi, Hansip Kehormatan, Juru Gosip, dll |
| Settings | Ganti nama, foto, logout |
| Karma | Poin reputasi, naik dari interaksi positif |

### 5.6 🏪 LAPAK (Abang Lapak)

| Fitur | Detail |
|-------|--------|
| Buka Lapak | Foto + Deskripsi + Harga (dalam Kopi) |
| Sewa Meja | 20 Kopi = Muncul di Feed Posko 1 hari |
| Transaksi | Pembeli bayar Kopi → Abang dapat Kopi (85%, Warung 15%) |
| Rating | Pembeli kasih bintang → Rating jelek = Pak RT tegur |
| Komisi | 15% dari setiap transaksi masuk kas Warung Circle |

---

## 🛡️ SECTION 6: MODERASI (Pak RT + Hansip + Ustad)

| Level | Pelanggaran | Karakter | Aksi |
|-------|-------------|----------|------|
| 🟡 1 | Spam, iklan, posting gak relevan | Pak RT | ⚠️ Warning + Post dihapus |
| 🟠 2 | Roasting kelewatan, curhat sebut nama | Pak RT | 🔇 Mute 24 jam |
| 🔴 3 | SARA, bullying, NSFW ringan | Hansip | 🔨 Ban 7 hari |
| 💀 4 | Narkoba, judi, doxxing, bokep | Hansip | 💀 Ban permanen |
| 🤲 Pencegahan | Konten sensitif sebelum post | Ustad | 🕌 "Nak, pikirin dulu ya..." |

**AI Filter (Gemini)**: Setiap post → Scan otomatis → Kalau bersih → Langsung muncul. Kalau ragu → Masuk review manual. Kalau jelas ilegal → Auto reject.

---

## ⚡ SECTION 7: EKONOMI KOPI (Lengkap)

| Paket Top Up | Harga | Kopi | Bonus |
|--------------|-------|------|-------|
| Ngopi Dulu | Rp 10.000 | 15 | - |
| Ngopi Santai | Rp 25.000 | 40 | +5 |
| Ngopi Serius | Rp 50.000 | 90 | +15 |
| Sultan Warung | Rp 100.000 | 200 | +50 |
| Juragan Warung | Rp 250.000 | 550 | +150 |

| Menu Bon Warung | Harga | Fungsi |
|-----------------|-------|
| Gorengan (Boost Post) | 2 Kopi | Post naik 1 jam |
| Buka Chat | 5 Kopi | Chat privat 1x |
| Skill Verified | 10 Kopi | Badge centang biru |
| Titip Cerita HD | 3 Kopi | Tanpa watermark |
| Bump Open Circle | 8 Kopi | Profil naik di pencarian |
| Liat Siapa Liat Gue | 5 Kopi | Tau siapa liat profil |
| Warung Premium | 50 Kopi/bln | Semua unlock + no ads |
| Kasbon 1x | 15 Kopi | Hutang, bayar nanti |
| Sewa Meja 1 Hari | 20 Kopi | Lapak muncul di feed |

| Cara Earn Kopi Gratis | Jumlah |
|----------------------|--------|
| Login harian | +1 |
| Post di Feed | +1 |
| Kasih rating | +1 |
| Skill Swap selesai | +5 |
| Share Titip Cerita | +2 |
| Ajak temen (referral) | +10 |
| Curhat 3x sehari | +3 |
| Open Circle selesai | +3 |
| **MAX per hari** | **~26 Kopi** |

---

## 🤖 SECTION 8: AI SYSTEM (Gemini API)

| Fitur AI | Prompt Type | Output |
|----------|-------------|--------|
| Teh Erni Chat | "Kamu Teh Erni, tante warung sassy. Jawab kayak ngobrol sama tante. Bahasa gaul Indo." | Chat response gaul + saran |
| Titip Cerita | "Buat teks '发疯文学' lucu lebay bahasa Indo tentang [TOPIK]. Maksimal 3 paragraf. Jangan SARA." | Teks lebay lucu |
| AI Filter | "Cek teks ini: ada NSFW/SARA/spam? Jawab YA atau TIDAK." | YA/TIDAK |
| Match Skill | Cari user yang skill kebalikan dari input user | List user cocok |

---

## ✅ SECTION 9: CHECKLIST FINAL (Trae Wajib Cek)

| No | Item | Status |
|----|------|--------|
| 1 | Nama App: Warung Circle | +
| 2 | 5 Tab: Posko, Ruang Tengah, Titip Cerita, Open Circle, Dapur Erni | + |
| 3 | 6 Karakter: Teh Erni, Pak RT, Hansip, Ustad, Abang Lapak, Kucing Warung | +
| 4 | Icon Style: Neon Glass Portrait (bukan emoji) | + |
| 5 | Warna: Warm Cream + Orange (bukan dark mode) | +
| 6 | Card Style: Sticky Note + Glassmorphism | +
| 7 | Nav: Floating Pill Shape | +
| 8 | Font: Poppins + Comic Neue | +
| 9 | Sistem Kopi: Top Up + Kasbon + Traktir + Earn | + |
| 10 | Moderasi: Pak RT + Hansip + Ustad + AI Filter | + |
| 11 | Fitur Lapak: Buka + Sewa Meja + Komisi 15% | +
| 12 | Titip Cerita: AI Generate + Share Card | +
| 13 | Onboarding: Teh Erni + 15 Kopi + Match 3 User | +
| 14 | Logout: Konfirmasi Teh Erni | + |

---

## 🚀 INSTRUKSI BUAT VS code

> Tolong buatkan aplikasi Flutter bernama **"WARUNG CIRCLE"** berdasarkan PRD di atas.
>
> **ATURAN KERAS**:
> 1. Jangan ubah nama fitur, karakter, , atau struktur yang ada di PRD ini.
> 2. Icon karakter WAJIB pakai style "Neon Glass Portrait" — BUKAN emoji.
> 3. Warna WAJIB warm cream + orange — BUKAN dark mode.
> 4. Semua fitur di PRD WAJIB ada — jangan skip.
> 5. Mulai dari: `warung_colors.dart` → `warung_theme.dart` → `main.dart` → Screen per screen.
> 6. setiap reload tidak boleh lebih dari 2 detik 
7. setiap habis pengerjaan wajib langsung buka alamat web 
> **Mulai sekarang. Gas. 🔥**
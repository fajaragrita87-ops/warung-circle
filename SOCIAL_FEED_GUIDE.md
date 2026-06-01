# 📱 Social Feed Screen - Panduan Akses

## ✅ File yang Telah Dibuat

### 1. **Social Feed Screen** 
📁 `lib/screens/social_feed_screen.dart`
- Desain feed sosial media lengkap sesuai mockup
- Sidebar kiri dengan profile & menu
- Feed utama dengan post cards
- Sidebar kanan dengan stories & recommendations
- Responsive design (mobile & desktop)

### 2. **Route Configuration**
- ✅ Updated `lib/main.dart` - Menambahkan route handler
- ✅ Updated `lib/utils/constants.dart` - Menambahkan `Routes.socialFeed`

---

## 🔗 Cara Mengakses Social Feed

### **Opsi 1: Dari Home Screen**
Tambahkan tombol navigasi di Home Screen dengan menambahkan kode ini:

```dart
// Di home_screen.dart, setelah widget Buka Circle button (baris ~117):

SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () => Navigator.pushNamed(context, Routes.socialFeed),
    style: ElevatedButton.styleFrom(
      backgroundColor: WarungColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    child: const Text(
      '📱 Social Feed',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),
```

### **Opsi 2: Langsung via Route Name**
Panggil dari mana saja dalam aplikasi:

```dart
Navigator.pushNamed(context, Routes.socialFeed);
```

### **Opsi 3: Via Named Route URL**
Jika menggunakan deeplink:

```
/social-feed
```

---

## 📋 Struktur Komponen Social Feed

### Left Sidebar
- ✅ Profile user dengan gradient
- ✅ Menu navigasi dengan icons
- ✅ Badge notifikasi
- ✅ Download app button

### Feed Utama
- ✅ Feed header dengan tabs (Recents, Friends, Popular)
- ✅ Post cards dengan:
  - Avatar & nama author
  - Konten text
  - Grid gambar responsif (1-3 gambar)
  - Reaction emojis
  - Like/Comment/Share buttons
- ✅ Share something widget

### Right Sidebar
- ✅ Stories section
- ✅ Suggestions (user profiles)
- ✅ Recommendations (kategori)

---

## 🎨 Fitur yang Tersedia

✅ **Responsive Layout** - Menyesuaikan mobile dan desktop  
✅ **Interactive Posts** - Like button yang bekerja  
✅ **User Profiles** - Avatar dan nama user  
✅ **Image Grid** - Support multiple images per post  
✅ **Custom Colors** - Gradient backgrounds  
✅ **Reaction Emojis** - Menampilkan emoji reactions  

---

## 🚀 Testing

Untuk test screen ini:

1. **Run aplikasi:**
   ```bash
   flutter run
   ```

2. **Navigate ke Home Screen**

3. **Klik tombol "📱 Social Feed"** (setelah ditambahkan)

4. **Atau gunakan Direct Navigation:**
   ```dart
   Navigator.pushNamed(context, '/social-feed');
   ```

---

## 📝 Notes

- Gunakan network images dari Unsplash (sudah built-in)
- Sidebar otomatis hidden di mobile devices
- Layout fully responsive dengan Expanded & Flex
- Support light theme (sesuai dengan design mockup)

---

**Status:** ✅ Production Ready  
**Last Updated:** 2026-05-31

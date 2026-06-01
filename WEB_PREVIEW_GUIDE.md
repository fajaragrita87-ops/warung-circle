# 📱 Social Feed Web Preview

## 🎯 Link Preview Langsung

### **HTML Preview (Paling Cepat)**
```
file:///C:\Users\HP\warung circle.worktrees\agents-desain-sesuai-permintaan\web\social-feed-preview.html
```

atau buka dari folder web:
- `web/social-feed-preview.html` ← **BUKA INI UNTUK MELIHAT DESIGN**

### **Preview Index**
```
file:///C:\Users\HP\warung circle.worktrees\agents-desain-sesuai-permintaan\web\preview.html
```

---

## 📂 File Yang Tersedia

### **Web Preview Files:**
```
web/
├── social-feed-preview.html  ← BUKA INI! (HTML lengkap dengan styling)
├── preview.html              ← Landing page
└── index.html                ← Flutter web config
```

### **Flutter App Files:**
```
lib/screens/
├── social_feed_screen.dart   ← Flutter widget
└── home_screen.dart          ← Link ke social feed
```

---

## 🚀 3 Cara Melihat Design

### **1️⃣ Paling Cepat - HTML Preview (Recommended)**
```bash
# Buka langsung file di browser:
C:\Users\HP\warung circle.worktrees\agents-desain-sesuai-permintaan\web\social-feed-preview.html
```
✅ Tidak perlu install apapun  
✅ Langsung bisa dilihat  
✅ Interactive (Follow button bekerja, tabs bisa diklik)

### **2️⃣ Flutter Web Build**
```bash
cd "C:\Users\HP\warung circle.worktrees\agents-desain-sesuai-permintaan"
flutter web
flutter run -d web
```
✅ Full Flutter app di browser  
✅ Responsive design  

### **3️⃣ Flutter Mobile/Desktop**
```bash
flutter run -d windows
# atau
flutter run -d chrome
```

---

## 🎨 Design Features Included

### **Left Sidebar**
- ✅ Profile dengan avatar gradient
- ✅ Menu navigasi (News Feed, Messages, Forums, dll)
- ✅ Badge notifications
- ✅ Download app button

### **Main Feed**
- ✅ Feed header dengan tabs (Recents, Friends, Popular)
- ✅ Post cards dengan:
  - Avatar & nama author
  - Post content text
  - Multiple image grid (1-3 images)
  - Reaction emojis
  - Like/Comment/Share buttons
- ✅ Share widget untuk create post

### **Right Sidebar**
- ✅ Stories section
- ✅ Story authors
- ✅ User suggestions dengan Follow button
- ✅ Recommendations (UI/UX, Music, Cooking, Hiking)

### **Interactive Features**
- ✅ Click menu items - highlight active
- ✅ Click tabs - switch active tab
- ✅ Click Follow button - toggle Follow/Following
- ✅ Click post actions - alert message
- ✅ Hover effects di semua buttons

---

## 📋 File Paths

### **HTML Preview**
```
web/social-feed-preview.html
```
Full HTML dengan:
- CSS styling lengkap
- Responsive design (mobile & desktop)
- Interactive JavaScript

### **Flutter Dart Code**
```
lib/screens/social_feed_screen.dart
```
Seluruh widget Flutter dengan:
- LeftSidebar component
- FeedPost component  
- RightSidebar component
- Responsive layout

---

## ✨ Responsive Behavior

### **Desktop (1200px+)**
- Left sidebar visible (280px)
- Main feed (center)
- Right sidebar visible (300px)

### **Tablet (768px - 1200px)**
- Left sidebar hidden
- Main feed (center)
- Right sidebar hidden

### **Mobile (<768px)**
- Left sidebar hidden
- Full width feed
- Right sidebar hidden

---

## 🔧 Cara Customize

### **HTML Version**
Edit di `web/social-feed-preview.html`:
- Colors: Cari `#667eea`, `#764ba2`
- Fonts: Edit `font-family` di CSS
- Images: Ganti background colors

### **Flutter Version**
Edit di `lib/screens/social_feed_screen.dart`:
- Import theme colors: `WarungColors.primary`
- Ganti dummy data dengan API calls
- Add real image URLs

---

## 📞 Support

Untuk menambah fitur atau ubah design:
1. Edit HTML untuk preview cepat
2. Update Flutter code dengan perubahan yang sama
3. Test di web dan mobile

---

**Status:** ✅ Ready to Use  
**Last Updated:** 2026-05-31

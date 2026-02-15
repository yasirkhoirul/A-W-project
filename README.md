# A&W - Flutter E-Commerce App


## Langkah Instalasi

1. Ekstrak file ZIP proyek.
2. Buka terminal di dalam folder proyek `a_and_w/`.
3. Jalankan perintah untuk mengambil library:
   flutter pub get


## Menjalankan Aplikasi
```bash
flutter run --dart-define=RAJAONGKIR_KEY=your_key
```
## Build Release
### Android APK

```bash
flutter build apk --release --dart-define=RAJAONGKIR_KEY=<your_key>
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle

```bash
flutter build appbundle --release --dart-define=RAJAONGKIR_KEY=<your_key>
```

Output: `build/app/outputs/bundle/release/app-release.aab`


### iOS (di macOS)

```bash
flutter build ios --release --dart-define=RAJAONGKIR_KEY=<your_key>
```

## Struktur Folder dan Arsitektur Proyek

Proyek menggunakan **Clean Architecture** dengan 3 layer utama:

```
┌──────────────────────────────────┐
│       Presentation Layer         │  ← Bloc/Cubit, Pages, Widgets
├──────────────────────────────────┤
│         Domain Layer             │  ← Entities, Usecases, Repository (abstract)
├──────────────────────────────────┤
│          Data Layer              │  ← Datasources, Models, Repository (impl)
└──────────────────────────────────┘
```

**State Management:** Flutter Bloc / Cubit  
**Dependency Injection:** get_it  
**Error Handling:** dartz `Either<Failure, T>`  
**Routing:** go_router  

---

```
a_and_w/
├── android/                    # Android native config
├── ios/                        # iOS native config
├── web/                        # Web config
├── functions/                  # Firebase Cloud Functions (TypeScript)
│   ├── src/
│   │   ├── index.ts            # Entry point Cloud Functions
│   │   ├── triggers/           # Function handlers
│   │   │   ├── auth.trigger.ts
│   │   │   ├── cart.trigger.ts
│   │   │   ├── payment.trigger.ts
│   │   │   ├── product.trigger.ts
│   │   │   └── notification.trigger.ts
│   │   ├── services/           # Business logic layer
│   │   ├── repositories/       # Data access layer
│   │   └── models/             # TypeScript interfaces & types
│   ├── package.json
│   └── tsconfig.json
├── lib/                        # Flutter source code
│   ├── main.dart               # App entry point
│   ├── firebase_options.dart   # Firebase config (auto-generated)
│   ├── core/                   # Shared/core module
│   │   ├── constant/           # Theme, base URL, constants
│   │   ├── database/           # Drift SQLite database (keranjang lokal)
│   │   ├── dependency_injection.dart  # get_it DI setup (~50 registrations)
│   │   ├── entities/           # Shared entities
│   │   ├── exceptions/         # Custom Exceptions & Failures
│   │   ├── models/             # Shared data models
│   │   ├── router/             # GoRouter configuration
│   │   ├── utils/              # Utilities (safe_execute, local_notification)
│   │   └── widgets/            # Shared widgets (AppBar, BottomNav, Dialogs)
│   └── features/               # Feature modules (Clean Architecture)
│       ├── auth/               # Autentikasi (login, signup, profile)
│       ├── barang/             # Katalog produk & keranjang
│       ├── history/            # Riwayat pesanan
│       ├── home/               # Halaman utama & scaffold
│       ├── pembayaran/         # WebView Midtrans
│       ├── pengantaran/        # Ongkir & tracking (RajaOngkir)
│       └── pesanan/            # Checkout & pemesanan
├── test/                       # Unit & widget tests
│   ├── test_helper.dart        # Mock setup
│   ├── dummy_data/             # Test fixtures
│   └── features/               # Feature-level tests
├── assets/
│   ├── images/                 # Gambar statis
│   └── lottie/                 # Animasi Lottie
├── firestore.rules             # Firestore security rules
├── storage.rules               # Storage security rules
├── firebase.json               # Firebase project config
└── pubspec.yaml                # Flutter dependencies
```

---

## Fitur Aplikasi
### Daftar Fitur

| Fitur | Deskripsi |
|-------|-----------|
| **Login / Signup** | Email + Password, Google Sign-In |
| **Profil** | Lihat & edit profil, set alamat pengiriman |
| **Katalog Produk** | Browse produk, filter by kategori |
| **Detail Produk** | Lihat detail, tambah ke keranjang |
| **Keranjang** | Keranjang lokal (SQLite/Drift), CRUD items |
| **Checkout** | Pilih alamat, pilih kurir & layanan pengiriman |
| **Pembayaran** | Midtrans Snap (via WebView) |
| **Riwayat Pesanan** | Lihat semua pesanan & detail |
| **Lacak Pengiriman** | Tracking resi real-time via RajaOngkir |
| **Push Notification** | Notifikasi perubahan status pesanan (FCM) |

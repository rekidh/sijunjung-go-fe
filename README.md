# Sijunjung Go Frontend

Repositori ini berisi kode frontend untuk aplikasi Sijunjung Go, yang terdiri dari tiga modul aplikasi Flutter dan satu modul shared.

## Struktur Proyek

- `customer-app/`: Aplikasi untuk Pelanggan.
- `driver-app/`: Aplikasi untuk Driver.
- `merchant-app/`: Aplikasi untuk Merchant.
- `shared/`: Kode dan resource yang digunakan bersama oleh ketiga aplikasi di atas.

## Cara Menjalankan Aplikasi

Untuk mempermudah workflow, kami menyediakan script `start-apps` dan `Makefile`.

### Menggunakan Makefile (Rekomendasi)

Gunakan perintah `make` untuk menjalankan perintah yang sering digunakan:

- **Customer App**: `make customer` (Production) atau `make customer-dev` (Development)
- **Driver App**: `make driver` (Production) atau `make driver-dev` (Development)
- **Merchant App**: `make merchant` (Production) atau `make merchant-dev` (Development)
- **Sync Dependencies**: `make sync`

### Menggunakan Script `start-apps` Secara Langsung

Anda juga bisa menjalankan script secara manual dengan opsi yang lebih detail:

```bash
./start-apps --customer-app
./start-apps --driver-app
./start-apps --merchant-app
./start-apps --sync
```

#### Opsi Tambahan:
- `--env [dev|prod]`: Menentukan environment (Default: `prod`).
- `--clean`: Menjalankan `flutter clean` sebelum start.
- `--release`: Menjalankan aplikasi dalam mode release.
- `--device [id]`: Menentukan ID perangkat tujuan.

**Contoh:**
```bash
./start-apps --customer-app --env dev --clean --device emulator-5554
```

## Management Environment

Kami menggunakan `dart-define` untuk mengelola environment variable.

- **Production**: `https://sijunjung-go-production.up.railway.app`
- **Development**: `https://sijunjung-go-dev.up.railway.app`

Lokasi konfigurasi ada di `shared/lib/config/env_config.dart`.

## Sinkronisasi Dependency

Jika ada perubahan pada `pubspec.yaml` di modul manapun, sangat disarankan untuk menjalankan sinkronisasi agar semua modul tetap sync:

```bash
make sync
```
atau
```bash
./start-apps --sync
```

## Kontribusi

1. Pastikan Flutter sudah terinstal di sistem Anda.
2. Selalu jalankan `make sync` setelah melakukan `git pull`.
3. Gunakan modul `shared` untuk fungsi-fungsi yang bersifat umum di ketiga aplikasi.

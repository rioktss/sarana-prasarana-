# SIPAS - Sistem Pengaduan Sarana dan Prasarana Sekolah

SIPAS adalah aplikasi PHP + MySQL/MariaDB untuk mencatat dan memantau pengaduan sarana sekolah.

## Teknologi
- PHP 5.6+
- PDO MySQL
- MySQL / MariaDB
- HTML, CSS, JavaScript tanpa framework

## Struktur
```text
Sipas_Baru/
├── config/database.php
├── controllers/
├── models/
├── views/
├── database/pengaduan_sekolah.sql
├── helpers.php
└── index.php
```

## Navigasi
Semua menu memakai pola sederhana `index.php?page=...`, sama seperti aplikasi PHP sekolah pada umumnya. Contoh:

```text
index.php?page=login
index.php?page=register
index.php?page=dashboard
index.php?page=admin-pengaduan
```


## Database
Pengaturan bawaan:
- Host: `127.0.0.1`
- Port: `3306`
- User: `root`
- Password: kosong
- Database: `pengaduan_sekolah`

Import file:
```text
database/pengaduan_sekolah.sql
```

## Akun demo
- Admin: `admin` / `admin123`
- Siswa: `siswa` / `siswa123`

## Menjalankan
Letakkan folder `Sipas_Baru` di folder web server, lalu buka:

```text
http://localhost/Sipas_Baru/
```

Untuk AWebServer Android, gunakan alamat localhost dan port yang ditampilkan AWebServer.


Kompatibilitas: kode PHP menggunakan syntax kompatibel dengan PHP 5.6+; database menggunakan PDO MySQL (bukan mysqli). Untuk AWebServer, aktifkan ekstensi PDO dan PDO MySQL.

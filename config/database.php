<?php


/**
 * FILE: config/database.php
 * FUNGSI: Menyediakan konfigurasi dan koneksi PDO ke MySQL.
 * ALUR KERJA: Membaca konfigurasi lokal opsional, mencoba pasangan database/password yang sudah disediakan, lalu mengembalikan koneksi PDO dengan mode error exception dan prepared statement native.
 * INPUT / OUTPUT: Input: konfigurasi default dan opsional config/database.local.php. Output: objek PDO atau pesan kegagalan koneksi.
 * FILE/TABEL TERKAIT: index.php, config/database.local.php (opsional), database/pengaduan_sekolah.sql
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
class Database
{
    private $host = '127.0.0.1';
    private $port = 3306;
    private $username = 'root';

    // Kandidat password dan nama database dicoba berurutan sampai ada yang berhasil,
    // sehingga aplikasi tetap jalan baik memakai database "sipasbaru" maupun
    // "pengaduan_sekolah" (nama bawaan file SQL), dengan password "root" atau kosong.
    // Untuk memaksa pengaturan sendiri, buat file config/database.local.php yang
    // mengembalikan array: ['host'=>..., 'port'=>..., 'username'=>..., 'passwords'=>[...], 'databases'=>[...]]
    // Kredensial ini adalah fallback kompatibilitas untuk lingkungan lokal; jangan gunakan akun root/default pada server produksi.
    private $passwords = ['root', ''];
    // Nama database kandidat mengikuti beberapa versi/skema yang disediakan project; file lokal dapat memilih nama yang pasti.
    private $databases = ['sipas_db', ''];

    /**
     * Memuat pengaturan koneksi lokal opsional tanpa mengharuskan file lokal ada di setiap instalasi.
     * Tidak ada parameter yang diterima dari pemanggil.
     * @return void Tidak mengembalikan nilai; properti koneksi disiapkan.
     * Alasan desain: File lokal dibuat opsional agar project tetap dapat berjalan dengan konfigurasi default, sedangkan instalasi berbeda dapat mengganti kredensial tanpa mengubah file inti.
     */

    public function __construct()
    {
        // __DIR__ membuat pencarian file konfigurasi selalu relatif ke folder config, bukan direktori terminal yang menjalankan PHP.
        $local = __DIR__ . '/database.local.php';
        if (is_file($local)) {
            // File lokal mengembalikan array konfigurasi; require dipakai karena file ini bagian dari konfigurasi tepercaya server.
            $cfg = require $local;
            if (is_array($cfg)) {
                if (isset($cfg['host'])) $this->host = $cfg['host'];
                if (isset($cfg['port'])) $this->port = (int) $cfg['port'];
                if (isset($cfg['username'])) $this->username = $cfg['username'];
                if (isset($cfg['passwords']) && is_array($cfg['passwords'])) $this->passwords = $cfg['passwords'];
                if (isset($cfg['databases']) && is_array($cfg['databases'])) $this->databases = $cfg['databases'];
            }
        }
    }

    /**
     * Membuat koneksi PDO ke database yang tersedia dari daftar kandidat konfigurasi.
     * @return PDO Objek koneksi database yang dapat dipakai model.
     * Alasan desain: PDO dipakai agar query dapat menggunakan prepared statement, mode exception, dan hasil fetch berbentuk associative array. Percobaan beberapa kandidat menjaga kompatibilitas dengan nama database yang disediakan project; untuk produksi, konfigurasi kredensial sebaiknya eksplisit dan tidak memakai akun root.
     */

    public function getConnection() {
        $lastError = '';

        foreach ($this->databases as $database) {
            foreach ($this->passwords as $password) {
                try {
                    // DSN menggabungkan host, port, database, dan charset. utf8mb4 mendukung Unicode lengkap, termasuk banyak simbol/emoji.
                    $dsn = "mysql:host={$this->host};port={$this->port};dbname={$database};charset=utf8mb4";
                    // Opsi PDO di bawah memastikan error terdeteksi sebagai exception dan bentuk hasil query konsisten untuk semua model.
                    return new PDO($dsn, $this->username, $password, [
                        // Exception membuat controller bisa menangani kegagalan query melalui try/catch.
                        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                        // FETCH_ASSOC membuat hasil fetch berupa array dengan nama kolom sebagai key.
                        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                        // Nonaktifkan emulasi agar PDO menggunakan prepared statement native ketika driver mendukungnya.
                        PDO::ATTR_EMULATE_PREPARES   => false,
                    ]);
                } catch (PDOException $e) {
                    $lastError = $e->getMessage();
                }
            }
        }

        // Hentikan request bila semua kandidat gagal; detail error membantu diagnosis lokal, tetapi sebaiknya dicatat ke log dan tidak dipaparkan kepada publik di server produksi.
        exit('Koneksi database gagal: ' . $lastError);
    }
}

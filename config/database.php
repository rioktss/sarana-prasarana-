<?php

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
    private $passwords = ['root', ''];
    private $databases = ['sipas_db', 'pengaduan_sekolah'];

    public function __construct()
    {
        $local = __DIR__ . '/database.local.php';
        if (is_file($local)) {
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

    public function getConnection() {
        $lastError = '';

        foreach ($this->databases as $database) {
            foreach ($this->passwords as $password) {
                try {
                    $dsn = "mysql:host={$this->host};port={$this->port};dbname={$database};charset=utf8mb4";
                    return new PDO($dsn, $this->username, $password, [
                        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                        PDO::ATTR_EMULATE_PREPARES   => false,
                    ]);
                } catch (PDOException $e) {
                    $lastError = $e->getMessage();
                }
            }
        }

        exit('Koneksi database gagal: ' . $lastError);
    }
}

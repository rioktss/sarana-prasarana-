<?php

class Database
{
    private $host = 'localhost';
    private $username = 'root';
    private $password = '';
    private $database = 'pengaduan_sekolah';
    private $port = 3306;

    public function getConnection() {
        try {
            $dsn = "mysql:host={$this->host};port={$this->port};dbname={$this->database};charset=utf8mb4";
            $pdo = new PDO($dsn, $this->username, $this->password, [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ]);

            return $pdo;
        } catch (PDOException $e) {
            exit('Koneksi database gagal: ' . $e->getMessage());
        }
    }
}

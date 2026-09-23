CREATE DATABASE IF NOT EXISTS pengaduan_sekolah CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pengaduan_sekolah;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS umpan_balik;
DROP TABLE IF EXISTS progres_pengaduan;
DROP TABLE IF EXISTS pengaduan;
DROP TABLE IF EXISTS siswa;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE users (
    id_user INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin','siswa') NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE siswa (
    id_siswa INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_user INT UNSIGNED NOT NULL UNIQUE,
    nis VARCHAR(20) NOT NULL UNIQUE,
    nama_siswa VARCHAR(100) NOT NULL,
    kelas VARCHAR(30) NOT NULL,
    CONSTRAINT fk_siswa_user FOREIGN KEY (id_user) REFERENCES users(id_user) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE pengaduan (
    id_pengaduan INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_siswa INT UNSIGNED NOT NULL,
    judul_pengaduan VARCHAR(150) NOT NULL,
    isi_pengaduan TEXT NOT NULL,
    tanggal_pengaduan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Diajukan','Diproses','Selesai','Ditolak') NOT NULL DEFAULT 'Diajukan',
    CONSTRAINT fk_pengaduan_siswa FOREIGN KEY (id_siswa) REFERENCES siswa(id_siswa) ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_pengaduan_status (status),
    INDEX idx_pengaduan_siswa (id_siswa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE progres_pengaduan (
    id_progres INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pengaduan INT UNSIGNED NOT NULL,
    status_progres VARCHAR(100) NOT NULL,
    keterangan TEXT NULL,
    tanggal_progres DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_progres_pengaduan FOREIGN KEY (id_pengaduan) REFERENCES pengaduan(id_pengaduan) ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_progres_pengaduan (id_pengaduan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE umpan_balik (
    id_feedback INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pengaduan INT UNSIGNED NOT NULL,
    isi_feedback TEXT NOT NULL,
    tanggal_feedback DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_feedback_pengaduan FOREIGN KEY (id_pengaduan) REFERENCES pengaduan(id_pengaduan) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE KEY uq_feedback_pengaduan (id_pengaduan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Login demo:
-- admin / admin123
-- siswa / siswa123
INSERT INTO users (username,password,role) VALUES
('admin','$2y$12$ANJcIBII/hfGYNLJDNN8o.S2w0UAfm9jBu0M3SbuNm8PKmv8YPCq2','admin'),
('siswa','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('andi','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa');

INSERT INTO siswa (id_user,nis,nama_siswa,kelas)
SELECT id_user,'123456789','Siswa Contoh','XII RPL' FROM users WHERE username='siswa';
INSERT INTO siswa (id_user,nis,nama_siswa,kelas)
SELECT id_user,'123456790','Andi Pratama','XII RPL' FROM users WHERE username='andi';

INSERT INTO pengaduan (id_siswa,judul_pengaduan,isi_pengaduan,status)
SELECT id_siswa,'Kursi rusak di kelas XII RPL','Beberapa kursi di kelas XII RPL mengalami kerusakan pada bagian kaki dan sandaran.','Diajukan'
FROM siswa WHERE nis='123456789';

INSERT INTO pengaduan (id_siswa,judul_pengaduan,isi_pengaduan,status)
SELECT id_siswa,'Proyektor tidak menyala','Proyektor di ruang kelas tidak dapat menyala saat digunakan untuk presentasi.','Diproses'
FROM siswa WHERE nis='123456790';

INSERT INTO pengaduan (id_siswa,judul_pengaduan,isi_pengaduan,status)
SELECT id_siswa,'Lampu kelas mati','Dua lampu di bagian belakang kelas mati dan membuat ruangan lebih gelap.','Selesai'
FROM siswa WHERE nis='123456789';

INSERT INTO progres_pengaduan(id_pengaduan,status_progres,keterangan)
SELECT id_pengaduan,'Diajukan','Laporan diterima sistem.' FROM pengaduan WHERE judul_pengaduan='Kursi rusak di kelas XII RPL';

INSERT INTO progres_pengaduan(id_pengaduan,status_progres,keterangan)
SELECT id_pengaduan,'Diajukan','Laporan diterima sistem.' FROM pengaduan WHERE judul_pengaduan='Proyektor tidak menyala';
INSERT INTO progres_pengaduan(id_pengaduan,status_progres,keterangan)
SELECT id_pengaduan,'Diproses','Laporan sedang ditindaklanjuti bagian sarpras.' FROM pengaduan WHERE judul_pengaduan='Proyektor tidak menyala';

INSERT INTO progres_pengaduan(id_pengaduan,status_progres,keterangan)
SELECT id_pengaduan,'Diajukan','Laporan diterima sistem.' FROM pengaduan WHERE judul_pengaduan='Lampu kelas mati';
INSERT INTO progres_pengaduan(id_pengaduan,status_progres,keterangan)
SELECT id_pengaduan,'Diproses','Lampu sudah dijadwalkan untuk diperbaiki.' FROM pengaduan WHERE judul_pengaduan='Lampu kelas mati';
INSERT INTO progres_pengaduan(id_pengaduan,status_progres,keterangan)
SELECT id_pengaduan,'Selesai','Lampu kelas sudah diganti dan berfungsi normal.' FROM pengaduan WHERE judul_pengaduan='Lampu kelas mati';

INSERT INTO umpan_balik(id_pengaduan,isi_feedback)
SELECT id_pengaduan,'Perbaikannya cepat dan lampu sekarang sudah normal. Terima kasih.' FROM pengaduan WHERE judul_pengaduan='Lampu kelas mati';

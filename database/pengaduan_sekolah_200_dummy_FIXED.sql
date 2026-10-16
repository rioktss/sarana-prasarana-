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
    pemberi ENUM('admin','siswa') NOT NULL DEFAULT 'siswa',
    isi_feedback TEXT NOT NULL,
    tanggal_feedback DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_feedback_pengaduan FOREIGN KEY (id_pengaduan) REFERENCES pengaduan(id_pengaduan) ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_feedback_pengaduan (id_pengaduan)
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

INSERT INTO umpan_balik(id_pengaduan,pemberi,isi_feedback)
SELECT id_pengaduan,'admin','Terima kasih atas laporannya. Lampu sudah diganti oleh bagian sarpras.' FROM pengaduan WHERE judul_pengaduan='Lampu kelas mati';

INSERT INTO umpan_balik(id_pengaduan,pemberi,isi_feedback)
SELECT id_pengaduan,'siswa','Perbaikannya cepat dan lampu sekarang sudah normal. Terima kasih.' FROM pengaduan WHERE judul_pengaduan='Lampu kelas mati';

-- ================================================================
-- 200 DATA DUMMY TAMBAHAN
-- Username: dummy001 s.d. dummy200
-- Password semua user dummy: siswa123
-- ================================================================

INSERT INTO users (username,password,role) VALUES
('dummy001','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy002','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy003','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy004','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy005','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy006','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy007','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy008','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy009','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy010','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy011','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy012','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy013','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy014','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy015','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy016','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy017','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy018','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy019','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy020','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy021','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy022','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy023','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy024','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy025','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy026','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy027','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy028','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy029','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy030','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy031','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy032','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy033','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy034','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy035','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy036','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy037','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy038','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy039','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy040','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy041','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy042','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy043','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy044','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy045','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy046','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy047','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy048','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy049','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy050','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy051','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy052','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy053','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy054','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy055','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy056','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy057','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy058','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy059','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy060','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy061','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy062','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy063','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy064','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy065','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy066','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy067','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy068','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy069','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy070','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy071','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy072','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy073','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy074','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy075','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy076','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy077','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy078','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy079','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy080','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy081','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy082','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy083','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy084','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy085','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy086','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy087','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy088','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy089','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy090','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy091','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy092','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy093','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy094','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy095','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy096','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy097','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy098','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy099','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy100','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy101','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy102','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy103','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy104','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy105','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy106','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy107','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy108','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy109','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy110','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy111','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy112','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy113','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy114','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy115','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy116','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy117','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy118','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy119','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy120','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy121','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy122','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy123','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy124','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy125','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy126','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy127','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy128','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy129','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy130','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy131','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy132','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy133','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy134','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy135','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy136','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy137','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy138','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy139','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy140','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy141','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy142','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy143','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy144','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy145','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy146','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy147','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy148','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy149','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy150','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy151','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy152','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy153','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy154','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy155','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy156','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy157','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy158','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy159','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy160','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy161','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy162','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy163','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy164','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy165','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy166','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy167','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy168','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy169','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy170','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy171','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy172','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy173','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy174','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy175','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy176','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy177','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy178','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy179','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy180','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy181','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy182','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy183','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy184','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy185','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy186','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy187','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy188','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy189','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy190','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy191','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy192','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy193','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy194','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy195','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy196','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy197','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy198','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy199','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa'),
('dummy200','$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.','siswa');

INSERT INTO siswa (id_user,nis,nama_siswa,kelas)
VALUES
((SELECT id_user FROM users WHERE username='dummy001'),'26000001','Siswa Dummy 001','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy002'),'26000002','Siswa Dummy 002','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy003'),'26000003','Siswa Dummy 003','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy004'),'26000004','Siswa Dummy 004','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy005'),'26000005','Siswa Dummy 005','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy006'),'26000006','Siswa Dummy 006','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy007'),'26000007','Siswa Dummy 007','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy008'),'26000008','Siswa Dummy 008','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy009'),'26000009','Siswa Dummy 009','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy010'),'26000010','Siswa Dummy 010','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy011'),'26000011','Siswa Dummy 011','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy012'),'26000012','Siswa Dummy 012','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy013'),'26000013','Siswa Dummy 013','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy014'),'26000014','Siswa Dummy 014','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy015'),'26000015','Siswa Dummy 015','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy016'),'26000016','Siswa Dummy 016','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy017'),'26000017','Siswa Dummy 017','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy018'),'26000018','Siswa Dummy 018','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy019'),'26000019','Siswa Dummy 019','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy020'),'26000020','Siswa Dummy 020','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy021'),'26000021','Siswa Dummy 021','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy022'),'26000022','Siswa Dummy 022','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy023'),'26000023','Siswa Dummy 023','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy024'),'26000024','Siswa Dummy 024','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy025'),'26000025','Siswa Dummy 025','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy026'),'26000026','Siswa Dummy 026','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy027'),'26000027','Siswa Dummy 027','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy028'),'26000028','Siswa Dummy 028','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy029'),'26000029','Siswa Dummy 029','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy030'),'26000030','Siswa Dummy 030','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy031'),'26000031','Siswa Dummy 031','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy032'),'26000032','Siswa Dummy 032','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy033'),'26000033','Siswa Dummy 033','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy034'),'26000034','Siswa Dummy 034','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy035'),'26000035','Siswa Dummy 035','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy036'),'26000036','Siswa Dummy 036','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy037'),'26000037','Siswa Dummy 037','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy038'),'26000038','Siswa Dummy 038','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy039'),'26000039','Siswa Dummy 039','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy040'),'26000040','Siswa Dummy 040','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy041'),'26000041','Siswa Dummy 041','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy042'),'26000042','Siswa Dummy 042','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy043'),'26000043','Siswa Dummy 043','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy044'),'26000044','Siswa Dummy 044','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy045'),'26000045','Siswa Dummy 045','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy046'),'26000046','Siswa Dummy 046','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy047'),'26000047','Siswa Dummy 047','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy048'),'26000048','Siswa Dummy 048','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy049'),'26000049','Siswa Dummy 049','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy050'),'26000050','Siswa Dummy 050','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy051'),'26000051','Siswa Dummy 051','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy052'),'26000052','Siswa Dummy 052','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy053'),'26000053','Siswa Dummy 053','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy054'),'26000054','Siswa Dummy 054','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy055'),'26000055','Siswa Dummy 055','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy056'),'26000056','Siswa Dummy 056','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy057'),'26000057','Siswa Dummy 057','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy058'),'26000058','Siswa Dummy 058','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy059'),'26000059','Siswa Dummy 059','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy060'),'26000060','Siswa Dummy 060','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy061'),'26000061','Siswa Dummy 061','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy062'),'26000062','Siswa Dummy 062','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy063'),'26000063','Siswa Dummy 063','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy064'),'26000064','Siswa Dummy 064','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy065'),'26000065','Siswa Dummy 065','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy066'),'26000066','Siswa Dummy 066','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy067'),'26000067','Siswa Dummy 067','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy068'),'26000068','Siswa Dummy 068','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy069'),'26000069','Siswa Dummy 069','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy070'),'26000070','Siswa Dummy 070','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy071'),'26000071','Siswa Dummy 071','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy072'),'26000072','Siswa Dummy 072','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy073'),'26000073','Siswa Dummy 073','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy074'),'26000074','Siswa Dummy 074','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy075'),'26000075','Siswa Dummy 075','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy076'),'26000076','Siswa Dummy 076','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy077'),'26000077','Siswa Dummy 077','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy078'),'26000078','Siswa Dummy 078','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy079'),'26000079','Siswa Dummy 079','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy080'),'26000080','Siswa Dummy 080','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy081'),'26000081','Siswa Dummy 081','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy082'),'26000082','Siswa Dummy 082','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy083'),'26000083','Siswa Dummy 083','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy084'),'26000084','Siswa Dummy 084','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy085'),'26000085','Siswa Dummy 085','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy086'),'26000086','Siswa Dummy 086','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy087'),'26000087','Siswa Dummy 087','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy088'),'26000088','Siswa Dummy 088','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy089'),'26000089','Siswa Dummy 089','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy090'),'26000090','Siswa Dummy 090','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy091'),'26000091','Siswa Dummy 091','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy092'),'26000092','Siswa Dummy 092','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy093'),'26000093','Siswa Dummy 093','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy094'),'26000094','Siswa Dummy 094','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy095'),'26000095','Siswa Dummy 095','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy096'),'26000096','Siswa Dummy 096','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy097'),'26000097','Siswa Dummy 097','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy098'),'26000098','Siswa Dummy 098','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy099'),'26000099','Siswa Dummy 099','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy100'),'26000100','Siswa Dummy 100','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy101'),'26000101','Siswa Dummy 101','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy102'),'26000102','Siswa Dummy 102','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy103'),'26000103','Siswa Dummy 103','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy104'),'26000104','Siswa Dummy 104','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy105'),'26000105','Siswa Dummy 105','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy106'),'26000106','Siswa Dummy 106','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy107'),'26000107','Siswa Dummy 107','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy108'),'26000108','Siswa Dummy 108','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy109'),'26000109','Siswa Dummy 109','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy110'),'26000110','Siswa Dummy 110','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy111'),'26000111','Siswa Dummy 111','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy112'),'26000112','Siswa Dummy 112','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy113'),'26000113','Siswa Dummy 113','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy114'),'26000114','Siswa Dummy 114','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy115'),'26000115','Siswa Dummy 115','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy116'),'26000116','Siswa Dummy 116','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy117'),'26000117','Siswa Dummy 117','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy118'),'26000118','Siswa Dummy 118','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy119'),'26000119','Siswa Dummy 119','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy120'),'26000120','Siswa Dummy 120','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy121'),'26000121','Siswa Dummy 121','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy122'),'26000122','Siswa Dummy 122','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy123'),'26000123','Siswa Dummy 123','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy124'),'26000124','Siswa Dummy 124','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy125'),'26000125','Siswa Dummy 125','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy126'),'26000126','Siswa Dummy 126','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy127'),'26000127','Siswa Dummy 127','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy128'),'26000128','Siswa Dummy 128','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy129'),'26000129','Siswa Dummy 129','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy130'),'26000130','Siswa Dummy 130','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy131'),'26000131','Siswa Dummy 131','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy132'),'26000132','Siswa Dummy 132','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy133'),'26000133','Siswa Dummy 133','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy134'),'26000134','Siswa Dummy 134','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy135'),'26000135','Siswa Dummy 135','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy136'),'26000136','Siswa Dummy 136','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy137'),'26000137','Siswa Dummy 137','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy138'),'26000138','Siswa Dummy 138','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy139'),'26000139','Siswa Dummy 139','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy140'),'26000140','Siswa Dummy 140','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy141'),'26000141','Siswa Dummy 141','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy142'),'26000142','Siswa Dummy 142','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy143'),'26000143','Siswa Dummy 143','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy144'),'26000144','Siswa Dummy 144','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy145'),'26000145','Siswa Dummy 145','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy146'),'26000146','Siswa Dummy 146','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy147'),'26000147','Siswa Dummy 147','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy148'),'26000148','Siswa Dummy 148','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy149'),'26000149','Siswa Dummy 149','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy150'),'26000150','Siswa Dummy 150','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy151'),'26000151','Siswa Dummy 151','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy152'),'26000152','Siswa Dummy 152','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy153'),'26000153','Siswa Dummy 153','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy154'),'26000154','Siswa Dummy 154','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy155'),'26000155','Siswa Dummy 155','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy156'),'26000156','Siswa Dummy 156','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy157'),'26000157','Siswa Dummy 157','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy158'),'26000158','Siswa Dummy 158','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy159'),'26000159','Siswa Dummy 159','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy160'),'26000160','Siswa Dummy 160','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy161'),'26000161','Siswa Dummy 161','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy162'),'26000162','Siswa Dummy 162','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy163'),'26000163','Siswa Dummy 163','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy164'),'26000164','Siswa Dummy 164','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy165'),'26000165','Siswa Dummy 165','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy166'),'26000166','Siswa Dummy 166','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy167'),'26000167','Siswa Dummy 167','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy168'),'26000168','Siswa Dummy 168','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy169'),'26000169','Siswa Dummy 169','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy170'),'26000170','Siswa Dummy 170','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy171'),'26000171','Siswa Dummy 171','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy172'),'26000172','Siswa Dummy 172','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy173'),'26000173','Siswa Dummy 173','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy174'),'26000174','Siswa Dummy 174','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy175'),'26000175','Siswa Dummy 175','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy176'),'26000176','Siswa Dummy 176','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy177'),'26000177','Siswa Dummy 177','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy178'),'26000178','Siswa Dummy 178','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy179'),'26000179','Siswa Dummy 179','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy180'),'26000180','Siswa Dummy 180','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy181'),'26000181','Siswa Dummy 181','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy182'),'26000182','Siswa Dummy 182','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy183'),'26000183','Siswa Dummy 183','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy184'),'26000184','Siswa Dummy 184','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy185'),'26000185','Siswa Dummy 185','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy186'),'26000186','Siswa Dummy 186','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy187'),'26000187','Siswa Dummy 187','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy188'),'26000188','Siswa Dummy 188','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy189'),'26000189','Siswa Dummy 189','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy190'),'26000190','Siswa Dummy 190','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy191'),'26000191','Siswa Dummy 191','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy192'),'26000192','Siswa Dummy 192','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy193'),'26000193','Siswa Dummy 193','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy194'),'26000194','Siswa Dummy 194','X RPL 2'),
((SELECT id_user FROM users WHERE username='dummy195'),'26000195','Siswa Dummy 195','XI RPL 1'),
((SELECT id_user FROM users WHERE username='dummy196'),'26000196','Siswa Dummy 196','XI RPL 2'),
((SELECT id_user FROM users WHERE username='dummy197'),'26000197','Siswa Dummy 197','XII RPL 1'),
((SELECT id_user FROM users WHERE username='dummy198'),'26000198','Siswa Dummy 198','XII RPL 2'),
((SELECT id_user FROM users WHERE username='dummy199'),'26000199','Siswa Dummy 199','X RPL 1'),
((SELECT id_user FROM users WHERE username='dummy200'),'26000200','Siswa Dummy 200','X RPL 2');

INSERT INTO pengaduan (id_siswa,judul_pengaduan,isi_pengaduan,status)
SELECT s.id_siswa, d.judul, d.isi, d.status
FROM siswa s
JOIN users u ON u.id_user=s.id_user
JOIN (
    SELECT 1 nomor, 'Kursi kelas rusak' judul, 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan.' isi, 'Diajukan' status
    UNION ALL SELECT 2, 'Lampu kelas mati #002', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 002.', 'Diproses'
    UNION ALL SELECT 3, 'Proyektor bermasalah #003', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 003.', 'Selesai'
    UNION ALL SELECT 4, 'Papan tulis rusak #004', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 004.', 'Ditolak'
    UNION ALL SELECT 5, 'Kipas angin tidak berfungsi #005', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 005.', 'Diajukan'
    UNION ALL SELECT 6, 'AC kelas tidak dingin #006', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 006.', 'Diproses'
    UNION ALL SELECT 7, 'Meja siswa rusak #007', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 007.', 'Selesai'
    UNION ALL SELECT 8, 'Jendela kelas rusak #008', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 008.', 'Ditolak'
    UNION ALL SELECT 9, 'Pintu kelas sulit ditutup #009', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 009.', 'Diajukan'
    UNION ALL SELECT 10, 'Stop kontak tidak berfungsi #010', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 010.', 'Diproses'
    UNION ALL SELECT 11, 'Kursi kelas rusak #011', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 011.', 'Selesai'
    UNION ALL SELECT 12, 'Lampu kelas mati #012', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 012.', 'Ditolak'
    UNION ALL SELECT 13, 'Proyektor bermasalah #013', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 013.', 'Diajukan'
    UNION ALL SELECT 14, 'Papan tulis rusak #014', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 014.', 'Diproses'
    UNION ALL SELECT 15, 'Kipas angin tidak berfungsi #015', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 015.', 'Selesai'
    UNION ALL SELECT 16, 'AC kelas tidak dingin #016', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 016.', 'Ditolak'
    UNION ALL SELECT 17, 'Meja siswa rusak #017', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 017.', 'Diajukan'
    UNION ALL SELECT 18, 'Jendela kelas rusak #018', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 018.', 'Diproses'
    UNION ALL SELECT 19, 'Pintu kelas sulit ditutup #019', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 019.', 'Selesai'
    UNION ALL SELECT 20, 'Stop kontak tidak berfungsi #020', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 020.', 'Ditolak'
    UNION ALL SELECT 21, 'Kursi kelas rusak #021', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 021.', 'Diajukan'
    UNION ALL SELECT 22, 'Lampu kelas mati #022', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 022.', 'Diproses'
    UNION ALL SELECT 23, 'Proyektor bermasalah #023', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 023.', 'Selesai'
    UNION ALL SELECT 24, 'Papan tulis rusak #024', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 024.', 'Ditolak'
    UNION ALL SELECT 25, 'Kipas angin tidak berfungsi #025', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 025.', 'Diajukan'
    UNION ALL SELECT 26, 'AC kelas tidak dingin #026', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 026.', 'Diproses'
    UNION ALL SELECT 27, 'Meja siswa rusak #027', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 027.', 'Selesai'
    UNION ALL SELECT 28, 'Jendela kelas rusak #028', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 028.', 'Ditolak'
    UNION ALL SELECT 29, 'Pintu kelas sulit ditutup #029', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 029.', 'Diajukan'
    UNION ALL SELECT 30, 'Stop kontak tidak berfungsi #030', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 030.', 'Diproses'
    UNION ALL SELECT 31, 'Kursi kelas rusak #031', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 031.', 'Selesai'
    UNION ALL SELECT 32, 'Lampu kelas mati #032', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 032.', 'Ditolak'
    UNION ALL SELECT 33, 'Proyektor bermasalah #033', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 033.', 'Diajukan'
    UNION ALL SELECT 34, 'Papan tulis rusak #034', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 034.', 'Diproses'
    UNION ALL SELECT 35, 'Kipas angin tidak berfungsi #035', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 035.', 'Selesai'
    UNION ALL SELECT 36, 'AC kelas tidak dingin #036', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 036.', 'Ditolak'
    UNION ALL SELECT 37, 'Meja siswa rusak #037', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 037.', 'Diajukan'
    UNION ALL SELECT 38, 'Jendela kelas rusak #038', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 038.', 'Diproses'
    UNION ALL SELECT 39, 'Pintu kelas sulit ditutup #039', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 039.', 'Selesai'
    UNION ALL SELECT 40, 'Stop kontak tidak berfungsi #040', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 040.', 'Ditolak'
    UNION ALL SELECT 41, 'Kursi kelas rusak #041', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 041.', 'Diajukan'
    UNION ALL SELECT 42, 'Lampu kelas mati #042', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 042.', 'Diproses'
    UNION ALL SELECT 43, 'Proyektor bermasalah #043', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 043.', 'Selesai'
    UNION ALL SELECT 44, 'Papan tulis rusak #044', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 044.', 'Ditolak'
    UNION ALL SELECT 45, 'Kipas angin tidak berfungsi #045', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 045.', 'Diajukan'
    UNION ALL SELECT 46, 'AC kelas tidak dingin #046', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 046.', 'Diproses'
    UNION ALL SELECT 47, 'Meja siswa rusak #047', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 047.', 'Selesai'
    UNION ALL SELECT 48, 'Jendela kelas rusak #048', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 048.', 'Ditolak'
    UNION ALL SELECT 49, 'Pintu kelas sulit ditutup #049', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 049.', 'Diajukan'
    UNION ALL SELECT 50, 'Stop kontak tidak berfungsi #050', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 050.', 'Diproses'
    UNION ALL SELECT 51, 'Kursi kelas rusak #051', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 051.', 'Selesai'
    UNION ALL SELECT 52, 'Lampu kelas mati #052', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 052.', 'Ditolak'
    UNION ALL SELECT 53, 'Proyektor bermasalah #053', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 053.', 'Diajukan'
    UNION ALL SELECT 54, 'Papan tulis rusak #054', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 054.', 'Diproses'
    UNION ALL SELECT 55, 'Kipas angin tidak berfungsi #055', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 055.', 'Selesai'
    UNION ALL SELECT 56, 'AC kelas tidak dingin #056', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 056.', 'Ditolak'
    UNION ALL SELECT 57, 'Meja siswa rusak #057', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 057.', 'Diajukan'
    UNION ALL SELECT 58, 'Jendela kelas rusak #058', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 058.', 'Diproses'
    UNION ALL SELECT 59, 'Pintu kelas sulit ditutup #059', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 059.', 'Selesai'
    UNION ALL SELECT 60, 'Stop kontak tidak berfungsi #060', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 060.', 'Ditolak'
    UNION ALL SELECT 61, 'Kursi kelas rusak #061', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 061.', 'Diajukan'
    UNION ALL SELECT 62, 'Lampu kelas mati #062', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 062.', 'Diproses'
    UNION ALL SELECT 63, 'Proyektor bermasalah #063', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 063.', 'Selesai'
    UNION ALL SELECT 64, 'Papan tulis rusak #064', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 064.', 'Ditolak'
    UNION ALL SELECT 65, 'Kipas angin tidak berfungsi #065', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 065.', 'Diajukan'
    UNION ALL SELECT 66, 'AC kelas tidak dingin #066', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 066.', 'Diproses'
    UNION ALL SELECT 67, 'Meja siswa rusak #067', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 067.', 'Selesai'
    UNION ALL SELECT 68, 'Jendela kelas rusak #068', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 068.', 'Ditolak'
    UNION ALL SELECT 69, 'Pintu kelas sulit ditutup #069', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 069.', 'Diajukan'
    UNION ALL SELECT 70, 'Stop kontak tidak berfungsi #070', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 070.', 'Diproses'
    UNION ALL SELECT 71, 'Kursi kelas rusak #071', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 071.', 'Selesai'
    UNION ALL SELECT 72, 'Lampu kelas mati #072', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 072.', 'Ditolak'
    UNION ALL SELECT 73, 'Proyektor bermasalah #073', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 073.', 'Diajukan'
    UNION ALL SELECT 74, 'Papan tulis rusak #074', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 074.', 'Diproses'
    UNION ALL SELECT 75, 'Kipas angin tidak berfungsi #075', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 075.', 'Selesai'
    UNION ALL SELECT 76, 'AC kelas tidak dingin #076', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 076.', 'Ditolak'
    UNION ALL SELECT 77, 'Meja siswa rusak #077', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 077.', 'Diajukan'
    UNION ALL SELECT 78, 'Jendela kelas rusak #078', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 078.', 'Diproses'
    UNION ALL SELECT 79, 'Pintu kelas sulit ditutup #079', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 079.', 'Selesai'
    UNION ALL SELECT 80, 'Stop kontak tidak berfungsi #080', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 080.', 'Ditolak'
    UNION ALL SELECT 81, 'Kursi kelas rusak #081', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 081.', 'Diajukan'
    UNION ALL SELECT 82, 'Lampu kelas mati #082', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 082.', 'Diproses'
    UNION ALL SELECT 83, 'Proyektor bermasalah #083', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 083.', 'Selesai'
    UNION ALL SELECT 84, 'Papan tulis rusak #084', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 084.', 'Ditolak'
    UNION ALL SELECT 85, 'Kipas angin tidak berfungsi #085', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 085.', 'Diajukan'
    UNION ALL SELECT 86, 'AC kelas tidak dingin #086', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 086.', 'Diproses'
    UNION ALL SELECT 87, 'Meja siswa rusak #087', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 087.', 'Selesai'
    UNION ALL SELECT 88, 'Jendela kelas rusak #088', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 088.', 'Ditolak'
    UNION ALL SELECT 89, 'Pintu kelas sulit ditutup #089', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 089.', 'Diajukan'
    UNION ALL SELECT 90, 'Stop kontak tidak berfungsi #090', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 090.', 'Diproses'
    UNION ALL SELECT 91, 'Kursi kelas rusak #091', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 091.', 'Selesai'
    UNION ALL SELECT 92, 'Lampu kelas mati #092', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 092.', 'Ditolak'
    UNION ALL SELECT 93, 'Proyektor bermasalah #093', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 093.', 'Diajukan'
    UNION ALL SELECT 94, 'Papan tulis rusak #094', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 094.', 'Diproses'
    UNION ALL SELECT 95, 'Kipas angin tidak berfungsi #095', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 095.', 'Selesai'
    UNION ALL SELECT 96, 'AC kelas tidak dingin #096', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 096.', 'Ditolak'
    UNION ALL SELECT 97, 'Meja siswa rusak #097', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 097.', 'Diajukan'
    UNION ALL SELECT 98, 'Jendela kelas rusak #098', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 098.', 'Diproses'
    UNION ALL SELECT 99, 'Pintu kelas sulit ditutup #099', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 099.', 'Selesai'
    UNION ALL SELECT 100, 'Stop kontak tidak berfungsi #100', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 100.', 'Ditolak'
    UNION ALL SELECT 101, 'Kursi kelas rusak #101', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 101.', 'Diajukan'
    UNION ALL SELECT 102, 'Lampu kelas mati #102', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 102.', 'Diproses'
    UNION ALL SELECT 103, 'Proyektor bermasalah #103', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 103.', 'Selesai'
    UNION ALL SELECT 104, 'Papan tulis rusak #104', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 104.', 'Ditolak'
    UNION ALL SELECT 105, 'Kipas angin tidak berfungsi #105', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 105.', 'Diajukan'
    UNION ALL SELECT 106, 'AC kelas tidak dingin #106', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 106.', 'Diproses'
    UNION ALL SELECT 107, 'Meja siswa rusak #107', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 107.', 'Selesai'
    UNION ALL SELECT 108, 'Jendela kelas rusak #108', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 108.', 'Ditolak'
    UNION ALL SELECT 109, 'Pintu kelas sulit ditutup #109', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 109.', 'Diajukan'
    UNION ALL SELECT 110, 'Stop kontak tidak berfungsi #110', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 110.', 'Diproses'
    UNION ALL SELECT 111, 'Kursi kelas rusak #111', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 111.', 'Selesai'
    UNION ALL SELECT 112, 'Lampu kelas mati #112', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 112.', 'Ditolak'
    UNION ALL SELECT 113, 'Proyektor bermasalah #113', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 113.', 'Diajukan'
    UNION ALL SELECT 114, 'Papan tulis rusak #114', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 114.', 'Diproses'
    UNION ALL SELECT 115, 'Kipas angin tidak berfungsi #115', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 115.', 'Selesai'
    UNION ALL SELECT 116, 'AC kelas tidak dingin #116', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 116.', 'Ditolak'
    UNION ALL SELECT 117, 'Meja siswa rusak #117', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 117.', 'Diajukan'
    UNION ALL SELECT 118, 'Jendela kelas rusak #118', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 118.', 'Diproses'
    UNION ALL SELECT 119, 'Pintu kelas sulit ditutup #119', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 119.', 'Selesai'
    UNION ALL SELECT 120, 'Stop kontak tidak berfungsi #120', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 120.', 'Ditolak'
    UNION ALL SELECT 121, 'Kursi kelas rusak #121', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 121.', 'Diajukan'
    UNION ALL SELECT 122, 'Lampu kelas mati #122', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 122.', 'Diproses'
    UNION ALL SELECT 123, 'Proyektor bermasalah #123', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 123.', 'Selesai'
    UNION ALL SELECT 124, 'Papan tulis rusak #124', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 124.', 'Ditolak'
    UNION ALL SELECT 125, 'Kipas angin tidak berfungsi #125', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 125.', 'Diajukan'
    UNION ALL SELECT 126, 'AC kelas tidak dingin #126', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 126.', 'Diproses'
    UNION ALL SELECT 127, 'Meja siswa rusak #127', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 127.', 'Selesai'
    UNION ALL SELECT 128, 'Jendela kelas rusak #128', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 128.', 'Ditolak'
    UNION ALL SELECT 129, 'Pintu kelas sulit ditutup #129', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 129.', 'Diajukan'
    UNION ALL SELECT 130, 'Stop kontak tidak berfungsi #130', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 130.', 'Diproses'
    UNION ALL SELECT 131, 'Kursi kelas rusak #131', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 131.', 'Selesai'
    UNION ALL SELECT 132, 'Lampu kelas mati #132', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 132.', 'Ditolak'
    UNION ALL SELECT 133, 'Proyektor bermasalah #133', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 133.', 'Diajukan'
    UNION ALL SELECT 134, 'Papan tulis rusak #134', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 134.', 'Diproses'
    UNION ALL SELECT 135, 'Kipas angin tidak berfungsi #135', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 135.', 'Selesai'
    UNION ALL SELECT 136, 'AC kelas tidak dingin #136', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 136.', 'Ditolak'
    UNION ALL SELECT 137, 'Meja siswa rusak #137', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 137.', 'Diajukan'
    UNION ALL SELECT 138, 'Jendela kelas rusak #138', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 138.', 'Diproses'
    UNION ALL SELECT 139, 'Pintu kelas sulit ditutup #139', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 139.', 'Selesai'
    UNION ALL SELECT 140, 'Stop kontak tidak berfungsi #140', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 140.', 'Ditolak'
    UNION ALL SELECT 141, 'Kursi kelas rusak #141', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 141.', 'Diajukan'
    UNION ALL SELECT 142, 'Lampu kelas mati #142', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 142.', 'Diproses'
    UNION ALL SELECT 143, 'Proyektor bermasalah #143', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 143.', 'Selesai'
    UNION ALL SELECT 144, 'Papan tulis rusak #144', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 144.', 'Ditolak'
    UNION ALL SELECT 145, 'Kipas angin tidak berfungsi #145', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 145.', 'Diajukan'
    UNION ALL SELECT 146, 'AC kelas tidak dingin #146', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 146.', 'Diproses'
    UNION ALL SELECT 147, 'Meja siswa rusak #147', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 147.', 'Selesai'
    UNION ALL SELECT 148, 'Jendela kelas rusak #148', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 148.', 'Ditolak'
    UNION ALL SELECT 149, 'Pintu kelas sulit ditutup #149', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 149.', 'Diajukan'
    UNION ALL SELECT 150, 'Stop kontak tidak berfungsi #150', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 150.', 'Diproses'
    UNION ALL SELECT 151, 'Kursi kelas rusak #151', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 151.', 'Selesai'
    UNION ALL SELECT 152, 'Lampu kelas mati #152', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 152.', 'Ditolak'
    UNION ALL SELECT 153, 'Proyektor bermasalah #153', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 153.', 'Diajukan'
    UNION ALL SELECT 154, 'Papan tulis rusak #154', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 154.', 'Diproses'
    UNION ALL SELECT 155, 'Kipas angin tidak berfungsi #155', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 155.', 'Selesai'
    UNION ALL SELECT 156, 'AC kelas tidak dingin #156', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 156.', 'Ditolak'
    UNION ALL SELECT 157, 'Meja siswa rusak #157', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 157.', 'Diajukan'
    UNION ALL SELECT 158, 'Jendela kelas rusak #158', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 158.', 'Diproses'
    UNION ALL SELECT 159, 'Pintu kelas sulit ditutup #159', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 159.', 'Selesai'
    UNION ALL SELECT 160, 'Stop kontak tidak berfungsi #160', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 160.', 'Ditolak'
    UNION ALL SELECT 161, 'Kursi kelas rusak #161', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 161.', 'Diajukan'
    UNION ALL SELECT 162, 'Lampu kelas mati #162', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 162.', 'Diproses'
    UNION ALL SELECT 163, 'Proyektor bermasalah #163', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 163.', 'Selesai'
    UNION ALL SELECT 164, 'Papan tulis rusak #164', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 164.', 'Ditolak'
    UNION ALL SELECT 165, 'Kipas angin tidak berfungsi #165', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 165.', 'Diajukan'
    UNION ALL SELECT 166, 'AC kelas tidak dingin #166', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 166.', 'Diproses'
    UNION ALL SELECT 167, 'Meja siswa rusak #167', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 167.', 'Selesai'
    UNION ALL SELECT 168, 'Jendela kelas rusak #168', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 168.', 'Ditolak'
    UNION ALL SELECT 169, 'Pintu kelas sulit ditutup #169', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 169.', 'Diajukan'
    UNION ALL SELECT 170, 'Stop kontak tidak berfungsi #170', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 170.', 'Diproses'
    UNION ALL SELECT 171, 'Kursi kelas rusak #171', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 171.', 'Selesai'
    UNION ALL SELECT 172, 'Lampu kelas mati #172', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 172.', 'Ditolak'
    UNION ALL SELECT 173, 'Proyektor bermasalah #173', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 173.', 'Diajukan'
    UNION ALL SELECT 174, 'Papan tulis rusak #174', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 174.', 'Diproses'
    UNION ALL SELECT 175, 'Kipas angin tidak berfungsi #175', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 175.', 'Selesai'
    UNION ALL SELECT 176, 'AC kelas tidak dingin #176', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 176.', 'Ditolak'
    UNION ALL SELECT 177, 'Meja siswa rusak #177', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 177.', 'Diajukan'
    UNION ALL SELECT 178, 'Jendela kelas rusak #178', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 178.', 'Diproses'
    UNION ALL SELECT 179, 'Pintu kelas sulit ditutup #179', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 179.', 'Selesai'
    UNION ALL SELECT 180, 'Stop kontak tidak berfungsi #180', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 180.', 'Ditolak'
    UNION ALL SELECT 181, 'Kursi kelas rusak #181', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 181.', 'Diajukan'
    UNION ALL SELECT 182, 'Lampu kelas mati #182', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 182.', 'Diproses'
    UNION ALL SELECT 183, 'Proyektor bermasalah #183', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 183.', 'Selesai'
    UNION ALL SELECT 184, 'Papan tulis rusak #184', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 184.', 'Ditolak'
    UNION ALL SELECT 185, 'Kipas angin tidak berfungsi #185', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 185.', 'Diajukan'
    UNION ALL SELECT 186, 'AC kelas tidak dingin #186', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 186.', 'Diproses'
    UNION ALL SELECT 187, 'Meja siswa rusak #187', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 187.', 'Selesai'
    UNION ALL SELECT 188, 'Jendela kelas rusak #188', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 188.', 'Ditolak'
    UNION ALL SELECT 189, 'Pintu kelas sulit ditutup #189', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 189.', 'Diajukan'
    UNION ALL SELECT 190, 'Stop kontak tidak berfungsi #190', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 190.', 'Diproses'
    UNION ALL SELECT 191, 'Kursi kelas rusak #191', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 191.', 'Selesai'
    UNION ALL SELECT 192, 'Lampu kelas mati #192', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 192.', 'Ditolak'
    UNION ALL SELECT 193, 'Proyektor bermasalah #193', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 193.', 'Diajukan'
    UNION ALL SELECT 194, 'Papan tulis rusak #194', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 194.', 'Diproses'
    UNION ALL SELECT 195, 'Kipas angin tidak berfungsi #195', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 195.', 'Selesai'
    UNION ALL SELECT 196, 'AC kelas tidak dingin #196', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 196.', 'Ditolak'
    UNION ALL SELECT 197, 'Meja siswa rusak #197', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 197.', 'Diajukan'
    UNION ALL SELECT 198, 'Jendela kelas rusak #198', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 198.', 'Diproses'
    UNION ALL SELECT 199, 'Pintu kelas sulit ditutup #199', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 199.', 'Selesai'
    UNION ALL SELECT 200, 'Stop kontak tidak berfungsi #200', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 200.', 'Ditolak'
) d ON d.nomor = CAST(SUBSTRING(u.username, 6) AS UNSIGNED);

-- Verifikasi jumlah data dummy yang ditambahkan
SELECT COUNT(*) AS jumlah_user_dummy FROM users WHERE username LIKE 'dummy___';
SELECT COUNT(*) AS jumlah_siswa_dummy FROM siswa WHERE nis LIKE '26______';
SELECT COUNT(*) AS jumlah_pengaduan_dummy FROM pengaduan WHERE judul_pengaduan LIKE '%#%';

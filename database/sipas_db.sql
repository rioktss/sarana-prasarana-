-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: sql304.infinityfree.com
-- Waktu pembuatan: 22 Okt 2026 pada 10.32
-- Versi server: 11.4.13-MariaDB
-- Versi PHP: 7.2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `if0_43190159_sipas_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengaduan`
--

CREATE TABLE `pengaduan` (
  `id_pengaduan` int(10) UNSIGNED NOT NULL,
  `id_siswa` int(10) UNSIGNED NOT NULL,
  `judul_pengaduan` varchar(150) NOT NULL,
  `isi_pengaduan` text NOT NULL,
  `tanggal_pengaduan` datetime NOT NULL DEFAULT current_timestamp(),
  `status` enum('Diajukan','Diproses','Selesai','Ditolak') NOT NULL DEFAULT 'Diajukan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `pengaduan`
--

INSERT INTO `pengaduan` (`id_pengaduan`, `id_siswa`, `judul_pengaduan`, `isi_pengaduan`, `tanggal_pengaduan`, `status`) VALUES
(1, 1, 'Kursi rusak di kelas XII RPL', 'Beberapa kursi di kelas XII RPL mengalami kerusakan pada bagian kaki dan sandaran.', '2026-09-24 15:59:53', 'Diajukan'),
(2, 2, 'Proyektor tidak menyala', 'Proyektor di ruang kelas tidak dapat menyala saat digunakan untuk presentasi.', '2026-09-24 15:59:53', 'Diproses'),
(3, 1, 'Lampu kelas mati', 'Dua lampu di bagian belakang kelas mati dan membuat ruangan lebih gelap.', '2026-09-24 15:59:53', 'Selesai'),
(4, 3, 'Kursi kelas rusak', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan.', '2026-09-24 15:59:54', 'Diajukan');
INSERT INTO `pengaduan` (`id_pengaduan`, `id_siswa`, `judul_pengaduan`, `isi_pengaduan`, `tanggal_pengaduan`, `status`) VALUES
(204, 3, 'kursi rusak', 'kursi rusak sama...', '2026-10-15 08:27:57', 'Ditolak'),
(205, 203, 'kursi rusak', 'kursi potong', '2026-10-15 08:33:54', 'Ditolak'),
(206, 205, 'wifi yo', 'wifi lemot banget duh', '2026-10-18 22:10:19', 'Diproses'),
(207, 206, 'kelaparan', 'teman teman saya hampir mati karena kelaparan', '2026-10-19 17:45:45', 'Diajukan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `progres_pengaduan`
--

CREATE TABLE `progres_pengaduan` (
  `id_progres` int(10) UNSIGNED NOT NULL,
  `id_pengaduan` int(10) UNSIGNED NOT NULL,
  `status_progres` varchar(100) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `tanggal_progres` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `progres_pengaduan`
--

INSERT INTO `progres_pengaduan` (`id_progres`, `id_pengaduan`, `status_progres`, `keterangan`, `tanggal_progres`) VALUES
(1, 1, 'Diajukan', 'Laporan diterima sistem.', '2026-09-24 15:59:53'),
(2, 2, 'Diajukan', 'Laporan diterima sistem.', '2026-09-24 15:59:53'),
(3, 2, 'Diproses', 'Laporan sedang ditindaklanjuti bagian sarpras.', '2026-09-24 15:59:53'),
(4, 3, 'Diajukan', 'Laporan diterima sistem.', '2026-09-24 15:59:53'),
(5, 3, 'Diproses', 'Lampu sudah dijadwalkan untuk diperbaiki.', '2026-09-24 15:59:53'),
(6, 3, 'Selesai', 'Lampu kelas sudah diganti dan berfungsi normal.', '2026-09-24 15:59:53'),
(9, 204, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.', '2026-10-15 08:27:57'),
(10, 204, 'Diproses', 'kursi lagi di benarkan', '2026-10-15 08:29:56'),
(11, 204, 'Selesai', 'kursi sudah diperbaiki', '2026-10-15 08:31:09'),
(12, 204, 'Ditolak', NULL, '2026-10-15 08:31:44'),
(13, 205, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.', '2026-10-15 08:33:54'),
(14, 205, 'Diproses', 'kursi sedang di perbaiki', '2026-10-15 08:34:24'),
(15, 205, 'Ditolak', 'stok kosong', '2026-10-15 08:35:17'),
(16, 206, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.', '2026-10-18 22:10:19'),
(17, 206, 'Diproses', 'diproses bro', '2026-10-18 23:47:08'),
(18, 207, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.', '2026-10-19 17:45:45');

-- --------------------------------------------------------

--
-- Struktur dari tabel `siswa`
--

CREATE TABLE `siswa` (
  `id_siswa` int(10) UNSIGNED NOT NULL,
  `id_user` int(10) UNSIGNED NOT NULL,
  `nis` varchar(20) NOT NULL,
  `nama_siswa` varchar(100) NOT NULL,
  `kelas` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `siswa`
--

INSERT INTO `siswa` (`id_siswa`, `id_user`, `nis`, `nama_siswa`, `kelas`) VALUES
(1, 2, '123456789', 'Siswa Contoh', 'XII RPL'),
(2, 3, '123456790', 'Andi Pratama', 'XII RPL'),
(3, 4, '26000001', 'rioo', 'X RPL 4'),
(203, 204, '131618', 'test', 'XI'),
(204, 205, '0824567', 'Kinar Ayu Naditya', 'XII RPL 4'),
(205, 206, '00897654', 'luthfi diandi rusmana', 'XII RPL 4'),
(206, 207, '111213', 'andika ahmad', 'XII RPL4');

-- --------------------------------------------------------

--
-- Struktur dari tabel `umpan_balik`
--

CREATE TABLE `umpan_balik` (
  `id_feedback` int(10) UNSIGNED NOT NULL,
  `id_pengaduan` int(10) UNSIGNED NOT NULL,
  `pemberi` enum('admin','siswa') NOT NULL DEFAULT 'siswa',
  `isi_feedback` text NOT NULL,
  `tanggal_feedback` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `umpan_balik`
--

INSERT INTO `umpan_balik` (`id_feedback`, `id_pengaduan`, `pemberi`, `isi_feedback`, `tanggal_feedback`) VALUES
(1, 3, 'siswa', 'Perbaikannya cepat dan lampu sekarang sudah normal. Terima kasih.', '2026-09-24 15:59:53'),
(2, 206, 'admin', 'kunaon wifi na', '2026-10-18 23:47:17');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id_user` int(10) UNSIGNED NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','siswa') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id_user`, `username`, `password`, `role`, `created_at`) VALUES
(1, 'admin', '$2y$12$ANJcIBII/hfGYNLJDNN8o.S2w0UAfm9jBu0M3SbuNm8PKmv8YPCq2', 'admin', '2026-09-24 08:59:53'),
(2, 'siswa', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(3, 'andi', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(4, 'rioo', '$2y$10$3vhHSkN1G64fpYLHKOJU8u1cNQudbcjUutEDi5IrK0bVntXOi8QHa', 'siswa', '2026-09-24 08:59:53');
INSERT INTO `users` (`id_user`, `username`, `password`, `role`, `created_at`) VALUES
(204, 'test', '$2y$10$rSyxUsnkQFyfpVMdVHs.aux.YVzqJPPWq8TWuS8nRch5u5re3ZuNK', 'siswa', '2026-10-15 01:33:29'),
(205, 'kinaayy', '$2y$12$pysytnnf2ikdkCZdm8xIEO.G1wQEFqWpJsD8d052nFIEKzMEGn1uu', 'siswa', '2026-10-19 02:26:01'),
(206, 'luthfid', '$2y$12$DlnRNRlZ7QPCrt.P9Prwg.P3O7N0eyBkWyPuTbV26WnV7xvxa9JyC', 'siswa', '2026-10-19 05:09:39'),
(207, 'dika', '$2y$12$YCGQGUem9I3WIIgKmKO61.muoJ5qYVBCrlX3fIMbZDcuxclXsl4ny', 'siswa', '2026-10-20 00:45:00');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `pengaduan`
--
ALTER TABLE `pengaduan`
  ADD PRIMARY KEY (`id_pengaduan`),
  ADD KEY `idx_pengaduan_status` (`status`),
  ADD KEY `idx_pengaduan_siswa` (`id_siswa`);

--
-- Indeks untuk tabel `progres_pengaduan`
--
ALTER TABLE `progres_pengaduan`
  ADD PRIMARY KEY (`id_progres`),
  ADD KEY `idx_progres_pengaduan` (`id_pengaduan`);

--
-- Indeks untuk tabel `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`id_siswa`),
  ADD UNIQUE KEY `id_user` (`id_user`),
  ADD UNIQUE KEY `nis` (`nis`);

--
-- Indeks untuk tabel `umpan_balik`
--
ALTER TABLE `umpan_balik`
  ADD PRIMARY KEY (`id_feedback`),
  ADD KEY `idx_feedback_pengaduan` (`id_pengaduan`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `pengaduan`
--
ALTER TABLE `pengaduan`
  MODIFY `id_pengaduan` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=208;

--
-- AUTO_INCREMENT untuk tabel `progres_pengaduan`
--
ALTER TABLE `progres_pengaduan`
  MODIFY `id_progres` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT untuk tabel `siswa`
--
ALTER TABLE `siswa`
  MODIFY `id_siswa` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=207;

--
-- AUTO_INCREMENT untuk tabel `umpan_balik`
--
ALTER TABLE `umpan_balik`
  MODIFY `id_feedback` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=208;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `pengaduan`
--
ALTER TABLE `pengaduan`
  ADD CONSTRAINT `fk_pengaduan_siswa` FOREIGN KEY (`id_siswa`) REFERENCES `siswa` (`id_siswa`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `progres_pengaduan`
--
ALTER TABLE `progres_pengaduan`
  ADD CONSTRAINT `fk_progres_pengaduan` FOREIGN KEY (`id_pengaduan`) REFERENCES `pengaduan` (`id_pengaduan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `siswa`
--
ALTER TABLE `siswa`
  ADD CONSTRAINT `fk_siswa_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `umpan_balik`
--
ALTER TABLE `umpan_balik`
  ADD CONSTRAINT `fk_feedback_pengaduan` FOREIGN KEY (`id_pengaduan`) REFERENCES `pengaduan` (`id_pengaduan`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 11 Nov 2026 pada 07.18
-- Versi server: 10.4.6-MariaDB
-- Versi PHP: 8.3.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sipas_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengaduan`
--

CREATE TABLE `pengaduan` (
  `id_pengaduan` int(10) UNSIGNED NOT NULL,
  `id_siswa` int(10) UNSIGNED NOT NULL,
  `judul_pengaduan` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isi_pengaduan` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto_bukti` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tanggal_pengaduan` datetime NOT NULL DEFAULT current_timestamp(),
  `status` enum('Diajukan','Diproses','Selesai','Ditolak') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Diajukan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `pengaduan`
--

INSERT INTO `pengaduan` (`id_pengaduan`, `id_siswa`, `judul_pengaduan`, `isi_pengaduan`, `foto_bukti`, `tanggal_pengaduan`, `status`) VALUES
(2, 2, 'Proyektor tidak menyala', 'Proyektor di ruang kelas tidak dapat menyala saat digunakan untuk presentasi.', NULL, '2026-09-24 15:59:53', 'Diproses'),
(205, 203, 'kursi rusak', 'kursi potong', NULL, '2026-10-15 08:33:54', 'Ditolak'),
(206, 205, 'wifi yo', 'wifi lemot banget duh', NULL, '2026-10-18 22:10:19', 'Diproses'),
(207, 206, 'kelaparan', 'teman teman saya hampir mati karena kelaparan', NULL, '2026-10-19 17:45:45', 'Diajukan'),
(208, 207, 'kursi rudak', 'kursi rusak di dekat kelas 12', NULL, '2026-11-07 03:37:56', 'Selesai'),
(209, 207, 'wifi lag', 'wifi lag ngelag', NULL, '2026-11-07 03:41:44', 'Ditolak'),
(210, 208, 'tes', 'tes', 'uploads/pengaduan/95e185e770f4c752b082d59addbfc1f4.jpg', '2026-11-11 14:17:22', 'Diajukan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `progres_pengaduan`
--

CREATE TABLE `progres_pengaduan` (
  `id_progres` int(10) UNSIGNED NOT NULL,
  `id_pengaduan` int(10) UNSIGNED NOT NULL,
  `status_progres` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `keterangan` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tanggal_progres` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `progres_pengaduan`
--

INSERT INTO `progres_pengaduan` (`id_progres`, `id_pengaduan`, `status_progres`, `keterangan`, `tanggal_progres`) VALUES
(2, 2, 'Diajukan', 'Laporan diterima sistem.', '2026-09-24 15:59:53'),
(3, 2, 'Diproses', 'Laporan sedang ditindaklanjuti bagian sarpras.', '2026-09-24 15:59:53'),
(13, 205, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.', '2026-10-15 08:33:54'),
(14, 205, 'Diproses', 'kursi sedang di perbaiki', '2026-10-15 08:34:24'),
(15, 205, 'Ditolak', 'stok kosong', '2026-10-15 08:35:17'),
(16, 206, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.', '2026-10-18 22:10:19'),
(17, 206, 'Diproses', 'diproses bro', '2026-10-18 23:47:08'),
(18, 207, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.', '2026-10-19 17:45:45'),
(19, 208, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.', '2026-11-07 03:37:56'),
(20, 208, 'Diproses', NULL, '2026-11-07 03:38:45'),
(21, 208, 'Selesai', 'sudah di ganti', '2026-11-07 03:40:05'),
(22, 209, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.', '2026-11-07 03:41:44'),
(23, 209, 'Diproses', 'sudah diproses', '2026-11-07 03:42:20'),
(24, 209, 'Ditolak', 'wifi emang lag jadi jangan ngeluh', '2026-11-07 03:43:46'),
(25, 209, 'Ditolak', 'ditolak', '2026-11-07 03:57:02'),
(26, 210, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.', '2026-11-11 14:17:22');

-- --------------------------------------------------------

--
-- Struktur dari tabel `siswa`
--

CREATE TABLE `siswa` (
  `id_siswa` int(10) UNSIGNED NOT NULL,
  `id_user` int(10) UNSIGNED NOT NULL,
  `nis` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_siswa` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kelas` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `siswa`
--

INSERT INTO `siswa` (`id_siswa`, `id_user`, `nis`, `nama_siswa`, `kelas`) VALUES
(2, 3, '123456790', 'Andi Pratama', 'XII RPL'),
(203, 204, '131618', 'test', 'XI'),
(204, 205, '0824567', 'Kinar Ayu Naditya', 'XII RPL 4'),
(205, 206, '00897654', 'luthfi diandi rusmana', 'XII RPL 4'),
(206, 207, '111213', 'andika ahmad', 'XII RPL4'),
(207, 208, '12131', 'test', 'XII'),
(208, 209, '0011', 'siswa', '12 RPL 4');

-- --------------------------------------------------------

--
-- Struktur dari tabel `umpan_balik`
--

CREATE TABLE `umpan_balik` (
  `id_feedback` int(10) UNSIGNED NOT NULL,
  `id_pengaduan` int(10) UNSIGNED NOT NULL,
  `pemberi` enum('admin','siswa') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'siswa',
  `isi_feedback` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `tanggal_feedback` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `umpan_balik`
--

INSERT INTO `umpan_balik` (`id_feedback`, `id_pengaduan`, `pemberi`, `isi_feedback`, `tanggal_feedback`) VALUES
(2, 206, 'admin', 'kunaon wifi na', '2026-10-18 23:47:17'),
(3, 208, 'siswa', 'mantap', '2026-11-07 03:40:40'),
(4, 209, 'admin', 'bye', '2026-11-07 03:54:08'),
(5, 209, 'admin', 'hahay', '2026-11-07 03:57:02');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id_user` int(10) UNSIGNED NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','siswa') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id_user`, `username`, `password`, `role`, `created_at`) VALUES
(1, 'admin', '$2y$12$ANJcIBII/hfGYNLJDNN8o.S2w0UAfm9jBu0M3SbuNm8PKmv8YPCq2', 'admin', '2026-09-24 08:59:53'),
(3, 'andi', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(204, 'test', '$2y$10$rSyxUsnkQFyfpVMdVHs.aux.YVzqJPPWq8TWuS8nRch5u5re3ZuNK', 'siswa', '2026-10-15 01:33:29'),
(205, 'kinaayy', '$2y$12$pysytnnf2ikdkCZdm8xIEO.G1wQEFqWpJsD8d052nFIEKzMEGn1uu', 'siswa', '2026-10-19 02:26:01'),
(206, 'luthfid', '$2y$12$DlnRNRlZ7QPCrt.P9Prwg.P3O7N0eyBkWyPuTbV26WnV7xvxa9JyC', 'siswa', '2026-10-19 05:09:39'),
(207, 'dika', '$2y$12$YCGQGUem9I3WIIgKmKO61.muoJ5qYVBCrlX3fIMbZDcuxclXsl4ny', 'siswa', '2026-10-20 00:45:00'),
(208, 'testing', '$2y$10$WT/jdo55.1PCtKsAOr096ei.YkmZlIC6PT6k9n/.FgrJWBL6T.yoy', 'siswa', '2026-11-06 20:37:23'),
(209, 'siswa', '$2y$10$uOwTUt0.LhemPB.vG5TPmuDCm35wYFLkffs8.f.pgAYfDG9kGeA8O', 'siswa', '2026-11-11 07:16:44');

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
  MODIFY `id_pengaduan` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=211;

--
-- AUTO_INCREMENT untuk tabel `progres_pengaduan`
--
ALTER TABLE `progres_pengaduan`
  MODIFY `id_progres` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT untuk tabel `siswa`
--
ALTER TABLE `siswa`
  MODIFY `id_siswa` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=209;

--
-- AUTO_INCREMENT untuk tabel `umpan_balik`
--
ALTER TABLE `umpan_balik`
  MODIFY `id_feedback` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=210;

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

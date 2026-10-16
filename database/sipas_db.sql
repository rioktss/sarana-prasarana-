-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 15 Okt 2026 pada 10.16
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
-- Database: `sipasbaru`
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
  `tanggal_pengaduan` datetime NOT NULL DEFAULT current_timestamp(),
  `status` enum('Diajukan','Diproses','Selesai','Ditolak') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Diajukan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `pengaduan`
--

INSERT INTO `pengaduan` (`id_pengaduan`, `id_siswa`, `judul_pengaduan`, `isi_pengaduan`, `tanggal_pengaduan`, `status`) VALUES
(1, 1, 'Kursi rusak di kelas XII RPL', 'Beberapa kursi di kelas XII RPL mengalami kerusakan pada bagian kaki dan sandaran.', '2026-09-24 15:59:53', 'Diajukan'),
(2, 2, 'Proyektor tidak menyala', 'Proyektor di ruang kelas tidak dapat menyala saat digunakan untuk presentasi.', '2026-09-24 15:59:53', 'Diproses'),
(3, 1, 'Lampu kelas mati', 'Dua lampu di bagian belakang kelas mati dan membuat ruangan lebih gelap.', '2026-09-24 15:59:53', 'Selesai'),
(4, 3, 'Kursi kelas rusak', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan.', '2026-09-24 15:59:54', 'Diajukan'),
(5, 4, 'Lampu kelas mati #002', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 002.', '2026-09-24 15:59:54', 'Diproses'),
(6, 5, 'Proyektor bermasalah #003', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 003.', '2026-09-24 15:59:54', 'Selesai'),
(7, 6, 'Papan tulis rusak #004', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 004.', '2026-09-24 15:59:54', 'Ditolak'),
(8, 7, 'Kipas angin tidak berfungsi #005', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 005.', '2026-09-24 15:59:54', 'Diajukan'),
(9, 8, 'AC kelas tidak dingin #006', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 006.', '2026-09-24 15:59:54', 'Diproses'),
(10, 9, 'Meja siswa rusak #007', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 007.', '2026-09-24 15:59:54', 'Selesai'),
(11, 10, 'Jendela kelas rusak #008', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 008.', '2026-09-24 15:59:54', 'Ditolak'),
(12, 11, 'Pintu kelas sulit ditutup #009', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 009.', '2026-09-24 15:59:54', 'Diajukan'),
(13, 12, 'Stop kontak tidak berfungsi #010', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 010.', '2026-09-24 15:59:54', 'Diproses'),
(14, 13, 'Kursi kelas rusak #011', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 011.', '2026-09-24 15:59:54', 'Selesai'),
(15, 14, 'Lampu kelas mati #012', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 012.', '2026-09-24 15:59:54', 'Ditolak'),
(16, 15, 'Proyektor bermasalah #013', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 013.', '2026-09-24 15:59:54', 'Diajukan'),
(17, 16, 'Papan tulis rusak #014', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 014.', '2026-09-24 15:59:54', 'Diproses'),
(18, 17, 'Kipas angin tidak berfungsi #015', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 015.', '2026-09-24 15:59:54', 'Selesai'),
(19, 18, 'AC kelas tidak dingin #016', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 016.', '2026-09-24 15:59:54', 'Ditolak'),
(20, 19, 'Meja siswa rusak #017', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 017.', '2026-09-24 15:59:54', 'Diajukan'),
(21, 20, 'Jendela kelas rusak #018', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 018.', '2026-09-24 15:59:54', 'Diproses'),
(22, 21, 'Pintu kelas sulit ditutup #019', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 019.', '2026-09-24 15:59:54', 'Selesai'),
(23, 22, 'Stop kontak tidak berfungsi #020', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 020.', '2026-09-24 15:59:54', 'Ditolak'),
(24, 23, 'Kursi kelas rusak #021', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 021.', '2026-09-24 15:59:54', 'Diajukan'),
(25, 24, 'Lampu kelas mati #022', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 022.', '2026-09-24 15:59:54', 'Diproses'),
(26, 25, 'Proyektor bermasalah #023', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 023.', '2026-09-24 15:59:54', 'Selesai'),
(27, 26, 'Papan tulis rusak #024', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 024.', '2026-09-24 15:59:54', 'Ditolak'),
(28, 27, 'Kipas angin tidak berfungsi #025', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 025.', '2026-09-24 15:59:54', 'Diajukan'),
(29, 28, 'AC kelas tidak dingin #026', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 026.', '2026-09-24 15:59:54', 'Diproses'),
(30, 29, 'Meja siswa rusak #027', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 027.', '2026-09-24 15:59:54', 'Selesai'),
(31, 30, 'Jendela kelas rusak #028', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 028.', '2026-09-24 15:59:54', 'Ditolak'),
(32, 31, 'Pintu kelas sulit ditutup #029', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 029.', '2026-09-24 15:59:54', 'Diajukan'),
(33, 32, 'Stop kontak tidak berfungsi #030', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 030.', '2026-09-24 15:59:54', 'Diproses'),
(34, 33, 'Kursi kelas rusak #031', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 031.', '2026-09-24 15:59:54', 'Selesai'),
(35, 34, 'Lampu kelas mati #032', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 032.', '2026-09-24 15:59:54', 'Ditolak'),
(36, 35, 'Proyektor bermasalah #033', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 033.', '2026-09-24 15:59:54', 'Diajukan'),
(37, 36, 'Papan tulis rusak #034', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 034.', '2026-09-24 15:59:54', 'Diproses'),
(38, 37, 'Kipas angin tidak berfungsi #035', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 035.', '2026-09-24 15:59:54', 'Selesai'),
(39, 38, 'AC kelas tidak dingin #036', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 036.', '2026-09-24 15:59:54', 'Ditolak'),
(40, 39, 'Meja siswa rusak #037', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 037.', '2026-09-24 15:59:54', 'Diajukan'),
(41, 40, 'Jendela kelas rusak #038', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 038.', '2026-09-24 15:59:54', 'Diproses'),
(42, 41, 'Pintu kelas sulit ditutup #039', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 039.', '2026-09-24 15:59:54', 'Selesai'),
(43, 42, 'Stop kontak tidak berfungsi #040', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 040.', '2026-09-24 15:59:54', 'Ditolak'),
(44, 43, 'Kursi kelas rusak #041', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 041.', '2026-09-24 15:59:54', 'Diajukan'),
(45, 44, 'Lampu kelas mati #042', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 042.', '2026-09-24 15:59:54', 'Diproses'),
(46, 45, 'Proyektor bermasalah #043', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 043.', '2026-09-24 15:59:54', 'Selesai'),
(47, 46, 'Papan tulis rusak #044', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 044.', '2026-09-24 15:59:54', 'Ditolak'),
(48, 47, 'Kipas angin tidak berfungsi #045', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 045.', '2026-09-24 15:59:54', 'Diajukan'),
(49, 48, 'AC kelas tidak dingin #046', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 046.', '2026-09-24 15:59:54', 'Diproses'),
(50, 49, 'Meja siswa rusak #047', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 047.', '2026-09-24 15:59:54', 'Selesai'),
(51, 50, 'Jendela kelas rusak #048', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 048.', '2026-09-24 15:59:54', 'Ditolak'),
(52, 51, 'Pintu kelas sulit ditutup #049', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 049.', '2026-09-24 15:59:54', 'Diajukan'),
(53, 52, 'Stop kontak tidak berfungsi #050', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 050.', '2026-09-24 15:59:54', 'Diproses'),
(54, 53, 'Kursi kelas rusak #051', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 051.', '2026-09-24 15:59:54', 'Selesai'),
(55, 54, 'Lampu kelas mati #052', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 052.', '2026-09-24 15:59:54', 'Ditolak'),
(56, 55, 'Proyektor bermasalah #053', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 053.', '2026-09-24 15:59:54', 'Diajukan'),
(57, 56, 'Papan tulis rusak #054', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 054.', '2026-09-24 15:59:54', 'Diproses'),
(58, 57, 'Kipas angin tidak berfungsi #055', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 055.', '2026-09-24 15:59:54', 'Selesai'),
(59, 58, 'AC kelas tidak dingin #056', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 056.', '2026-09-24 15:59:54', 'Ditolak'),
(60, 59, 'Meja siswa rusak #057', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 057.', '2026-09-24 15:59:54', 'Diajukan'),
(61, 60, 'Jendela kelas rusak #058', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 058.', '2026-09-24 15:59:54', 'Diproses'),
(62, 61, 'Pintu kelas sulit ditutup #059', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 059.', '2026-09-24 15:59:54', 'Selesai'),
(63, 62, 'Stop kontak tidak berfungsi #060', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 060.', '2026-09-24 15:59:54', 'Ditolak'),
(64, 63, 'Kursi kelas rusak #061', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 061.', '2026-09-24 15:59:54', 'Diajukan'),
(65, 64, 'Lampu kelas mati #062', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 062.', '2026-09-24 15:59:54', 'Diproses'),
(66, 65, 'Proyektor bermasalah #063', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 063.', '2026-09-24 15:59:54', 'Selesai'),
(67, 66, 'Papan tulis rusak #064', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 064.', '2026-09-24 15:59:54', 'Ditolak'),
(68, 67, 'Kipas angin tidak berfungsi #065', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 065.', '2026-09-24 15:59:54', 'Diajukan'),
(69, 68, 'AC kelas tidak dingin #066', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 066.', '2026-09-24 15:59:54', 'Diproses'),
(70, 69, 'Meja siswa rusak #067', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 067.', '2026-09-24 15:59:54', 'Selesai'),
(71, 70, 'Jendela kelas rusak #068', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 068.', '2026-09-24 15:59:54', 'Ditolak'),
(72, 71, 'Pintu kelas sulit ditutup #069', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 069.', '2026-09-24 15:59:54', 'Diajukan'),
(73, 72, 'Stop kontak tidak berfungsi #070', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 070.', '2026-09-24 15:59:54', 'Diproses'),
(74, 73, 'Kursi kelas rusak #071', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 071.', '2026-09-24 15:59:54', 'Selesai'),
(75, 74, 'Lampu kelas mati #072', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 072.', '2026-09-24 15:59:54', 'Ditolak'),
(76, 75, 'Proyektor bermasalah #073', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 073.', '2026-09-24 15:59:54', 'Diajukan'),
(77, 76, 'Papan tulis rusak #074', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 074.', '2026-09-24 15:59:54', 'Diproses'),
(78, 77, 'Kipas angin tidak berfungsi #075', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 075.', '2026-09-24 15:59:54', 'Selesai'),
(79, 78, 'AC kelas tidak dingin #076', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 076.', '2026-09-24 15:59:54', 'Ditolak'),
(80, 79, 'Meja siswa rusak #077', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 077.', '2026-09-24 15:59:54', 'Diajukan'),
(81, 80, 'Jendela kelas rusak #078', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 078.', '2026-09-24 15:59:54', 'Diproses'),
(82, 81, 'Pintu kelas sulit ditutup #079', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 079.', '2026-09-24 15:59:54', 'Selesai'),
(83, 82, 'Stop kontak tidak berfungsi #080', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 080.', '2026-09-24 15:59:54', 'Ditolak'),
(84, 83, 'Kursi kelas rusak #081', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 081.', '2026-09-24 15:59:54', 'Diajukan'),
(85, 84, 'Lampu kelas mati #082', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 082.', '2026-09-24 15:59:54', 'Diproses'),
(86, 85, 'Proyektor bermasalah #083', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 083.', '2026-09-24 15:59:54', 'Selesai'),
(87, 86, 'Papan tulis rusak #084', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 084.', '2026-09-24 15:59:54', 'Ditolak'),
(88, 87, 'Kipas angin tidak berfungsi #085', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 085.', '2026-09-24 15:59:54', 'Diajukan'),
(89, 88, 'AC kelas tidak dingin #086', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 086.', '2026-09-24 15:59:54', 'Diproses'),
(90, 89, 'Meja siswa rusak #087', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 087.', '2026-09-24 15:59:54', 'Selesai'),
(91, 90, 'Jendela kelas rusak #088', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 088.', '2026-09-24 15:59:54', 'Ditolak'),
(92, 91, 'Pintu kelas sulit ditutup #089', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 089.', '2026-09-24 15:59:54', 'Diajukan'),
(93, 92, 'Stop kontak tidak berfungsi #090', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 090.', '2026-09-24 15:59:54', 'Diproses'),
(94, 93, 'Kursi kelas rusak #091', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 091.', '2026-09-24 15:59:54', 'Selesai'),
(95, 94, 'Lampu kelas mati #092', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 092.', '2026-09-24 15:59:54', 'Ditolak'),
(96, 95, 'Proyektor bermasalah #093', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 093.', '2026-09-24 15:59:54', 'Diajukan'),
(97, 96, 'Papan tulis rusak #094', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 094.', '2026-09-24 15:59:54', 'Diproses'),
(98, 97, 'Kipas angin tidak berfungsi #095', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 095.', '2026-09-24 15:59:54', 'Selesai'),
(99, 98, 'AC kelas tidak dingin #096', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 096.', '2026-09-24 15:59:54', 'Ditolak'),
(100, 99, 'Meja siswa rusak #097', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 097.', '2026-09-24 15:59:54', 'Diajukan'),
(101, 100, 'Jendela kelas rusak #098', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 098.', '2026-09-24 15:59:54', 'Diproses'),
(102, 101, 'Pintu kelas sulit ditutup #099', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 099.', '2026-09-24 15:59:54', 'Selesai'),
(103, 102, 'Stop kontak tidak berfungsi #100', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 100.', '2026-09-24 15:59:54', 'Ditolak'),
(104, 103, 'Kursi kelas rusak #101', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 101.', '2026-09-24 15:59:54', 'Diajukan'),
(105, 104, 'Lampu kelas mati #102', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 102.', '2026-09-24 15:59:54', 'Diproses'),
(106, 105, 'Proyektor bermasalah #103', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 103.', '2026-09-24 15:59:54', 'Selesai'),
(107, 106, 'Papan tulis rusak #104', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 104.', '2026-09-24 15:59:54', 'Ditolak'),
(108, 107, 'Kipas angin tidak berfungsi #105', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 105.', '2026-09-24 15:59:54', 'Diajukan'),
(109, 108, 'AC kelas tidak dingin #106', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 106.', '2026-09-24 15:59:54', 'Diproses'),
(110, 109, 'Meja siswa rusak #107', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 107.', '2026-09-24 15:59:54', 'Selesai'),
(111, 110, 'Jendela kelas rusak #108', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 108.', '2026-09-24 15:59:54', 'Ditolak'),
(112, 111, 'Pintu kelas sulit ditutup #109', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 109.', '2026-09-24 15:59:54', 'Diajukan'),
(113, 112, 'Stop kontak tidak berfungsi #110', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 110.', '2026-09-24 15:59:54', 'Diproses'),
(114, 113, 'Kursi kelas rusak #111', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 111.', '2026-09-24 15:59:54', 'Selesai'),
(115, 114, 'Lampu kelas mati #112', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 112.', '2026-09-24 15:59:54', 'Ditolak'),
(116, 115, 'Proyektor bermasalah #113', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 113.', '2026-09-24 15:59:54', 'Diajukan'),
(117, 116, 'Papan tulis rusak #114', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 114.', '2026-09-24 15:59:54', 'Diproses'),
(118, 117, 'Kipas angin tidak berfungsi #115', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 115.', '2026-09-24 15:59:54', 'Selesai'),
(119, 118, 'AC kelas tidak dingin #116', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 116.', '2026-09-24 15:59:54', 'Ditolak'),
(120, 119, 'Meja siswa rusak #117', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 117.', '2026-09-24 15:59:54', 'Diajukan'),
(121, 120, 'Jendela kelas rusak #118', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 118.', '2026-09-24 15:59:54', 'Diproses'),
(122, 121, 'Pintu kelas sulit ditutup #119', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 119.', '2026-09-24 15:59:54', 'Selesai'),
(123, 122, 'Stop kontak tidak berfungsi #120', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 120.', '2026-09-24 15:59:54', 'Ditolak'),
(124, 123, 'Kursi kelas rusak #121', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 121.', '2026-09-24 15:59:54', 'Diajukan'),
(125, 124, 'Lampu kelas mati #122', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 122.', '2026-09-24 15:59:54', 'Diproses'),
(126, 125, 'Proyektor bermasalah #123', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 123.', '2026-09-24 15:59:54', 'Selesai'),
(127, 126, 'Papan tulis rusak #124', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 124.', '2026-09-24 15:59:54', 'Ditolak'),
(128, 127, 'Kipas angin tidak berfungsi #125', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 125.', '2026-09-24 15:59:54', 'Diajukan'),
(129, 128, 'AC kelas tidak dingin #126', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 126.', '2026-09-24 15:59:54', 'Diproses'),
(130, 129, 'Meja siswa rusak #127', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 127.', '2026-09-24 15:59:54', 'Selesai'),
(131, 130, 'Jendela kelas rusak #128', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 128.', '2026-09-24 15:59:54', 'Ditolak'),
(132, 131, 'Pintu kelas sulit ditutup #129', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 129.', '2026-09-24 15:59:54', 'Diajukan'),
(133, 132, 'Stop kontak tidak berfungsi #130', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 130.', '2026-09-24 15:59:54', 'Diproses'),
(134, 133, 'Kursi kelas rusak #131', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 131.', '2026-09-24 15:59:54', 'Selesai'),
(135, 134, 'Lampu kelas mati #132', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 132.', '2026-09-24 15:59:54', 'Ditolak'),
(136, 135, 'Proyektor bermasalah #133', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 133.', '2026-09-24 15:59:54', 'Diajukan'),
(137, 136, 'Papan tulis rusak #134', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 134.', '2026-09-24 15:59:54', 'Diproses'),
(138, 137, 'Kipas angin tidak berfungsi #135', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 135.', '2026-09-24 15:59:54', 'Selesai'),
(139, 138, 'AC kelas tidak dingin #136', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 136.', '2026-09-24 15:59:54', 'Ditolak'),
(140, 139, 'Meja siswa rusak #137', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 137.', '2026-09-24 15:59:54', 'Diajukan'),
(141, 140, 'Jendela kelas rusak #138', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 138.', '2026-09-24 15:59:54', 'Diproses'),
(142, 141, 'Pintu kelas sulit ditutup #139', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 139.', '2026-09-24 15:59:54', 'Selesai'),
(143, 142, 'Stop kontak tidak berfungsi #140', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 140.', '2026-09-24 15:59:54', 'Ditolak'),
(144, 143, 'Kursi kelas rusak #141', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 141.', '2026-09-24 15:59:54', 'Diajukan'),
(145, 144, 'Lampu kelas mati #142', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 142.', '2026-09-24 15:59:54', 'Diproses'),
(146, 145, 'Proyektor bermasalah #143', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 143.', '2026-09-24 15:59:54', 'Selesai'),
(147, 146, 'Papan tulis rusak #144', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 144.', '2026-09-24 15:59:54', 'Ditolak'),
(148, 147, 'Kipas angin tidak berfungsi #145', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 145.', '2026-09-24 15:59:54', 'Diajukan'),
(149, 148, 'AC kelas tidak dingin #146', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 146.', '2026-09-24 15:59:54', 'Diproses'),
(150, 149, 'Meja siswa rusak #147', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 147.', '2026-09-24 15:59:54', 'Selesai'),
(151, 150, 'Jendela kelas rusak #148', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 148.', '2026-09-24 15:59:54', 'Ditolak'),
(152, 151, 'Pintu kelas sulit ditutup #149', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 149.', '2026-09-24 15:59:54', 'Diajukan'),
(153, 152, 'Stop kontak tidak berfungsi #150', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 150.', '2026-09-24 15:59:54', 'Diproses'),
(154, 153, 'Kursi kelas rusak #151', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 151.', '2026-09-24 15:59:54', 'Selesai'),
(155, 154, 'Lampu kelas mati #152', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 152.', '2026-09-24 15:59:54', 'Ditolak'),
(156, 155, 'Proyektor bermasalah #153', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 153.', '2026-09-24 15:59:54', 'Diajukan'),
(157, 156, 'Papan tulis rusak #154', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 154.', '2026-09-24 15:59:54', 'Diproses'),
(158, 157, 'Kipas angin tidak berfungsi #155', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 155.', '2026-09-24 15:59:54', 'Selesai'),
(159, 158, 'AC kelas tidak dingin #156', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 156.', '2026-09-24 15:59:54', 'Ditolak'),
(160, 159, 'Meja siswa rusak #157', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 157.', '2026-09-24 15:59:54', 'Diajukan'),
(161, 160, 'Jendela kelas rusak #158', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 158.', '2026-09-24 15:59:54', 'Diproses'),
(162, 161, 'Pintu kelas sulit ditutup #159', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 159.', '2026-09-24 15:59:54', 'Selesai'),
(163, 162, 'Stop kontak tidak berfungsi #160', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 160.', '2026-09-24 15:59:54', 'Ditolak'),
(164, 163, 'Kursi kelas rusak #161', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 161.', '2026-09-24 15:59:54', 'Diajukan'),
(165, 164, 'Lampu kelas mati #162', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 162.', '2026-09-24 15:59:54', 'Diproses'),
(166, 165, 'Proyektor bermasalah #163', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 163.', '2026-09-24 15:59:54', 'Selesai'),
(167, 166, 'Papan tulis rusak #164', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 164.', '2026-09-24 15:59:54', 'Ditolak'),
(168, 167, 'Kipas angin tidak berfungsi #165', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 165.', '2026-09-24 15:59:54', 'Diajukan'),
(169, 168, 'AC kelas tidak dingin #166', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 166.', '2026-09-24 15:59:54', 'Diproses'),
(170, 169, 'Meja siswa rusak #167', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 167.', '2026-09-24 15:59:54', 'Selesai'),
(171, 170, 'Jendela kelas rusak #168', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 168.', '2026-09-24 15:59:54', 'Ditolak'),
(172, 171, 'Pintu kelas sulit ditutup #169', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 169.', '2026-09-24 15:59:54', 'Diajukan'),
(173, 172, 'Stop kontak tidak berfungsi #170', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 170.', '2026-09-24 15:59:54', 'Diproses'),
(174, 173, 'Kursi kelas rusak #171', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 171.', '2026-09-24 15:59:54', 'Selesai'),
(175, 174, 'Lampu kelas mati #172', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 172.', '2026-09-24 15:59:54', 'Ditolak'),
(176, 175, 'Proyektor bermasalah #173', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 173.', '2026-09-24 15:59:54', 'Diajukan'),
(177, 176, 'Papan tulis rusak #174', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 174.', '2026-09-24 15:59:54', 'Diproses'),
(178, 177, 'Kipas angin tidak berfungsi #175', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 175.', '2026-09-24 15:59:54', 'Selesai'),
(179, 178, 'AC kelas tidak dingin #176', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 176.', '2026-09-24 15:59:54', 'Ditolak'),
(180, 179, 'Meja siswa rusak #177', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 177.', '2026-09-24 15:59:54', 'Diajukan'),
(181, 180, 'Jendela kelas rusak #178', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 178.', '2026-09-24 15:59:54', 'Diproses'),
(182, 181, 'Pintu kelas sulit ditutup #179', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 179.', '2026-09-24 15:59:54', 'Selesai'),
(183, 182, 'Stop kontak tidak berfungsi #180', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 180.', '2026-09-24 15:59:54', 'Ditolak'),
(184, 183, 'Kursi kelas rusak #181', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 181.', '2026-09-24 15:59:54', 'Diajukan'),
(185, 184, 'Lampu kelas mati #182', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 182.', '2026-09-24 15:59:54', 'Diproses'),
(186, 185, 'Proyektor bermasalah #183', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 183.', '2026-09-24 15:59:54', 'Selesai'),
(187, 186, 'Papan tulis rusak #184', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 184.', '2026-09-24 15:59:54', 'Ditolak'),
(188, 187, 'Kipas angin tidak berfungsi #185', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 185.', '2026-09-24 15:59:54', 'Diajukan'),
(189, 188, 'AC kelas tidak dingin #186', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 186.', '2026-09-24 15:59:54', 'Diproses'),
(190, 189, 'Meja siswa rusak #187', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 187.', '2026-09-24 15:59:54', 'Selesai'),
(191, 190, 'Jendela kelas rusak #188', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 188.', '2026-09-24 15:59:54', 'Ditolak'),
(192, 191, 'Pintu kelas sulit ditutup #189', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 189.', '2026-09-24 15:59:54', 'Diajukan'),
(193, 192, 'Stop kontak tidak berfungsi #190', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 190.', '2026-09-24 15:59:54', 'Diproses'),
(194, 193, 'Kursi kelas rusak #191', 'Beberapa kursi di kelas mengalami kerusakan dan perlu diperbaiki agar nyaman digunakan. Laporan dummy nomor 191.', '2026-09-24 15:59:54', 'Selesai'),
(195, 194, 'Lampu kelas mati #192', 'Lampu di ruang kelas mati sehingga pencahayaan kurang baik saat kegiatan belajar. Laporan dummy nomor 192.', '2026-09-24 15:59:54', 'Ditolak'),
(196, 195, 'Proyektor bermasalah #193', 'Proyektor kelas tidak dapat digunakan dengan normal saat presentasi. Laporan dummy nomor 193.', '2026-09-24 15:59:54', 'Diajukan'),
(197, 196, 'Papan tulis rusak #194', 'Papan tulis mengalami kerusakan dan perlu diperiksa oleh bagian sarana prasarana. Laporan dummy nomor 194.', '2026-09-24 15:59:54', 'Diproses'),
(198, 197, 'Kipas angin tidak berfungsi #195', 'Kipas angin di kelas tidak berfungsi sehingga sirkulasi udara kurang nyaman. Laporan dummy nomor 195.', '2026-09-24 15:59:54', 'Selesai'),
(199, 198, 'AC kelas tidak dingin #196', 'AC di ruang kelas tidak dingin dan perlu dilakukan pemeriksaan. Laporan dummy nomor 196.', '2026-09-24 15:59:54', 'Ditolak'),
(200, 199, 'Meja siswa rusak #197', 'Beberapa meja siswa rusak dan mengganggu kegiatan belajar. Laporan dummy nomor 197.', '2026-09-24 15:59:54', 'Diajukan'),
(201, 200, 'Jendela kelas rusak #198', 'Jendela kelas mengalami kerusakan pada bagian engsel atau pengunci. Laporan dummy nomor 198.', '2026-09-24 15:59:54', 'Selesai'),
(202, 201, 'Pintu kelas sulit ditutup #199', 'Pintu kelas sulit ditutup dengan baik dan membutuhkan perbaikan. Laporan dummy nomor 199.', '2026-09-24 15:59:54', 'Selesai'),
(203, 202, 'Stop kontak tidak berfungsi #200', 'Stop kontak di ruang kelas tidak dapat digunakan untuk kebutuhan pembelajaran. Laporan dummy nomor 200.', '2026-09-24 15:59:54', 'Selesai'),
(204, 3, 'kursi rusak', 'kursi rusak sama...', '2026-10-15 08:27:57', 'Ditolak'),
(205, 203, 'kursi rusak', 'kursi potong', '2026-10-15 08:33:54', 'Ditolak');

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
(1, 1, 'Diajukan', 'Laporan diterima sistem.', '2026-09-24 15:59:53'),
(2, 2, 'Diajukan', 'Laporan diterima sistem.', '2026-09-24 15:59:53'),
(3, 2, 'Diproses', 'Laporan sedang ditindaklanjuti bagian sarpras.', '2026-09-24 15:59:53'),
(4, 3, 'Diajukan', 'Laporan diterima sistem.', '2026-09-24 15:59:53'),
(5, 3, 'Diproses', 'Lampu sudah dijadwalkan untuk diperbaiki.', '2026-09-24 15:59:53'),
(6, 3, 'Selesai', 'Lampu kelas sudah diganti dan berfungsi normal.', '2026-09-24 15:59:53'),
(7, 203, 'Selesai', NULL, '2026-09-24 16:03:12'),
(8, 201, 'Selesai', NULL, '2026-10-15 07:54:33'),
(9, 204, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.', '2026-10-15 08:27:57'),
(10, 204, 'Diproses', 'kursi lagi di benarkan', '2026-10-15 08:29:56'),
(11, 204, 'Selesai', 'kursi sudah diperbaiki', '2026-10-15 08:31:09'),
(12, 204, 'Ditolak', NULL, '2026-10-15 08:31:44'),
(13, 205, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.', '2026-10-15 08:33:54'),
(14, 205, 'Diproses', 'kursi sedang di perbaiki', '2026-10-15 08:34:24'),
(15, 205, 'Ditolak', 'stok kosong', '2026-10-15 08:35:17');

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
(1, 2, '123456789', 'Siswa Contoh', 'XII RPL'),
(2, 3, '123456790', 'Andi Pratama', 'XII RPL'),
(3, 4, '26000001', 'rioo', 'X RPL 4'),
(4, 5, '26000002', 'Siswa Dummy 002', 'X RPL 2'),
(5, 6, '26000003', 'Siswa Dummy 003', 'XI RPL 1'),
(6, 7, '26000004', 'Siswa Dummy 004', 'XI RPL 2'),
(7, 8, '26000005', 'Siswa Dummy 005', 'XII RPL 1'),
(8, 9, '26000006', 'Siswa Dummy 006', 'XII RPL 2'),
(9, 10, '26000007', 'Siswa Dummy 007', 'X RPL 1'),
(10, 11, '26000008', 'Siswa Dummy 008', 'X RPL 2'),
(11, 12, '26000009', 'Siswa Dummy 009', 'XI RPL 1'),
(12, 13, '26000010', 'Siswa Dummy 010', 'XI RPL 2'),
(13, 14, '26000011', 'Siswa Dummy 011', 'XII RPL 1'),
(14, 15, '26000012', 'Siswa Dummy 012', 'XII RPL 2'),
(15, 16, '26000013', 'Siswa Dummy 013', 'X RPL 1'),
(16, 17, '26000014', 'Siswa Dummy 014', 'X RPL 2'),
(17, 18, '26000015', 'Siswa Dummy 015', 'XI RPL 1'),
(18, 19, '26000016', 'Siswa Dummy 016', 'XI RPL 2'),
(19, 20, '26000017', 'Siswa Dummy 017', 'XII RPL 1'),
(20, 21, '26000018', 'Siswa Dummy 018', 'XII RPL 2'),
(21, 22, '26000019', 'Siswa Dummy 019', 'X RPL 1'),
(22, 23, '26000020', 'Siswa Dummy 020', 'X RPL 2'),
(23, 24, '26000021', 'Siswa Dummy 021', 'XI RPL 1'),
(24, 25, '26000022', 'Siswa Dummy 022', 'XI RPL 2'),
(25, 26, '26000023', 'Siswa Dummy 023', 'XII RPL 1'),
(26, 27, '26000024', 'Siswa Dummy 024', 'XII RPL 2'),
(27, 28, '26000025', 'Siswa Dummy 025', 'X RPL 1'),
(28, 29, '26000026', 'Siswa Dummy 026', 'X RPL 2'),
(29, 30, '26000027', 'Siswa Dummy 027', 'XI RPL 1'),
(30, 31, '26000028', 'Siswa Dummy 028', 'XI RPL 2'),
(31, 32, '26000029', 'Siswa Dummy 029', 'XII RPL 1'),
(32, 33, '26000030', 'Siswa Dummy 030', 'XII RPL 2'),
(33, 34, '26000031', 'Siswa Dummy 031', 'X RPL 1'),
(34, 35, '26000032', 'Siswa Dummy 032', 'X RPL 2'),
(35, 36, '26000033', 'Siswa Dummy 033', 'XI RPL 1'),
(36, 37, '26000034', 'Siswa Dummy 034', 'XI RPL 2'),
(37, 38, '26000035', 'Siswa Dummy 035', 'XII RPL 1'),
(38, 39, '26000036', 'Siswa Dummy 036', 'XII RPL 2'),
(39, 40, '26000037', 'Siswa Dummy 037', 'X RPL 1'),
(40, 41, '26000038', 'Siswa Dummy 038', 'X RPL 2'),
(41, 42, '26000039', 'Siswa Dummy 039', 'XI RPL 1'),
(42, 43, '26000040', 'Siswa Dummy 040', 'XI RPL 2'),
(43, 44, '26000041', 'Siswa Dummy 041', 'XII RPL 1'),
(44, 45, '26000042', 'Siswa Dummy 042', 'XII RPL 2'),
(45, 46, '26000043', 'Siswa Dummy 043', 'X RPL 1'),
(46, 47, '26000044', 'Siswa Dummy 044', 'X RPL 2'),
(47, 48, '26000045', 'Siswa Dummy 045', 'XI RPL 1'),
(48, 49, '26000046', 'Siswa Dummy 046', 'XI RPL 2'),
(49, 50, '26000047', 'Siswa Dummy 047', 'XII RPL 1'),
(50, 51, '26000048', 'Siswa Dummy 048', 'XII RPL 2'),
(51, 52, '26000049', 'Siswa Dummy 049', 'X RPL 1'),
(52, 53, '26000050', 'Siswa Dummy 050', 'X RPL 2'),
(53, 54, '26000051', 'Siswa Dummy 051', 'XI RPL 1'),
(54, 55, '26000052', 'Siswa Dummy 052', 'XI RPL 2'),
(55, 56, '26000053', 'Siswa Dummy 053', 'XII RPL 1'),
(56, 57, '26000054', 'Siswa Dummy 054', 'XII RPL 2'),
(57, 58, '26000055', 'Siswa Dummy 055', 'X RPL 1'),
(58, 59, '26000056', 'Siswa Dummy 056', 'X RPL 2'),
(59, 60, '26000057', 'Siswa Dummy 057', 'XI RPL 1'),
(60, 61, '26000058', 'Siswa Dummy 058', 'XI RPL 2'),
(61, 62, '26000059', 'Siswa Dummy 059', 'XII RPL 1'),
(62, 63, '26000060', 'Siswa Dummy 060', 'XII RPL 2'),
(63, 64, '26000061', 'Siswa Dummy 061', 'X RPL 1'),
(64, 65, '26000062', 'Siswa Dummy 062', 'X RPL 2'),
(65, 66, '26000063', 'Siswa Dummy 063', 'XI RPL 1'),
(66, 67, '26000064', 'Siswa Dummy 064', 'XI RPL 2'),
(67, 68, '26000065', 'Siswa Dummy 065', 'XII RPL 1'),
(68, 69, '26000066', 'Siswa Dummy 066', 'XII RPL 2'),
(69, 70, '26000067', 'Siswa Dummy 067', 'X RPL 1'),
(70, 71, '26000068', 'Siswa Dummy 068', 'X RPL 2'),
(71, 72, '26000069', 'Siswa Dummy 069', 'XI RPL 1'),
(72, 73, '26000070', 'Siswa Dummy 070', 'XI RPL 2'),
(73, 74, '26000071', 'Siswa Dummy 071', 'XII RPL 1'),
(74, 75, '26000072', 'Siswa Dummy 072', 'XII RPL 2'),
(75, 76, '26000073', 'Siswa Dummy 073', 'X RPL 1'),
(76, 77, '26000074', 'Siswa Dummy 074', 'X RPL 2'),
(77, 78, '26000075', 'Siswa Dummy 075', 'XI RPL 1'),
(78, 79, '26000076', 'Siswa Dummy 076', 'XI RPL 2'),
(79, 80, '26000077', 'Siswa Dummy 077', 'XII RPL 1'),
(80, 81, '26000078', 'Siswa Dummy 078', 'XII RPL 2'),
(81, 82, '26000079', 'Siswa Dummy 079', 'X RPL 1'),
(82, 83, '26000080', 'Siswa Dummy 080', 'X RPL 2'),
(83, 84, '26000081', 'Siswa Dummy 081', 'XI RPL 1'),
(84, 85, '26000082', 'Siswa Dummy 082', 'XI RPL 2'),
(85, 86, '26000083', 'Siswa Dummy 083', 'XII RPL 1'),
(86, 87, '26000084', 'Siswa Dummy 084', 'XII RPL 2'),
(87, 88, '26000085', 'Siswa Dummy 085', 'X RPL 1'),
(88, 89, '26000086', 'Siswa Dummy 086', 'X RPL 2'),
(89, 90, '26000087', 'Siswa Dummy 087', 'XI RPL 1'),
(90, 91, '26000088', 'Siswa Dummy 088', 'XI RPL 2'),
(91, 92, '26000089', 'Siswa Dummy 089', 'XII RPL 1'),
(92, 93, '26000090', 'Siswa Dummy 090', 'XII RPL 2'),
(93, 94, '26000091', 'Siswa Dummy 091', 'X RPL 1'),
(94, 95, '26000092', 'Siswa Dummy 092', 'X RPL 2'),
(95, 96, '26000093', 'Siswa Dummy 093', 'XI RPL 1'),
(96, 97, '26000094', 'Siswa Dummy 094', 'XI RPL 2'),
(97, 98, '26000095', 'Siswa Dummy 095', 'XII RPL 1'),
(98, 99, '26000096', 'Siswa Dummy 096', 'XII RPL 2'),
(99, 100, '26000097', 'Siswa Dummy 097', 'X RPL 1'),
(100, 101, '26000098', 'Siswa Dummy 098', 'X RPL 2'),
(101, 102, '26000099', 'Siswa Dummy 099', 'XI RPL 1'),
(102, 103, '26000100', 'Siswa Dummy 100', 'XI RPL 2'),
(103, 104, '26000101', 'Siswa Dummy 101', 'XII RPL 1'),
(104, 105, '26000102', 'Siswa Dummy 102', 'XII RPL 2'),
(105, 106, '26000103', 'Siswa Dummy 103', 'X RPL 1'),
(106, 107, '26000104', 'Siswa Dummy 104', 'X RPL 2'),
(107, 108, '26000105', 'Siswa Dummy 105', 'XI RPL 1'),
(108, 109, '26000106', 'Siswa Dummy 106', 'XI RPL 2'),
(109, 110, '26000107', 'Siswa Dummy 107', 'XII RPL 1'),
(110, 111, '26000108', 'Siswa Dummy 108', 'XII RPL 2'),
(111, 112, '26000109', 'Siswa Dummy 109', 'X RPL 1'),
(112, 113, '26000110', 'Siswa Dummy 110', 'X RPL 2'),
(113, 114, '26000111', 'Siswa Dummy 111', 'XI RPL 1'),
(114, 115, '26000112', 'Siswa Dummy 112', 'XI RPL 2'),
(115, 116, '26000113', 'Siswa Dummy 113', 'XII RPL 1'),
(116, 117, '26000114', 'Siswa Dummy 114', 'XII RPL 2'),
(117, 118, '26000115', 'Siswa Dummy 115', 'X RPL 1'),
(118, 119, '26000116', 'Siswa Dummy 116', 'X RPL 2'),
(119, 120, '26000117', 'Siswa Dummy 117', 'XI RPL 1'),
(120, 121, '26000118', 'Siswa Dummy 118', 'XI RPL 2'),
(121, 122, '26000119', 'Siswa Dummy 119', 'XII RPL 1'),
(122, 123, '26000120', 'Siswa Dummy 120', 'XII RPL 2'),
(123, 124, '26000121', 'Siswa Dummy 121', 'X RPL 1'),
(124, 125, '26000122', 'Siswa Dummy 122', 'X RPL 2'),
(125, 126, '26000123', 'Siswa Dummy 123', 'XI RPL 1'),
(126, 127, '26000124', 'Siswa Dummy 124', 'XI RPL 2'),
(127, 128, '26000125', 'Siswa Dummy 125', 'XII RPL 1'),
(128, 129, '26000126', 'Siswa Dummy 126', 'XII RPL 2'),
(129, 130, '26000127', 'Siswa Dummy 127', 'X RPL 1'),
(130, 131, '26000128', 'Siswa Dummy 128', 'X RPL 2'),
(131, 132, '26000129', 'Siswa Dummy 129', 'XI RPL 1'),
(132, 133, '26000130', 'Siswa Dummy 130', 'XI RPL 2'),
(133, 134, '26000131', 'Siswa Dummy 131', 'XII RPL 1'),
(134, 135, '26000132', 'Siswa Dummy 132', 'XII RPL 2'),
(135, 136, '26000133', 'Siswa Dummy 133', 'X RPL 1'),
(136, 137, '26000134', 'Siswa Dummy 134', 'X RPL 2'),
(137, 138, '26000135', 'Siswa Dummy 135', 'XI RPL 1'),
(138, 139, '26000136', 'Siswa Dummy 136', 'XI RPL 2'),
(139, 140, '26000137', 'Siswa Dummy 137', 'XII RPL 1'),
(140, 141, '26000138', 'Siswa Dummy 138', 'XII RPL 2'),
(141, 142, '26000139', 'Siswa Dummy 139', 'X RPL 1'),
(142, 143, '26000140', 'Siswa Dummy 140', 'X RPL 2'),
(143, 144, '26000141', 'Siswa Dummy 141', 'XI RPL 1'),
(144, 145, '26000142', 'Siswa Dummy 142', 'XI RPL 2'),
(145, 146, '26000143', 'Siswa Dummy 143', 'XII RPL 1'),
(146, 147, '26000144', 'Siswa Dummy 144', 'XII RPL 2'),
(147, 148, '26000145', 'Siswa Dummy 145', 'X RPL 1'),
(148, 149, '26000146', 'Siswa Dummy 146', 'X RPL 2'),
(149, 150, '26000147', 'Siswa Dummy 147', 'XI RPL 1'),
(150, 151, '26000148', 'Siswa Dummy 148', 'XI RPL 2'),
(151, 152, '26000149', 'Siswa Dummy 149', 'XII RPL 1'),
(152, 153, '26000150', 'Siswa Dummy 150', 'XII RPL 2'),
(153, 154, '26000151', 'Siswa Dummy 151', 'X RPL 1'),
(154, 155, '26000152', 'Siswa Dummy 152', 'X RPL 2'),
(155, 156, '26000153', 'Siswa Dummy 153', 'XI RPL 1'),
(156, 157, '26000154', 'Siswa Dummy 154', 'XI RPL 2'),
(157, 158, '26000155', 'Siswa Dummy 155', 'XII RPL 1'),
(158, 159, '26000156', 'Siswa Dummy 156', 'XII RPL 2'),
(159, 160, '26000157', 'Siswa Dummy 157', 'X RPL 1'),
(160, 161, '26000158', 'Siswa Dummy 158', 'X RPL 2'),
(161, 162, '26000159', 'Siswa Dummy 159', 'XI RPL 1'),
(162, 163, '26000160', 'Siswa Dummy 160', 'XI RPL 2'),
(163, 164, '26000161', 'Siswa Dummy 161', 'XII RPL 1'),
(164, 165, '26000162', 'Siswa Dummy 162', 'XII RPL 2'),
(165, 166, '26000163', 'Siswa Dummy 163', 'X RPL 1'),
(166, 167, '26000164', 'Siswa Dummy 164', 'X RPL 2'),
(167, 168, '26000165', 'Siswa Dummy 165', 'XI RPL 1'),
(168, 169, '26000166', 'Siswa Dummy 166', 'XI RPL 2'),
(169, 170, '26000167', 'Siswa Dummy 167', 'XII RPL 1'),
(170, 171, '26000168', 'Siswa Dummy 168', 'XII RPL 2'),
(171, 172, '26000169', 'Siswa Dummy 169', 'X RPL 1'),
(172, 173, '26000170', 'Siswa Dummy 170', 'X RPL 2'),
(173, 174, '26000171', 'Siswa Dummy 171', 'XI RPL 1'),
(174, 175, '26000172', 'Siswa Dummy 172', 'XI RPL 2'),
(175, 176, '26000173', 'Siswa Dummy 173', 'XII RPL 1'),
(176, 177, '26000174', 'Siswa Dummy 174', 'XII RPL 2'),
(177, 178, '26000175', 'Siswa Dummy 175', 'X RPL 1'),
(178, 179, '26000176', 'Siswa Dummy 176', 'X RPL 2'),
(179, 180, '26000177', 'Siswa Dummy 177', 'XI RPL 1'),
(180, 181, '26000178', 'Siswa Dummy 178', 'XI RPL 2'),
(181, 182, '26000179', 'Siswa Dummy 179', 'XII RPL 1'),
(182, 183, '26000180', 'Siswa Dummy 180', 'XII RPL 2'),
(183, 184, '26000181', 'Siswa Dummy 181', 'X RPL 1'),
(184, 185, '26000182', 'Siswa Dummy 182', 'X RPL 2'),
(185, 186, '26000183', 'Siswa Dummy 183', 'XI RPL 1'),
(186, 187, '26000184', 'Siswa Dummy 184', 'XI RPL 2'),
(187, 188, '26000185', 'Siswa Dummy 185', 'XII RPL 1'),
(188, 189, '26000186', 'Siswa Dummy 186', 'XII RPL 2'),
(189, 190, '26000187', 'Siswa Dummy 187', 'X RPL 1'),
(190, 191, '26000188', 'Siswa Dummy 188', 'X RPL 2'),
(191, 192, '26000189', 'Siswa Dummy 189', 'XI RPL 1'),
(192, 193, '26000190', 'Siswa Dummy 190', 'XI RPL 2'),
(193, 194, '26000191', 'Siswa Dummy 191', 'XII RPL 1'),
(194, 195, '26000192', 'Siswa Dummy 192', 'XII RPL 2'),
(195, 196, '26000193', 'Siswa Dummy 193', 'X RPL 1'),
(196, 197, '26000194', 'Siswa Dummy 194', 'X RPL 2'),
(197, 198, '26000195', 'Siswa Dummy 195', 'XI RPL 1'),
(198, 199, '26000196', 'Siswa Dummy 196', 'XI RPL 2'),
(199, 200, '26000197', 'Siswa Dummy 197', 'XII RPL 1'),
(200, 201, '26000198', 'Siswa Dummy 198', 'XII RPL 2'),
(201, 202, '26000199', 'Siswa Dummy 199', 'X RPL 1'),
(202, 203, '26000200', 'Siswa Dummy 200', 'X RPL 4'),
(203, 204, '131618', 'test', 'XI');

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
(1, 3, 'siswa', 'Perbaikannya cepat dan lampu sekarang sudah normal. Terima kasih.', '2026-09-24 15:59:53');

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
(2, 'siswa', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(3, 'andi', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(4, 'rioo', '$2y$10$3vhHSkN1G64fpYLHKOJU8u1cNQudbcjUutEDi5IrK0bVntXOi8QHa', 'siswa', '2026-09-24 08:59:53'),
(5, 'dummy002', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(6, 'dummy003', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(7, 'dummy004', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(8, 'dummy005', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(9, 'dummy006', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(10, 'dummy007', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(11, 'dummy008', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(12, 'dummy009', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(13, 'dummy010', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(14, 'dummy011', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(15, 'dummy012', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(16, 'dummy013', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(17, 'dummy014', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(18, 'dummy015', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(19, 'dummy016', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(20, 'dummy017', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(21, 'dummy018', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(22, 'dummy019', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(23, 'dummy020', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(24, 'dummy021', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(25, 'dummy022', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(26, 'dummy023', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(27, 'dummy024', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(28, 'dummy025', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(29, 'dummy026', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(30, 'dummy027', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(31, 'dummy028', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(32, 'dummy029', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(33, 'dummy030', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(34, 'dummy031', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(35, 'dummy032', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(36, 'dummy033', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(37, 'dummy034', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(38, 'dummy035', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(39, 'dummy036', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(40, 'dummy037', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(41, 'dummy038', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(42, 'dummy039', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(43, 'dummy040', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(44, 'dummy041', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(45, 'dummy042', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(46, 'dummy043', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(47, 'dummy044', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(48, 'dummy045', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(49, 'dummy046', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(50, 'dummy047', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(51, 'dummy048', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(52, 'dummy049', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(53, 'dummy050', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(54, 'dummy051', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(55, 'dummy052', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(56, 'dummy053', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(57, 'dummy054', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(58, 'dummy055', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(59, 'dummy056', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(60, 'dummy057', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(61, 'dummy058', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(62, 'dummy059', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(63, 'dummy060', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(64, 'dummy061', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(65, 'dummy062', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(66, 'dummy063', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(67, 'dummy064', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(68, 'dummy065', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(69, 'dummy066', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(70, 'dummy067', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(71, 'dummy068', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(72, 'dummy069', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(73, 'dummy070', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(74, 'dummy071', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(75, 'dummy072', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(76, 'dummy073', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(77, 'dummy074', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(78, 'dummy075', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(79, 'dummy076', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(80, 'dummy077', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(81, 'dummy078', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(82, 'dummy079', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(83, 'dummy080', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(84, 'dummy081', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(85, 'dummy082', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(86, 'dummy083', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(87, 'dummy084', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(88, 'dummy085', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(89, 'dummy086', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(90, 'dummy087', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(91, 'dummy088', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(92, 'dummy089', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(93, 'dummy090', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(94, 'dummy091', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(95, 'dummy092', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(96, 'dummy093', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(97, 'dummy094', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(98, 'dummy095', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(99, 'dummy096', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(100, 'dummy097', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(101, 'dummy098', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(102, 'dummy099', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(103, 'dummy100', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(104, 'dummy101', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(105, 'dummy102', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(106, 'dummy103', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(107, 'dummy104', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(108, 'dummy105', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(109, 'dummy106', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(110, 'dummy107', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(111, 'dummy108', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(112, 'dummy109', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(113, 'dummy110', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(114, 'dummy111', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(115, 'dummy112', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(116, 'dummy113', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(117, 'dummy114', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(118, 'dummy115', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(119, 'dummy116', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(120, 'dummy117', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(121, 'dummy118', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(122, 'dummy119', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(123, 'dummy120', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(124, 'dummy121', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(125, 'dummy122', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(126, 'dummy123', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(127, 'dummy124', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(128, 'dummy125', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(129, 'dummy126', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(130, 'dummy127', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(131, 'dummy128', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(132, 'dummy129', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(133, 'dummy130', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(134, 'dummy131', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(135, 'dummy132', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(136, 'dummy133', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(137, 'dummy134', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(138, 'dummy135', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(139, 'dummy136', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(140, 'dummy137', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(141, 'dummy138', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(142, 'dummy139', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(143, 'dummy140', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(144, 'dummy141', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(145, 'dummy142', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(146, 'dummy143', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(147, 'dummy144', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(148, 'dummy145', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(149, 'dummy146', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(150, 'dummy147', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(151, 'dummy148', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(152, 'dummy149', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(153, 'dummy150', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(154, 'dummy151', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(155, 'dummy152', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(156, 'dummy153', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(157, 'dummy154', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(158, 'dummy155', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(159, 'dummy156', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(160, 'dummy157', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(161, 'dummy158', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(162, 'dummy159', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(163, 'dummy160', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(164, 'dummy161', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(165, 'dummy162', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(166, 'dummy163', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(167, 'dummy164', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(168, 'dummy165', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(169, 'dummy166', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(170, 'dummy167', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(171, 'dummy168', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(172, 'dummy169', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(173, 'dummy170', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(174, 'dummy171', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(175, 'dummy172', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(176, 'dummy173', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(177, 'dummy174', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(178, 'dummy175', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(179, 'dummy176', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(180, 'dummy177', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(181, 'dummy178', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(182, 'dummy179', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(183, 'dummy180', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(184, 'dummy181', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(185, 'dummy182', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(186, 'dummy183', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(187, 'dummy184', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(188, 'dummy185', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(189, 'dummy186', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(190, 'dummy187', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(191, 'dummy188', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(192, 'dummy189', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(193, 'dummy190', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(194, 'dummy191', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(195, 'dummy192', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(196, 'dummy193', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(197, 'dummy194', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(198, 'dummy195', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(199, 'dummy196', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(200, 'dummy197', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(201, 'dummy198', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(202, 'dummy199', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(203, 'dummy200', '$2y$12$pNq5U77KWvb7Zx20DbgggeKxfMBfLmeH0eeSV0q1Jdzj7bBamPn0.', 'siswa', '2026-09-24 08:59:53'),
(204, 'test', '$2y$10$rSyxUsnkQFyfpVMdVHs.aux.YVzqJPPWq8TWuS8nRch5u5re3ZuNK', 'siswa', '2026-10-15 01:33:29');

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
  MODIFY `id_pengaduan` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=206;

--
-- AUTO_INCREMENT untuk tabel `progres_pengaduan`
--
ALTER TABLE `progres_pengaduan`
  MODIFY `id_progres` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `siswa`
--
ALTER TABLE `siswa`
  MODIFY `id_siswa` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=204;

--
-- AUTO_INCREMENT untuk tabel `umpan_balik`
--
ALTER TABLE `umpan_balik`
  MODIFY `id_feedback` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=205;

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

<?php

/**
 * FILE: index.php
 * FUNGSI: Pintu masuk dan router utama SIPAS.
 * ALUR KERJA MVC: index.php menerima request dan memilih route; Controller memvalidasi hak akses/input, Controller memanggil Model untuk query database, lalu Controller mengirim data ke View untuk dirender.
 * INPUT / OUTPUT: Input: `$_GET[page]` dan data session. Output: halaman HTML dari view atau redirect ke route yang sesuai.
 * FILE/TABEL TERKAIT: config/database.php, helpers.php, seluruh file model, seluruh file controller, views/errors/404.php
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
// Memulai/melanjutkan session sebelum membaca atau menulis $_SESSION, karena session menyimpan identitas login dan pesan sementara.
session_start();

// Muat konfigurasi koneksi dan fungsi umum terlebih dahulu karena router/controller memakainya.
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/helpers.php';
// Model adalah lapisan akses data; file dimuat sebelum controller yang membuat objek model.
require_once __DIR__ . '/models/UserModel.php';
require_once __DIR__ . '/models/SiswaModel.php';
require_once __DIR__ . '/models/PengaduanModel.php';
require_once __DIR__ . '/models/ProgresModel.php';
require_once __DIR__ . '/models/FeedbackModel.php';
// Controller menerima request route, menjalankan aturan bisnis, lalu mengirim data ke view.
require_once __DIR__ . '/controllers/AuthController.php';
require_once __DIR__ . '/controllers/DashboardController.php';
require_once __DIR__ . '/controllers/PengaduanController.php';
require_once __DIR__ . '/controllers/SiswaController.php';

// Session menyimpan ID akun yang telah terautentikasi untuk mengenali pengguna pada request berikutnya.
/* Route berasal dari parameter page; jika tidak diberikan, sesi login diarahkan ke dashboard dan pengunjung anonim ke login. Pemilihan default ini memudahkan akses awal tanpa menganggap pengguna sudah terautentikasi. */
$page = isset($_GET['page']) ? $_GET['page'] : (isset($_SESSION['id_user']) ? 'dashboard' : 'login');
$db = (new Database())->getConnection();
ensureFeedbackSchema($db);

/* Daftar route publik dinyatakan eksplisit. Semua route di luar daftar memerlukan session pengguna, dengan logout diperlakukan khusus supaya pengguna dapat selalu mengakhiri session. */
$publicPages = ['login', 'proses-login', 'register', 'proses-register'];
// Session menyimpan ID akun yang telah terautentikasi untuk mengenali pengguna pada request berikutnya.
if (!in_array($page, $publicPages, true) && $page !== 'logout' && !isset($_SESSION['id_user'])) {
    // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
    redirect('login');
}

// Dispatcher MVC: setiap case memetakan nama route ke method controller, bukan menulis query SQL di router.
switch ($page) {
    // Autentikasi: route login dan submit login ditangani oleh action yang sama berdasarkan metode request.
    case 'login':
    case 'proses-login':
        (new AuthController($db))->login();
        break;

    // Registrasi: menampilkan form atau memproses POST pembuatan akun siswa.
    case 'register':
    case 'proses-register':
        (new AuthController($db))->register();
        break;

    // Logout membersihkan session sebelum pengguna kembali ke halaman login.
    case 'logout':
        (new AuthController($db))->logout();
        break;

    // Dashboard memilih data dan view berbeda menurut role di session.
    case 'dashboard':
        (new DashboardController($db))->index();
        break;

    // Alur admin pengaduan: daftar, detail, perubahan status, dan feedback.
    case 'admin-pengaduan':
        (new PengaduanController($db))->adminIndex();
        break;

    case 'admin-detail':
        (new PengaduanController($db))->adminDetail();
        break;

    case 'update-status':
        (new PengaduanController($db))->updateStatus();
        break;

    // Alur siswa: form buat laporan, simpan laporan, lihat histori/detail, dan kirim feedback.
    case 'kirim-pengaduan':
        (new PengaduanController($db))->formCreate();
        break;

    case 'proses-pengaduan':
        (new PengaduanController($db))->store();
        break;

    case 'histori':
        (new PengaduanController($db))->history();
        break;

    case 'siswa-detail':
        (new PengaduanController($db))->siswaDetail();
        break;

    case 'simpan-feedback':
        (new PengaduanController($db))->saveFeedback();
        break;

    case 'admin-feedback':
        (new PengaduanController($db))->saveAdminFeedback();
        break;

    // Pengelolaan akun/profil siswa hanya tersedia setelah controller memeriksa role admin.
    case 'kelola-siswa':
        (new SiswaController($db))->index();
        break;

    case 'form-siswa':
        (new SiswaController($db))->form();
        break;

    case 'simpan-siswa':
        (new SiswaController($db))->save();
        break;

    case 'hapus-siswa':
        (new SiswaController($db))->delete();
        break;

    default:
        // Status HTTP 404 memberi tahu browser/proxy bahwa route tersebut tidak ditemukan, bukan hanya menampilkan tulisan 404.
        http_response_code(404);
        // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
        view('errors/404', ['title' => '404 - SIPAS']);
}

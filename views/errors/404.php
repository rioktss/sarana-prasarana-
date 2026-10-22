<?php 
/**
 * FILE: views/errors/404.php
 * FUNGSI: Template halaman saat route tidak tersedia.
 * ALUR KERJA: Menampilkan respons 404 dan tautan untuk kembali ke dashboard. Kode status HTTP ditetapkan router.
 * INPUT / OUTPUT: Input: `$title` opsional. Output: HTML pesan halaman tidak ditemukan.
 * FILE/TABEL TERKAIT: index.php, views/layout/header.php, views/layout/footer.php
 * KEAMANAN OUTPUT: Teks dinamis di konteks HTML menggunakan e() untuk meng-escape karakter khusus dan membantu mencegah XSS; ID yang ditampilkan sebagai angka dikonversi ke integer.
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
$title = isset($title) ? $title : '404 - SIPAS'; require __DIR__ . '/../layout/header.php'; ?>
<div class="card error-page">
    <div class="card-body error-page-body">
        <div class="error-code">404</div>
        <h2>Halaman tidak ditemukan</h2>
        <p class="muted">Menu yang kamu buka tidak tersedia.</p>
        <a class="btn btn-primary" href="index.php?page=dashboard"><?= uiIcon('home') ?><span>Kembali ke Dashboard</span></a>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

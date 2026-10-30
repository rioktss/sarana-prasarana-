<?php 
/**
 * FILE: views/siswa/dashboard.php
 * FUNGSI: Template dashboard untuk pengguna role siswa.
 * ALUR KERJA: Menampilkan sapaan siswa, ringkasan jumlah pengaduan, dan beberapa pengaduan terbaru milik akun yang sedang login.
 * INPUT / OUTPUT: Input: `$total`, `$berjalan`, `$selesai`, `$terbaru` dan session profil. Output: HTML dashboard siswa.
 * FILE/TABEL TERKAIT: controllers/DashboardController.php, models/PengaduanModel.php, views/layout/*.php, helpers.php
 * KEAMANAN OUTPUT: Teks dinamis di konteks HTML menggunakan e() untuk meng-escape karakter khusus dan membantu mencegah XSS; ID yang ditampilkan sebagai angka dikonversi ke integer.
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
$title='Dashboard Siswa - SIPAS'; $menu='dashboard'; require __DIR__ . '/../layout/header.php'; ?>
<div class="card welcome page-space-after">
    <div class="card-body">
        <h2>Halo, <?= /* Nama/username dari session ditampilkan sebagai teks ter-escape, bukan markup HTML. */ e(isset($_SESSION['nama_siswa']) ? $_SESSION['nama_siswa'] : (isset($_SESSION['username']) ? $_SESSION['username'] : '')) ?></h2>
        <p><?= /* Kelas dari session ditampilkan sebagai teks yang di-escape, bukan sebagai HTML aktif. */ e(isset($_SESSION['kelas']) ? $_SESSION['kelas'] : '') ?> · Sampaikan kerusakan sarana sekolah dengan mudah.</p>
    </div>
    <div class="card-body welcome-action"><a class="btn btn-primary" href="index.php?page=kirim-pengaduan"><?= uiIcon('plus') ?><span>Buat Pengaduan</span></a></div>
</div>

<div class="grid grid-4 page-space-after">
    <div class="card"><div class="card-body stat"><div><div class="stat-label">Total Pengaduan</div><div class="stat-value"><?= (int)$total ?></div></div><div class="stat-icon"><?= uiIcon('report') ?></div></div></div>
    <div class="card"><div class="card-body stat"><div><div class="stat-label">Berjalan</div><div class="stat-value"><?= (int)$berjalan ?></div></div><div class="stat-icon"><?= uiIcon('clock') ?></div></div></div>
    <div class="card"><div class="card-body stat"><div><div class="stat-label">Selesai</div><div class="stat-value"><?= (int)$selesai ?></div></div><div class="stat-icon"><?= uiIcon('check') ?></div></div></div>
</div>

<div class="card">
    <div class="card-body">
        <div class="page-actions">
            <div><h3>Pengaduan Terbaru</h3><div class="small muted">Laporan yang baru kamu kirim.</div></div>
            <a class="btn btn-secondary btn-sm" href="index.php?page=histori">Lihat Histori</a>
        </div>

        <?php if (empty($terbaru)): ?>
            <div class="empty-state">
                <div class="empty-state-icon"><?= uiIcon('report') ?></div>
                <h3>Belum ada pengaduan</h3>
                <p>Kamu belum membuat pengaduan. Buat pengaduan pertama untuk melaporkan masalah sarana sekolah.</p>
                <a class="btn btn-primary" href="index.php?page=kirim-pengaduan"><?= uiIcon('plus') ?><span>Buat Pengaduan</span></a>
            </div>
        <?php else: ?>
            <div class="table-wrap">
                <table class="table">
                    <thead><tr><th>Pengaduan</th><th>Tanggal</th><th>Status</th><th>Aksi</th></tr></thead>
                    <tbody>
                    <?php foreach($terbaru as $item): ?>
                        <tr>
                            <td><strong><?= e($item['judul_pengaduan']) ?></strong><div class="small muted"><?= e(excerpt($item['isi_pengaduan'], 85)) ?></div></td>
                            <td><?= e(formatTanggal($item['tanggal_pengaduan'])) ?></td>
                            <td><?= statusBadge($item['status']) ?></td>
                            <td><a class="btn btn-secondary btn-sm" href="index.php?page=siswa-detail&id=<?= (int)$item['id_pengaduan'] ?>">Detail</a></td>
                        </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

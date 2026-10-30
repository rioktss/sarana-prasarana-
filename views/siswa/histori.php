<?php 
/**
 * FILE: views/siswa/histori.php
 * FUNGSI: Template histori seluruh pengaduan milik siswa.
 * ALUR KERJA: Menampilkan daftar laporan sebelumnya dan tautan menuju detail atau form pengaduan baru.
 * INPUT / OUTPUT: Input: `$histori`. Output: tabel histori atau keadaan kosong.
 * FILE/TABEL TERKAIT: controllers/PengaduanController.php, models/PengaduanModel.php, helpers.php, views/layout/*.php
 * KEAMANAN OUTPUT: Teks dinamis di konteks HTML menggunakan e() untuk meng-escape karakter khusus dan membantu mencegah XSS; ID yang ditampilkan sebagai angka dikonversi ke integer.
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
$title='Histori Pengaduan - SIPAS'; $menu='histori'; require __DIR__ . '/../layout/header.php'; ?>
<div class="page-actions">
    <div><h2>Histori Pengaduan</h2><div class="small muted">Semua laporan yang pernah kamu kirim.</div></div>
    <a class="btn btn-primary" href="index.php?page=kirim-pengaduan"><?= uiIcon('plus') ?><span>Pengaduan Baru</span></a>
</div>

<div class="card">
    <div class="card-body">
        <?php if (empty($histori)): ?>
            <div class="empty-state">
                <div class="empty-state-icon"><?= uiIcon('history') ?></div>
                <h3>Belum ada pengaduan</h3>
                <p>Belum ada laporan yang tercatat di akunmu.</p>
                <a class="btn btn-primary" href="index.php?page=kirim-pengaduan"><?= uiIcon('plus') ?><span>Buat Pengaduan</span></a>
            </div>
        <?php else: ?>
            <div class="table-wrap">
                <table class="table">
                    <thead><tr><th>#</th><th>Judul</th><th>Tanggal</th><th>Status</th><th>Aksi</th></tr></thead>
                    <tbody>
                    <?php /* Loop berjalan atas histori yang sudah difilter model berdasarkan id_siswa dari session, bukan memilih data melalui ID bebas di browser. */  foreach($histori as $item): ?>
                        <tr>
                            <td><?= (int)$item['id_pengaduan'] ?></td>
                            <td><strong><?= e($item['judul_pengaduan']) ?></strong><div class="small muted"><?= e(excerpt($item['isi_pengaduan'], 75)) ?></div></td>
                            <td><?= e(formatTanggal($item['tanggal_pengaduan'])) ?></td>
                            <td><?= statusBadge($item['status']) ?></td>
                            <td><a class="btn btn-primary btn-sm" href="index.php?page=siswa-detail&id=<?= (int)$item['id_pengaduan'] ?>">Detail</a></td>
                        </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

<?php $title='Histori Pengaduan - SIPAS'; $menu='histori'; require __DIR__ . '/../layout/header.php'; ?>
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
                    <?php foreach($histori as $item): ?>
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

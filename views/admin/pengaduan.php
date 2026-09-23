<?php $title='Data Pengaduan - SIPAS'; $menu='pengaduan'; require __DIR__ . '/../layout/header.php'; ?>
<div class="page-actions">
    <div><h2>Data Pengaduan</h2><div class="small muted">Daftar laporan sarana dan prasarana dari siswa.</div></div>
</div>

<div class="toolbar filter-toolbar" aria-label="Filter status pengaduan">
    <a class="btn <?= $status === '' ? 'btn-primary' : 'btn-secondary' ?> btn-sm" href="index.php?page=admin-pengaduan">Semua</a>
    <?php foreach(['Diajukan','Diproses','Selesai','Ditolak'] as $st): ?>
        <a class="btn <?= $status===$st ? 'btn-primary' : 'btn-secondary' ?> btn-sm" href="index.php?page=admin-pengaduan&status=<?= urlencode($st) ?>"><?= e($st) ?></a>
    <?php endforeach; ?>
</div>

<div class="card">
    <div class="card-body">
        <?php if (empty($list)): ?>
            <div class="empty-state">
                <div class="empty-state-icon"><?= uiIcon('report') ?></div>
                <h3>Tidak ada pengaduan</h3>
                <p><?= $status !== '' ? 'Belum ada pengaduan dengan status ini.' : 'Belum ada pengaduan yang tercatat di sistem.' ?></p>
                <?php if ($status !== ''): ?><a class="btn btn-secondary" href="index.php?page=admin-pengaduan">Tampilkan Semua</a><?php endif; ?>
            </div>
        <?php else: ?>
            <div class="table-wrap">
                <table class="table">
                    <thead><tr><th>#</th><th>Judul</th><th>Pelapor</th><th>Kelas</th><th>Tanggal</th><th>Status</th><th>Aksi</th></tr></thead>
                    <tbody>
                    <?php foreach($list as $item): ?>
                        <tr>
                            <td><?= (int)$item['id_pengaduan'] ?></td>
                            <td><strong><?= e($item['judul_pengaduan']) ?></strong></td>
                            <td><?= e($item['nama_siswa']) ?><div class="small muted">NIS <?= e($item['nis']) ?></div></td>
                            <td><?= e($item['kelas']) ?></td>
                            <td><?= e(formatTanggal($item['tanggal_pengaduan'])) ?></td>
                            <td><?= statusBadge($item['status']) ?></td>
                            <td><a class="btn btn-primary btn-sm" href="index.php?page=admin-detail&id=<?= (int)$item['id_pengaduan'] ?>">Detail</a></td>
                        </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

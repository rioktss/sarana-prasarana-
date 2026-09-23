<?php $title='Dashboard Admin - SIPAS'; $menu='dashboard'; require __DIR__ . '/../layout/header.php'; ?>
<div class="card welcome page-space-after">
    <div class="card-body">
        <h2>Dashboard Admin</h2>
        <p>Kelola pengaduan siswa dan pantau proses penanganannya dari satu tempat.</p>
    </div>
    <div class="card-body welcome-action"><a class="btn btn-primary" href="index.php?page=admin-pengaduan"><?= uiIcon('report') ?><span>Lihat Pengaduan</span></a></div>
</div>

<div class="grid grid-4 page-space-after">
    <?php foreach ([
        ['Total Pengaduan', $stats['total'], 'report'],
        ['Diajukan', $stats['Diajukan'], 'clock'],
        ['Diproses', $stats['Diproses'], 'refresh'],
        ['Selesai', $stats['Selesai'], 'check'],
    ] as $st): ?>
        <div class="card">
            <div class="card-body stat">
                <div><div class="stat-label"><?= e($st[0]) ?></div><div class="stat-value"><?= (int)$st[1] ?></div></div>
                <div class="stat-icon"><?= uiIcon($st[2]) ?></div>
            </div>
        </div>
    <?php endforeach; ?>
</div>

<div class="grid grid-2">
    <div class="card">
        <div class="card-body">
            <div class="page-actions">
                <div><h3>Pengaduan Terbaru</h3><div class="small muted">Laporan yang paling baru masuk.</div></div>
                <a class="btn btn-secondary btn-sm" href="index.php?page=admin-pengaduan">Semua Pengaduan</a>
            </div>

            <?php if (!$terbaru): ?>
                <div class="empty-state compact">
                    <div class="empty-state-icon"><?= uiIcon('report') ?></div>
                    <h3>Belum ada pengaduan</h3>
                    <p>Belum ada laporan sarana dan prasarana yang masuk ke sistem.</p>
                    <a class="btn btn-secondary btn-sm" href="index.php?page=admin-pengaduan">Buka Pengaduan</a>
                </div>
            <?php else: ?>
                <div class="table-wrap">
                    <table class="table">
                        <thead><tr><th>Siswa</th><th>Pengaduan</th><th>Tanggal</th><th>Status</th><th>Aksi</th></tr></thead>
                        <tbody>
                        <?php foreach ($terbaru as $row): ?>
                            <tr>
                                <td><strong><?= e($row['nama_siswa']) ?></strong><div class="small muted"><?= e($row['kelas']) ?></div></td>
                                <td><?= e($row['judul_pengaduan']) ?></td>
                                <td><?= e(formatTanggal($row['tanggal_pengaduan'])) ?></td>
                                <td><?= statusBadge($row['status']) ?></td>
                                <td><a class="btn btn-secondary btn-sm" href="index.php?page=admin-detail&id=<?= (int)$row['id_pengaduan'] ?>">Detail</a></td>
                            </tr>
                        <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            <?php endif; ?>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <h3 class="section-title-simple">Ringkasan</h3>
            <div class="small muted summary-intro">Data singkat sistem SIPAS.</div>
            <div class="detail-item">
                <label>Total Siswa</label>
                <strong class="summary-value"><?= (int)$totalSiswa ?></strong>
            </div>
            <div class="detail-item">
                <label>Status Pengaduan</label>
                <div class="toolbar status-filters">
                    <a class="btn btn-secondary btn-sm" href="index.php?page=admin-pengaduan&status=Diajukan">Diajukan</a>
                    <a class="btn btn-secondary btn-sm" href="index.php?page=admin-pengaduan&status=Diproses">Diproses</a>
                    <a class="btn btn-secondary btn-sm" href="index.php?page=admin-pengaduan&status=Selesai">Selesai</a>
                </div>
            </div>
        </div>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

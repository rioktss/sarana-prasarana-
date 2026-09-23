<?php $title='Dashboard Admin - SIPAS'; $menu='dashboard'; require __DIR__ . '/../layout/header.php'; ?>
<div class="card welcome" style="margin-bottom:18px;">
    <div class="card-body">
        <h2>Dashboard Admin</h2>
        <p>Kelola pengaduan siswa dan pantau proses penanganannya dari satu tempat.</p>
    </div>
    <div class="card-body"><a class="btn btn-primary" href="index.php?page=admin-pengaduan">Lihat Pengaduan</a></div>
</div>
<div class="grid grid-4" style="margin-bottom:18px;">
    <?php foreach ([
        ['Total Pengaduan', $stats['total'], '▤'],
        ['Diajukan', $stats['Diajukan'], '◷'],
        ['Diproses', $stats['Diproses'], '↻'],
        ['Selesai', $stats['Selesai'], '✓'],
    ] as $st): ?>
    <div class="card"><div class="card-body stat"><div><div class="stat-label"><?= e($st[0]) ?></div><div class="stat-value"><?= (int)$st[1] ?></div></div><div class="stat-icon"><?= e($st[2]) ?></div></div></div>
    <?php endforeach; ?>
</div>
<div class="grid grid-2">
    <div class="card">
        <div class="card-body">
            <div class="page-actions"><div><h3 style="margin:0;">Pengaduan Terbaru</h3><div class="small muted">Laporan yang paling baru masuk.</div></div><a class="btn btn-secondary btn-sm" href="index.php?page=admin-pengaduan">Semua Pengaduan</a></div>
            <div class="table-wrap"><table class="table"><thead><tr><th>Siswa</th><th>Pengaduan</th><th>Tanggal</th><th>Status</th><th></th></tr></thead><tbody>
            <?php if (!$terbaru): ?><tr><td colspan="5" class="empty">Belum ada pengaduan.</td></tr><?php else: foreach ($terbaru as $row): ?><tr><td><strong><?= e($row['nama_siswa']) ?></strong><div class="small muted"><?= e($row['kelas']) ?></div></td><td><?= e($row['judul_pengaduan']) ?></td><td><?= e(formatTanggal($row['tanggal_pengaduan'])) ?></td><td><?= statusBadge($row['status']) ?></td><td><a class="btn btn-secondary btn-sm" href="index.php?page=admin-detail&id=<?= (int)$row['id_pengaduan'] ?>">Detail</a></td></tr><?php endforeach; endif; ?>
            </tbody></table></div>
        </div>
    </div>
    <div class="card"><div class="card-body"><h3 style="margin:0 0 6px;">Ringkasan</h3><div class="small muted" style="margin-bottom:16px;">Data singkat sistem SIPAS.</div><div class="detail-item"><label>Total Siswa</label><strong style="font-size:24px;"><?= (int)$totalSiswa ?></strong></div><div class="detail-item"><label>Status Pengaduan</label><div class="toolbar"><a class="btn btn-secondary btn-sm" href="index.php?page=admin-pengaduan&status=Diajukan">Diajukan</a><a class="btn btn-secondary btn-sm" href="index.php?page=admin-pengaduan&status=Diproses">Diproses</a><a class="btn btn-secondary btn-sm" href="index.php?page=admin-pengaduan&status=Selesai">Selesai</a></div></div></div></div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

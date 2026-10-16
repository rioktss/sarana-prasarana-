<?php
$title='Detail Pengaduan - SIPAS';
$menu='pengaduan';
$lastProgressIndex = !empty($progres) ? count($progres) - 1 : -1;
require __DIR__ . '/../layout/header.php';
?>
<a class="link page-back" href="index.php?page=admin-pengaduan"><?= uiIcon('arrow-left') ?><span>Kembali ke pengaduan</span></a>

<div class="detail-grid">
    <div>
        <div class="card">
            <div class="card-body">
                <div class="detail-topline">
                    <?= statusBadge($pengaduan['status']) ?>
                    <span class="small muted">#<?= (int)$pengaduan['id_pengaduan'] ?> · <?= e(formatTanggal($pengaduan['tanggal_pengaduan'])) ?></span>
                </div>
                <h2 class="detail-title"><?= e($pengaduan['judul_pengaduan']) ?></h2>
                <p class="detail-description"><?= e($pengaduan['isi_pengaduan']) ?></p>
                <div class="detail-item detail-reporter">
                    <label>Pelapor</label>
                    <strong><?= e($pengaduan['nama_siswa']) ?></strong>
                    <div class="small muted"><?= e($pengaduan['kelas']) ?> · NIS <?= e($pengaduan['nis']) ?></div>
                </div>
            </div>
        </div>

        <div class="card card-space-top">
            <div class="card-body">
                <div class="section-title"><h3>Riwayat Progres</h3><span class="small muted"><?= count($progres) ?> pembaruan</span></div>
                <?php if(empty($progres)): ?>
                    <div class="empty">Belum ada progres.</div>
                <?php else: ?>
                    <div class="timeline" aria-label="Riwayat progres pengaduan">
                        <?php foreach($progres as $index => $item): ?>
                            <div class="timeline-item <?= $index === $lastProgressIndex ? 'is-current' : 'is-complete' ?> <?= $item['status_progres'] === 'Ditolak' ? 'is-rejected' : '' ?>">
                                <span class="timeline-dot" aria-hidden="true"></span>
                                <h4><?= e($item['status_progres']) ?><?= $index === $lastProgressIndex ? ' · Terakhir' : '' ?></h4>
                                <?php if($item['keterangan']): ?><div class="small muted timeline-note"><?= e($item['keterangan']) ?></div><?php endif; ?>
                                <small><?= e(formatTanggal($item['tanggal_progres'])) ?></small>
                            </div>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <div>
        <div class="card">
            <div class="card-body">
                <div class="section-title"><h3>Update Status</h3><?= statusBadge($pengaduan['status']) ?></div>
                <form method="post" action="index.php?page=update-status" data-loading>
                    <input type="hidden" name="id_pengaduan" value="<?= (int)$pengaduan['id_pengaduan'] ?>">
                    <div class="form-group">
                        <label class="label required" for="status_pengaduan">Status Pengaduan</label>
                        <select class="select" id="status_pengaduan" name="status" required>
                            <?php foreach(['Diajukan','Diproses','Selesai','Ditolak'] as $st): ?>
                                <option value="<?= e($st) ?>" <?= $pengaduan['status']===$st?'selected':'' ?>><?= e($st) ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="label" for="keterangan">Keterangan Progres</label>
                        <textarea class="textarea" id="keterangan" name="keterangan" placeholder="Contoh: Sudah dilaporkan ke bagian sarpras."></textarea>
                        <div class="helper">Tambahkan catatan singkat agar siswa memahami perubahan yang dibuat.</div>
                    </div>
                    <button class="btn btn-primary full-width" type="submit" data-loading-label="Menyimpan..."><?= uiIcon('save') ?><span>Simpan Perubahan</span></button>
                </form>
            </div>
        </div>

        <div class="card card-space-top">
            <div class="card-body">
                <h3 class="section-title-simple">Umpan Balik</h3>
                <?php if(empty($feedbacks)): ?>
                    <div class="empty">Belum ada umpan balik untuk pengaduan ini.</div>
                <?php else: ?>
                    <?php foreach($feedbacks as $fb): ?>
                        <div class="feedback-box feedback-<?= e($fb['pemberi']) ?>">
                            <div class="feedback-author"><?= $fb['pemberi'] === 'admin' ? 'Tanggapan Admin' : 'Feedback Siswa' ?></div>
                            <?= nl2br(e($fb['isi_feedback'])) ?>
                            <div class="small muted feedback-date">Diberikan <?= e(formatTanggal($fb['tanggal_feedback'])) ?></div>
                        </div>
                    <?php endforeach; ?>
                <?php endif; ?>

                <form class="feedback-form" method="post" action="index.php?page=admin-feedback" data-loading>
                    <input type="hidden" name="id_pengaduan" value="<?= (int)$pengaduan['id_pengaduan'] ?>">
                    <div class="form-group">
                        <label class="label required" for="isi_feedback_admin">Beri Umpan Balik</label>
                        <textarea class="textarea" id="isi_feedback_admin" name="isi_feedback" maxlength="2000" placeholder="Contoh: Laporan sudah kami terima dan akan diperbaiki minggu ini." required></textarea>
                        <div class="helper">Tanggapan ini akan tampil di halaman detail pengaduan milik siswa.</div>
                    </div>
                    <button class="btn btn-success full-width" type="submit" data-loading-label="Mengirim...">
                        <?= uiIcon('send') ?><span>Kirim Umpan Balik</span>
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

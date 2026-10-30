<?php

/**
 * FILE: views/siswa/detail.php
 * FUNGSI: Template detail pengaduan untuk siswa.
 * ALUR KERJA: Menampilkan detail laporan, progres, feedback, dan form feedback yang hanya ditawarkan setelah status selesai serta belum ada feedback siswa.
 * INPUT / OUTPUT: Input: `$pengaduan`, `$progres`, `$feedbacks`. Output: HTML detail dan form POST feedback.
 * FILE/TABEL TERKAIT: controllers/PengaduanController.php, models/FeedbackModel.php, views/layout/*.php, helpers.php
 * KEAMANAN OUTPUT: Teks dinamis di konteks HTML menggunakan e() untuk meng-escape karakter khusus dan membantu mencegah XSS; ID yang ditampilkan sebagai angka dikonversi ke integer.
 * CATATAN FORM: ID pengaduan pada form tidak membuktikan kepemilikan; controller membandingkan id_siswa dengan session.
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
$title='Detail Pengaduan - SIPAS';
$menu='histori';
$lastProgressIndex = !empty($progres) ? count($progres) - 1 : -1;
$sudahFeedbackSiswa = false;
foreach ($feedbacks as $fb) {
    if ($fb['pemberi'] === 'siswa') $sudahFeedbackSiswa = true;
}
require __DIR__ . '/../layout/header.php';
?>
<a class="link page-back" href="index.php?page=histori"><?= uiIcon('arrow-left') ?><span>Kembali ke histori</span></a>

<div class="detail-grid">
    <div>
        <div class="card">
            <div class="card-body">
                <div class="detail-topline">
                    <?= statusBadge($pengaduan['status']) ?>
                    <span class="small muted">#<?= /* ID menghubungkan feedback ke laporan; controller juga memastikan laporan dimiliki siswa aktif. */ (int)$pengaduan['id_pengaduan'] ?> · <?= e(formatTanggal($pengaduan['tanggal_pengaduan'])) ?></span>
                </div>
                <h2 class="detail-title"><?= e($pengaduan['judul_pengaduan']) ?></h2>
                <p class="detail-description"><?= e($pengaduan['isi_pengaduan']) ?></p>
            </div>
        </div>

        <div class="card card-space-top">
            <div class="card-body">
                <div class="section-title"><h3>Progres Pengaduan</h3><span class="small muted"><?= e($pengaduan['status']) ?></span></div>
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
                <h3 class="section-title-simple">Umpan Balik</h3>
                <?php foreach($feedbacks as $fb): ?>
                    <div class="feedback-box feedback-<?= e($fb['pemberi']) ?>">
                        <div class="feedback-author"><?= $fb['pemberi'] === 'admin' ? 'Tanggapan Admin' : 'Feedback Kamu' ?></div>
                        <?= nl2br(e($fb['isi_feedback'])) ?>
                        <div class="small muted feedback-date">Diberikan <?= e(formatTanggal($fb['tanggal_feedback'])) ?></div>
                    </div>
                <?php endforeach; ?>

                <?php if($pengaduan['status']==='Selesai' && !$sudahFeedbackSiswa): ?>
                    <p class="detail-description detail-description-muted">Pengaduan sudah selesai. Berikan feedback untuk penanganannya.</p>
                    <form method="post" action="index.php?page=simpan-feedback" data-loading>
                        <input type="hidden" name="id_pengaduan" value="<?= (int)$pengaduan['id_pengaduan'] ?>">
                        <div class="form-group">
                            <label class="label required" for="isi_feedback">Feedback</label>
                            <textarea class="textarea" id="isi_feedback" name="isi_feedback" maxlength="2000" placeholder="Contoh: Perbaikan sudah rapi, terima kasih." required></textarea>
                        </div>
                        <button class="btn btn-success full-width" type="submit" data-loading-label="Mengirim...">
                            <?= uiIcon('send') ?><span>Kirim Feedback</span>
                        </button>
                    </form>
                <?php elseif(empty($feedbacks)): ?>
                    <div class="empty">Belum ada umpan balik. Tanggapan admin akan tampil di sini, dan feedback dari kamu bisa diberikan setelah status pengaduan menjadi <b>Selesai</b>.</div>
                <?php endif; ?>
            </div>
        </div>

        <div class="card card-space-top">
            <div class="card-body">
                <div class="small muted">Tips</div>
                <p class="tips-text">Buka kembali halaman ini kapan saja untuk melihat perubahan status dan riwayat progres.</p>
            </div>
        </div>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

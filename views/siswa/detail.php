<?php
/**
 * FILE: views/siswa/detail.php
 * FUNGSI: Menampilkan laporan milik siswa, riwayat progres, dan komunikasi umpan balik.
 * CATATAN: Kepemilikan laporan dan aturan pengiriman feedback tetap divalidasi controller.
 */
$title = 'Detail Pengaduan - SIPAS';
$menu = 'histori';

$progres = isset($progres) && is_array($progres) ? $progres : [];
$feedbacks = isset($feedbacks) && is_array($feedbacks) ? $feedbacks : [];
$lastProgressIndex = count($progres) - 1;
$isSelesai = isset($pengaduan['status']) && $pengaduan['status'] === 'Selesai';
$idPengaduan = (int) $pengaduan['id_pengaduan'];
$sudahFeedbackSiswa = false;

foreach ($feedbacks as $feedback) {
    if (isset($feedback['pemberi']) && $feedback['pemberi'] === 'siswa') {
        $sudahFeedbackSiswa = true;
        break;
    }
}

require __DIR__ . '/../layout/header.php';
?>

<div class="detail-page">
    <a class="link page-back" href="index.php?page=histori">
        <?= uiIcon('arrow-left') ?>
        <span>Kembali ke histori</span>
    </a>

    <div class="detail-page-heading">
        <div>
            <div class="detail-eyebrow">HISTORI PENGADUAN</div>
            <h1>Detail Pengaduan</h1>
            <p>Pantau perkembangan laporan dan baca tanggapan dari admin sekolah.</p>
        </div>
        <div class="detail-heading-status">
            <?= statusBadge($pengaduan['status']) ?>
            <span class="small muted">Laporan #<?= $idPengaduan ?></span>
        </div>
    </div>

    <div class="detail-grid detail-grid-siswa">
        <div class="detail-stack">
            <section class="card">
                <div class="card-body">
                    <div class="detail-panel-heading">
                        <div>
                            <span class="detail-eyebrow">INFORMASI LAPORAN</span>
                            <h2 class="detail-title"><?= e($pengaduan['judul_pengaduan']) ?></h2>
                        </div>
                        <span class="small muted detail-date"><?= e(formatTanggal($pengaduan['tanggal_pengaduan'])) ?></span>
                    </div>
                    <div class="detail-description detail-report-content"><?= e($pengaduan['isi_pengaduan']) ?></div>
                    <?php $fotoBukti = isset($pengaduan['foto_bukti']) ? (string) $pengaduan['foto_bukti'] : ''; ?>
                    <?php if (strpos($fotoBukti, 'uploads/pengaduan/') === 0): ?>
                        <div class="evidence-section">
                            <div class="evidence-heading">
                                <h3>Foto Bukti</h3>
                                <span class="small muted">Foto yang kamu lampirkan</span>
                            </div>
                            <a class="evidence-image-link" href="index.php?page=foto-bukti&id=<?= $idPengaduan ?>" target="_blank" rel="noopener noreferrer">
                                <img class="evidence-image" src="index.php?page=foto-bukti&amp;id=<?= $idPengaduan ?>" alt="Foto bukti pengaduan">
                            </a>
                            <p class="helper">Klik foto untuk melihat ukuran penuh.</p>
                        </div>
                    <?php endif; ?>
                </div>
            </section>

            <section class="card">
                <div class="card-body">
                    <div class="section-title detail-section-heading">
                        <div>
                            <span class="detail-eyebrow">PERKEMBANGAN</span>
                            <h3>Progres Pengaduan</h3>
                        </div>
                        <span class="small muted"><?= count($progres) ?> pembaruan</span>
                    </div>

                    <?php if (empty($progres)): ?>
                        <div class="detail-empty-state">Belum ada progres untuk laporan ini.</div>
                    <?php else: ?>
                        <div class="timeline" aria-label="Riwayat progres pengaduan">
                            <?php foreach ($progres as $index => $item): ?>
                                <?php
                                $statusProgres = isset($item['status_progres']) ? $item['status_progres'] : '';
                                $isLast = $index === $lastProgressIndex;
                                ?>
                                <article class="timeline-item <?= $isLast ? 'is-current' : 'is-complete' ?> <?= $statusProgres === 'Ditolak' ? 'is-rejected' : '' ?>">
                                    <span class="timeline-dot" aria-hidden="true"></span>
                                    <div class="timeline-content">
                                        <div class="timeline-heading-row">
                                            <h4><?= e($statusProgres) ?></h4>
                                            <?php if ($isLast): ?><span class="timeline-current-label">Terbaru</span><?php endif; ?>
                                        </div>
                                        <?php if (!empty($item['keterangan'])): ?>
                                            <p class="small muted timeline-note"><?= e($item['keterangan']) ?></p>
                                        <?php endif; ?>
                                        <small><?= e(formatTanggal($item['tanggal_progres'])) ?></small>
                                    </div>
                                </article>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>
                </div>
            </section>
        </div>

        <div class="detail-stack">
            <section class="card">
                <div class="card-body">
                    <div class="section-title detail-section-heading">
                        <div>
                            <span class="detail-eyebrow">KOMUNIKASI</span>
                            <h3>Umpan Balik</h3>
                        </div>
                        <span class="small muted"><?= count($feedbacks) ?> pesan</span>
                    </div>

                    <?php if (empty($feedbacks)): ?>
                        <div class="detail-empty-state detail-feedback-empty">Belum ada umpan balik. Tanggapan dari admin akan ditampilkan di sini.</div>
                    <?php else: ?>
                        <div class="detail-feedback-list">
                            <?php foreach ($feedbacks as $fb): ?>
                                <?php
                                $pemberi = isset($fb['pemberi']) ? $fb['pemberi'] : '';
                                $isAdminFeedback = $pemberi === 'admin';
                                $feedbackLabel = $isAdminFeedback ? 'Tanggapan Admin' : ($pemberi === 'siswa' ? 'Feedback Kamu' : 'Umpan Balik');
                                ?>
                                <article class="feedback-box <?= $isAdminFeedback ? 'feedback-admin' : 'feedback-siswa' ?>">
                                    <div class="feedback-card-heading">
                                        <strong><?= e($feedbackLabel) ?></strong>
                                        <span class="small muted"><?= e(formatTanggal($fb['tanggal_feedback'])) ?></span>
                                    </div>
                                    <div class="feedback-message"><?= nl2br(e($fb['isi_feedback'])) ?></div>
                                </article>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>

                    <?php if ($isSelesai && !$sudahFeedbackSiswa): ?>
                        <div class="detail-feedback-prompt">
                            <strong>Bagaimana hasil penanganannya?</strong>
                            <p>Pengaduan sudah selesai. Kamu dapat mengirim satu feedback untuk memberikan penilaian atau tanggapan kepada sekolah.</p>
                        </div>
                        <form class="detail-form" method="post" action="index.php?page=simpan-feedback" data-loading>
                            <?= csrfField() ?>
                            <input type="hidden" name="id_pengaduan" value="<?= $idPengaduan ?>">
                            <div class="form-group">
                                <label class="label required" for="isi_feedback">Feedback Kamu</label>
                                <textarea class="textarea detail-textarea" id="isi_feedback" name="isi_feedback" maxlength="2000" placeholder="Tulis tanggapan tentang hasil penanganan pengaduan..." required></textarea>
                                <span class="helper">Maksimal 2.000 karakter.</span>
                            </div>
                            <button class="btn btn-success full-width detail-submit" type="submit" data-loading-label="Mengirim...">
                                <?= uiIcon('send') ?>
                                <span>Kirim Feedback</span>
                            </button>
                        </form>
                    <?php elseif ($sudahFeedbackSiswa): ?>
                        <div class="detail-feedback-sent">
                            <?= uiIcon('check-circle') ?>
                            <span>Feedback kamu sudah dikirim. Terima kasih!</span>
                        </div>
                    <?php elseif (!$isSelesai): ?>
                        <div class="detail-feedback-waiting">
                            <strong>Feedback belum tersedia</strong>
                            <p>Form feedback akan muncul setelah status pengaduan menjadi <b>Selesai</b>.</p>
                        </div>
                    <?php endif; ?>
                </div>
            </section>

            <section class="card detail-tip-card">
                <div class="card-body">
                    <div class="detail-tip-icon" aria-hidden="true"><?= uiIcon('info') ?></div>
                    <div>
                        <strong>Informasi</strong>
                        <p>Buka kembali halaman ini untuk melihat perubahan status, catatan progres, dan tanggapan terbaru dari admin.</p>
                    </div>
                </div>
            </section>
        </div>
    </div>
</div>

<?php require __DIR__ . '/../layout/footer.php'; ?>

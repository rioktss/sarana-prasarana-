<?php
/**
 * FILE: views/admin/detail.php
 * FUNGSI: Menampilkan detail laporan, progres, dan panel pembaruan untuk admin.
 * ALUR: Satu form menyimpan perubahan status/catatan dan umpan balik admin.
 */
$title = 'Detail Pengaduan - SIPAS';
$menu = 'pengaduan';

$progres = isset($progres) && is_array($progres) ? $progres : [];
$feedbacks = isset($feedbacks) && is_array($feedbacks) ? $feedbacks : [];
$lastProgressIndex = count($progres) - 1;
$statusSaatIni = isset($pengaduan['status']) ? $pengaduan['status'] : '';
$isSelesai = $statusSaatIni === 'Selesai';
$idPengaduan = (int) $pengaduan['id_pengaduan'];

require __DIR__ . '/../layout/header.php';
?>

<div class="detail-page">
    <a class="link page-back" href="index.php?page=admin-pengaduan">
        <?= uiIcon('arrow-left') ?>
        <span>Kembali ke pengaduan</span>
    </a>

    <div class="detail-page-heading">
        <div>
            <div class="detail-eyebrow">PENGELOLAAN LAPORAN</div>
            <h1>Detail Pengaduan</h1>
            <p>Periksa laporan, pantau progres, dan kirim pembaruan kepada siswa.</p>
        </div>
        <div class="detail-heading-status">
            <?= statusBadge($statusSaatIni) ?>
            <span class="small muted">Laporan #<?= $idPengaduan ?></span>
        </div>
    </div>

    <div class="detail-grid detail-grid-admin">
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
                                <span class="small muted">Dilampirkan siswa</span>
                            </div>
                            <a class="evidence-image-link" href="index.php?page=foto-bukti&id=<?= $idPengaduan ?>" target="_blank" rel="noopener noreferrer">
                                <img class="evidence-image" src="index.php?page=foto-bukti&amp;id=<?= $idPengaduan ?>" alt="Foto bukti pengaduan">
                            </a>
                            <p class="helper">Klik foto untuk melihat ukuran penuh.</p>
                        </div>
                    <?php endif; ?>

                    <div class="detail-reporter-card">
                        <div class="detail-reporter-avatar" aria-hidden="true"><?= e(strtoupper(substr((string) $pengaduan['nama_siswa'], 0, 1))) ?></div>
                        <div class="detail-reporter-copy">
                            <span class="small muted">Dilaporkan oleh</span>
                            <strong><?= e($pengaduan['nama_siswa']) ?></strong>
                            <span class="small muted"><?= e($pengaduan['kelas']) ?> <span aria-hidden="true">·</span> NIS <?= e($pengaduan['nis']) ?></span>
                        </div>
                    </div>
                </div>
            </section>

            <section class="card">
                <div class="card-body">
                    <div class="section-title detail-section-heading">
                        <div>
                            <span class="detail-eyebrow">PERJALANAN LAPORAN</span>
                            <h3>Riwayat Progres</h3>
                        </div>
                        <span class="small muted"><?= count($progres) ?> pembaruan</span>
                    </div>

                    <?php if (empty($progres)): ?>
                        <div class="detail-empty-state">Belum ada riwayat progres untuk laporan ini.</div>
                    <?php else: ?>
                        <div class="timeline" aria-label="Riwayat progres pengaduan">
                            <?php foreach ($progres as $index => $item): ?>
                                <?php
                                $statusProgres = isset($item['status_progres']) ? $item['status_progres'] : '';
                                $isLast = $index === $lastProgressIndex;
                                $isRejected = $statusProgres === 'Ditolak';
                                ?>
                                <article class="timeline-item <?= $isLast ? 'is-current' : 'is-complete' ?> <?= $isRejected ? 'is-rejected' : '' ?>">
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
                    <div class="detail-section-heading detail-panel-heading">
                        <div>
                            <span class="detail-eyebrow">TINDAK LANJUT</span>
                            <h3>Perbarui Pengaduan</h3>
                        </div>
                        <?= statusBadge($statusSaatIni) ?>
                    </div>

                    <?php if ($isSelesai): ?>
                        <div class="detail-lock-notice">
                            <span class="detail-notice-icon" aria-hidden="true"><?= uiIcon('lock') ?></span>
                            <div>
                                <strong>Pengaduan telah selesai</strong>
                                <p>Status dan riwayat progres dikunci. Admin masih dapat mengirim umpan balik kepada siswa.</p>
                            </div>
                        </div>
                    <?php else: ?>
                        <p class="detail-intro-copy">Ubah status sesuai perkembangan penanganan. Catatan progres akan masuk ke riwayat laporan.</p>
                    <?php endif; ?>

                    <form class="detail-form" method="post" action="index.php?page=update-status" data-loading>
                        <?= csrfField() ?>
                        <input type="hidden" name="id_pengaduan" value="<?= $idPengaduan ?>">

                        <div class="form-group">
                            <label class="label required" for="status_pengaduan">Status Pengaduan</label>
                            <?php if ($isSelesai): ?>
                                <input type="hidden" name="status" value="Selesai">
                            <?php endif; ?>
                            <select class="select" id="status_pengaduan" name="<?= $isSelesai ? '' : 'status' ?>" <?= $isSelesai ? 'disabled' : 'required' ?>>
                                <?php foreach (['Diajukan', 'Diproses', 'Selesai', 'Ditolak'] as $status): ?>
                                    <option value="<?= e($status) ?>" <?= $statusSaatIni === $status ? 'selected' : '' ?>><?= e($status) ?></option>
                                <?php endforeach; ?>
                            </select>
                            <?php if ($isSelesai): ?><span class="helper">Status tidak dapat diubah kembali.</span><?php endif; ?>
                        </div>

                        <?php if (!$isSelesai): ?>
                            <div class="form-group">
                                <label class="label" for="keterangan">Catatan Progres <span class="label-optional">(opsional)</span></label>
                                <textarea class="textarea detail-textarea" id="keterangan" name="keterangan" maxlength="2000" placeholder="Jelaskan perkembangan penanganan laporan..."></textarea>
                                <span class="helper">Catatan akan ditampilkan pada riwayat progres yang dapat dilihat siswa.</span>
                            </div>
                        <?php endif; ?>

                        <div class="form-group detail-feedback-input-group">
                            <label class="label" for="isi_feedback_admin">Umpan Balik untuk Siswa <span class="label-optional">(opsional)</span></label>
                            <textarea class="textarea detail-textarea" id="isi_feedback_admin" name="isi_feedback" maxlength="2000" placeholder="Tulis informasi atau tanggapan untuk siswa..."></textarea>
                            <span class="helper">Kosongkan jika tidak ada umpan balik baru. Maksimal 2.000 karakter.</span>
                        </div>

                        <button class="btn btn-primary full-width detail-submit" type="submit" data-loading-label="Menyimpan...">
                            <?= uiIcon('save') ?>
                            <span>Simpan Perubahan</span>
                        </button>
                    </form>
                </div>
            </section>

            <section class="card">
                <div class="card-body">
                    <div class="section-title detail-section-heading">
                        <div>
                            <span class="detail-eyebrow">KOMUNIKASI</span>
                            <h3>Riwayat Umpan Balik</h3>
                        </div>
                        <span class="small muted"><?= count($feedbacks) ?> pesan</span>
                    </div>

                    <?php if (empty($feedbacks)): ?>
                        <div class="detail-empty-state">Belum ada umpan balik pada pengaduan ini.</div>
                    <?php else: ?>
                        <div class="detail-feedback-list">
                            <?php foreach ($feedbacks as $fb): ?>
                                <?php
                                $pemberi = isset($fb['pemberi']) ? $fb['pemberi'] : '';
                                $isAdminFeedback = $pemberi === 'admin';
                                $feedbackLabel = $isAdminFeedback ? 'Tanggapan Admin' : ($pemberi === 'siswa' ? 'Feedback Siswa' : 'Umpan Balik');
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
                </div>
            </section>
        </div>
    </div>
</div>

<?php require __DIR__ . '/../layout/footer.php'; ?>

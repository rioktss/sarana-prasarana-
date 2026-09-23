<?php $title='Kirim Pengaduan - SIPAS'; $menu='kirim'; require __DIR__ . '/../layout/header.php'; ?>
<a class="link page-back" href="index.php?page=dashboard"><?= uiIcon('arrow-left') ?><span>Kembali ke dashboard</span></a>

<div class="card form-card form-card-narrow">
    <div class="card-body">
        <div class="section-heading">
            <h2>Kirim Pengaduan</h2>
            <p>Jelaskan kerusakan, lokasi, dan kondisi sarana yang ingin dilaporkan.</p>
        </div>

        <?php if($error): ?>
            <div class="alert alert-error" role="alert">
                <span class="alert-icon"><?= uiIcon('alert') ?></span>
                <div class="alert-content"><?= e($error) ?></div>
            </div>
        <?php endif; ?>

        <form method="post" action="index.php?page=proses-pengaduan" data-loading>
            <div class="form-group">
                <label class="label required" for="judul_pengaduan">Judul Pengaduan</label>
                <input class="input" id="judul_pengaduan" name="judul_pengaduan" maxlength="150" value="<?= e($old['judul_pengaduan']) ?>" placeholder="Contoh: Kursi rusak di kelas XII RPL" autocomplete="off" required>
                <div class="helper form-counter" data-count-target="judul_pengaduan" data-max="150"></div>
            </div>

            <div class="form-group">
                <label class="label required" for="isi_pengaduan">Isi Pengaduan</label>
                <textarea class="textarea" id="isi_pengaduan" name="isi_pengaduan" placeholder="Tuliskan detail kerusakan dan lokasinya..." required><?= e($old['isi_pengaduan']) ?></textarea>
                <div class="helper">Jelaskan kondisi, lokasi, dan dampak kerusakan agar laporan lebih mudah ditindaklanjuti.</div>
            </div>

            <div class="toolbar form-actions">
                <button class="btn btn-primary" type="submit" data-loading-label="Mengirim..." data-loading-wide><?= uiIcon('send') ?><span>Kirim Pengaduan</span></button>
                <a class="btn btn-secondary" href="index.php?page=dashboard">Batal</a>
            </div>
        </form>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

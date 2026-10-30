<?php 
/**
 * FILE: views/admin/siswa_form.php
 * FUNGSI: Template form tambah atau edit siswa.
 * ALUR KERJA: Mengisi nilai lama ke form, menampilkan error validasi, dan mengirim identitas siswa ke route simpan-siswa.
 * INPUT / OUTPUT: Input: `$mode`, `$id`, `$old`, `$error`. Output: HTML form tambah/edit siswa.
 * FILE/TABEL TERKAIT: controllers/SiswaController.php, models/UserModel.php, models/SiswaModel.php, views/layout/*.php, assets/app.js
 * KEAMANAN OUTPUT: Teks dinamis di konteks HTML menggunakan e() untuk meng-escape karakter khusus dan membantu mencegah XSS; ID yang ditampilkan sebagai angka dikonversi ke integer.
 * CATATAN FORM: ID hidden berasal dari browser dan harus dianggap tidak tepercaya sampai diperiksa ulang controller; password edit opsional.
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
$title=($mode==='tambah'?'Tambah Siswa':'Edit Siswa') . ' - SIPAS'; $menu='siswa'; require __DIR__ . '/../layout/header.php'; ?>
<a class="link page-back" href="index.php?page=kelola-siswa"><?= uiIcon('arrow-left') ?><span>Kembali ke data siswa</span></a>

<div class="card form-card form-card-medium">
    <div class="card-body">
        <div class="section-heading">
            <h2><?= $mode==='tambah'?'Tambah Siswa':'Edit Siswa' ?></h2>
            <p><?= $mode==='tambah' ? 'Lengkapi data siswa untuk membuat akun baru.' : 'Perbarui data siswa. Password dapat dikosongkan jika tidak ingin diubah.' ?></p>
        </div>

        <?php if($error): ?>
            <div class="alert alert-error" role="alert">
                <span class="alert-icon"><?= uiIcon('alert') ?></span>
                <div class="alert-content"><?= e($error) ?></div>
            </div>
        <?php endif; ?>

        <form method="post" action="index.php?page=simpan-siswa" data-loading>
            <input type="hidden" name="id_siswa" value="<?= /* Hidden ID digunakan untuk menandai mode edit; ID tetap dianggap input klien dan divalidasi ulang oleh controller. */ (int)$id ?>">
            <div class="grid grid-2">
                <div class="form-group">
                    <label class="label required" for="username">Username</label>
                    <input class="input" type="text" id="username" name="username" value="<?= e($old['username']) ?>" minlength="4" autocomplete="username" required>
                </div>
                <div class="form-group">
                    <label class="label required" for="nis">NIS</label>
                    <input class="input" type="text" id="nis" name="nis" value="<?= e($old['nis']) ?>" inputmode="numeric" autocomplete="off" required>
                </div>
                <div class="form-group">
                    <label class="label required" for="nama_siswa">Nama Siswa</label>
                    <input class="input" type="text" id="nama_siswa" name="nama_siswa" value="<?= e($old['nama_siswa']) ?>" autocomplete="name" required>
                </div>
                <div class="form-group">
                    <label class="label required" for="kelas">Kelas</label>
                    <input class="input" type="text" id="kelas" name="kelas" value="<?= e($old['kelas']) ?>" placeholder="Contoh: XII RPL" autocomplete="off" required>
                </div>
            </div>

            <div class="form-group">
                <label class="label <?= $mode==='tambah' ? 'required' : '' ?>" for="student_password">Password <?= /* Saat edit, password kosong dimaksudkan agar password lama dipertahankan; controller mengganti hash hanya bila password baru diisi. */ $mode==='edit'?'(opsional)':'' ?></label>
                <div class="password-field">
                    <input class="input" type="password" id="student_password" name="password" <?= $mode==='tambah'?'required':'' ?> minlength="6" autocomplete="new-password">
                    <button class="password-toggle" type="button" aria-label="Tampilkan password" aria-controls="student_password" aria-pressed="false" data-password-toggle>
                        <span class="password-icon-show"><?= uiIcon('eye') ?></span>
                        <span class="password-icon-hide"><?= uiIcon('eye-off') ?></span>
                    </button>
                </div>
                <div class="helper"><?= $mode==='edit'?'Kosongkan bila password tidak ingin diubah.':'Minimal 6 karakter.' ?></div>
            </div>

            <div class="toolbar form-actions">
                <button class="btn btn-primary" type="submit" data-loading-label="Menyimpan..."><?= uiIcon('save') ?><span>Simpan</span></button>
                <a class="btn btn-secondary" href="index.php?page=kelola-siswa">Batal</a>
            </div>
        </form>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

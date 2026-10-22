<?php 
/**
 * FILE: views/auth/register.php
 * FUNGSI: Template registrasi akun siswa.
 * ALUR KERJA: Menampilkan form identitas siswa, username, password, dan konfirmasi password, serta mempertahankan input sebelumnya ketika validasi gagal.
 * INPUT / OUTPUT: Input: `$old` dan `$error`. Output: HTML form POST ke route proses-register.
 * FILE/TABEL TERKAIT: controllers/AuthController.php, models/UserModel.php, models/SiswaModel.php, assets/app.js, views/layout/*.php
 * KEAMANAN OUTPUT: Teks dinamis di konteks HTML menggunakan e() untuk meng-escape karakter khusus dan membantu mencegah XSS; ID yang ditampilkan sebagai angka dikonversi ke integer.
 * CATATAN FORM: Atribut HTML membantu validasi awal; setCustomValidity() berada di assets/app.js dan tidak menggantikan validasi server.
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
$title = 'Registrasi - SIPAS'; require __DIR__ . '/../layout/header.php'; ?>
<div class="auth-card">
    <div class="auth-hero">
        <div class="brand-icon" aria-hidden="true">S</div>
        <h2>Registrasi Siswa</h2>
        <p>Buat akun agar kamu dapat mengirim dan memantau pengaduan sarana dan prasarana sekolah.</p>
        <div class="auth-points">
            <div class="auth-point"><b>01</b><span>Isi identitas siswa dengan benar.</span></div>
            <div class="auth-point"><b>02</b><span>Buat username dan password untuk login.</span></div>
            <div class="auth-point"><b>03</b><span>Login dan mulai kirim pengaduan.</span></div>
        </div>
    </div>

    <div class="auth-main">
        <h1>Daftar Akun</h1>
        <div class="sub">Lengkapi data berikut untuk membuat akun siswa.</div>

        <?php /* required/minlength membantu UX. data-match pada konfirmasi diproses assets/app.js dengan setCustomValidity(); perbandingan password tetap diulang server oleh AuthController. */ if (!empty($error)): ?>
            <div class="alert alert-error" role="alert">
                <span class="alert-icon"><?= uiIcon('alert') ?></span>
                <div class="alert-content"><?= e($error) ?></div>
            </div>
        <?php endif; ?>

        <form method="post" action="index.php?page=proses-register" data-loading>
            <div class="grid grid-2">
                <div class="form-group">
                    <label class="label required" for="nama_siswa">Nama Siswa</label>
                    <input class="input" type="text" id="nama_siswa" name="nama_siswa" value="<?= e($old['nama_siswa']) ?>" placeholder="Nama lengkap" autocomplete="name" required>
                </div>
                <div class="form-group">
                    <label class="label required" for="nis">NIS</label>
                    <input class="input" type="text" id="nis" name="nis" value="<?= e($old['nis']) ?>" placeholder="Nomor induk siswa" inputmode="numeric" autocomplete="off" required>
                </div>
                <div class="form-group">
                    <label class="label required" for="kelas">Kelas</label>
                    <input class="input" type="text" id="kelas" name="kelas" value="<?= e($old['kelas']) ?>" placeholder="Contoh: XII RPL" autocomplete="off" required>
                </div>
                <div class="form-group">
                    <label class="label required" for="username">Username</label>
                    <input class="input" type="text" id="username" name="username" value="<?= e($old['username']) ?>" placeholder="Minimal 4 karakter" minlength="4" autocomplete="username" required>
                </div>
                <div class="form-group">
                    <label class="label required" for="password">Password</label>
                    <div class="password-field">
                        <input class="input" type="password" id="password" name="password" placeholder="Minimal 6 karakter" minlength="6" autocomplete="new-password" required>
                        <button class="password-toggle" type="button" aria-label="Tampilkan password" aria-controls="password" aria-pressed="false" data-password-toggle>
                            <span class="password-icon-show"><?= uiIcon('eye') ?></span>
                            <span class="password-icon-hide"><?= uiIcon('eye-off') ?></span>
                        </button>
                    </div>
                </div>
                <div class="form-group">
                    <label class="label required" for="konfirmasi">Konfirmasi Password</label>
                    <div class="password-field">
                        <input class="input" type="password" id="konfirmasi" name="konfirmasi" placeholder="Ulangi password" minlength="6" autocomplete="new-password" data-match="#password" data-match-error="Konfirmasi password tidak sama." required>
                        <button class="password-toggle" type="button" aria-label="Tampilkan password" aria-controls="konfirmasi" aria-pressed="false" data-password-toggle>
                            <span class="password-icon-show"><?= uiIcon('eye') ?></span>
                            <span class="password-icon-hide"><?= uiIcon('eye-off') ?></span>
                        </button>
                    </div>
                    <div class="field-error" data-match-message hidden></div>
                </div>
            </div>

            <button class="btn btn-primary full-width" type="submit" data-loading-label="Membuat akun...">
                <?= uiIcon('users') ?><span>Buat Akun</span>
            </button>
        </form>

        <div class="footer-note">Sudah punya akun? <a class="link" href="index.php?page=login">Kembali ke login</a></div>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

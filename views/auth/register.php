<?php $title = 'Registrasi - SIPAS'; require __DIR__ . '/../layout/header.php'; ?>
<div class="auth-card">
    <div class="auth-hero">
        <div class="brand-icon">S</div>
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
        <?php if (!empty($error)): ?><div class="alert alert-error"><?= e($error) ?></div><?php endif; ?>
        <form method="post" action="index.php?page=proses-register">
            <div class="grid grid-2">
                <div class="form-group"><label class="label" for="nama_siswa">Nama Siswa</label><input class="input" type="text" id="nama_siswa" name="nama_siswa" value="<?= e($old['nama_siswa']) ?>" placeholder="Nama lengkap" required></div>
                <div class="form-group"><label class="label" for="nis">NIS</label><input class="input" type="text" id="nis" name="nis" value="<?= e($old['nis']) ?>" placeholder="Nomor induk siswa" required></div>
                <div class="form-group"><label class="label" for="kelas">Kelas</label><input class="input" type="text" id="kelas" name="kelas" value="<?= e($old['kelas']) ?>" placeholder="Contoh: XII RPL" required></div>
                <div class="form-group"><label class="label" for="username">Username</label><input class="input" type="text" id="username" name="username" value="<?= e($old['username']) ?>" placeholder="Minimal 4 karakter" minlength="4" required></div>
                <div class="form-group"><label class="label" for="password">Password</label><input class="input" type="password" id="password" name="password" placeholder="Minimal 6 karakter" minlength="6" required></div>
                <div class="form-group"><label class="label" for="konfirmasi">Konfirmasi Password</label><input class="input" type="password" id="konfirmasi" name="konfirmasi" placeholder="Ulangi password" minlength="6" required></div>
            </div>
            <button class="btn btn-primary" type="submit" style="width:100%;">Buat Akun</button>
        </form>
        <div class="footer-note">Sudah punya akun? <a class="link" href="index.php?page=login">Kembali ke login</a></div>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

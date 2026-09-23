<?php
$title = 'Login - SIPAS';
require __DIR__ . '/../layout/header.php';
?>

<div class="auth-card">
    <div class="auth-hero">
        <div class="brand-icon" aria-hidden="true">S</div>
        <h2>SIPAS</h2>
        <p>Kelola pengaduan sarana dan prasarana sekolah dengan lebih cepat, rapi, dan mudah dipantau.</p>

        <div class="auth-points">
            <div class="auth-point"><b>01</b><span>Pengaduan siswa tercatat secara terstruktur.</span></div>
            <div class="auth-point"><b>02</b><span>Progres penanganan dapat dipantau siswa.</span></div>
            <div class="auth-point"><b>03</b><span>Admin dapat menindaklanjuti laporan dari satu sistem.</span></div>
        </div>
    </div>

    <div class="auth-main">
        <h1>Selamat Datang</h1>
        <div class="sub">Masuk menggunakan akun yang sudah terdaftar.</div>

        <?php if (!empty($error)): ?>
            <div class="alert alert-error" role="alert">
                <span class="alert-icon"><?= uiIcon('alert') ?></span>
                <div class="alert-content"><?= e($error) ?></div>
            </div>
        <?php endif; ?>

        <form method="post" action="index.php?page=proses-login" data-loading>
            <div class="form-group">
                <label class="label required" for="username">Username</label>
                <input class="input" type="text" id="username" name="username" placeholder="Masukkan username" autocomplete="username" required autofocus>
                <div class="field-error" data-field-error-for="username" hidden></div>
            </div>

            <div class="form-group">
                <label class="label required" for="password">Password</label>
                <div class="password-field">
                    <input class="input" type="password" id="password" name="password" placeholder="Masukkan password" autocomplete="current-password" required>
                    <button class="password-toggle" type="button" aria-label="Tampilkan password" aria-controls="password" aria-pressed="false" data-password-toggle>
                        <span class="password-icon-show"><?= uiIcon('eye') ?></span>
                        <span class="password-icon-hide"><?= uiIcon('eye-off') ?></span>
                    </button>
                </div>
                <div class="field-error" data-field-error-for="password" hidden></div>
            </div>

            <button class="btn btn-primary login-button" type="submit" data-loading-label="Memproses...">
                <?= uiIcon('report') ?><span>Masuk ke Sistem</span>
            </button>
        </form>

        <div class="footer-note">
            Belum memiliki akun siswa?
            <a class="link" href="index.php?page=register">Registrasi di sini</a>
        </div>
    </div>
</div>

<?php require __DIR__ . '/../layout/footer.php'; ?>

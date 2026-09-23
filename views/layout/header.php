<?php
$flash = flash();
$role = isset($_SESSION['role']) ? $_SESSION['role'] : null;
$name = isset($_SESSION['nama_siswa']) ? $_SESSION['nama_siswa'] : (isset($_SESSION['username']) ? $_SESSION['username'] : 'Pengguna');
$isAdmin = $role === 'admin';
$menu = isset($menu) ? $menu : '';
$title = isset($title) ? $title : 'SIPAS';

$flashClassMap = [
    'success' => 'alert-success',
    'danger' => 'alert-error',
    'error' => 'alert-error',
    'warning' => 'alert-warning',
    'info' => 'alert-info'
];
$flashClass = $flash ? (isset($flashClassMap[$flash['type']]) ? $flashClassMap[$flash['type']] : 'alert-info') : '';
$flashIcon = $flash && $flash['type'] === 'success' ? 'check' : ($flash && $flash['type'] === 'danger' ? 'alert' : 'info');
?>
<!doctype html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <meta name="theme-color" content="#2f4cff">
    <title><?= e($title) ?></title>
    <link rel="stylesheet" href="assets/style.css">
    <script src="assets/app.js" defer></script>
</head>
<body>
<a class="skip-link" href="#main-content">Lewati ke konten utama</a>
<?php if ($role): ?>
<div class="app">
    <aside class="sidebar" id="sipas-sidebar" aria-label="Navigasi utama">
        <div class="brand">
            <div class="brand-icon" aria-hidden="true">S</div>
            <div class="brand-copy">
                <strong>SIPAS</strong>
                <small>Sistem Pengaduan Sekolah</small>
            </div>
            <button class="sidebar-close" type="button" aria-label="Tutup menu" data-sidebar-close><?= uiIcon('close') ?></button>
        </div>

        <div class="profile">
            <div class="avatar" aria-hidden="true"><?= e(strtoupper(substr($name, 0, 1))) ?></div>
            <div class="name"><?= e($name) ?></div>
            <div class="role"><?= $isAdmin ? 'Administrator' : 'Siswa' ?></div>
        </div>

        <nav class="nav">
            <div class="nav-title">Menu Utama</div>
            <a class="<?= $menu === 'dashboard' ? 'active' : '' ?>" href="index.php?page=dashboard" <?= $menu === 'dashboard' ? 'aria-current="page"' : '' ?>>
                <span class="ico"><?= uiIcon('home') ?></span><span>Dashboard</span>
            </a>

            <?php if ($isAdmin): ?>
                <a class="<?= $menu === 'pengaduan' ? 'active' : '' ?>" href="index.php?page=admin-pengaduan" <?= $menu === 'pengaduan' ? 'aria-current="page"' : '' ?>>
                    <span class="ico"><?= uiIcon('report') ?></span><span>Pengaduan</span>
                </a>
                <a class="<?= $menu === 'siswa' ? 'active' : '' ?>" href="index.php?page=kelola-siswa" <?= $menu === 'siswa' ? 'aria-current="page"' : '' ?>>
                    <span class="ico"><?= uiIcon('users') ?></span><span>Kelola Siswa</span>
                </a>
            <?php else: ?>
                <a class="<?= $menu === 'kirim' ? 'active' : '' ?>" href="index.php?page=kirim-pengaduan" <?= $menu === 'kirim' ? 'aria-current="page"' : '' ?>>
                    <span class="ico"><?= uiIcon('plus') ?></span><span>Buat Pengaduan</span>
                </a>
                <a class="<?= $menu === 'histori' ? 'active' : '' ?>" href="index.php?page=histori" <?= $menu === 'histori' ? 'aria-current="page"' : '' ?>>
                    <span class="ico"><?= uiIcon('history') ?></span><span>Histori Pengaduan</span>
                </a>
            <?php endif; ?>
        </nav>

        <div class="side-bottom">
            <a class="logout" href="index.php?page=logout">
                <?= uiIcon('logout') ?><span>Keluar</span>
            </a>
        </div>
    </aside>

    <main class="main" id="main-content">
        <header class="topbar">
            <div class="topbar-left">
                <button class="mobile-menu" type="button" aria-label="Buka menu" aria-expanded="false" aria-controls="sipas-sidebar">
                    <?= uiIcon('menu') ?>
                </button>
                <div class="topbar-title">
                    <h1><?= e($title) ?></h1>
                    <div class="small muted">Aplikasi Pengaduan Sarana dan Prasarana Sekolah</div>
                </div>
            </div>
            <div class="topbar-right">
                <button class="theme-toggle" type="button" id="themeToggle" aria-label="Aktifkan tema gelap" aria-pressed="false">
                    <span class="theme-icon-dark"><?= uiIcon('moon') ?></span>
                    <span class="theme-icon-light"><?= uiIcon('sun') ?></span>
                </button>
                <div class="small muted topbar-date"><?= e(date('d/m/Y')) ?></div>
            </div>
        </header>

        <section class="content">
            <?php if ($flash): ?>
                <div class="alert <?= e($flashClass) ?> toast" role="<?= $flash['type'] === 'danger' ? 'alert' : 'status' ?>" data-toast data-toast-auto="<?= $flash['type'] === 'success' ? 'true' : 'false' ?>">
                    <span class="alert-icon"><?= uiIcon($flashIcon) ?></span>
                    <div class="alert-content"><?= e($flash['message']) ?></div>
                    <button class="alert-close" type="button" aria-label="Tutup notifikasi" data-toast-close><?= uiIcon('close') ?></button>
                </div>
            <?php endif; ?>
<?php else: ?>
<div class="auth-page" id="main-content">
    <?php if ($flash): ?>
        <div class="auth-flash">
            <div class="alert <?= e($flashClass) ?> toast" role="<?= $flash['type'] === 'danger' ? 'alert' : 'status' ?>" data-toast data-toast-auto="<?= $flash['type'] === 'success' ? 'true' : 'false' ?>">
                <span class="alert-icon"><?= uiIcon($flashIcon) ?></span>
                <div class="alert-content"><?= e($flash['message']) ?></div>
                <button class="alert-close" type="button" aria-label="Tutup notifikasi" data-toast-close><?= uiIcon('close') ?></button>
            </div>
        </div>
    <?php endif; ?>
    <button class="theme-toggle theme-toggle-auth" type="button" id="themeToggle" aria-label="Aktifkan tema gelap" aria-pressed="false">
        <span class="theme-icon-dark"><?= uiIcon('moon') ?></span>
        <span class="theme-icon-light"><?= uiIcon('sun') ?></span>
    </button>
<?php endif; ?>

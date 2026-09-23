<?php
$flash = flash();
$role = isset($_SESSION['role']) ? $_SESSION['role'] : null;
$name = isset($_SESSION['nama_siswa']) ? $_SESSION['nama_siswa'] : (isset($_SESSION['username']) ? $_SESSION['username'] : 'Pengguna');
$isAdmin = $role === 'admin';
$menu = isset($menu) ? $menu : '';
$title = isset($title) ? $title : 'SIPAS';
?>
<!doctype html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#2f4cff">
    <title><?= e($title) ?></title>
    <link rel="stylesheet" href="views/assets/style.css">
</head>
<body>
<?php if ($role): ?>
<div class="app">
    <aside class="sidebar">
        <div class="brand">
            <div class="brand-icon">S</div>
            <div>
                <strong>SIPAS</strong>
                <small>Sistem Pengaduan Sekolah</small>
            </div>
        </div>

        <div class="profile">
            <div class="avatar"><?= e(strtoupper(substr($name, 0, 1))) ?></div>
            <div class="name"><?= e($name) ?></div>
            <div class="role"><?= $isAdmin ? 'Administrator' : 'Siswa' ?></div>
        </div>

        <nav class="nav">
            <div class="nav-title">Menu Utama</div>
            <a class="<?= $menu === 'dashboard' ? 'active' : '' ?>" href="index.php?page=dashboard">
                <span class="ico">⌂</span> Dashboard
            </a>

            <?php if ($isAdmin): ?>
                <a class="<?= $menu === 'pengaduan' ? 'active' : '' ?>" href="index.php?page=admin-pengaduan">
                    <span class="ico">▤</span> Pengaduan
                </a>
                <a class="<?= $menu === 'siswa' ? 'active' : '' ?>" href="index.php?page=kelola-siswa">
                    <span class="ico">♙</span> Kelola Siswa
                </a>
            <?php else: ?>
                <a class="<?= $menu === 'kirim' ? 'active' : '' ?>" href="index.php?page=kirim-pengaduan">
                    <span class="ico">＋</span> Buat Pengaduan
                </a>
                <a class="<?= $menu === 'histori' ? 'active' : '' ?>" href="index.php?page=histori">
                    <span class="ico">◷</span> Histori Pengaduan
                </a>
            <?php endif; ?>
        </nav>

        <div class="side-bottom">
            <a class="logout" href="index.php?page=logout">⇥ Keluar</a>
        </div>
    </aside>

    <main class="main">
        <header class="topbar">
            <div class="profile-mini">
                <button class="mobile-menu" type="button" aria-label="Buka menu">☰</button>
                <div>
                    <h1><?= e($title) ?></h1>
                    <div class="small muted">Aplikasi Pengaduan Sarana dan Prasarana Sekolah</div>
                </div>
            </div>
            <div class="small muted"><?= e(date('d/m/Y')) ?></div>
        </header>

        <section class="content">
            <?php if ($flash): ?>
                <div class="alert <?= $flash['type'] === 'success' ? 'alert-success' : 'alert-error' ?>"><?= e($flash['message']) ?></div>
            <?php endif; ?>
<?php else: ?>
<div class="auth-page">
<?php if ($flash): ?>
    <div style="position:fixed;top:18px;left:50%;transform:translateX(-50%);width:min(520px,calc(100% - 28px));z-index:10;">
        <div class="alert <?= $flash['type'] === 'success' ? 'alert-success' : 'alert-error' ?>"><?= e($flash['message']) ?></div>
    </div>
<?php endif; ?>
<?php endif; ?>

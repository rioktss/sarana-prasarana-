<?php $title = isset($title) ? $title : '404 - SIPAS'; require __DIR__ . '/../layout/header.php'; ?>
<div class="card error-page">
    <div class="card-body" style="text-align:center;">
        <div class="error-code">404</div>
        <h2>Halaman tidak ditemukan</h2>
        <p class="muted">Menu yang kamu buka tidak tersedia.</p>
        <a class="btn btn-primary" href="index.php?page=dashboard">Kembali ke Dashboard</a>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

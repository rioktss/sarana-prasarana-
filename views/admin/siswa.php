<?php 
/**
 * FILE: views/admin/siswa.php
 * FUNGSI: Template daftar dan aksi pengelolaan siswa.
 * ALUR KERJA: Menampilkan tabel siswa serta tautan edit dan form hapus yang mengirim ID melalui POST.
 * INPUT / OUTPUT: Input: `$siswa`. Output: HTML daftar siswa dan form aksi admin.
 * FILE/TABEL TERKAIT: controllers/SiswaController.php, views/admin/siswa_form.php, views/layout/*.php
 * KEAMANAN OUTPUT: Teks dinamis di konteks HTML menggunakan e() untuk meng-escape karakter khusus dan membantu mencegah XSS; ID yang ditampilkan sebagai angka dikonversi ke integer.
 * CATATAN AKSI: Konfirmasi hapus hanya perlindungan UX; pemeriksaan hak admin dan ID wajib tetap dilakukan controller di server.
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
$title='Kelola Siswa - SIPAS'; $menu='siswa'; require __DIR__ . '/../layout/header.php'; ?>
<div class="page-actions">
    <div><h2>Kelola Siswa</h2><div class="small muted">Tambah, edit, atau hapus akun siswa.</div></div>
    <a class="btn btn-primary" href="index.php?page=form-siswa"><?= uiIcon('plus') ?><span>Tambah Siswa</span></a>
</div>

<div class="card">
    <div class="card-body">
        <?php if(empty($siswa)): ?>
            <div class="empty-state">
                <div class="empty-state-icon"><?= uiIcon('users') ?></div>
                <h3>Belum ada data siswa</h3>
                <p>Tambahkan siswa pertama untuk mulai mengelola akun dan data siswa.</p>
                <a class="btn btn-primary" href="index.php?page=form-siswa"><?= uiIcon('plus') ?><span>Tambah Siswa</span></a>
            </div>
        <?php else: ?>
            <div class="table-wrap">
                <table class="table">
                    <thead><tr><th>NIS</th><th>Nama</th><th>Kelas</th><th>Username</th><th>Aksi</th></tr></thead>
                    <tbody>
                    <?php foreach($siswa as $item): ?>
                        <tr>
                            <td><?= e($item['nis']) ?></td>
                            <td><strong><?= e($item['nama_siswa']) ?></strong></td>
                            <td><?= e($item['kelas']) ?></td>
                            <td>@<?= e($item['username']) ?></td>
                            <td>
                                <div class="toolbar row-actions">
                                    <a class="btn btn-secondary btn-sm" href="index.php?page=form-siswa&id=<?= /* ID hidden dikirim melalui POST; controller tetap memeriksa role dan mencari ulang record sebelum menghapus. */ (int)$item['id_siswa'] ?>"><?= uiIcon('edit') ?><span>Edit</span></a>
                                    <form method="post" action="index.php?page=hapus-siswa" data-confirm="Hapus siswa ini? Pengaduannya juga akan terhapus." data-confirm-title="Hapus data siswa?" data-confirm-detail="Data siswa dan pengaduan yang terkait akan ikut terhapus dan tidak dapat dikembalikan.">
                                        <input type="hidden" name="id_siswa" value="<?= (int)$item['id_siswa'] ?>">
                                        <button class="btn btn-danger btn-sm" type="submit" data-loading-label="Menghapus..."><?= uiIcon('trash') ?><span>Hapus</span></button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </div>
</div>
<?php require __DIR__ . '/../layout/footer.php'; ?>

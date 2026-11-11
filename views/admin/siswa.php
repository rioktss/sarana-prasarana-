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

$title = 'Kelola Siswa - SIPAS';
$menu = 'siswa';

require __DIR__ . '/../layout/header.php';
?>

<div class="page-actions">
    <div>
        <h2>Kelola Siswa</h2>
        <div class="small muted">
            Tambah, edit, cari, atau hapus akun siswa.
        </div>
    </div>

    <a class="btn btn-primary" href="index.php?page=form-siswa">
        <?= uiIcon('plus') ?>
        <span>Tambah Siswa</span>
    </a>
</div>

<div class="card">
    <div class="card-body">

        <?php if (empty($siswa)): ?>

            <div class="empty-state">
                <div class="empty-state-icon">
                    <?= uiIcon('users') ?>
                </div>

                <h3>Belum ada data siswa</h3>

                <p>
                    Tambahkan siswa pertama untuk mulai mengelola akun
                    dan data siswa.
                </p>

                <a class="btn btn-primary" href="index.php?page=form-siswa">
                    <?= uiIcon('plus') ?>
                    <span>Tambah Siswa</span>
                </a>
            </div>

        <?php else: ?>

            <!-- Pencarian Siswa -->
            <div class="student-search">
                <div class="student-search-heading">
                    <label for="searchSiswa" class="student-search-label">Cari Siswa</label>
                    <span class="student-search-hint">Cari berdasarkan NIS, nama, kelas, atau username</span>
                </div>

                <div class="student-search-field">
                    <input
                        type="search"
                        id="searchSiswa"
                        class="input student-search-input"
                        placeholder="Ketik nama, NIS, kelas, atau username..."
                        autocomplete="off"
                        aria-label="Cari data siswa"
                    >
                </div>

                <div class="small muted student-search-info" id="searchInfo" aria-live="polite">
                    Menampilkan <?= count($siswa) ?> siswa.
                </div>
            </div>

            <!-- Tabel Siswa -->
            <div class="table-wrap">
                <table class="table">

                    <thead>
                        <tr>
                            <th>NIS</th>
                            <th>Nama</th>
                            <th>Kelas</th>
                            <th>Username</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>

                    <tbody id="studentTable">

                        <?php foreach ($siswa as $item): ?>

                            <tr class="siswa-row">

                                <td data-label="NIS">
                                    <?= e($item['nis']) ?>
                                </td>

                                <td data-label="Nama">
                                    <strong>
                                        <?= e($item['nama_siswa']) ?>
                                    </strong>
                                </td>

                                <td data-label="Kelas">
                                    <?= e($item['kelas']) ?>
                                </td>

                                <td data-label="Username">
                                    @<?= e($item['username']) ?>
                                </td>

                                <td data-label="Aksi">
                                    <div class="toolbar row-actions">

                                        <!-- Edit Siswa -->
                                        <a
                                            class="btn btn-secondary btn-sm"
                                            href="index.php?page=form-siswa&id=<?= (int)$item['id_siswa'] ?>"
                                        >
                                            <?= uiIcon('edit') ?>
                                            <span>Edit</span>
                                        </a>

                                        <!-- Hapus Siswa -->
                                        <form
                                            method="post"
                                            action="index.php?page=hapus-siswa"
                                            data-confirm="Hapus siswa ini?"
                                            data-confirm-title="Hapus data siswa?"
                                            data-confirm-detail="Data siswa dan pengaduan yang terkait akan ikut terhapus dan tidak dapat dikembalikan."
                                        >

                                            <input
                                                type="hidden"
                                                name="id_siswa"
                                                value="<?= (int)$item['id_siswa'] ?>"
                                            >

                                            <button
                                                class="btn btn-danger btn-sm"
                                                type="submit"
                                                data-loading-label="Menghapus..."
                                            >
                                                <?= uiIcon('trash') ?>
                                                <span>Hapus</span>
                                            </button>

                                        </form>

                                    </div>
                                </td>

                            </tr>

                        <?php endforeach; ?>

                        <!-- Pesan ketika pencarian tidak ditemukan -->
                        <tr id="noSearchResults" class="student-search-empty" hidden>
                            <td colspan="5" style="text-align:center; padding:25px;">
                                <div class="muted">
                                    Tidak ada siswa yang cocok dengan pencarian.
                                </div>
                            </td>
                        </tr>

                    </tbody>

                </table>
            </div>

        <?php endif; ?>

    </div>
</div>

<!-- JavaScript Pencarian Siswa -->
<script>
document.addEventListener('DOMContentLoaded', function () {

    const searchInput = document.getElementById('searchSiswa');
    const studentTable = document.getElementById('studentTable');
    const searchInfo = document.getElementById('searchInfo');
    const noResults = document.getElementById('noSearchResults');

    // Jika elemen pencarian tidak tersedia, hentikan script.
    if (!searchInput || !studentTable) {
        return;
    }

    const studentRows = studentTable.querySelectorAll('.siswa-row');
    const totalStudents = studentRows.length;

    searchInput.addEventListener('input', function () {

        const normalizeText = function (value) {
            return value
                .toString()
                .normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '')
                .toLowerCase()
                .trim();
        };

        const keyword = normalizeText(this.value);

        let visibleCount = 0;

        studentRows.forEach(function (row) {

            // Cari hanya pada kolom NIS, Nama, Kelas, dan Username.
            const searchText = normalizeText(
                Array.from(row.cells)
                    .slice(0, 4)
                    .map(function (cell) {
                        return cell.textContent;
                    })
                    .join(' ')
            );

            const isMatch = searchText.includes(keyword);

            row.hidden = !isMatch;

            if (isMatch) {
                visibleCount++;
            }

        });

        // Perbarui informasi jumlah siswa.
        if (searchInfo) {
            searchInfo.textContent =
                'Menampilkan ' + visibleCount +
                ' dari ' + totalStudents + ' siswa.';
        }

        // Tampilkan pesan jika hasil pencarian kosong.
        if (noResults) {
            noResults.hidden = visibleCount !== 0;
        }

    });

});
</script>

<?php require __DIR__ . '/../layout/footer.php'; ?>

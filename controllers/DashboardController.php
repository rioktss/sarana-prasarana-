<?php


/**
 * FILE: controllers/DashboardController.php
 * FUNGSI: Menyiapkan data untuk dashboard admin atau siswa.
 * ALUR KERJA: Memeriksa sesi login, menentukan role, mengambil statistik atau histori milik siswa melalui model, lalu mengirim data ke view yang sesuai.
 * INPUT / OUTPUT: Input: session role dan id_siswa. Output: data statistik/daftar pengaduan untuk dashboard.
 * FILE/TABEL TERKAIT: index.php, helpers.php, models/PengaduanModel.php, models/SiswaModel.php, views/admin/dashboard.php, views/siswa/dashboard.php
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
class DashboardController
{
    private $db;
    private $pengaduan;
    private $siswa;

    /**
     * Menyiapkan koneksi dan model data yang diperlukan dashboard.
     * @param PDO $db Koneksi database aktif.
     * @return void Tidak ada nilai kembalian.
     * Alasan desain: Model dipakai sebagai lapisan pengambilan data agar query tidak ditulis langsung di view.
     */

    public function __construct($db)
    {
        $this->db = $db;
        $this->pengaduan = new PengaduanModel($db);
        $this->siswa = new SiswaModel($db);
    }

    /**
     * Memastikan pengguna login lalu memilih dashboard berdasarkan role.
     * @return void Meneruskan proses ke dashboard admin atau siswa.
     * Alasan desain: requireLogin melakukan guard di server; role dari session menentukan tampilan yang sesuai.
     */

    public function index()
    {
        // Guard server-side: pastikan hanya pengguna yang sudah login yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin();
        // Role disimpan pada session agar controller/layout dapat menerapkan akses dan navigasi yang sesuai.
        if ((isset($_SESSION['role']) ? $_SESSION['role'] : '') === 'admin') {
            $this->admin();
        } else {
            $this->siswa();
        }
    }

    /**
     * Mengumpulkan ringkasan untuk dashboard admin.
     * @return void Mengirim statistik, jumlah siswa, dan lima laporan terbaru ke view admin.
     * Alasan desain: Data diringkas oleh model supaya template fokus pada presentasi, bukan query database.
     */

    private function admin()
    {
        $stats = $this->pengaduan->countByStatus();
        // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
        view('admin/dashboard', [
            'stats' => $stats,
            'totalSiswa' => $this->siswa->countAll(),
            'terbaru' => $this->pengaduan->latest(5)
        ]);
    }

    /**
     * Menghitung ringkasan histori pengaduan milik siswa yang sedang login.
     * @return void Mengirim total, jumlah selesai, jumlah yang berjalan, dan daftar terbaru ke view siswa.
     * Alasan desain: Pencarian memakai id_siswa dari session agar ringkasan terkait akun aktif, bukan ID bebas dari URL. Status dihitung dari daftar yang diambil model.
     */

    private function siswa()
    {
        // ID siswa diambil dari session, bukan dipercaya dari form/URL, sehingga operasi dapat dibatasi pada pemilik akun aktif.
        $histori = $this->pengaduan->findBySiswa($_SESSION['id_siswa']);
        $selesai = 0;
        $berjalan = 0;
        foreach ($histori as $item) {
            if ($item['status'] === 'Selesai') $selesai++;
            if ($item['status'] === 'Diajukan' || $item['status'] === 'Diproses') $berjalan++;
        }

        // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
        view('siswa/dashboard', [
            'total' => count($histori),
            'selesai' => $selesai,
            'berjalan' => $berjalan,
            'terbaru' => array_slice($histori, 0, 5)
        ]);
    }
}

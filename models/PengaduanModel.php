<?php


/**
 * FILE: models/PengaduanModel.php
 * FUNGSI: Akses data utama pengaduan sekolah.
 * ALUR KERJA: Menyimpan pengaduan, mencari detail, mengambil daftar per siswa/seluruh siswa, menghitung statistik status, mengambil data terbaru, dan memperbarui status.
 * INPUT / OUTPUT: Input: ID, status, teks pengaduan, atau filter. Output: row/array statistik atau operasi database.
 * FILE/TABEL TERKAIT: controllers/PengaduanController.php, controllers/DashboardController.php, tabel pengaduan dan siswa
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
class PengaduanModel
{
    private $db;

    /**
     * Menyimpan koneksi PDO untuk seluruh query pengaduan.
     * @param PDO $db Koneksi database aktif.
     * @return void Tidak ada nilai kembalian.
     * Alasan desain: Dependency injection membuat semua query memakai koneksi terpusat dan bisa mengikuti transaksi controller.
     */

    public function __construct($db)
    {
        $this->db = $db;
    }

    /**
     * Menambahkan satu baris pengaduan baru.
     * @param int $idSiswa ID siswa pemilik laporan.
     * @param string $judul Judul ringkas pengaduan.
     * @param string $isi Detail kerusakan/laporan.
     * @return int ID pengaduan yang baru dibuat.
     * Alasan desain: Prepared statement menjaga input teks tetap terpisah dari SQL; lastInsertId memberi ID yang dibutuhkan untuk membuat progres awal dan membuka detail.
     */

    public function create($idSiswa, $judul, $isi) {
        // SQL: Query INSERT ini membuat laporan dengan mencatat siswa pemilik, judul, dan isi. Nilai disalurkan lewat prepared statement agar teks input tidak dapat mengubah struktur SQL.
        $stmt = $this->db->prepare('INSERT INTO pengaduan (id_siswa, judul_pengaduan, isi_pengaduan) VALUES (?, ?, ?)');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$idSiswa, $judul, $isi]);
        return (int) $this->db->lastInsertId();
    }

    /**
     * Mencari satu pengaduan beserta data siswa pelapornya.
     * @param int $id ID pengaduan yang dicari.
     * @return array|null Satu baris gabungan pengaduan dan data pelapor atau null.
     * Alasan desain: INNER JOIN diperlukan supaya view detail bisa menampilkan nama, NIS, dan kelas pelapor dari tabel siswa; WHERE membatasi satu ID dan LIMIT 1 mencegah pengambilan baris berlebih.
     */

    public function findById($id)
    {
        // SQL: Query ini menggabungkan tabel pengaduan (alias p) dengan siswa (alias s) melalui relasi id_siswa supaya detail laporan dapat menampilkan identitas pelapor. WHERE memilih satu laporan berdasarkan ID dan LIMIT 1 membatasi hasil.
        $stmt = $this->db->prepare('SELECT p.*, s.nis, s.nama_siswa, s.kelas FROM pengaduan p INNER JOIN siswa s ON s.id_siswa = p.id_siswa WHERE p.id_pengaduan = ? LIMIT 1');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    /**
     * Mengambil histori pengaduan milik siswa tertentu.
     * @param int $idSiswa ID siswa pemilik laporan.
     * @return array Daftar pengaduan terbaru terlebih dahulu.
     * Alasan desain: WHERE id_siswa menerapkan batas kepemilikan data; urutan tanggal dan ID menstabilkan susunan laporan ketika tanggal sama.
     */

    public function findBySiswa($idSiswa) {
        // SQL: Query ini hanya mengambil pengaduan dengan id_siswa yang cocok, sehingga histori dapat dibatasi pada pemilik yang sedang login. Urutan tanggal/ID DESC menempatkan laporan terbaru di awal.
        $stmt = $this->db->prepare('SELECT p.* FROM pengaduan p WHERE p.id_siswa = ? ORDER BY p.tanggal_pengaduan DESC, p.id_pengaduan DESC');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$idSiswa]);
        return $stmt->fetchAll();
    }

    /**
     * Mengambil daftar pengaduan untuk kebutuhan admin, dengan filter status opsional.
     * @param string $status Status filter; string kosong berarti semua status.
     * @return array Daftar laporan disertai identitas pelapor.
     * Alasan desain: Saat status dipilih, prepared statement mengikat nilai status. Saat filter kosong, query tanpa WHERE status mengembalikan semua laporan. INNER JOIN menambahkan data siswa agar daftar admin informatif.
     */

    public function findAll($status = '') {
        if ($status !== '') {
            // SQL: Query admin ini memfilter laporan berdasarkan status, lalu JOIN ke siswa agar daftar memuat NIS, nama, dan kelas pelapor. Status menggunakan placeholder, bukan digabung ke teks SQL.
            $stmt = $this->db->prepare('SELECT p.*, s.nis, s.nama_siswa, s.kelas FROM pengaduan p INNER JOIN siswa s ON s.id_siswa = p.id_siswa WHERE p.status = ? ORDER BY p.tanggal_pengaduan DESC, p.id_pengaduan DESC');
            // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
            $stmt->execute([$status]);
            return $stmt->fetchAll();
        }

        // SQL: Query ini mengambil semua laporan untuk admin dan menggabungkan identitas siswa melalui id_siswa. Tidak ada filter status karena pemanggil meminta seluruh laporan; pengurutan DESC menempatkan data terbaru di awal.
        $stmt = $this->db->query('SELECT p.*, s.nis, s.nama_siswa, s.kelas FROM pengaduan p INNER JOIN siswa s ON s.id_siswa = p.id_siswa ORDER BY p.tanggal_pengaduan DESC, p.id_pengaduan DESC');
        return $stmt->fetchAll();
    }

    /**
     * Menghitung total pengaduan untuk setiap status yang dikenal aplikasi.
     * @return array Array total keseluruhan serta jumlah per status.
     * Alasan desain: GROUP BY membuat database menghitung per status secara efisien. Pengecekan array_key_exists mengabaikan status asing agar hasil tetap mengikuti kategori yang dipakai dashboard.
     */

    public function countByStatus() {
        $rows = ['total' => 0, 'Diajukan' => 0, 'Diproses' => 0, 'Selesai' => 0, 'Ditolak' => 0];
        // SQL: Query agregasi ini menghitung jumlah laporan per status di database. GROUP BY menghindari menghitung satu per satu di PHP dan hasilnya dipakai untuk kartu statistik dashboard.
        $stmt = $this->db->query('SELECT status, COUNT(*) AS total FROM pengaduan GROUP BY status');

        foreach ($stmt->fetchAll() as $row) {
            if (array_key_exists($row['status'], $rows)) {
                $rows[$row['status']] = (int) $row['total'];
                $rows['total'] += (int) $row['total'];
            }
        }

        return $rows;
    }

    /**
     * Mengambil sejumlah pengaduan terbaru dengan batas maksimum yang wajar.
     * @param int $limit Jumlah baris yang diminta; dibatasi menjadi 1 sampai 20.
     * @return array Daftar laporan terbaru beserta nama dan kelas siswa.
     * Alasan desain: LIMIT tidak dapat diikat sebagai string biasa pada semua konfigurasi, sehingga nilainya diikat sebagai PDO::PARAM_INT. Batas 1–20 mencegah permintaan jumlah baris yang kelewat besar; INNER JOIN menyediakan nama pelapor.
     */

    public function latest($limit = 5) {
        $limit = max(1, min(20, $limit));
        // SQL: Query ini menggabungkan laporan dengan nama/kelas pelapor dan mengurutkan yang terbaru. LIMIT terikat sebagai integer agar jumlah baris terkontrol dan tidak disisipkan sebagai teks SQL mentah.
        $stmt = $this->db->prepare('SELECT p.*, s.nama_siswa, s.kelas FROM pengaduan p INNER JOIN siswa s ON s.id_siswa = p.id_siswa ORDER BY p.tanggal_pengaduan DESC, p.id_pengaduan DESC LIMIT :limit');
        // Parameter LIMIT diikat sebagai bilangan bulat agar database menerima tipe yang benar, bukan teks bebas.
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /**
     * Mengubah status terkini dari pengaduan tertentu.
     * @param int $id ID pengaduan yang akan diubah.
     * @param string $status Status baru yang telah divalidasi controller.
     * @return void Tidak mengembalikan nilai.
     * Alasan desain: WHERE id_pengaduan membatasi perubahan pada satu laporan; parameter query memisahkan ID/status dari SQL. Validasi status berada di controller sebelum model dipanggil.
     */

    public function updateStatus($id, $status) {
        // SQL: Query UPDATE ini mengubah status laporan tertentu saja. WHERE id_pengaduan penting agar status laporan lain tidak ikut berubah; controller memastikan status termasuk daftar yang diizinkan.
        $stmt = $this->db->prepare('UPDATE pengaduan SET status = ? WHERE id_pengaduan = ?');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$status, $id]);
    }
}

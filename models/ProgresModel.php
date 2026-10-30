<?php


/**
 * FILE: models/ProgresModel.php
 * FUNGSI: Akses riwayat perubahan progres pengaduan.
 * ALUR KERJA: Menambah catatan progres dan mengambil riwayatnya secara kronologis agar admin maupun siswa bisa melihat tahapan penanganan.
 * INPUT / OUTPUT: Input: ID pengaduan, status progres, keterangan. Output: array histori atau operasi tulis database.
 * FILE/TABEL TERKAIT: controllers/PengaduanController.php, tabel progres_pengaduan
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
class ProgresModel
{
    private $db;

    /**
     * Menyimpan koneksi PDO untuk tabel progres_pengaduan.
     * @param PDO $db Koneksi database aktif.
     * @return void Tidak ada nilai kembalian.
     * Alasan desain: Koneksi yang sama membuat penambahan progres dapat menjadi bagian transaksi controller.
     */

    public function __construct($db)
    {
        $this->db = $db;
    }

    /**
     * Mencatat satu perubahan/tahap penanganan pengaduan.
     * @param int $idPengaduan ID pengaduan terkait.
     * @param string $status Status progres yang dicatat.
     * @param string|null $keterangan Catatan tambahan; null jika tidak ada.
     * @return void Tidak mengembalikan nilai.
     * Alasan desain: Riwayat progres disimpan terpisah dari status terkini agar perubahan tidak menghapus catatan sebelumnya. Prepared statement memisahkan isi keterangan dari SQL.
     */

    public function create($idPengaduan, $status, $keterangan = null) {
        // SQL: Query INSERT ini membuat catatan riwayat tersendiri setiap kali progres berubah, supaya status lama tidak hilang saat status utama diperbarui. Semua nilai memakai placeholder prepared statement.
        $stmt = $this->db->prepare('INSERT INTO progres_pengaduan (id_pengaduan, status_progres, keterangan) VALUES (?, ?, ?)');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$idPengaduan, $status, $keterangan]);
    }

    /**
     * Mengambil riwayat progres untuk satu pengaduan menurut urutan waktunya.
     * @param int $idPengaduan ID pengaduan yang riwayatnya dicari.
     * @return array Daftar progres dari yang paling awal ke terbaru.
     * Alasan desain: WHERE menjaga riwayat tetap milik satu laporan, sedangkan urutan tanggal dan ID menjaga urutan yang dapat diprediksi.
     */

    public function findByPengaduan($idPengaduan) {
        // SQL: Query ini mengambil progres milik satu laporan dan mengurutkannya dari kejadian awal ke terbaru. Filter ID mencegah riwayat dari laporan lain tercampur.
        $stmt = $this->db->prepare('SELECT * FROM progres_pengaduan WHERE id_pengaduan = ? ORDER BY tanggal_progres ASC, id_progres ASC');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$idPengaduan]);
        return $stmt->fetchAll();
    }
}

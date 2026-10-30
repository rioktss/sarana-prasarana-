<?php


/**
 * FILE: models/FeedbackModel.php
 * FUNGSI: Akses data tabel umpan_balik.
 * ALUR KERJA: Mengambil daftar/feedback terbaru, memeriksa apakah pihak tertentu sudah mengirim feedback, serta menyimpan feedback menggunakan prepared statement.
 * INPUT / OUTPUT: Input: ID pengaduan, isi feedback, dan jenis pemberi. Output: array, boolean, atau operasi tulis database.
 * FILE/TABEL TERKAIT: controllers/PengaduanController.php, config/database.php, tabel umpan_balik
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
class FeedbackModel
{
    private $db;

    /**
     * Menyimpan koneksi PDO untuk query tabel umpan_balik.
     * @param PDO $db Koneksi database aktif.
     * @return void Tidak ada nilai kembalian.
     * Alasan desain: Koneksi disuntikkan dari router/controller supaya konfigurasi database terpusat.
     */

    public function __construct($db)
    {
        $this->db = $db;
    }

    /**
     * Mengambil semua feedback untuk satu pengaduan secara kronologis.
     * @param int $idPengaduan ID pengaduan yang feedback-nya ingin ditampilkan.
     * @return array Daftar feedback dari yang paling awal sampai terbaru.
     * Alasan desain: WHERE membatasi hasil pada satu pengaduan agar feedback tidak tercampur; ORDER BY ASC menyajikan percakapan sesuai urutan waktu. Placeholder `?` memisahkan data dari SQL untuk mengurangi risiko SQL Injection.
     */

    public function listByPengaduan($idPengaduan)
    {
        // SQL: Query ini mengambil feedback hanya untuk pengaduan yang sedang dibuka. WHERE membatasi lingkup data dan dua kolom ORDER BY mengurutkan feedback secara kronologis; placeholder ? menjaga ID tetap sebagai nilai data, bukan SQL.
        $stmt = $this->db->prepare('SELECT * FROM umpan_balik WHERE id_pengaduan = ? ORDER BY tanggal_feedback ASC, id_feedback ASC');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$idPengaduan]);
        return $stmt->fetchAll();
    }

    /**
     * Mengambil satu feedback paling baru dari pengaduan tertentu.
     * @param int $idPengaduan ID pengaduan yang dicari.
     * @return array|null Satu baris feedback terbaru atau null jika tidak ada.
     * Alasan desain: ORDER BY id_feedback DESC dan LIMIT 1 membuat pencarian berhenti pada feedback terakhir. Hasil kosong dinormalisasi menjadi null agar pemanggil mudah memeriksa ketiadaan data.
     */

    public function findByPengaduan($idPengaduan)
    {
        // SQL: Query ini mencari feedback terakhir untuk satu pengaduan. WHERE memilih laporan yang benar, urutan DESC dan LIMIT 1 mengambil baris paling baru saja sehingga tidak perlu memuat semua feedback.
        $stmt = $this->db->prepare('SELECT * FROM umpan_balik WHERE id_pengaduan = ? ORDER BY id_feedback DESC LIMIT 1');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$idPengaduan]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    /**
     * Memeriksa apakah pengirim tertentu telah memberi feedback untuk pengaduan tersebut.
     * @param int $idPengaduan ID pengaduan.
     * @param string $pemberi Jenis pengirim, biasanya siswa atau admin.
     * @return bool true jika ditemukan setidaknya satu feedback yang cocok.
     * Alasan desain: LIMIT 1 cukup untuk pemeriksaan keberadaan sehingga tidak perlu mengambil semua isi feedback; kedua kriteria dibatasi oleh parameter query.
     */

    public function exists($idPengaduan, $pemberi = 'siswa') {
        // SQL: Query ini hanya memeriksa keberadaan feedback oleh jenis pemberi tertentu pada satu pengaduan. Dua syarat WHERE mencegah feedback pihak lain dianggap sebagai duplikasi; LIMIT 1 cukup untuk pemeriksaan boolean.
        $stmt = $this->db->prepare('SELECT id_feedback FROM umpan_balik WHERE id_pengaduan = ? AND pemberi = ? LIMIT 1');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$idPengaduan, $pemberi]);
        return (bool) $stmt->fetchColumn();
    }

    /**
     * Menyimpan feedback baru yang terkait ke satu pengaduan dan jenis pemberinya.
     * @param int $idPengaduan ID pengaduan yang ditanggapi.
     * @param string $isi Teks umpan balik.
     * @param string $pemberi Jenis penulis, default siswa.
     * @return void Tidak mengembalikan nilai; menjalankan insert ke database.
     * Alasan desain: Satu statement insert menyimpan keterkaitan dan isi dalam satu operasi; prepared statement menjaga nilai teks tetap sebagai data, bukan bagian sintaks SQL.
     */

    public function create($idPengaduan, $isi, $pemberi = 'siswa') {
        // SQL: Query INSERT ini menyimpan ID laporan, identitas jenis pemberi, dan isi feedback sebagai satu record. Placeholder ? memisahkan nilai input dari sintaks SQL.
        $stmt = $this->db->prepare('INSERT INTO umpan_balik (id_pengaduan, pemberi, isi_feedback) VALUES (?, ?, ?)');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$idPengaduan, $pemberi, $isi]);
    }
}

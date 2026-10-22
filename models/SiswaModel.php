<?php


/**
 * FILE: models/SiswaModel.php
 * FUNGSI: Akses data profil siswa.
 * ALUR KERJA: Mencari siswa berdasarkan user/ID, menampilkan daftar, mengecek keunikan NIS, menambah/mengubah/menghapus siswa, dan menghitung total siswa.
 * INPUT / OUTPUT: Input: id user/siswa serta identitas siswa. Output: data siswa, boolean, ID baru, hitungan, atau operasi database.
 * FILE/TABEL TERKAIT: controllers/AuthController.php, controllers/DashboardController.php, controllers/SiswaController.php, tabel siswa dan users
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
class SiswaModel
{
    private $db;

    /**
     * Menyimpan koneksi PDO untuk query profil siswa.
     * @param PDO $db Koneksi database aktif.
     * @return void Tidak ada nilai kembalian.
     * Alasan desain: Koneksi diberikan dari luar agar model tidak membuat koneksi database baru sendiri.
     */

    public function __construct($db)
    {
        $this->db = $db;
    }

    /**
     * Mencari profil siswa yang terhubung ke akun login.
     * @param int $idUser ID akun dari tabel users.
     * @return array|null Data siswa atau null jika profil belum tersedia.
     * Alasan desain: Relasi id_user menghubungkan akun autentikasi dengan profil siswa; LIMIT 1 cukup karena satu akun diharapkan terhubung dengan satu profil.
     */

    public function findByUserId($idUser)
    {
        // SQL: Query ini mencari profil siswa berdasarkan foreign key id_user yang menghubungkan profil dengan akun autentikasi. LIMIT 1 sesuai asumsi satu akun memiliki satu profil siswa.
        $stmt = $this->db->prepare('SELECT * FROM siswa WHERE id_user = ? LIMIT 1');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$idUser]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    /**
     * Mencari satu profil siswa beserta username akun terkait.
     * @param int $id ID siswa yang dicari.
     * @return array|null Data siswa dan username atau null jika tidak ditemukan.
     * Alasan desain: INNER JOIN users diperlukan untuk menampilkan username yang disimpan di tabel akun, sedangkan WHERE dan LIMIT 1 membatasi hasil ke satu profil.
     */

    public function findById($id)
    {
        // SQL: Query ini JOIN profil siswa dengan akun users agar username tersedia bersama identitas siswa. WHERE membatasi satu ID profil dan LIMIT 1 mencegah pengambilan hasil tambahan.
        $stmt = $this->db->prepare('SELECT s.*, u.username FROM siswa s INNER JOIN users u ON u.id_user = s.id_user WHERE s.id_siswa = ? LIMIT 1');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    /**
     * Mengambil daftar semua siswa beserta username akun.
     * @return array Daftar siswa diurutkan dari ID terbesar ke terkecil.
     * Alasan desain: INNER JOIN menggabungkan profil dengan akun login; urutan menempatkan record terbaru/ber-ID lebih tinggi di awal.
     */

    public function findAll() {
        // SQL: Query daftar ini JOIN siswa dan users supaya admin dapat melihat username masing-masing siswa. Pengurutan ID menempatkan record bernomor lebih tinggi lebih dahulu.
        $stmt = $this->db->query('SELECT s.*, u.username FROM siswa s INNER JOIN users u ON u.id_user = s.id_user ORDER BY s.id_siswa DESC');
        return $stmt->fetchAll();
    }

    /**
     * Memeriksa apakah NIS sudah dipakai siswa lain.
     * @param string $nis Nomor induk siswa yang akan diperiksa.
     * @param int|null $exceptId ID siswa yang dikecualikan saat edit; default null.
     * @return bool true bila NIS sudah ada di record lain yang tidak dikecualikan.
     * Alasan desain: Cabang tanpa exceptId dipakai saat membuat siswa baru. Saat edit, kondisi `id_siswa <> ?` membuat NIS milik record saat ini tidak dianggap duplikat. LIMIT 1 cukup untuk cek keberadaan.
     */

    // Pengecekan keunikan di server mencegah dua akun memakai identitas yang sama; constraint database tetap penting sebagai perlindungan terakhir.
    public function existsNis($nis, $exceptId = null) {
        if ($exceptId === null) {
            // SQL: Query ini mengecek apakah NIS sudah ada tanpa mengambil seluruh kolom siswa. LIMIT 1 menghemat pekerjaan karena pemanggil hanya memerlukan jawaban ada/tidak.
            $stmt = $this->db->prepare('SELECT id_siswa FROM siswa WHERE nis = ? LIMIT 1');
            // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
            $stmt->execute([$nis]);
        } else {
            // SQL: Saat edit, query ini mengecek NIS pada siswa lain dengan mengecualikan id_siswa yang sedang diubah. Tanpa syarat `<>`, NIS milik record itu sendiri akan salah dianggap duplikat.
            $stmt = $this->db->prepare('SELECT id_siswa FROM siswa WHERE nis = ? AND id_siswa <> ? LIMIT 1');
            // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
            $stmt->execute([$nis, $exceptId]);
        }

        return (bool) $stmt->fetchColumn();
    }

    /**
     * Menyimpan profil siswa yang terhubung ke akun user.
     * @param int $idUser ID akun yang baru dibuat.
     * @param string $nis NIS siswa.
     * @param string $nama Nama lengkap siswa.
     * @param string $kelas Kelas siswa.
     * @return int ID siswa yang baru dibuat.
     * Alasan desain: Insert menyimpan relasi akun dan identitas siswa sekaligus; prepared statement melindungi nilai input dan lastInsertId mengembalikan identitas profil baru.
     */

    public function create($idUser, $nis, $nama, $kelas) {
        // SQL: Query INSERT ini menyimpan profil dan tautannya ke akun users. Prepared statement memisahkan identitas siswa dari sintaks SQL.
        $stmt = $this->db->prepare('INSERT INTO siswa (id_user, nis, nama_siswa, kelas) VALUES (?, ?, ?, ?)');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$idUser, $nis, $nama, $kelas]);
        return (int) $this->db->lastInsertId();
    }

    /**
     * Memperbarui identitas profil siswa tanpa mengganti akun yang terkait.
     * @param int $idSiswa ID profil yang diubah.
     * @param string $nis NIS baru.
     * @param string $nama Nama siswa baru.
     * @param string $kelas Kelas baru.
     * @return void Tidak mengembalikan nilai.
     * Alasan desain: WHERE menghindari perubahan massal; data akun username/password dikelola terpisah oleh UserModel.
     */

    public function update($idSiswa, $nis, $nama, $kelas) {
        // SQL: Query UPDATE ini hanya mengubah data profil yang ditunjuk oleh id_siswa. Username/password dikelola UserModel karena disimpan di tabel users yang berbeda.
        $stmt = $this->db->prepare('UPDATE siswa SET nis = ?, nama_siswa = ?, kelas = ? WHERE id_siswa = ?');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$nis, $nama, $kelas, $idSiswa]);
    }

    /**
     * Menghapus akun user yang terkait dengan profil siswa.
     * @param int $idSiswa ID profil yang akan dihapus.
     * @return void Berhenti tanpa perubahan bila profil tidak ditemukan.
     * Alasan desain: Pertama mencari id_user karena tabel users adalah tempat akun login disimpan. Penghapusan user dapat menghapus profil dan data terkait sesuai aturan relasi database; controller membungkus operasi dengan transaksi.
     */

    public function delete($idSiswa) {
        // SQL: Query ini mencari id_user milik profil sebelum penghapusan, karena kredensial login tersimpan pada tabel users. Jika siswa tidak ada, model berhenti tanpa melakukan DELETE.
        $stmt = $this->db->prepare('SELECT id_user FROM siswa WHERE id_siswa = ? LIMIT 1');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$idSiswa]);
        $row = $stmt->fetch();
        if (!$row) {
            return;
        }

        // SQL: Query ini menghapus akun login yang terkait dengan siswa. Efek ke tabel siswa/pengaduan bergantung pada foreign key/cascade yang didefinisikan di database, dan controller membungkusnya dengan transaksi.
        $stmt = $this->db->prepare('DELETE FROM users WHERE id_user = ?');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([(int) $row['id_user']]);
    }

    /**
     * Menghitung jumlah seluruh baris siswa.
     * @return int Total siswa sebagai bilangan bulat.
     * Alasan desain: COUNT(*) dikerjakan database tanpa memuat seluruh data siswa ke PHP sehingga lebih hemat memori.
     */

    public function countAll() {
        // SQL: Query COUNT(*) meminta database menghitung baris siswa tanpa mengambil seluruh data profil, jadi lebih ringan untuk kartu statistik.
        return (int) $this->db->query('SELECT COUNT(*) FROM siswa')->fetchColumn();
    }
}

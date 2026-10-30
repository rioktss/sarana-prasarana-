<?php


/**
 * FILE: models/UserModel.php
 * FUNGSI: Akses data akun untuk login dan pengelolaan siswa.
 * ALUR KERJA: Mencari akun, mengecek keunikan username, membuat akun dengan password hash, dan memperbarui username/password.
 * INPUT / OUTPUT: Input: username, password, role, atau id user. Output: data user, boolean, ID baru, atau operasi database.
 * FILE/TABEL TERKAIT: controllers/AuthController.php, controllers/SiswaController.php, tabel users
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
class UserModel
{
    private $db;

    /**
     * Menyimpan koneksi PDO untuk operasi akun.
     * @param PDO $db Koneksi database aktif.
     * @return void Tidak ada nilai kembalian.
     * Alasan desain: Koneksi dibagikan oleh controller agar query akun mengikuti konfigurasi yang sama.
     */

    public function __construct($db)
    {
        $this->db = $db;
    }

    /**
     * Mencari akun berdasarkan username untuk proses autentikasi.
     * @param string $username Username yang dikirim pada form login.
     * @return array|null Data akun termasuk hash password atau null bila tidak cocok.
     * Alasan desain: Username dipakai sebagai kriteria unik; prepared statement mencegah input username diperlakukan sebagai sintaks SQL. Hash password dibutuhkan untuk password_verify, bukan untuk ditampilkan.
     */

    public function findByUsername($username)
    {
        // SQL: Query ini mencari satu akun dari username yang dimasukkan saat login. Placeholder mencegah username diperlakukan sebagai bagian dari perintah SQL; hasil mencakup hash yang diperlukan password_verify.
        $stmt = $this->db->prepare('SELECT * FROM users WHERE username = ? LIMIT 1');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$username]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    /**
     * Memeriksa apakah username sudah dipakai akun lain.
     * @param string $username Username yang hendak dicek.
     * @param int|null $exceptId ID akun yang diabaikan ketika mode edit; default null.
     * @return bool true jika username sudah dipakai akun lain.
     * Alasan desain: Saat edit, pengecualian id_user mencegah username milik akun sendiri dianggap duplikat. LIMIT 1 cukup karena yang diperlukan hanya status ada/tidak.
     */

    // Pengecekan keunikan di server mencegah dua akun memakai identitas yang sama; constraint database tetap penting sebagai perlindungan terakhir.
    public function existsUsername($username, $exceptId = null) {
        if ($exceptId === null) {
            // SQL: Query ini memeriksa keunikan username dengan mengambil ID saja, karena data lengkap akun tidak dibutuhkan untuk validasi duplikasi.
            $stmt = $this->db->prepare('SELECT id_user FROM users WHERE username = ? LIMIT 1');
            // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
            $stmt->execute([$username]);
        } else {
            // SQL: Saat edit akun, query mengecek apakah username digunakan oleh akun lain dan mengecualikan id_user sendiri agar perubahan tanpa mengganti username tetap sah.
            $stmt = $this->db->prepare('SELECT id_user FROM users WHERE username = ? AND id_user <> ? LIMIT 1');
            // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
            $stmt->execute([$username, $exceptId]);
        }

        return (bool) $stmt->fetchColumn();
    }

    /**
     * Membuat akun baru dan menyimpan password dalam bentuk hash.
     * @param string $username Username akun baru.
     * @param string $password Password asli yang diterima saat proses pembuatan; tidak disimpan mentah.
     * @param string $role Peran akun, misalnya siswa.
     * @return int ID akun yang baru dibuat.
     * Alasan desain: password_hash dengan PASSWORD_DEFAULT memilih algoritma hash yang direkomendasikan oleh versi PHP dan menyimpan salt dalam hash. Database tidak perlu menyimpan password asli; prepared statement memisahkan seluruh nilai dari SQL.
     */

    public function create($username, $password, $role) {
        // Simpan hash satu arah, bukan password mentah. password_hash mengelola salt dan format hash; saat login dicek dengan password_verify.
        // Hash satu arah memungkinkan verifikasi tanpa menyimpan password asli, sehingga kebocoran tabel tidak langsung membeberkan password.
        $hash = password_hash($password, PASSWORD_DEFAULT);
        // SQL: Query INSERT ini menyimpan username, hash password, dan role akun. Yang dikirim ke kolom password adalah hash dari password_hash, bukan password mentah.
        $stmt = $this->db->prepare('INSERT INTO users (username, password, role) VALUES (?, ?, ?)');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$username, $hash, $role]);
        return (int) $this->db->lastInsertId();
    }

    /**
     * Mengubah username pada satu akun.
     * @param int $idUser ID akun target.
     * @param string $username Username yang baru.
     * @return void Tidak mengembalikan nilai.
     * Alasan desain: WHERE id_user membatasi pembaruan ke akun yang dimaksud dan parameter query menjaga nilai sebagai data.
     */

    public function updateUsername($idUser, $username) {
        // SQL: Query ini mengubah username pada satu ID akun. WHERE membatasi baris target dan parameter terpisah menjaga input sebagai nilai.
        $stmt = $this->db->prepare('UPDATE users SET username = ? WHERE id_user = ?');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$username, $idUser]);
    }

    /**
     * Mengganti password akun dengan hash baru.
     * @param int $idUser ID akun target.
     * @param string $password Password baru yang akan di-hash.
     * @return void Tidak mengembalikan nilai.
     * Alasan desain: Password baru di-hash sebelum ditulis, jadi kolom password tidak berisi password mentah. password_verify kelak akan memeriksa nilai tersebut saat login.
     */

    public function updatePassword($idUser, $password) {
        // Simpan hash satu arah, bukan password mentah. password_hash mengelola salt dan format hash; saat login dicek dengan password_verify.
        // Hash satu arah memungkinkan verifikasi tanpa menyimpan password asli, sehingga kebocoran tabel tidak langsung membeberkan password.
        $hash = password_hash($password, PASSWORD_DEFAULT);
        // SQL: Query ini mengubah hash password pada satu akun. password_hash telah dipanggil sebelum query, dan WHERE mencegah akun lain ikut diperbarui.
        $stmt = $this->db->prepare('UPDATE users SET password = ? WHERE id_user = ?');
        // Nilai diserahkan sebagai parameter statement, bukan ditempel langsung ke string SQL.
        $stmt->execute([$hash, $idUser]);
    }
}

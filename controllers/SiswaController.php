<?php


/**
 * FILE: controllers/SiswaController.php
 * FUNGSI: Menangani pengelolaan data dan akun siswa oleh admin.
 * ALUR KERJA: Menampilkan data siswa, menyiapkan form tambah/edit, memvalidasi data yang dikirim, menjaga konsistensi perubahan data siswa dan akun user menggunakan transaksi, serta menghapus akun.
 * INPUT / OUTPUT: Input: parameter GET/POST dan session admin. Output: view admin, perubahan database, flash message, atau redirect.
 * FILE/TABEL TERKAIT: index.php, helpers.php, models/SiswaModel.php, models/UserModel.php, views/admin/siswa.php, views/admin/siswa_form.php
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
class SiswaController
{
    private $db;
    private $siswa;
    private $users;

    /**
     * Menyiapkan model siswa dan user untuk pengelolaan akun siswa.
     * @param PDO $db Koneksi database aktif.
     * @return void Tidak ada nilai kembalian.
     * Alasan desain: Data profil dan data login dikelola oleh dua model berbeda tetapi koneksinya sama agar operasi dapat berada dalam satu transaksi.
     */

    public function __construct($db)
    {
        $this->db = $db;
        $this->siswa = new SiswaModel($db);
        $this->users = new UserModel($db);
    }

    /**
     * Menampilkan semua data siswa untuk admin.
     * @return void Meneruskan daftar siswa ke view admin/siswa.
     * Alasan desain: requireLogin admin menjadi guard server-side sebelum data sensitif daftar siswa diambil.
     */

    public function index() {
        // Guard server-side: pastikan hanya admin yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('admin');
        // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
        view('admin/siswa', ['siswa' => $this->siswa->findAll()]);
    }

    /**
     * Menampilkan form tambah kosong atau mengisi form edit dari data siswa yang ada.
     * @return void Memanggil view siswa_form sesuai mode tambah/edit.
     * Alasan desain: ID dikonversi ke integer dan data dicari ulang di database. Data yang tidak ditemukan tidak diteruskan ke template sebagai data valid.
     */

    public function form() {
        // Guard server-side: pastikan hanya admin yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('admin');
        // Parameter URL berasal dari klien sehingga diperiksa keberadaannya dan kemudian dinormalisasi/validasi sebelum dipakai.
        $id = (int) ((isset($_GET['id']) ? $_GET['id'] : 0));

        // ID dikonversi ke integer dan diperiksa batasnya agar nilai kosong/tidak masuk akal tidak dipakai sebagai target query.
        if ($id > 0) {
            // Data dicari ulang di database; jangan hanya mengandalkan ID yang dikirim browser karena record bisa tidak ada atau bukan milik pengguna.
            $data = $this->siswa->findById($id);
            if (!$data) {
                // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
                flash('danger', 'Data siswa tidak ditemukan.');
                // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
                redirect('kelola-siswa');
            }

            $old = [
                'username' => $data['username'],
                'nis' => $data['nis'],
                'nama_siswa' => $data['nama_siswa'],
                'kelas' => $data['kelas']
            ];

            // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
            view('admin/siswa_form', ['mode'=>'edit','id'=>$id,'old'=>$old,'error'=>'']);
            return;
        }

        // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
        view('admin/siswa_form', [
            'mode'=>'tambah',
            'id'=>0,
            'old'=>['username'=>'','nis'=>'','nama_siswa'=>'','kelas'=>''],
            'error'=>''
        ]);
    }

    /**
     * Memvalidasi data siswa lalu membuat akun baru atau memperbarui akun/profil lama.
     * @return void Menyimpan data lalu redirect atau mengembalikan form dengan pesan error.
     * Alasan desain: Username dan NIS dicek unik dengan pengecualian record sendiri saat edit. Perubahan akun dan profil dilakukan dalam satu transaksi. Password hanya diganti bila mode tambah atau field password edit diisi.
     */

    public function save() {
        // Guard server-side: pastikan hanya admin yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('admin');
        // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
        $id = (int) ((isset($_POST['id_siswa']) ? $_POST['id_siswa'] : 0));
        $old = [
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            'username' => trim((isset($_POST['username']) ? $_POST['username'] : '')),
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            'nis' => trim((isset($_POST['nis']) ? $_POST['nis'] : '')),
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            'nama_siswa' => trim((isset($_POST['nama_siswa']) ? $_POST['nama_siswa'] : '')),
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            'kelas' => trim((isset($_POST['kelas']) ? $_POST['kelas'] : ''))
        ];
        // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
        $password = (isset($_POST['password']) ? $_POST['password'] : '');
        $error = '';
        // ID dikonversi ke integer dan diperiksa batasnya agar nilai kosong/tidak masuk akal tidak dipakai sebagai target query.
        $existing = $id > 0 ? $this->siswa->findById($id) : null;

        // ID dikonversi ke integer dan diperiksa batasnya agar nilai kosong/tidak masuk akal tidak dipakai sebagai target query.
        if ($id > 0 && !$existing) {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Data siswa tidak ditemukan.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('kelola-siswa');
        }

        $idUserExisting = $existing ? (int) $existing['id_user'] : null;

        // Pencocokan strict (`true`) mencegah perbedaan tipe dianggap sama; whitelist membatasi input ke opsi yang diketahui aplikasi.
        if (in_array('', $old, true) || ($id === 0 && $password === '')) {
            $error = 'Semua kolom wajib diisi.';
        // Validasi panjang di server memastikan aturan minimum tetap berlaku walaupun request dikirim tanpa melalui form browser.
        } elseif (strlen($old['username']) < 4) {
            $error = 'Username minimal 4 karakter.';
        // Validasi panjang di server memastikan aturan minimum tetap berlaku walaupun request dikirim tanpa melalui form browser.
        } elseif (($id === 0 || $password !== '') && strlen($password) < 6) {
            $error = 'Password minimal 6 karakter.';
        // Pengecekan keunikan di server mencegah dua akun memakai identitas yang sama; constraint database tetap penting sebagai perlindungan terakhir.
        } elseif ($this->users->existsUsername($old['username'], $idUserExisting)) {
            $error = 'Username sudah digunakan.';
        // Pengecekan keunikan di server mencegah dua akun memakai identitas yang sama; constraint database tetap penting sebagai perlindungan terakhir.
        } elseif ($this->siswa->existsNis($old['nis'], $id > 0 ? $id : null)) {
            $error = 'NIS sudah digunakan.';
        }

        if ($error !== '') {
            // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
            view('admin/siswa_form', [
                // ID dikonversi ke integer dan diperiksa batasnya agar nilai kosong/tidak masuk akal tidak dipakai sebagai target query.
                'mode'=>$id > 0 ? 'edit':'tambah',
                'id'=>$id,
                'old'=>$old,
                'error'=>$error
            ]);
            return;
        }

        try {
            // Mulai transaksi agar beberapa query yang saling bergantung bisa dianggap satu operasi; jika ada yang gagal, semuanya bisa di-rollback.
            $this->db->beginTransaction();

            if ($id === 0) {
                $idUser = $this->users->create($old['username'], $password, 'siswa');
                $this->siswa->create($idUser, $old['nis'], $old['nama_siswa'], $old['kelas']);
                // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
                flash('success', 'Siswa berhasil ditambahkan.');
            } else {
                $this->siswa->update($id, $old['nis'], $old['nama_siswa'], $old['kelas']);
                $this->users->updateUsername((int)$existing['id_user'], $old['username']);
                // Saat edit, password kosong berarti pengguna meminta mempertahankan password lama.
                if ($password !== '') $this->users->updatePassword((int)$existing['id_user'], $password);
                // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
                flash('success', 'Data siswa berhasil diperbarui.');
            }

            // Commit memastikan seluruh perubahan dalam transaksi disimpan setelah semua langkah berhasil.
            $this->db->commit();
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('kelola-siswa');
        // Tangani kegagalan agar proses berhenti dengan pesan yang sesuai; bila perubahan database sudah berada dalam transaksi, controller dapat melakukan rollback.
        } catch (Exception $e) {
            // Rollback membatalkan perubahan yang belum di-commit agar database tidak tertinggal dalam keadaan setengah jadi.
            if ($this->db->inTransaction()) $this->db->rollBack();
            // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
            view('admin/siswa_form', [
                // ID dikonversi ke integer dan diperiksa batasnya agar nilai kosong/tidak masuk akal tidak dipakai sebagai target query.
                'mode'=>$id > 0 ? 'edit':'tambah',
                'id'=>$id,
                'old'=>$old,
                'error'=>'Gagal menyimpan: ' . $e->getMessage()
            ]);
        }
    }

    /**
     * Menghapus akun siswa sesuai ID yang dikirim admin.
     * @return void Commit dan redirect setelah penghapusan, atau rollback serta pesan error jika gagal.
     * Alasan desain: Aksi ini memerlukan role admin dan ID positif. Transaksi memastikan kegagalan query dapat dibatalkan; penghapusan dapat berdampak pada data terkait sesuai aturan foreign key database.
     */

    public function delete() {
        // Guard server-side: pastikan hanya admin yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('admin');
        // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
        $id = (int) ((isset($_POST['id_siswa']) ? $_POST['id_siswa'] : 0));
        // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
        if ($id <= 0) redirect('kelola-siswa');

        try {
            // Mulai transaksi agar beberapa query yang saling bergantung bisa dianggap satu operasi; jika ada yang gagal, semuanya bisa di-rollback.
            $this->db->beginTransaction();
            $this->siswa->delete($id);
            // Commit memastikan seluruh perubahan dalam transaksi disimpan setelah semua langkah berhasil.
            $this->db->commit();
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('success', 'Data siswa berhasil dihapus.');
        // Tangani kegagalan agar proses berhenti dengan pesan yang sesuai; bila perubahan database sudah berada dalam transaksi, controller dapat melakukan rollback.
        } catch (Exception $e) {
            // Rollback membatalkan perubahan yang belum di-commit agar database tidak tertinggal dalam keadaan setengah jadi.
            if ($this->db->inTransaction()) $this->db->rollBack();
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Gagal menghapus siswa: ' . $e->getMessage());
        }

        // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
        redirect('kelola-siswa');
    }
}

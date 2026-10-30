<?php


/**
 * FILE: controllers/AuthController.php
 * FUNGSI: Menangani login, registrasi akun siswa, dan logout.
 * ALUR KERJA: Menerima formulir autentikasi, memvalidasi input, memanggil UserModel/SiswaModel, mengelola session, serta menyimpan data akun dalam transaksi ketika registrasi.
 * INPUT / OUTPUT: Input: POST username/password/identitas siswa dan session aktif. Output: view login/registrasi, flash message, perubahan session, atau redirect.
 * FILE/TABEL TERKAIT: index.php, models/UserModel.php, models/SiswaModel.php, helpers.php, views/auth/login.php, views/auth/register.php
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
class AuthController
{
    private $db;
    private $users;
    private $siswa;

    /**
     * Menyimpan koneksi dan menyiapkan model akun serta siswa untuk dipakai action autentikasi.
     * @param PDO $db Koneksi database aktif.
     * @return void Tidak mengembalikan nilai; menyimpan dependency pada properti.
     * Alasan desain: Dependency diberikan dari router sehingga controller dan model memakai koneksi yang sama.
     */

    public function __construct($db)
    {
        $this->db = $db;
        $this->users = new UserModel($db);
        $this->siswa = new SiswaModel($db);
    }

    /**
     * Menangani permintaan menampilkan form login sekaligus memproses POST login.
     * @return void Menampilkan view, menyimpan session, atau mengarahkan ke route berikutnya.
     * Alasan desain: Pengecekan dilakukan di sisi server walaupun form juga menggunakan atribut required. password_verify membandingkan password asli dengan hash tersimpan tanpa perlu mengetahui password asli dari database.
     */

    public function login() {
        // Session menyimpan ID akun yang telah terautentikasi untuk mengenali pengguna pada request berikutnya.
        if (isset($_SESSION['id_user'])) {
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('dashboard');
        }

        $error = '';
        // Memastikan blok pemrosesan hanya berjalan untuk metode HTTP yang diharapkan; membuka form GET tidak dianggap sebagai pengiriman data.
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            $username = trim((isset($_POST['username']) ? $_POST['username'] : ''));
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            $password = (isset($_POST['password']) ? $_POST['password'] : '');

            // Validasi server menolak nilai kosong sebelum operasi database; atribut required di HTML hanya bantuan UX dan bukan pengganti validasi ini.
            if ($username === '' || $password === '') {
                $error = 'Username dan password wajib diisi.';
            } else {
                $user = $this->users->findByUsername($username);

                // password_verify membandingkan password yang diketik dengan hash di database; aplikasi tidak perlu menyimpan/mengambil password asli.
                // Kredensial valid saja belum cukup bagi akun siswa: controller juga memastikan profil siswa terkait tersedia.
                if ($user && password_verify($password, $user['password'])) {
                    // Ganti ID session setelah login berhasil untuk mengurangi risiko session fixation (pemakaian ID sesi lama yang ditebak/dipaksakan).
                    session_regenerate_id(true);
                    // Session menyimpan ID akun yang telah terautentikasi untuk mengenali pengguna pada request berikutnya.
                    $_SESSION['id_user'] = (int) $user['id_user'];
                    // Data session digunakan untuk menjaga konteks login/pengguna antarrekuest HTTP.
                    $_SESSION['username'] = $user['username'];
                    // Role disimpan pada session agar controller/layout dapat menerapkan akses dan navigasi yang sesuai.
                    $_SESSION['role'] = $user['role'];

                    if ($user['role'] === 'siswa') {
                        $dataSiswa = $this->siswa->findByUserId((int) $user['id_user']);
                        // Session role sudah sempat diisi; session_unset mencegah sesi login parsial tertinggal saat profil siswa tidak ada.
                        if (!$dataSiswa) {
                            session_unset();
                            $error = 'Data siswa belum lengkap. Hubungi admin.';
                        } else {
                            // ID siswa diambil dari session, bukan dipercaya dari form/URL, sehingga operasi dapat dibatasi pada pemilik akun aktif.
                            $_SESSION['id_siswa'] = (int) $dataSiswa['id_siswa'];
                            // Data session digunakan untuk menjaga konteks login/pengguna antarrekuest HTTP.
                            $_SESSION['nama_siswa'] = $dataSiswa['nama_siswa'];
                            // Data session digunakan untuk menjaga konteks login/pengguna antarrekuest HTTP.
                            $_SESSION['kelas'] = $dataSiswa['kelas'];
                        }
                    }

                    if ($error === '') {
                        // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
                        flash('success', 'Login berhasil. Selamat datang, ' . $user['username'] . '!');
                        // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
                        redirect('dashboard');
                    }
                } else {
                    $error = 'Username atau password salah.';
                }
            }
        }

        // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
        view('auth/login', ['error' => $error]);
    }

    /**
     * Memvalidasi dan membuat akun siswa beserta profil siswanya.
     * @return void Menampilkan form registrasi atau membuat akun kemudian redirect ke login.
     * Alasan desain: Validasi berlapis menjaga data wajib, panjang username/password, kecocokan konfirmasi, dan keunikan username/NIS. Transaksi menjaga agar akun user dan baris profil siswa tidak tertinggal sebagian bila salah satu insert gagal.
     */

    public function register() {
        // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
        if (isset($_SESSION['id_user'])) redirect('dashboard');

        $error = '';
        $old = ['username'=>'', 'nis'=>'', 'nama_siswa'=>'', 'kelas'=>''];

        // Memastikan blok pemrosesan hanya berjalan untuk metode HTTP yang diharapkan; membuka form GET tidak dianggap sebagai pengiriman data.
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            $old['username'] = trim((isset($_POST['username']) ? $_POST['username'] : ''));
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            $old['nis'] = trim((isset($_POST['nis']) ? $_POST['nis'] : ''));
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            $old['nama_siswa'] = trim((isset($_POST['nama_siswa']) ? $_POST['nama_siswa'] : ''));
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            $old['kelas'] = trim((isset($_POST['kelas']) ? $_POST['kelas'] : ''));
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            $password = (isset($_POST['password']) ? $_POST['password'] : '');
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            $confirm = (isset($_POST['konfirmasi']) ? $_POST['konfirmasi'] : '');

            // Pencocokan strict (`true`) mencegah perbedaan tipe dianggap sama; whitelist membatasi input ke opsi yang diketahui aplikasi.
            if (in_array('', $old, true) || $password === '') {
                $error = 'Semua kolom wajib diisi.';
            // Validasi panjang di server memastikan aturan minimum tetap berlaku walaupun request dikirim tanpa melalui form browser.
            } elseif (strlen($old['username']) < 4) {
                $error = 'Username minimal 4 karakter.';
            // Validasi panjang di server memastikan aturan minimum tetap berlaku walaupun request dikirim tanpa melalui form browser.
            } elseif (strlen($password) < 6) {
                $error = 'Password minimal 6 karakter.';
            // Konfirmasi harus sama dengan password yang akan disimpan, untuk menangkap salah ketik saat pengguna mendaftar.
            } elseif ($password !== $confirm) {
                $error = 'Konfirmasi password tidak sama.';
            // Pengecekan keunikan di server mencegah dua akun memakai identitas yang sama; constraint database tetap penting sebagai perlindungan terakhir.
            } elseif ($this->users->existsUsername($old['username'])) {
                $error = 'Username sudah digunakan.';
            // Pengecekan keunikan di server mencegah dua akun memakai identitas yang sama; constraint database tetap penting sebagai perlindungan terakhir.
            } elseif ($this->siswa->existsNis($old['nis'])) {
                $error = 'NIS sudah digunakan.';
            } else {
                try {
                    // Mulai transaksi agar beberapa query yang saling bergantung bisa dianggap satu operasi; jika ada yang gagal, semuanya bisa di-rollback.
                    // Pembuatan users dan siswa harus konsisten: jangan sampai akun dapat login tanpa profil siswa, atau sebaliknya.
                    $this->db->beginTransaction();
                    $idUser = $this->users->create($old['username'], $password, 'siswa');
                    $this->siswa->create($idUser, $old['nis'], $old['nama_siswa'], $old['kelas']);
                    // Commit memastikan seluruh perubahan dalam transaksi disimpan setelah semua langkah berhasil.
                    $this->db->commit();
                    // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
                    flash('success', 'Akun berhasil dibuat. Silakan login.');
                    // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
                    redirect('login');
                // Tangani kegagalan agar proses berhenti dengan pesan yang sesuai; bila perubahan database sudah berada dalam transaksi, controller dapat melakukan rollback.
                } catch (Exception $e) {
                    // Rollback membatalkan perubahan yang belum di-commit agar database tidak tertinggal dalam keadaan setengah jadi.
                    if ($this->db->inTransaction()) $this->db->rollBack();
                    $error = 'Registrasi gagal: ' . $e->getMessage();
                }
            }
        }

        // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
        view('auth/register', ['error'=>$error, 'old'=>$old]);
    }

    /**
     * Menghapus data session dan cookie session saat pengguna keluar.
     * @return void Mengakhiri session lalu mengarahkan browser ke login.
     * Alasan desain: Mengosongkan session, menghapus cookie session bila memakai cookie, dan memanggil session_destroy membantu menutup sesi pengguna pada browser tersebut.
     */

    public function logout() {
        // Kosongkan data session di memori sebelum menghancurkan session di server.
        $_SESSION = [];

        if (ini_get('session.use_cookies')) {
            $params = session_get_cookie_params();
            // Kedaluwarsakan cookie session pada browser agar browser tidak terus mengirim ID sesi yang sudah logout.
            setcookie(session_name(), '', time() - 42000, $params['path'], $params['domain'], $params['secure'], $params['httponly']);
        }

        // Hapus data session di sisi server; ini melengkapi pengosongan array dan penghapusan cookie.
        session_destroy();
        // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
        redirect('login');
    }
}

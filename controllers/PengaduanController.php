<?php


/**
 * FILE: controllers/PengaduanController.php
 * FUNGSI: Menangani daftar, detail, status, pengiriman, histori, dan feedback pengaduan.
 * ALUR KERJA: Memastikan role sesuai, memvalidasi ID/status/isi form, mengatur transaksi ketika status dan progres perlu konsisten, lalu memakai model untuk baca/tulis data.
 * INPUT / OUTPUT: Input: GET/POST dan session pengguna. Output: view, data database, flash message, atau redirect.
 * FILE/TABEL TERKAIT: index.php, helpers.php, models/PengaduanModel.php, models/ProgresModel.php, models/FeedbackModel.php, template admin, template siswa
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
class PengaduanController
{
    private $db;
    private $pengaduan;
    private $progres;
    private $feedback;

    /**
     * Menyiapkan model pengaduan, progres, dan feedback dengan koneksi yang sama.
     * @param PDO $db Koneksi database aktif.
     * @return void Tidak ada nilai kembalian.
     * Alasan desain: Ketiga model menangani tabel yang saling berkaitan dalam alur laporan dan tetap dapat ikut transaksi dari koneksi PDO yang sama.
     */

    public function __construct($db)
    {
        $this->db = $db;
        $this->pengaduan = new PengaduanModel($db);
        $this->progres = new ProgresModel($db);
        $this->feedback = new FeedbackModel($db);
    }

    /**
     * Menampilkan daftar pengaduan bagi admin, dengan filter status opsional.
     * @return void Mengirim list dan status filter ke view admin/pengaduan.
     * Alasan desain: requireLogin admin mencegah siswa membaca halaman pengelolaan. Daftar status allowlist memastikan filter yang diteruskan hanya status yang dikenali aplikasi.
     */

    public function adminIndex() {
        // Guard server-side: pastikan hanya admin yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('admin');
        $allowed = ['Diajukan','Diproses','Selesai','Ditolak'];
        // Parameter URL berasal dari klien sehingga diperiksa keberadaannya dan kemudian dinormalisasi/validasi sebelum dipakai.
        $status = (isset($_GET['status']) ? $_GET['status'] : '');
        // Pencocokan strict (`true`) mencegah perbedaan tipe dianggap sama; whitelist membatasi input ke opsi yang diketahui aplikasi.
        if (!in_array($status, $allowed, true)) $status = '';

        // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
        view('admin/pengaduan', [
            'list' => $this->pengaduan->findAll($status),
            'status' => $status
        ]);
    }

    /**
     * Mengambil detail satu pengaduan, progres, dan feedback untuk admin.
     * @return void Menampilkan view admin/detail atau redirect jika ID/data tidak valid.
     * Alasan desain: ID dari URL dikonversi menjadi integer lalu diperiksa. Mengecek record dulu mencegah view mengakses indeks data yang tidak tersedia.
     */

    public function adminDetail() {
        // Guard server-side: pastikan hanya admin yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('admin');
        // Parameter URL berasal dari klien sehingga diperiksa keberadaannya dan kemudian dinormalisasi/validasi sebelum dipakai.
        $id = (int) ((isset($_GET['id']) ? $_GET['id'] : 0));
        // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
        if ($id <= 0) redirect('admin-pengaduan');

        // Data dicari ulang di database; jangan hanya mengandalkan ID yang dikirim browser karena record bisa tidak ada atau bukan milik pengguna.
        $data = $this->pengaduan->findById($id);
        if (!$data) {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Pengaduan tidak ditemukan.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('admin-pengaduan');
        }

        // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
        view('admin/detail', [
            'pengaduan' => $data,
            'progres' => $this->progres->findByPengaduan($id),
            'feedbacks' => $this->feedback->listByPengaduan($id)
        ]);
    }

    /**
     * Memvalidasi perubahan status dan mencatat progres barunya secara atomik.
     * @return void Menyimpan status dan progres atau memberi notifikasi gagal, kemudian redirect ke detail.
     * Alasan desain: Role admin serta whitelist status menjaga operasi administratif. Transaksi membuat perubahan status dan penambahan riwayat progres berhasil bersama-sama atau dibatalkan bersama-sama.
     */

    public function updateStatus() {
        // Guard server-side: pastikan hanya admin yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('admin');
        // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
        $id = (int) ((isset($_POST['id_pengaduan']) ? $_POST['id_pengaduan'] : 0));
        // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
        $status = (isset($_POST['status']) ? $_POST['status'] : '');
        // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
        $keterangan = trim((isset($_POST['keterangan']) ? $_POST['keterangan'] : ''));
        $allowed = ['Diajukan','Diproses','Selesai','Ditolak'];

        // Pencocokan strict (`true`) mencegah perbedaan tipe dianggap sama; whitelist membatasi input ke opsi yang diketahui aplikasi.
        if ($id <= 0 || !in_array($status, $allowed, true)) {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Data status tidak valid.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('admin-pengaduan');
        }

        if (!$this->pengaduan->findById($id)) {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Pengaduan tidak ditemukan.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('admin-pengaduan');
        }

        try {
            // Mulai transaksi agar beberapa query yang saling bergantung bisa dianggap satu operasi; jika ada yang gagal, semuanya bisa di-rollback.
            $this->db->beginTransaction();
            $this->pengaduan->updateStatus($id, $status);
            // Status saat ini dan jejak riwayat disimpan bersama sehingga halaman detail menampilkan status yang sama dengan progres terakhir.
            $this->progres->create($id, $status, $keterangan !== '' ? $keterangan : null);
            // Commit memastikan seluruh perubahan dalam transaksi disimpan setelah semua langkah berhasil.
            $this->db->commit();
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('success', 'Status pengaduan berhasil diperbarui.');
        // Tangani kegagalan agar proses berhenti dengan pesan yang sesuai; bila perubahan database sudah berada dalam transaksi, controller dapat melakukan rollback.
        } catch (Exception $e) {
            // Rollback membatalkan perubahan yang belum di-commit agar database tidak tertinggal dalam keadaan setengah jadi.
            if ($this->db->inTransaction()) $this->db->rollBack();
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Gagal memperbarui status: ' . $e->getMessage());
        }

        // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
        redirect('admin-detail', ['id' => $id]);
    }

    /**
     * Menampilkan form kosong untuk membuat laporan baru.
     * @return void Memanggil view siswa/kirim dengan nilai awal kosong.
     * Alasan desain: Akses dibatasi untuk role siswa dan nilai awal membuat template tidak perlu menebak apakah variabel telah tersedia.
     */

    public function formCreate() {
        // Guard server-side: pastikan hanya siswa yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('siswa');
        // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
        view('siswa/kirim', ['error'=>'', 'old'=>['judul_pengaduan'=>'','isi_pengaduan'=>'']]);
    }

    /**
     * Memvalidasi dan menyimpan pengaduan baru beserta progres awalnya.
     * @return void Menampilkan ulang form dengan error atau redirect ke detail laporan yang baru dibuat.
     * Alasan desain: Validasi server diperlukan karena batas HTML dapat dilewati. Transaksi menyatukan insert pengaduan dan progres awal supaya histori tidak kehilangan langkah pertama.
     */

    public function store() {
        // Guard server-side: pastikan hanya siswa yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('siswa');
        $old = [
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            'judul_pengaduan' => trim((isset($_POST['judul_pengaduan']) ? $_POST['judul_pengaduan'] : '')),
            // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
            'isi_pengaduan' => trim((isset($_POST['isi_pengaduan']) ? $_POST['isi_pengaduan'] : ''))
        ];
        $error = '';

        // Validasi server menolak nilai kosong sebelum operasi database; atribut required di HTML hanya bantuan UX dan bukan pengganti validasi ini.
        if ($old['judul_pengaduan'] === '' || $old['isi_pengaduan'] === '') {
            $error = 'Judul dan isi pengaduan wajib diisi.';
        // Pemeriksaan panjang memakai jumlah karakter UTF-8. Pada input form, batas ini tetap ditegakkan di server karena batas HTML bisa dilewati.
        } elseif (textLength($old['judul_pengaduan']) > 150) {
            $error = 'Judul maksimal 150 karakter.';
        }

        if ($error !== '') {
            // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
            view('siswa/kirim', ['error'=>$error, 'old'=>$old]);
            return;
        }

        try {
            // Mulai transaksi agar beberapa query yang saling bergantung bisa dianggap satu operasi; jika ada yang gagal, semuanya bisa di-rollback.
            $this->db->beginTransaction();
            // ID siswa diambil dari session, bukan dipercaya dari form/URL, sehingga operasi dapat dibatasi pada pemilik akun aktif.
            $id = $this->pengaduan->create((int) $_SESSION['id_siswa'], $old['judul_pengaduan'], $old['isi_pengaduan']);
            // Catatan awal membuat timeline tidak kosong begitu pengaduan berhasil dibuat.
            $this->progres->create($id, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.');
            // Commit memastikan seluruh perubahan dalam transaksi disimpan setelah semua langkah berhasil.
            $this->db->commit();
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('success', 'Pengaduan berhasil dikirim.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('siswa-detail', ['id'=>$id]);
        // Tangani kegagalan agar proses berhenti dengan pesan yang sesuai; bila perubahan database sudah berada dalam transaksi, controller dapat melakukan rollback.
        } catch (Exception $e) {
            // Rollback membatalkan perubahan yang belum di-commit agar database tidak tertinggal dalam keadaan setengah jadi.
            if ($this->db->inTransaction()) $this->db->rollBack();
            // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
            view('siswa/kirim', ['error'=>'Pengaduan gagal disimpan: ' . $e->getMessage(), 'old'=>$old]);
        }
    }

    /**
     * Menampilkan seluruh pengaduan milik siswa yang sedang login.
     * @return void Mengirim hasil model ke view histori siswa.
     * Alasan desain: ID pemilik diambil dari session, bukan dari form/URL, untuk menjaga batas kepemilikan data.
     */

    public function history() {
        // Guard server-side: pastikan hanya siswa yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('siswa');
        // ID siswa diambil dari session, bukan dipercaya dari form/URL, sehingga operasi dapat dibatasi pada pemilik akun aktif.
        view('siswa/histori', ['histori'=>$this->pengaduan->findBySiswa((int) $_SESSION['id_siswa'])]);
    }

    /**
     * Menampilkan detail pengaduan hanya kepada siswa pemiliknya.
     * @return void Membuka view detail siswa atau redirect jika data tidak tersedia/tidak dimiliki akun aktif.
     * Alasan desain: Memeriksa ID pemilik dari hasil database mencegah IDOR, yaitu mencoba mengganti ID URL untuk melihat pengaduan siswa lain.
     */

    public function siswaDetail() {
        // Guard server-side: pastikan hanya siswa yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('siswa');
        // Parameter URL berasal dari klien sehingga diperiksa keberadaannya dan kemudian dinormalisasi/validasi sebelum dipakai.
        $id = (int) ((isset($_GET['id']) ? $_GET['id'] : 0));
        // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
        if ($id <= 0) redirect('histori');

        // Data dicari ulang di database; jangan hanya mengandalkan ID yang dikirim browser karena record bisa tidak ada atau bukan milik pengguna.
        $data = $this->pengaduan->findById($id);
        // ID siswa diambil dari session, bukan dipercaya dari form/URL, sehingga operasi dapat dibatasi pada pemilik akun aktif.
        if (!$data || (int)$data['id_siswa'] !== (int)$_SESSION['id_siswa']) {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Pengaduan tidak ditemukan.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('histori');
        }

        // Controller meneruskan data yang sudah diolah ke view; template bertugas menampilkan, bukan menjalankan query database.
        view('siswa/detail', [
            'pengaduan' => $data,
            'progres' => $this->progres->findByPengaduan($id),
            'feedbacks' => $this->feedback->listByPengaduan($id)
        ]);
    }

    /**
     * Menyimpan feedback siswa setelah pengaduan selesai.
     * @return void Menampilkan flash message dan kembali ke detail pengaduan.
     * Alasan desain: Pemeriksaan pemilik, status selesai, isi, panjang, dan duplikasi dilakukan di server agar aturan bisnis tidak hanya bergantung pada tampilan form.
     */

    public function saveFeedback() {
        // Guard server-side: pastikan hanya siswa yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('siswa');
        // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
        $id = (int) ((isset($_POST['id_pengaduan']) ? $_POST['id_pengaduan'] : 0));
        // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
        $isi = trim((isset($_POST['isi_feedback']) ? $_POST['isi_feedback'] : ''));
        // Data dicari ulang di database; jangan hanya mengandalkan ID yang dikirim browser karena record bisa tidak ada atau bukan milik pengguna.
        $data = $this->pengaduan->findById($id);

        // ID siswa diambil dari session, bukan dipercaya dari form/URL, sehingga operasi dapat dibatasi pada pemilik akun aktif.
        if (!$data || (int)$data['id_siswa'] !== (int)$_SESSION['id_siswa']) {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Pengaduan tidak ditemukan.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('histori');
        }
        // Aturan bisnis ini memaksa feedback siswa hanya diberikan setelah laporan selesai, walaupun request dikirim manual.
        // Form di view bisa disembunyikan, tetapi aturan penting ini tetap ditegakkan di server.
        if ($data['status'] !== 'Selesai') {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Feedback hanya dapat diberikan setelah pengaduan selesai.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('siswa-detail', ['id'=>$id]);
        }
        if ($isi === '') {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Isi feedback wajib diisi.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('siswa-detail', ['id'=>$id]);
        }
        // Pemeriksaan panjang memakai jumlah karakter UTF-8. Pada input form, batas ini tetap ditegakkan di server karena batas HTML bisa dilewati.
        if (textLength($isi) > 2000) {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Feedback maksimal 2000 karakter.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('siswa-detail', ['id'=>$id]);
        }
        // Cek duplikasi di sisi server mencegah feedback siswa dikirim berulang melalui request terpisah.
        if ($this->feedback->exists($id, 'siswa')) {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Feedback untuk pengaduan ini sudah pernah diberikan.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('siswa-detail', ['id'=>$id]);
        }

        try {
            $this->feedback->create($id, $isi, 'siswa');
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('success', 'Terima kasih, feedback berhasil disimpan.');
        // Tangani kegagalan agar proses berhenti dengan pesan yang sesuai; bila perubahan database sudah berada dalam transaksi, controller dapat melakukan rollback.
        } catch (Exception $e) {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Feedback gagal disimpan: ' . $e->getMessage());
        }

        // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
        redirect('siswa-detail', ['id'=>$id]);
    }

    /**
     * Menyimpan tanggapan admin pada pengaduan tertentu.
     * @return void Menampilkan flash message dan kembali ke detail admin.
     * Alasan desain: Akses dibatasi bagi admin; ID harus menunjuk record yang benar dan isi feedback divalidasi sebelum insert.
     */

    public function saveAdminFeedback() {
        // Guard server-side: pastikan hanya admin yang dapat menjalankan action ini; menyembunyikan menu saja tidak cukup karena URL bisa dipanggil langsung.
        requireLogin('admin');
        // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
        $id = (int) ((isset($_POST['id_pengaduan']) ? $_POST['id_pengaduan'] : 0));
        // Ambil nilai form hanya jika key tersedia agar akses input kosong tidak memunculkan undefined index; validasi berikutnya tetap dilakukan di server.
        $isi = trim((isset($_POST['isi_feedback']) ? $_POST['isi_feedback'] : ''));
        // ID dikonversi ke integer dan diperiksa batasnya agar nilai kosong/tidak masuk akal tidak dipakai sebagai target query.
        $data = $id > 0 ? $this->pengaduan->findById($id) : null;

        if (!$data) {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Pengaduan tidak ditemukan.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('admin-pengaduan');
        }
        if ($isi === '') {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Isi umpan balik wajib diisi.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('admin-detail', ['id'=>$id]);
        }
        // Pemeriksaan panjang memakai jumlah karakter UTF-8. Pada input form, batas ini tetap ditegakkan di server karena batas HTML bisa dilewati.
        if (textLength($isi) > 2000) {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Umpan balik maksimal 2000 karakter.');
            // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
            redirect('admin-detail', ['id'=>$id]);
        }

        try {
            $this->feedback->create($id, $isi, 'admin');
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('success', 'Umpan balik berhasil dikirim ke siswa.');
        // Tangani kegagalan agar proses berhenti dengan pesan yang sesuai; bila perubahan database sudah berada dalam transaksi, controller dapat melakukan rollback.
        } catch (Exception $e) {
            // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
            flash('danger', 'Umpan balik gagal disimpan: ' . $e->getMessage());
        }

        // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
        redirect('admin-detail', ['id'=>$id]);
    }
}

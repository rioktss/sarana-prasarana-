<?php


/**
 * FILE: helpers.php
 * FUNGSI: Kumpulan fungsi bantuan umum yang dipakai controller dan view.
 * ALUR KERJA: Menyediakan redirect, escaping HTML, pengukuran teks, potongan teks, penyesuaian skema feedback, format tanggal, ikon, badge status, flash message, pengecekan login, dan pemanggilan view.
 * INPUT / OUTPUT: Input: nilai dari controller/session/database. Output: teks aman untuk HTML, response redirect, status akses, atau template view.
 * FILE/TABEL TERKAIT: index.php, seluruh file controller, models/FeedbackModel.php, seluruh template di folder views, assets/app.js
 * CATATAN PEMBELAJARAN: komentar ini menjelaskan kode yang ada; perilaku program sengaja dipertahankan.
 */
/**
 * Mengarahkan browser ke route SIPAS dan mengakhiri request saat ini.
 * @param string $page Nama route yang akan ditangani parameter `page` di index.php.
 * @param array $params Parameter tambahan yang akan ditambahkan ke query string; default berupa array kosong.
 * @return void Fungsi menjalankan `exit`, sehingga eksekusi request berhenti setelah redirect.
 * Alasan desain: http_build_query mengubah array menjadi query string dengan encoding yang tepat. exit mencegah controller meneruskan proses setelah mengirim header Location.
 */
function redirect($page, $params = []) {
    $query = array_merge(['page' => $page], $params);
    // Mengirim header HTTP Location untuk meminta browser membuka URL tujuan; harus dilakukan sebelum output HTML.
    header('Location: index.php?' . http_build_query($query));
    exit;
}

/**
 * Mengubah nilai dinamis menjadi teks aman untuk konteks HTML.
 * @param mixed $value Nilai dari database, session, atau input yang hendak ditampilkan.
 * @return string Teks yang telah di-escape untuk HTML.
 * Alasan desain: htmlspecialchars menetralkan karakter seperti <, >, tanda kutip, dan ampersand sehingga teks tidak ditafsirkan sebagai tag atau atribut HTML. ENT_QUOTES mencakup dua jenis kutip, ENT_SUBSTITUTE menangani byte UTF-8 tidak valid, dan UTF-8 disetel eksplisit. Ini membantu mencegah XSS ketika hasilnya dipakai pada HTML; tetap gunakan sesuai konteks output.
 */

function e($value) {
    // Escape karakter khusus HTML sebelum ditampilkan untuk mencegah teks dinamis dibaca browser sebagai markup/script (mitigasi XSS).
    return htmlspecialchars((string) $value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

/**
 * Menghitung panjang teks dengan memperhatikan karakter UTF-8.
 * @param string $text Teks yang akan dihitung.
 * @return int Jumlah karakter, bukan semata jumlah byte, jika dukungan yang tersedia memungkinkan.
 * Alasan desain: mb_strlen lebih sesuai untuk huruf beraksen/karakter multibyte. Fallback regex mencoba menghitung karakter Unicode, kemudian strlen menjadi pilihan terakhir agar fungsi tetap tersedia pada server tanpa ekstensi mbstring.
 */

function textLength($text) {
    $text = (string) $text;
    if (function_exists('mb_strlen')) return mb_strlen($text, 'UTF-8');
    $n = preg_match_all('/./us', $text, $m);
    return $n === false ? strlen($text) : $n;
}

/**
 * Memotong teks untuk ringkasan dengan akhiran elipsis.
 * @param string $text Teks asal.
 * @param int $length Panjang ringkasan yang diinginkan.
 * @return string Teks utuh atau potongan teks yang diakhiri `...`.
 * Alasan desain: Pemeriksaan panjang lebih dulu mencegah teks pendek dipotong sia-sia. mb_substr/regex dipilih untuk sebisa mungkin tidak memotong karakter UTF-8 di tengah byte.
 */

function excerpt($text, $length) {
    $text = (string) $text;
    $length = (int) $length;
    // Pemeriksaan panjang memakai jumlah karakter UTF-8. Pada input form, batas ini tetap ditegakkan di server karena batas HTML bisa dilewati.
    if (textLength($text) <= $length) return $text;

    if (function_exists('mb_substr')) {
        return mb_substr($text, 0, $length, 'UTF-8') . '...';
    }

    if (preg_match('/^.{0,' . $length . '}/us', $text, $m)) {
        return $m[0] . '...';
    }

    return substr($text, 0, $length) . '...';
}

/**
 * Memastikan kolom dan indeks yang dibutuhkan fitur feedback tersedia.
 * @param PDO $db Koneksi database aktif yang berasal dari Database::getConnection().
 * @return void Tidak mengembalikan nilai; menandai sesi bila pengecekan berhasil.
 * Alasan desain: Pengecekan kolom/indeks membuat project lama dapat menyesuaikan skema yang diharapkan. Penanda session menghindari pemeriksaan DDL berulang pada setiap halaman dalam sesi yang sama. Ini adalah penyesuaian skema saat runtime; pada produksi, migrasi terencana biasanya lebih mudah diaudit.
 */

function ensureFeedbackSchema($db) {
    // Data session digunakan untuk menjaga konteks login/pengguna antarrekuest HTTP.
    if (!empty($_SESSION['schema_feedback_ok'])) return;

    try {
        // SQL: SHOW COLUMNS memeriksa apakah kolom `pemberi` telah tersedia sebelum migrasi dijalankan, supaya ALTER TABLE tidak dilakukan tanpa kebutuhan.
        $cols = $db->query("SHOW COLUMNS FROM umpan_balik LIKE 'pemberi'")->fetchAll();

        if (empty($cols)) {
            // SQL: ALTER TABLE menambahkan jenis pihak pemberi agar feedback admin dan siswa dapat dibedakan. Default `siswa` mempertahankan kompatibilitas record lama; perubahan skema semacam ini sebaiknya dikelola dengan migrasi terencana saat deployment.
            $db->exec("ALTER TABLE umpan_balik ADD COLUMN pemberi ENUM('admin','siswa') NOT NULL DEFAULT 'siswa' AFTER id_pengaduan");

            // SQL: SHOW INDEX memeriksa apakah indeks berdasarkan id_pengaduan sudah tersedia sehingga indeks tidak ditambahkan berulang kali.
            $idx = $db->query("SHOW INDEX FROM umpan_balik WHERE Key_name = 'idx_feedback_pengaduan'")->fetchAll();
            if (empty($idx)) {
                // SQL: Indeks pada id_pengaduan membantu query feedback yang sering memfilter berdasarkan satu pengaduan; indeks bukan pengganti WHERE, tetapi dapat mempercepat pencarian.
                $db->exec('ALTER TABLE umpan_balik ADD INDEX idx_feedback_pengaduan (id_pengaduan)');
            }

            // SQL: SHOW INDEX mencari indeks unik lama yang membatasi satu baris feedback per pengaduan tanpa membedakan pemberi.
            $uq = $db->query("SHOW INDEX FROM umpan_balik WHERE Key_name = 'uq_feedback_pengaduan'")->fetchAll();
            if (!empty($uq)) {
                // SQL: Indeks unik lama dilepas agar skema yang diharapkan dapat menampung feedback dari jenis pemberi yang berbeda. Efek perubahan skema dipertahankan apa adanya sesuai kode project.
                $db->exec('ALTER TABLE umpan_balik DROP INDEX uq_feedback_pengaduan');
            }
        }

        // Data session digunakan untuk menjaga konteks login/pengguna antarrekuest HTTP.
        $_SESSION['schema_feedback_ok'] = true;
    // Tangani kegagalan agar proses berhenti dengan pesan yang sesuai; bila perubahan database sudah berada dalam transaksi, controller dapat melakukan rollback.
    } catch (Exception $e) {
        exit('Struktur database belum sesuai. Import database/pengaduan_sekolah.sql atau jalankan database/migrasi_umpan_balik_admin.sql, lalu muat ulang halaman. Detail: ' . $e->getMessage());
    }
}

/**
 * Mengubah nilai tanggal database menjadi tampilan tanggal berbahasa Indonesia.
 * @param string|null $tanggal Nilai tanggal/waktu dari database.
 * @return string Tanggal yang sudah diformat atau tanda `-` bila nilainya kosong.
 * Alasan desain: strtotime digunakan untuk membaca tanggal database dan daftar nama bulan lokal menghindari ketergantungan pada locale sistem. Nilai yang tidak dapat diparse dikembalikan lewat e() agar tetap aman saat ditampilkan.
 */

function formatTanggal($tanggal) {
    if (!$tanggal) return '-';

    $ts = strtotime($tanggal);
    if (!$ts) return e($tanggal);

    $bulan = [1=>'Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
    return date('d', $ts) . ' ' . $bulan[(int) date('n', $ts)] . ' ' . date('Y, H:i', $ts);
}

/**
 * Menghasilkan ikon SVG dari daftar ikon yang diizinkan aplikasi.
 * @param string $name Kunci nama ikon, misalnya `home` atau `report`.
 * @return string Markup SVG atau string kosong jika nama ikon tidak terdaftar.
 * Alasan desain: Pemetaan allowlist mencegah input nama ikon menyisipkan markup SVG sembarang; pemanggil hanya bisa memilih path yang sudah didefinisikan.
 */

function uiIcon($name) {
    $paths = [
        'menu' => '<path d="M4 6h16M4 12h16M4 18h16"/>',
        'home' => '<path d="m3 10 9-7 9 7v10a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1V10Z"/>',
        'report' => '<path d="M6 3h8l4 4v14H6a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2Z"/><path d="M14 3v5h5M8 12h7M8 16h6"/>',
        'users' => '<path d="M16 20v-1a4 4 0 0 0-4-4H7a4 4 0 0 0-4 4v1"/><circle cx="9.5" cy="7" r="3"/><path d="M17 11a3 3 0 0 0 0-6M21 20v-1a4 4 0 0 0-3-3.87"/>',
        'plus' => '<path d="M12 5v14M5 12h14"/>',
        'history' => '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2M3 12H1"/>',
        'logout' => '<path d="M10 17l5-5-5-5M15 12H3M14 4h4a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-4"/>',
        'moon' => '<path d="M20.5 14.3A8.5 8.5 0 0 1 9.7 3.5 8.5 8.5 0 1 0 20.5 14.3Z"/>',
        'sun' => '<circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41"/>',
        'eye' => '<path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12Z"/><circle cx="12" cy="12" r="2.5"/>',
        'eye-off' => '<path d="m3 3 18 18M10.6 6.2A10.6 10.6 0 0 1 12 6c6.5 0 10 6 10 6a17.6 17.6 0 0 1-4 3.9M6.7 6.7C3.7 8.5 2 12 2 12s3.5 6 10 6c1.2 0 2.3-.2 3.3-.5"/>',
        'arrow-left' => '<path d="m15 18-6-6 6-6M9 12h12"/>',
        'save' => '<path d="M5 4h11l3 3v13H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2Z"/><path d="M7 4v6h8V4M8 20v-6h7v6"/>',
        'trash' => '<path d="M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3"/>',
        'edit' => '<path d="m4 16-.8 4.8L8 20l11-11-4-4L4 16Z"/><path d="m13.5 6.5 4 4"/>',
        'send' => '<path d="m3 11 18-8-8 18-2.5-7.5L3 11Z"/><path d="m10.5 13.5 4-4"/>',
        'check' => '<path d="m5 12 4 4L19 6"/>',
        'alert' => '<path d="M10.3 4.4 2.8 18a2 2 0 0 0 1.7 3h15a2 2 0 0 0 1.7-3L13.7 4.4a2 2 0 0 0-3.4 0Z"/><path d="M12 9v4M12 17h.01"/>',
        'info' => '<circle cx="12" cy="12" r="9"/><path d="M12 10v6M12 7h.01"/>',
        'close' => '<path d="m6 6 12 12M18 6 6 18"/>',
        'clock' => '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
        'refresh' => '<path d="M20 11a8 8 0 0 0-14-4L3 10M4 4v6h6M4 13a8 8 0 0 0 14 4l3-3M20 20v-6h-6"/>',
    ];

    // Ikon hanya boleh berasal dari daftar yang ditentukan; nama tak dikenal tidak menghasilkan SVG dari input pengguna.
    if (!isset($paths[$name])) return '';

    return '<svg class="icon" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' . $paths[$name] . '</svg>';
}

/**
 * Membuat label status dengan kelas CSS yang sesuai.
 * @param string $status Status pengaduan yang akan ditampilkan.
 * @return string Markup span badge yang berisi status.
 * Alasan desain: Pemetaan status membuat warna konsisten. e() tetap digunakan pada kelas dan teks status karena keduanya ikut disisipkan ke HTML; status tidak dianggap aman hanya karena berasal dari database.
 */

function statusBadge($status) {
    $map = [
        'Diajukan' => 'badge-info',
        'Diproses' => 'badge-warning',
        'Selesai' => 'badge-success',
        'Ditolak' => 'badge-danger',
    ];

    // Status tak dikenal tetap diberi kelas netral, bukan membuat class CSS berdasarkan teks input bebas.
    $class = isset($map[$status]) ? $map[$status] : 'badge-muted';
    return '<span class="badge ' . e($class) . '" role="status"><span class="badge-dot" aria-hidden="true"></span>' . e($status) . '</span>';
}

/**
 * Menyimpan atau mengambil notifikasi singkat antarpindah halaman.
 * @param string|null $type Jenis notifikasi saat menyimpan, misalnya success/danger; null berarti mengambil.
 * @param string|null $message Isi pesan notifikasi ketika mode simpan.
 * @return array|null Data flash berisi type/message atau null jika tidak ada.
 * Alasan desain: Session dipakai karena redirect membuat request HTTP baru. Saat dibaca, pesan langsung dihapus agar hanya tampil satu kali dan tidak terus berulang ketika halaman dimuat ulang.
 */

function flash($type = null, $message = null)
{
    if ($type !== null) {
        // Flash disimpan di session karena redirect menghasilkan request baru; data ini bersifat sementara dan ditampilkan satu kali.
        $_SESSION['flash'] = ['type' => $type, 'message' => $message];
        return;
    }

    // Flash disimpan di session karena redirect menghasilkan request baru; data ini bersifat sementara dan ditampilkan satu kali.
    if (!isset($_SESSION['flash'])) return null;

    // Flash disimpan di session karena redirect menghasilkan request baru; data ini bersifat sementara dan ditampilkan satu kali.
    $data = $_SESSION['flash'];
    // Flash disimpan di session karena redirect menghasilkan request baru; data ini bersifat sementara dan ditampilkan satu kali.
    unset($_SESSION['flash']);
    return $data;
}

/**
 * Menjaga route agar hanya diakses sesi login dan role yang diizinkan.
 * @param string|null $role Role yang diperlukan, misalnya admin atau siswa; null hanya memerlukan login.
 * @return void Tidak mengembalikan nilai; pengguna yang tidak memenuhi syarat diarahkan ke halaman lain.
 * Alasan desain: Pemeriksaan dilakukan di server, bukan hanya menyembunyikan menu di browser, karena URL dapat diketik langsung. Pemeriksaan role mencegah akun login biasa menjalankan aksi khusus admin.
 */

function requireLogin($role = null) {
    // Session menyimpan ID akun yang telah terautentikasi untuk mengenali pengguna pada request berikutnya.
    if (!isset($_SESSION['id_user'])) {
        // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
        flash('danger', 'Silakan login terlebih dahulu.');
        // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
        redirect('login');
    }

    // Role disimpan pada session agar controller/layout dapat menerapkan akses dan navigasi yang sesuai.
    if ($role !== null && (isset($_SESSION['role']) ? $_SESSION['role'] : '') !== $role) {
        // Pesan flash disimpan di session agar tetap tersedia setelah redirect, lalu ditampilkan sekali oleh layout/header.php.
        flash('danger', 'Anda tidak memiliki akses ke halaman tersebut.');
        // Alihkan pengguna ke route yang sesuai setelah kondisi ditangani; helper redirect juga memanggil exit agar proses tidak berlanjut.
        redirect('dashboard');
    }
}

/**
 * Memuat file template dan menyediakan variabel data untuk template tersebut.
 * @param string $file Nama view relatif di dalam folder views tanpa ekstensi `.php`.
 * @param array $data Data yang diekstrak menjadi variabel lokal template; default array kosong.
 * @return void Mengeluarkan HTML dari file view yang dipanggil.
 * Alasan desain: extract membuat elemen data dapat dipakai sebagai variabel sederhana dalam template, sedangkan __DIR__ membuat path relatif tidak bergantung pada working directory saat PHP dijalankan. Nama view perlu berasal dari kode tepercaya, bukan input route mentah.
 */

function view($file, $data = []) {
    // Array data diubah menjadi variabel lokal agar nama field bisa dibaca template. Karena extract membuat variabel, nama view dan key data harus berasal dari alur kode tepercaya.
    extract($data);
    require __DIR__ . '/views/' . $file . '.php';
}

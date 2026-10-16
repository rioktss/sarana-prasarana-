<?php

function redirect($page, $params = []) {
    $query = array_merge(['page' => $page], $params);
    header('Location: index.php?' . http_build_query($query));
    exit;
}

function e($value) {
    return htmlspecialchars((string) $value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function textLength($text) {
    $text = (string) $text;
    if (function_exists('mb_strlen')) return mb_strlen($text, 'UTF-8');
    $n = preg_match_all('/./us', $text, $m);
    return $n === false ? strlen($text) : $n;
}

function excerpt($text, $length) {
    $text = (string) $text;
    $length = (int) $length;
    if (textLength($text) <= $length) return $text;

    if (function_exists('mb_substr')) {
        return mb_substr($text, 0, $length, 'UTF-8') . '...';
    }

    if (preg_match('/^.{0,' . $length . '}/us', $text, $m)) {
        return $m[0] . '...';
    }

    return substr($text, 0, $length) . '...';
}

function ensureFeedbackSchema($db) {
    if (!empty($_SESSION['schema_feedback_ok'])) return;

    try {
        $cols = $db->query("SHOW COLUMNS FROM umpan_balik LIKE 'pemberi'")->fetchAll();

        if (empty($cols)) {
            $db->exec("ALTER TABLE umpan_balik ADD COLUMN pemberi ENUM('admin','siswa') NOT NULL DEFAULT 'siswa' AFTER id_pengaduan");

            $idx = $db->query("SHOW INDEX FROM umpan_balik WHERE Key_name = 'idx_feedback_pengaduan'")->fetchAll();
            if (empty($idx)) {
                $db->exec('ALTER TABLE umpan_balik ADD INDEX idx_feedback_pengaduan (id_pengaduan)');
            }

            $uq = $db->query("SHOW INDEX FROM umpan_balik WHERE Key_name = 'uq_feedback_pengaduan'")->fetchAll();
            if (!empty($uq)) {
                $db->exec('ALTER TABLE umpan_balik DROP INDEX uq_feedback_pengaduan');
            }
        }

        $_SESSION['schema_feedback_ok'] = true;
    } catch (Exception $e) {
        exit('Struktur database belum sesuai. Import database/pengaduan_sekolah.sql atau jalankan database/migrasi_umpan_balik_admin.sql, lalu muat ulang halaman. Detail: ' . $e->getMessage());
    }
}

function formatTanggal($tanggal) {
    if (!$tanggal) return '-';

    $ts = strtotime($tanggal);
    if (!$ts) return e($tanggal);

    $bulan = [1=>'Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
    return date('d', $ts) . ' ' . $bulan[(int) date('n', $ts)] . ' ' . date('Y, H:i', $ts);
}

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

    if (!isset($paths[$name])) return '';

    return '<svg class="icon" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' . $paths[$name] . '</svg>';
}

function statusBadge($status) {
    $map = [
        'Diajukan' => 'badge-info',
        'Diproses' => 'badge-warning',
        'Selesai' => 'badge-success',
        'Ditolak' => 'badge-danger',
    ];

    $class = isset($map[$status]) ? $map[$status] : 'badge-muted';
    return '<span class="badge ' . e($class) . '" role="status"><span class="badge-dot" aria-hidden="true"></span>' . e($status) . '</span>';
}

function flash($type = null, $message = null)
{
    if ($type !== null) {
        $_SESSION['flash'] = ['type' => $type, 'message' => $message];
        return;
    }

    if (!isset($_SESSION['flash'])) return null;

    $data = $_SESSION['flash'];
    unset($_SESSION['flash']);
    return $data;
}

function requireLogin($role = null) {
    if (!isset($_SESSION['id_user'])) {
        flash('danger', 'Silakan login terlebih dahulu.');
        redirect('login');
    }

    if ($role !== null && (isset($_SESSION['role']) ? $_SESSION['role'] : '') !== $role) {
        flash('danger', 'Anda tidak memiliki akses ke halaman tersebut.');
        redirect('dashboard');
    }
}

function view($file, $data = []) {
    extract($data);
    require __DIR__ . '/views/' . $file . '.php';
}

<?php

function redirect($page, $params = []) {
    $query = array_merge(['page' => $page], $params);
    header('Location: index.php?' . http_build_query($query));
    exit;
}

function e($value) {
    return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
}

function formatTanggal($tanggal) {
    if (!$tanggal) return '-';

    $ts = strtotime($tanggal);
    if (!$ts) return e($tanggal);

    $bulan = [1=>'Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
    return date('d', $ts) . ' ' . $bulan[(int) date('n', $ts)] . ' ' . date('Y, H:i', $ts);
}

function statusBadge($status) {
    $map = [
        'Diajukan' => 'badge-info',
        'Diproses' => 'badge-warning',
        'Selesai' => 'badge-success',
        'Ditolak' => 'badge-danger',
    ];

    $class = isset($map[$status]) ? $map[$status] : 'badge-muted';
    return '<span class="badge ' . e($class) . '">' . e($status) . '</span>';
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

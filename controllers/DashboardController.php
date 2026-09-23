<?php

class DashboardController
{
    private $db;
    private $pengaduan;
    private $siswa;

    public function __construct($db)
    {
        $this->db = $db;
        $this->pengaduan = new PengaduanModel($db);
        $this->siswa = new SiswaModel($db);
    }

    public function index()
    {
        requireLogin();
        if ((isset($_SESSION['role']) ? $_SESSION['role'] : '') === 'admin') {
            $this->admin();
        } else {
            $this->siswa();
        }
    }

    private function admin()
    {
        $stats = $this->pengaduan->countByStatus();
        view('admin/dashboard', [
            'stats' => $stats,
            'totalSiswa' => $this->siswa->countAll(),
            'terbaru' => $this->pengaduan->latest(5)
        ]);
    }

    private function siswa()
    {
        $histori = $this->pengaduan->findBySiswa($_SESSION['id_siswa']);
        $selesai = 0;
        $berjalan = 0;
        foreach ($histori as $item) {
            if ($item['status'] === 'Selesai') $selesai++;
            if ($item['status'] === 'Diajukan' || $item['status'] === 'Diproses') $berjalan++;
        }

        view('siswa/dashboard', [
            'total' => count($histori),
            'selesai' => $selesai,
            'berjalan' => $berjalan,
            'terbaru' => array_slice($histori, 0, 5)
        ]);
    }
}

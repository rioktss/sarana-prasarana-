<?php

class PengaduanModel
{
    private $db;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function create($idSiswa, $judul, $isi) {
        $stmt = $this->db->prepare('INSERT INTO pengaduan (id_siswa, judul_pengaduan, isi_pengaduan) VALUES (?, ?, ?)');
        $stmt->execute([$idSiswa, $judul, $isi]);
        return (int) $this->db->lastInsertId();
    }

    public function findById($id)
    {
        $stmt = $this->db->prepare('SELECT p.*, s.nis, s.nama_siswa, s.kelas FROM pengaduan p INNER JOIN siswa s ON s.id_siswa = p.id_siswa WHERE p.id_pengaduan = ? LIMIT 1');
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function findBySiswa($idSiswa) {
        $stmt = $this->db->prepare('SELECT p.* FROM pengaduan p WHERE p.id_siswa = ? ORDER BY p.tanggal_pengaduan DESC, p.id_pengaduan DESC');
        $stmt->execute([$idSiswa]);
        return $stmt->fetchAll();
    }

    public function findAll($status = '') {
        if ($status !== '') {
            $stmt = $this->db->prepare('SELECT p.*, s.nis, s.nama_siswa, s.kelas FROM pengaduan p INNER JOIN siswa s ON s.id_siswa = p.id_siswa WHERE p.status = ? ORDER BY p.tanggal_pengaduan DESC, p.id_pengaduan DESC');
            $stmt->execute([$status]);
            return $stmt->fetchAll();
        }

        $stmt = $this->db->query('SELECT p.*, s.nis, s.nama_siswa, s.kelas FROM pengaduan p INNER JOIN siswa s ON s.id_siswa = p.id_siswa ORDER BY p.tanggal_pengaduan DESC, p.id_pengaduan DESC');
        return $stmt->fetchAll();
    }

    public function countByStatus() {
        $rows = ['total' => 0, 'Diajukan' => 0, 'Diproses' => 0, 'Selesai' => 0, 'Ditolak' => 0];
        $stmt = $this->db->query('SELECT status, COUNT(*) AS total FROM pengaduan GROUP BY status');

        foreach ($stmt->fetchAll() as $row) {
            if (array_key_exists($row['status'], $rows)) {
                $rows[$row['status']] = (int) $row['total'];
                $rows['total'] += (int) $row['total'];
            }
        }

        return $rows;
    }

    public function latest($limit = 5) {
        $limit = max(1, min(20, $limit));
        $stmt = $this->db->prepare('SELECT p.*, s.nama_siswa, s.kelas FROM pengaduan p INNER JOIN siswa s ON s.id_siswa = p.id_siswa ORDER BY p.tanggal_pengaduan DESC, p.id_pengaduan DESC LIMIT :limit');
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function updateStatus($id, $status) {
        $stmt = $this->db->prepare('UPDATE pengaduan SET status = ? WHERE id_pengaduan = ?');
        $stmt->execute([$status, $id]);
    }
}

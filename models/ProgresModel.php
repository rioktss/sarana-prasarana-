<?php

class ProgresModel
{
    private $db;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function create($idPengaduan, $status, $keterangan = null) {
        $stmt = $this->db->prepare('INSERT INTO progres_pengaduan (id_pengaduan, status_progres, keterangan) VALUES (?, ?, ?)');
        $stmt->execute([$idPengaduan, $status, $keterangan]);
    }

    public function findByPengaduan($idPengaduan) {
        $stmt = $this->db->prepare('SELECT * FROM progres_pengaduan WHERE id_pengaduan = ? ORDER BY tanggal_progres ASC, id_progres ASC');
        $stmt->execute([$idPengaduan]);
        return $stmt->fetchAll();
    }
}

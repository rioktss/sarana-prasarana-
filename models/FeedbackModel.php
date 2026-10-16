<?php

class FeedbackModel
{
    private $db;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function listByPengaduan($idPengaduan)
    {
        $stmt = $this->db->prepare('SELECT * FROM umpan_balik WHERE id_pengaduan = ? ORDER BY tanggal_feedback ASC, id_feedback ASC');
        $stmt->execute([$idPengaduan]);
        return $stmt->fetchAll();
    }

    public function findByPengaduan($idPengaduan)
    {
        $stmt = $this->db->prepare('SELECT * FROM umpan_balik WHERE id_pengaduan = ? ORDER BY id_feedback DESC LIMIT 1');
        $stmt->execute([$idPengaduan]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function exists($idPengaduan, $pemberi = 'siswa') {
        $stmt = $this->db->prepare('SELECT id_feedback FROM umpan_balik WHERE id_pengaduan = ? AND pemberi = ? LIMIT 1');
        $stmt->execute([$idPengaduan, $pemberi]);
        return (bool) $stmt->fetchColumn();
    }

    public function create($idPengaduan, $isi, $pemberi = 'siswa') {
        $stmt = $this->db->prepare('INSERT INTO umpan_balik (id_pengaduan, pemberi, isi_feedback) VALUES (?, ?, ?)');
        $stmt->execute([$idPengaduan, $pemberi, $isi]);
    }
}

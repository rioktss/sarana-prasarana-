<?php

class FeedbackModel
{
    private $db;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function findByPengaduan($idPengaduan)
    {
        $stmt = $this->db->prepare('SELECT * FROM umpan_balik WHERE id_pengaduan = ? ORDER BY id_feedback DESC LIMIT 1');
        $stmt->execute([$idPengaduan]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function exists($idPengaduan) {
        $stmt = $this->db->prepare('SELECT id_feedback FROM umpan_balik WHERE id_pengaduan = ? LIMIT 1');
        $stmt->execute([$idPengaduan]);
        return (bool) $stmt->fetchColumn();
    }

    public function create($idPengaduan, $isi) {
        $stmt = $this->db->prepare('INSERT INTO umpan_balik (id_pengaduan, isi_feedback) VALUES (?, ?)');
        $stmt->execute([$idPengaduan, $isi]);
    }
}

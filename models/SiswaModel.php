<?php

class SiswaModel
{
    private $db;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function findByUserId($idUser)
    {
        $stmt = $this->db->prepare('SELECT * FROM siswa WHERE id_user = ? LIMIT 1');
        $stmt->execute([$idUser]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function findById($id)
    {
        $stmt = $this->db->prepare('SELECT s.*, u.username FROM siswa s INNER JOIN users u ON u.id_user = s.id_user WHERE s.id_siswa = ? LIMIT 1');
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function findAll() {
        $stmt = $this->db->query('SELECT s.*, u.username FROM siswa s INNER JOIN users u ON u.id_user = s.id_user ORDER BY s.id_siswa DESC');
        return $stmt->fetchAll();
    }

    public function existsNis($nis, $exceptId = null) {
        if ($exceptId === null) {
            $stmt = $this->db->prepare('SELECT id_siswa FROM siswa WHERE nis = ? LIMIT 1');
            $stmt->execute([$nis]);
        } else {
            $stmt = $this->db->prepare('SELECT id_siswa FROM siswa WHERE nis = ? AND id_siswa <> ? LIMIT 1');
            $stmt->execute([$nis, $exceptId]);
        }

        return (bool) $stmt->fetchColumn();
    }

    public function create($idUser, $nis, $nama, $kelas) {
        $stmt = $this->db->prepare('INSERT INTO siswa (id_user, nis, nama_siswa, kelas) VALUES (?, ?, ?, ?)');
        $stmt->execute([$idUser, $nis, $nama, $kelas]);
        return (int) $this->db->lastInsertId();
    }

    public function update($idSiswa, $nis, $nama, $kelas) {
        $stmt = $this->db->prepare('UPDATE siswa SET nis = ?, nama_siswa = ?, kelas = ? WHERE id_siswa = ?');
        $stmt->execute([$nis, $nama, $kelas, $idSiswa]);
    }

    public function delete($idSiswa) {
        $stmt = $this->db->prepare('SELECT id_user FROM siswa WHERE id_siswa = ? LIMIT 1');
        $stmt->execute([$idSiswa]);
        $row = $stmt->fetch();
        if (!$row) {
            return;
        }

        $stmt = $this->db->prepare('DELETE FROM users WHERE id_user = ?');
        $stmt->execute([(int) $row['id_user']]);
    }

    public function countAll() {
        return (int) $this->db->query('SELECT COUNT(*) FROM siswa')->fetchColumn();
    }
}

<?php

class UserModel
{
    private $db;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function findByUsername($username)
    {
        $stmt = $this->db->prepare('SELECT * FROM users WHERE username = ? LIMIT 1');
        $stmt->execute([$username]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function existsUsername($username, $exceptId = null) {
        if ($exceptId === null) {
            $stmt = $this->db->prepare('SELECT id_user FROM users WHERE username = ? LIMIT 1');
            $stmt->execute([$username]);
        } else {
            $stmt = $this->db->prepare('SELECT id_user FROM users WHERE username = ? AND id_user <> ? LIMIT 1');
            $stmt->execute([$username, $exceptId]);
        }

        return (bool) $stmt->fetchColumn();
    }

    public function create($username, $password, $role) {
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $stmt = $this->db->prepare('INSERT INTO users (username, password, role) VALUES (?, ?, ?)');
        $stmt->execute([$username, $hash, $role]);
        return (int) $this->db->lastInsertId();
    }

    public function updateUsername($idUser, $username) {
        $stmt = $this->db->prepare('UPDATE users SET username = ? WHERE id_user = ?');
        $stmt->execute([$username, $idUser]);
    }

    public function updatePassword($idUser, $password) {
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $stmt = $this->db->prepare('UPDATE users SET password = ? WHERE id_user = ?');
        $stmt->execute([$hash, $idUser]);
    }
}

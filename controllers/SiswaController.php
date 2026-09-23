<?php

class SiswaController
{
    private $db;
    private $siswa;
    private $users;

    public function __construct($db)
    {
        $this->db = $db;
        $this->siswa = new SiswaModel($db);
        $this->users = new UserModel($db);
    }

    public function index() {
        requireLogin('admin');
        view('admin/siswa', ['siswa' => $this->siswa->findAll()]);
    }

    public function form() {
        requireLogin('admin');
        $id = (int) ((isset($_GET['id']) ? $_GET['id'] : 0));

        if ($id > 0) {
            $data = $this->siswa->findById($id);
            if (!$data) {
                flash('danger', 'Data siswa tidak ditemukan.');
                redirect('kelola-siswa');
            }

            $old = [
                'username' => $data['username'],
                'nis' => $data['nis'],
                'nama_siswa' => $data['nama_siswa'],
                'kelas' => $data['kelas']
            ];

            view('admin/siswa_form', ['mode'=>'edit','id'=>$id,'old'=>$old,'error'=>'']);
            return;
        }

        view('admin/siswa_form', [
            'mode'=>'tambah',
            'id'=>0,
            'old'=>['username'=>'','nis'=>'','nama_siswa'=>'','kelas'=>''],
            'error'=>''
        ]);
    }

    public function save() {
        requireLogin('admin');
        $id = (int) ((isset($_POST['id_siswa']) ? $_POST['id_siswa'] : 0));
        $old = [
            'username' => trim((isset($_POST['username']) ? $_POST['username'] : '')),
            'nis' => trim((isset($_POST['nis']) ? $_POST['nis'] : '')),
            'nama_siswa' => trim((isset($_POST['nama_siswa']) ? $_POST['nama_siswa'] : '')),
            'kelas' => trim((isset($_POST['kelas']) ? $_POST['kelas'] : ''))
        ];
        $password = (isset($_POST['password']) ? $_POST['password'] : '');
        $error = '';
        $existing = $id > 0 ? $this->siswa->findById($id) : null;

        if ($id > 0 && !$existing) {
            flash('danger', 'Data siswa tidak ditemukan.');
            redirect('kelola-siswa');
        }

        $idUserExisting = $existing ? (int) $existing['id_user'] : null;

        if (in_array('', $old, true) || ($id === 0 && $password === '')) {
            $error = 'Semua kolom wajib diisi.';
        } elseif (strlen($old['username']) < 4) {
            $error = 'Username minimal 4 karakter.';
        } elseif (($id === 0 || $password !== '') && strlen($password) < 6) {
            $error = 'Password minimal 6 karakter.';
        } elseif ($this->users->existsUsername($old['username'], $idUserExisting)) {
            $error = 'Username sudah digunakan.';
        } elseif ($this->siswa->existsNis($old['nis'], $id > 0 ? $id : null)) {
            $error = 'NIS sudah digunakan.';
        }

        if ($error !== '') {
            view('admin/siswa_form', [
                'mode'=>$id > 0 ? 'edit':'tambah',
                'id'=>$id,
                'old'=>$old,
                'error'=>$error
            ]);
            return;
        }

        try {
            $this->db->beginTransaction();

            if ($id === 0) {
                $idUser = $this->users->create($old['username'], $password, 'siswa');
                $this->siswa->create($idUser, $old['nis'], $old['nama_siswa'], $old['kelas']);
                flash('success', 'Siswa berhasil ditambahkan.');
            } else {
                $this->siswa->update($id, $old['nis'], $old['nama_siswa'], $old['kelas']);
                $this->users->updateUsername((int)$existing['id_user'], $old['username']);
                if ($password !== '') $this->users->updatePassword((int)$existing['id_user'], $password);
                flash('success', 'Data siswa berhasil diperbarui.');
            }

            $this->db->commit();
            redirect('kelola-siswa');
        } catch (Exception $e) {
            if ($this->db->inTransaction()) $this->db->rollBack();
            view('admin/siswa_form', [
                'mode'=>$id > 0 ? 'edit':'tambah',
                'id'=>$id,
                'old'=>$old,
                'error'=>'Gagal menyimpan: ' . $e->getMessage()
            ]);
        }
    }

    public function delete() {
        requireLogin('admin');
        $id = (int) ((isset($_POST['id_siswa']) ? $_POST['id_siswa'] : 0));
        if ($id <= 0) redirect('kelola-siswa');

        try {
            $this->db->beginTransaction();
            $this->siswa->delete($id);
            $this->db->commit();
            flash('success', 'Data siswa berhasil dihapus.');
        } catch (Exception $e) {
            if ($this->db->inTransaction()) $this->db->rollBack();
            flash('danger', 'Gagal menghapus siswa: ' . $e->getMessage());
        }

        redirect('kelola-siswa');
    }
}

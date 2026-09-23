<?php

class AuthController
{
    private $db;
    private $users;
    private $siswa;

    public function __construct($db)
    {
        $this->db = $db;
        $this->users = new UserModel($db);
        $this->siswa = new SiswaModel($db);
    }

    public function login() {
        if (isset($_SESSION['id_user'])) {
            redirect('dashboard');
        }

        $error = '';
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $username = trim((isset($_POST['username']) ? $_POST['username'] : ''));
            $password = (isset($_POST['password']) ? $_POST['password'] : '');

            if ($username === '' || $password === '') {
                $error = 'Username dan password wajib diisi.';
            } else {
                $user = $this->users->findByUsername($username);

                if ($user && password_verify($password, $user['password'])) {
                    session_regenerate_id(true);
                    $_SESSION['id_user'] = (int) $user['id_user'];
                    $_SESSION['username'] = $user['username'];
                    $_SESSION['role'] = $user['role'];

                    if ($user['role'] === 'siswa') {
                        $dataSiswa = $this->siswa->findByUserId((int) $user['id_user']);
                        if (!$dataSiswa) {
                            session_unset();
                            $error = 'Data siswa belum lengkap. Hubungi admin.';
                        } else {
                            $_SESSION['id_siswa'] = (int) $dataSiswa['id_siswa'];
                            $_SESSION['nama_siswa'] = $dataSiswa['nama_siswa'];
                            $_SESSION['kelas'] = $dataSiswa['kelas'];
                        }
                    }

                    if ($error === '') {
                        flash('success', 'Login berhasil. Selamat datang, ' . $user['username'] . '!');
                        redirect('dashboard');
                    }
                } else {
                    $error = 'Username atau password salah.';
                }
            }
        }

        view('auth/login', ['error' => $error]);
    }

    public function register() {
        if (isset($_SESSION['id_user'])) redirect('dashboard');

        $error = '';
        $old = ['username'=>'', 'nis'=>'', 'nama_siswa'=>'', 'kelas'=>''];

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $old['username'] = trim((isset($_POST['username']) ? $_POST['username'] : ''));
            $old['nis'] = trim((isset($_POST['nis']) ? $_POST['nis'] : ''));
            $old['nama_siswa'] = trim((isset($_POST['nama_siswa']) ? $_POST['nama_siswa'] : ''));
            $old['kelas'] = trim((isset($_POST['kelas']) ? $_POST['kelas'] : ''));
            $password = (isset($_POST['password']) ? $_POST['password'] : '');
            $confirm = (isset($_POST['konfirmasi']) ? $_POST['konfirmasi'] : '');

            if (in_array('', $old, true) || $password === '') {
                $error = 'Semua kolom wajib diisi.';
            } elseif (strlen($old['username']) < 4) {
                $error = 'Username minimal 4 karakter.';
            } elseif (strlen($password) < 6) {
                $error = 'Password minimal 6 karakter.';
            } elseif ($password !== $confirm) {
                $error = 'Konfirmasi password tidak sama.';
            } elseif ($this->users->existsUsername($old['username'])) {
                $error = 'Username sudah digunakan.';
            } elseif ($this->siswa->existsNis($old['nis'])) {
                $error = 'NIS sudah digunakan.';
            } else {
                try {
                    $this->db->beginTransaction();
                    $idUser = $this->users->create($old['username'], $password, 'siswa');
                    $this->siswa->create($idUser, $old['nis'], $old['nama_siswa'], $old['kelas']);
                    $this->db->commit();
                    flash('success', 'Akun berhasil dibuat. Silakan login.');
                    redirect('login');
                } catch (Exception $e) {
                    if ($this->db->inTransaction()) $this->db->rollBack();
                    $error = 'Registrasi gagal: ' . $e->getMessage();
                }
            }
        }

        view('auth/register', ['error'=>$error, 'old'=>$old]);
    }

    public function logout() {
        $_SESSION = [];

        if (ini_get('session.use_cookies')) {
            $params = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000, $params['path'], $params['domain'], $params['secure'], $params['httponly']);
        }

        session_destroy();
        redirect('login');
    }
}

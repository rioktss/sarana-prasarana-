<?php

class PengaduanController
{
    private $db;
    private $pengaduan;
    private $progres;
    private $feedback;

    public function __construct($db)
    {
        $this->db = $db;
        $this->pengaduan = new PengaduanModel($db);
        $this->progres = new ProgresModel($db);
        $this->feedback = new FeedbackModel($db);
    }

    public function adminIndex() {
        requireLogin('admin');
        $allowed = ['Diajukan','Diproses','Selesai','Ditolak'];
        $status = (isset($_GET['status']) ? $_GET['status'] : '');
        if (!in_array($status, $allowed, true)) $status = '';

        view('admin/pengaduan', [
            'list' => $this->pengaduan->findAll($status),
            'status' => $status
        ]);
    }

    public function adminDetail() {
        requireLogin('admin');
        $id = (int) ((isset($_GET['id']) ? $_GET['id'] : 0));
        if ($id <= 0) redirect('admin-pengaduan');

        $data = $this->pengaduan->findById($id);
        if (!$data) {
            flash('danger', 'Pengaduan tidak ditemukan.');
            redirect('admin-pengaduan');
        }

        view('admin/detail', [
            'pengaduan' => $data,
            'progres' => $this->progres->findByPengaduan($id),
            'feedbacks' => $this->feedback->listByPengaduan($id)
        ]);
    }

    public function updateStatus() {
        requireLogin('admin');
        $id = (int) ((isset($_POST['id_pengaduan']) ? $_POST['id_pengaduan'] : 0));
        $status = (isset($_POST['status']) ? $_POST['status'] : '');
        $keterangan = trim((isset($_POST['keterangan']) ? $_POST['keterangan'] : ''));
        $allowed = ['Diajukan','Diproses','Selesai','Ditolak'];

        if ($id <= 0 || !in_array($status, $allowed, true)) {
            flash('danger', 'Data status tidak valid.');
            redirect('admin-pengaduan');
        }

        if (!$this->pengaduan->findById($id)) {
            flash('danger', 'Pengaduan tidak ditemukan.');
            redirect('admin-pengaduan');
        }

        try {
            $this->db->beginTransaction();
            $this->pengaduan->updateStatus($id, $status);
            $this->progres->create($id, $status, $keterangan !== '' ? $keterangan : null);
            $this->db->commit();
            flash('success', 'Status pengaduan berhasil diperbarui.');
        } catch (Exception $e) {
            if ($this->db->inTransaction()) $this->db->rollBack();
            flash('danger', 'Gagal memperbarui status: ' . $e->getMessage());
        }

        redirect('admin-detail', ['id' => $id]);
    }

    public function formCreate() {
        requireLogin('siswa');
        view('siswa/kirim', ['error'=>'', 'old'=>['judul_pengaduan'=>'','isi_pengaduan'=>'']]);
    }

    public function store() {
        requireLogin('siswa');
        $old = [
            'judul_pengaduan' => trim((isset($_POST['judul_pengaduan']) ? $_POST['judul_pengaduan'] : '')),
            'isi_pengaduan' => trim((isset($_POST['isi_pengaduan']) ? $_POST['isi_pengaduan'] : ''))
        ];
        $error = '';

        if ($old['judul_pengaduan'] === '' || $old['isi_pengaduan'] === '') {
            $error = 'Judul dan isi pengaduan wajib diisi.';
        } elseif (textLength($old['judul_pengaduan']) > 150) {
            $error = 'Judul maksimal 150 karakter.';
        }

        if ($error !== '') {
            view('siswa/kirim', ['error'=>$error, 'old'=>$old]);
            return;
        }

        try {
            $this->db->beginTransaction();
            $id = $this->pengaduan->create((int) $_SESSION['id_siswa'], $old['judul_pengaduan'], $old['isi_pengaduan']);
            $this->progres->create($id, 'Diajukan', 'Pengaduan telah diterima sistem dan menunggu ditindaklanjuti.');
            $this->db->commit();
            flash('success', 'Pengaduan berhasil dikirim.');
            redirect('siswa-detail', ['id'=>$id]);
        } catch (Exception $e) {
            if ($this->db->inTransaction()) $this->db->rollBack();
            view('siswa/kirim', ['error'=>'Pengaduan gagal disimpan: ' . $e->getMessage(), 'old'=>$old]);
        }
    }

    public function history() {
        requireLogin('siswa');
        view('siswa/histori', ['histori'=>$this->pengaduan->findBySiswa((int) $_SESSION['id_siswa'])]);
    }

    public function siswaDetail() {
        requireLogin('siswa');
        $id = (int) ((isset($_GET['id']) ? $_GET['id'] : 0));
        if ($id <= 0) redirect('histori');

        $data = $this->pengaduan->findById($id);
        if (!$data || (int)$data['id_siswa'] !== (int)$_SESSION['id_siswa']) {
            flash('danger', 'Pengaduan tidak ditemukan.');
            redirect('histori');
        }

        view('siswa/detail', [
            'pengaduan' => $data,
            'progres' => $this->progres->findByPengaduan($id),
            'feedbacks' => $this->feedback->listByPengaduan($id)
        ]);
    }

    public function saveFeedback() {
        requireLogin('siswa');
        $id = (int) ((isset($_POST['id_pengaduan']) ? $_POST['id_pengaduan'] : 0));
        $isi = trim((isset($_POST['isi_feedback']) ? $_POST['isi_feedback'] : ''));
        $data = $this->pengaduan->findById($id);

        if (!$data || (int)$data['id_siswa'] !== (int)$_SESSION['id_siswa']) {
            flash('danger', 'Pengaduan tidak ditemukan.');
            redirect('histori');
        }
        if ($data['status'] !== 'Selesai') {
            flash('danger', 'Feedback hanya dapat diberikan setelah pengaduan selesai.');
            redirect('siswa-detail', ['id'=>$id]);
        }
        if ($isi === '') {
            flash('danger', 'Isi feedback wajib diisi.');
            redirect('siswa-detail', ['id'=>$id]);
        }
        if (textLength($isi) > 2000) {
            flash('danger', 'Feedback maksimal 2000 karakter.');
            redirect('siswa-detail', ['id'=>$id]);
        }
        if ($this->feedback->exists($id, 'siswa')) {
            flash('danger', 'Feedback untuk pengaduan ini sudah pernah diberikan.');
            redirect('siswa-detail', ['id'=>$id]);
        }

        try {
            $this->feedback->create($id, $isi, 'siswa');
            flash('success', 'Terima kasih, feedback berhasil disimpan.');
        } catch (Exception $e) {
            flash('danger', 'Feedback gagal disimpan: ' . $e->getMessage());
        }

        redirect('siswa-detail', ['id'=>$id]);
    }

    public function saveAdminFeedback() {
        requireLogin('admin');
        $id = (int) ((isset($_POST['id_pengaduan']) ? $_POST['id_pengaduan'] : 0));
        $isi = trim((isset($_POST['isi_feedback']) ? $_POST['isi_feedback'] : ''));
        $data = $id > 0 ? $this->pengaduan->findById($id) : null;

        if (!$data) {
            flash('danger', 'Pengaduan tidak ditemukan.');
            redirect('admin-pengaduan');
        }
        if ($isi === '') {
            flash('danger', 'Isi umpan balik wajib diisi.');
            redirect('admin-detail', ['id'=>$id]);
        }
        if (textLength($isi) > 2000) {
            flash('danger', 'Umpan balik maksimal 2000 karakter.');
            redirect('admin-detail', ['id'=>$id]);
        }

        try {
            $this->feedback->create($id, $isi, 'admin');
            flash('success', 'Umpan balik berhasil dikirim ke siswa.');
        } catch (Exception $e) {
            flash('danger', 'Umpan balik gagal disimpan: ' . $e->getMessage());
        }

        redirect('admin-detail', ['id'=>$id]);
    }
}

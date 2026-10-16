<?php
session_start();

require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/helpers.php';
require_once __DIR__ . '/models/UserModel.php';
require_once __DIR__ . '/models/SiswaModel.php';
require_once __DIR__ . '/models/PengaduanModel.php';
require_once __DIR__ . '/models/ProgresModel.php';
require_once __DIR__ . '/models/FeedbackModel.php';
require_once __DIR__ . '/controllers/AuthController.php';
require_once __DIR__ . '/controllers/DashboardController.php';
require_once __DIR__ . '/controllers/PengaduanController.php';
require_once __DIR__ . '/controllers/SiswaController.php';

$page = isset($_GET['page']) ? $_GET['page'] : (isset($_SESSION['id_user']) ? 'dashboard' : 'login');
$db = (new Database())->getConnection();
ensureFeedbackSchema($db);

$publicPages = ['login', 'proses-login', 'register', 'proses-register'];
if (!in_array($page, $publicPages, true) && $page !== 'logout' && !isset($_SESSION['id_user'])) {
    redirect('login');
}

switch ($page) {
    case 'login':
    case 'proses-login':
        (new AuthController($db))->login();
        break;

    case 'register':
    case 'proses-register':
        (new AuthController($db))->register();
        break;

    case 'logout':
        (new AuthController($db))->logout();
        break;

    case 'dashboard':
        (new DashboardController($db))->index();
        break;

    case 'admin-pengaduan':
        (new PengaduanController($db))->adminIndex();
        break;

    case 'admin-detail':
        (new PengaduanController($db))->adminDetail();
        break;

    case 'update-status':
        (new PengaduanController($db))->updateStatus();
        break;

    case 'kirim-pengaduan':
        (new PengaduanController($db))->formCreate();
        break;

    case 'proses-pengaduan':
        (new PengaduanController($db))->store();
        break;

    case 'histori':
        (new PengaduanController($db))->history();
        break;

    case 'siswa-detail':
        (new PengaduanController($db))->siswaDetail();
        break;

    case 'simpan-feedback':
        (new PengaduanController($db))->saveFeedback();
        break;

    case 'admin-feedback':
        (new PengaduanController($db))->saveAdminFeedback();
        break;

    case 'kelola-siswa':
        (new SiswaController($db))->index();
        break;

    case 'form-siswa':
        (new SiswaController($db))->form();
        break;

    case 'simpan-siswa':
        (new SiswaController($db))->save();
        break;

    case 'hapus-siswa':
        (new SiswaController($db))->delete();
        break;

    default:
        http_response_code(404);
        view('errors/404', ['title' => '404 - SIPAS']);
}

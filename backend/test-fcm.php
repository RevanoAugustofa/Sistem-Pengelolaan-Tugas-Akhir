<?php

use App\Models\User;
use App\Services\FcmService;

require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';

$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);
$kernel->handle(Illuminate\Http\Request::capture());

// --- KONFIGURASI TEST ---
$userId = 2; // Ganti dengan ID User yang ingin ditest (mahasiswa)
$title = "Test Notifikasi Manual";
$body = "Halo! Ini adalah notifikasi test dari script PHP pada jam " . date('H:i:s');
// ------------------------

echo "Mencoba mengirim notifikasi ke User ID: $userId...\n";

$user = User::find($userId);

if (!$user) {
    echo "Gagal: User tidak ditemukan.\n";
    exit;
}

if (!$user->fcm_token) {
    echo "Gagal: User tidak memiliki fcm_token. Silakan login dulu lewat aplikasi.\n";
    exit;
}

echo "Token ditemukan: " . substr($user->fcm_token, 0, 15) . "...\n";

$success = FcmService::sendNotification($userId, $title, $body, ['type' => 'test']);

if ($success) {
    echo "BERHASIL: Notifikasi dikirim dan disimpan ke tabel notifikasi.\n";
} else {
    echo "GAGAL: Cek storage/logs/laravel.log untuk detail error.\n";
}

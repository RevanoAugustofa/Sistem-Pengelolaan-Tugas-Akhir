<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use App\Models\Notifikasi;
use App\Models\User;

class FcmService
{
    /**
     * Kirim notifikasi ke satu user
     */
    public static function sendNotification($userId, $title, $body, $data = [])
    {
        $user = User::find($userId);
        if (!$user || !$user->fcm_token) {
            return false;
        }

        // Simpan ke database
        Notifikasi::create([
            'id_user' => $userId,
            'nama_notif' => $title,
            'isi_notif' => $body,
            'tgl_notif' => now(),
        ]);

        // Kirim via FCM (HTTP v1 legacy or standard approach)
        // Note: Anda perlu mengatur FIREBASE_SERVER_KEY di .env
        $serverKey = env('FIREBASE_SERVER_KEY');
        
        if (!$serverKey) {
            return false;
        }

        $response = Http::withHeaders([
            'Authorization' => 'key=' . $serverKey,
            'Content-Type' => 'application/json',
        ])->post('https://fcm.googleapis.com/fcm/send', [
            'to' => $user->fcm_token,
            'notification' => [
                'title' => $title,
                'body' => $body,
                'sound' => 'default',
            ],
            'data' => $data,
        ]);

        return $response->successful();
    }
}

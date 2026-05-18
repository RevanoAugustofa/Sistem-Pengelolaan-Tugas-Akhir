<?php

namespace App\Services;

use App\Models\Notifikasi;
use App\Models\User;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class FcmService
{
    /**
     * Kirim notifikasi ke satu user menggunakan Firebase V1 (Kreait)
     */
    public static function sendNotification($userId, $title, $body, $data = [])
    {
        $user = User::find($userId);
        if (!$user || !$user->fcm_token) {
            return false;
        }

        // Simpan ke database lokal untuk history
        Notifikasi::create([
            'id_user' => $userId,
            'nama_notif' => $title,
            'isi_notif' => $body,
            'tgl_notif' => now(),
        ]);

        try {
            // Gunakan service messaging dari Kreait
            $messaging = app('firebase.messaging');
            
            // Firebase Cloud Messaging (V1) mewajibkan semua nilai di dalam 'data' berupa string
            $stringData = array_map(function($value) {
                return (string) $value;
            }, $data);

            $message = CloudMessage::fromArray([
                'token' => $user->fcm_token,
                'notification' => [
                    'title' => $title,
                    'body' => $body,
                ],
                'data' => $stringData,
            ]);

            $response = $messaging->send($message);
            \Log::info('FCM Success for User ID ' . $userId . ': ' . json_encode($response));
            return true;
        } catch (\Exception $e) {
            \Log::error('FCM Error for User ID ' . $userId . ': ' . $e->getMessage());
            return false;
        }
    }
}

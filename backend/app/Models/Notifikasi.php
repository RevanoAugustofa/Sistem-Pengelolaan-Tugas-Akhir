<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notifikasi extends Model
{
    use HasFactory;

    protected $table = 'notifikasi';

    protected $fillable = [
        'id_user',
        'nama_notif',
        'isi_notif',
        'tgl_notif',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }
}

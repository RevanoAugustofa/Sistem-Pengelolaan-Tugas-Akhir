<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DaftarBimbingan extends Model
{
    use HasFactory;

    protected $table = 'daftar_bimbingan';

    protected $fillable = [
        'id_mahasiswa',
        'id_jadwal_bimbingan',
        'status', // enum: menunggu, diterima, ditolak, dibatalkan
    ];

    public function mahasiswa()
    {
        return $this->belongsTo(Mahasiswa::class, 'id_mahasiswa');
    }

    public function jadwalBimbingan()
    {
        return $this->belongsTo(JadwalBimbingan::class, 'id_jadwal_bimbingan');
    }

    public function logbooks()
    {
        return $this->hasMany(LogbookBimbingan::class, 'id_daftar_bimbingan');
    }
}

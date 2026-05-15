<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JadwalSidangTA extends Model
{
    use HasFactory;

    protected $table = 'jadwal_sidangta';
    
    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'update_at';

    protected $fillable = [
        'id_mahasiswa',
        'jenis_sidang',
        'id_pembimbing_utama',
        'id_pembimbing_pendamping',
        'id_penguji_utama',
        'id_penguji_pendamping',
        'tanggal',
        'waktu_mulai',
        'waktu_selesai',
        'id_ruang_sidang',
    ];

    public function mahasiswa()
    {
        return $this->belongsTo(Mahasiswa::class, 'id_mahasiswa');
    }

    public function pengujiUtama()
    {
        return $this->belongsTo(Dosen::class, 'id_penguji_utama');
    }

    public function pengujiPendamping()
    {
        return $this->belongsTo(Dosen::class, 'id_penguji_pendamping');
    }

    public function pembimbingUtama()
    {
        return $this->belongsTo(Dosen::class, 'id_pembimbing_utama');
    }

    public function pembimbingPendamping()
    {
        return $this->belongsTo(Dosen::class, 'id_pembimbing_pendamping');
    }

    public function ruangan()
    {
        return $this->belongsTo(Ruangan::class, 'id_ruang_sidang');
    }
}

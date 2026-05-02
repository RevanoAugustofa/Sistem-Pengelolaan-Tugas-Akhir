<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PengajuanPembimbing extends Model
{
    use HasFactory;

    protected $table = 'pengajuan_pembimbing';

    protected $fillable = [
        'id_mahasiswa',
        'id_pembimbing_utama',
        'id_pembimbing_pendamping',
        'status',
    ];

    public function mahasiswa()
    {
        return $this->belongsTo(Mahasiswa::class, 'id_mahasiswa');
    }

    public function pembimbingUtama()
    {
        return $this->belongsTo(Dosen::class, 'id_pembimbing_utama');
    }

    public function pembimbingPendamping()
    {
        return $this->belongsTo(Dosen::class, 'id_pembimbing_pendamping');
    }
}

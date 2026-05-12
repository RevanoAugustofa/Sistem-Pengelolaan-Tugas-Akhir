<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HasilAkhirTA extends Model
{
    use HasFactory;

    protected $table = 'hasil_akhirta';
    public $timestamps = false;

    protected $fillable = [
        'id_mahasiswa',
        'id_jadwal_sidangTA',
        'id_kaprodi',
        'nilai_pembimbing_utama',
        'nilai_pembimbing_pendamping',
        'nilai_penguji_utama',
        'nilai_penguji_pendamping',
        'nilai_total',
        'created_at',
        'update_at',
    ];

    public function mahasiswa()
    {
        return $this->belongsTo(Mahasiswa::class, 'id_mahasiswa');
    }

    public function jadwalSidangTA()
    {
        return $this->belongsTo(JadwalSidangTA::class, 'id_jadwal_sidangTA');
    }

    public function kaprodi()
    {
        return $this->belongsTo(Dosen::class, 'id_kaprodi');
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HasilSempro extends Model
{
    use HasFactory;

    protected $table = 'hasil_sempro';
    public $timestamps = false; // Based on migration having created_at and update_at manually

    protected $fillable = [
        'id_jadwal_sempro',
        'id_proposal',
        'nilai_penguji_utama',
        'nilai_penguji_pendamping',
        'nilai_total',
        'status',
        'created_at',
        'update_at',
    ];

    public function jadwalSempro()
    {
        return $this->belongsTo(JadwalSempro::class, 'id_jadwal_sempro');
    }

    public function proposal()
    {
        return $this->belongsTo(Proposal::class, 'id_proposal');
    }
}

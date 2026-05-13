<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LogbookBimbingan extends Model
{
    use HasFactory;

    protected $table = 'logbook_bimbingan';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'update_at';

    protected $fillable = [
        'id_mahasiswa',
        'id_daftar_bimbingan',
        'permasalahan',
        'file_bimbingan',
        'rekom_pembimbing_utama',
        'rekom_pembimbing_pendamping',
    ];

    public function mahasiswa()
    {
        return $this->belongsTo(Mahasiswa::class, 'id_mahasiswa');
    }

    public function daftarBimbingan()
    {
        return $this->belongsTo(DaftarBimbingan::class, 'id_daftar_bimbingan');
    }
}

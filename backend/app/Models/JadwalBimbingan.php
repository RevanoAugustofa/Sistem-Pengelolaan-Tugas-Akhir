<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JadwalBimbingan extends Model
{
    use HasFactory;

    protected $table = 'jadwal_bimbingan';

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'update_at';

    protected $fillable = [
        'id_dosen',
        'waktu_tanggal',
        'kuota',
        'metode_bimbingan',
        'tempat_link',
        'status',
    ];

    public function dosen()
    {
        return $this->belongsTo(Dosen::class, 'id_dosen');
    }
}

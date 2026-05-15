<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CatatanRevisiSempro extends Model
{
    use HasFactory;

    protected $table = 'catatan_revisi_sempro';
    
    // Disable automatic timestamps if using manual field names or if requested
    public $timestamps = false;

    protected $fillable = [
        'id_dosen',
        'id_jadwal_sempro',
        'catatan_revisi',
        'created_at',
        'update_at',
    ];

    protected $casts = [
        'catatan_revisi' => 'array', // Automatically cast JSON to array
    ];
}

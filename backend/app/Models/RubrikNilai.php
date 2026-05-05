<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RubrikNilai extends Model
{
    use HasFactory;

    protected $table = 'rubrik_nilai';

    protected $fillable = [
        'id_prodi',
        'jenis_dosen',
        'kelompok',
        'kategori',
        'presentse',
    ];

    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'update_at';

    public function prodi()
    {
        return $this->belongsTo(Prodi::class, 'id_prodi');
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Prodi extends Model
{
    protected $table = 'prodi';

    protected $fillable = [
        'kode_prodi',
        'nama_prodi',
    ];

    public function dosen()
    {
        return $this->belongsToMany(Dosen::class, 'dosen_prodi', 'id_prodi', 'id_dosen');
    }
}

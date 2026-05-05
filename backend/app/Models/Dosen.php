<?php

namespace App\Models;

use App\Enums\JabatanDosen;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Dosen extends Model
{
    use HasFactory;

    protected $table = 'dosen';

    protected $fillable = [
        'id_user',
        'nama_dosen',
        'nip',
        'nidn',
        'ttd_dosen',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }

    public function prodi()
    {
        return $this->belongsToMany(Prodi::class, 'dosen_prodi', 'id_dosen', 'id_prodi')
            ->withPivot('jabatan')
            ->withTimestamps();
    }
}

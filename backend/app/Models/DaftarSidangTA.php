<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DaftarSidangTA extends Model
{
    use HasFactory;

    protected $table = 'daftar_sidangta';
    
    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'update_at';

    protected $fillable = [
        'id_mahasiswa',
        'tanggal_pendaftaran',
        'file_tugas_akhir',
        'file_bebas_pinjaman_administrasi',
        'file_slip_pembayaran_semester_akhir',
        'file_transkip_sementara',
        'file_bukti_pembayaran_sidang_ta',
    ];

    public function mahasiswa()
    {
        return $this->belongsTo(Mahasiswa::class, 'id_mahasiswa');
    }
}

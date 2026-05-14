<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Mahasiswa extends Model
{
    use HasFactory;

    protected $table = 'mahasiswa';

    protected $fillable = [
        'id_user',
        'id_prodi',
        'id_tahun_ajar',
        'nim',
        'nama_mahasiswa',
        'tgl_lahir',
        'jenis_kelamin',
        'alamat',
        'ttd_mahasiswa',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }

    public function prodi()
    {
        return $this->belongsTo(Prodi::class, 'id_prodi');
    }

    public function tahunAjar()
    {
        return $this->belongsTo(TahunAjar::class, 'id_tahun_ajar');
    }

    public function proposal()
    {
        return $this->hasOne(Proposal::class, 'id_mahasiswa')->latestOfMany();
    }

    public function pengajuanPembimbing()
    {
        return $this->hasOne(PengajuanPembimbing::class, 'id_mahasiswa');
    }

    public function jadwalSempro()
    {
        return $this->hasOne(JadwalSempro::class, 'id_mahasiswa');
    }

    public function jadwalSidang()
    {
        return $this->hasOne(JadwalSidangTA::class, 'id_mahasiswa');
    }

    public function daftarSidangTA()
    {
        return $this->hasOne(DaftarSidangTA::class, 'id_mahasiswa')->latestOfMany();
    }
}

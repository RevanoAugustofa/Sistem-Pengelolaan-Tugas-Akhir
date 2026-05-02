<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;

use App\Enums\UserRole;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;


class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'role' => UserRole::class,
        ];
    }

    protected $appends = ['available_roles'];

    public function dosen()
    {
        return $this->hasOne(Dosen::class, 'id_user');
    }

    public function mahasiswa()
    {
        return $this->hasOne(Mahasiswa::class, 'id_user');
    }

    public function getAvailableRolesAttribute()
    {
        $roles = [];

        // Masukkan jabatan dulu jika ada (admin/koorprodi)
        if ($this->isDosen() && $this->dosen && $this->dosen->jabatan) {
            $roles[] = $this->dosen->jabatan->value;
        }

        // Masukkan role dasar (dosen/mahasiswa)
        $roles[] = $this->role->value;

        return array_values(array_unique($roles));
    }

    public function isAdmin()
    {
        return $this->isDosen() && $this->dosen?->jabatan === \App\Enums\JabatanDosen::ADMIN;
    }

    public function isMahasiswa()
    {
        return $this->role == UserRole::MAHASISWA;
    }

    public function isDosen()
    {
        return $this->role == UserRole::DOSEN;
    }

    public function isKoordinatorProdi()
    {
        return $this->isDosen() && $this->dosen?->jabatan === \App\Enums\JabatanDosen::KOORPRODI;
    }
}

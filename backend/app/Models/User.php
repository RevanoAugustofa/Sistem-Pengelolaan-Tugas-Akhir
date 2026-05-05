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

    protected $appends = ['available_roles', 'available_contexts'];

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
        $roles = [$this->role->value];

        if ($this->isDosen() && $this->dosen) {
            foreach ($this->dosen->prodi as $p) {
                if ($p->pivot->jabatan) {
                    $roles[] = $p->pivot->jabatan;
                }
            }
        }

        return array_values(array_unique($roles));
    }

    public function getAvailableContextsAttribute()
    {
        $contexts = [];

        if ($this->isMahasiswa() && $this->mahasiswa) {
            $contexts[] = [
                'role' => 'mahasiswa',
                'prodi_id' => $this->mahasiswa->id_prodi,
                'prodi_name' => $this->mahasiswa->prodi?->nama_prodi,
            ];
        }

        if ($this->isDosen() && $this->dosen) {
            foreach ($this->dosen->prodi as $p) {
                // Context as regular Dosen
                $contexts[] = [
                    'role' => 'dosen',
                    'prodi_id' => $p->id,
                    'prodi_name' => $p->nama_prodi,
                ];

                // Context with special jabatan (koorprodi/admin)
                if ($p->pivot->jabatan) {
                    $contexts[] = [
                        'role' => $p->pivot->jabatan,
                        'prodi_id' => $p->id,
                        'prodi_name' => $p->nama_prodi,
                    ];
                }
            }
        }

        return $contexts;
    }

    public function isAdmin()
    {
        return in_array('admin', $this->available_roles);
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
        return in_array('koorprodi', $this->available_roles);
    }
}

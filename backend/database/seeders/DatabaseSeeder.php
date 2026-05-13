<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Dosen;
use App\Models\Prodi;
use App\Enums\UserRole;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Buat Prodi (Jika belum ada)
        $prodi = Prodi::updateOrCreate(
            ['nama_prodi' => 'Teknik Informatika'],
            ['kode_prodi' => 'IF']
        );

        // 2. Buat User untuk Admin (Role default harus 'dosen' karena enum hanya ada dosen/mahasiswa)
        $user = User::updateOrCreate(
            ['email' => 'admin@gmail.com'],
            [
                'name' => 'Administrator',
                'password' => Hash::make('password'),
                'role' => UserRole::DOSEN,
            ]
        );

        // 3. Buat Data Dosen untuk User tersebut
        $dosen = Dosen::updateOrCreate(
            ['id_user' => $user->id],
            [
                'nama_dosen' => 'Administrator',
                'nip' => '123456789',
                'nidn' => '987654321',
                'jenis_kelamin' => 'L',
                'alamat' => 'Kampus',
            ]
        );

        // 4. Hubungkan Dosen ke Prodi dengan jabatan 'admin'
        DB::table('dosen_prodi')->updateOrInsert(
            [
                'id_dosen' => $dosen->id,
                'id_prodi' => $prodi->id,
            ],
            [
                'jabatan' => 'admin',
            ]
        );
    }
}

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('mahasiswa', function (Blueprint $table) {
            $table->integer('id', true);
            $table->integer('id_user')->index('id_user');
            $table->integer('id_prodi')->index('id_prodi');
            $table->integer('id_tahun_ajar')->index('mahasiswa_ibfk_3');
            $table->string('nim')->nullable();
            $table->string('nama_mahasiswa')->nullable();
            $table->string('tgl_lahir');
            $table->string('jenis_kelamin');
            $table->string('alamat');
            $table->string('ttd_mahasiswa')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('mahasiswa');
    }
};

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
        Schema::create('jadwal_sidangta', function (Blueprint $table) {
            $table->integer('id', true);
            $table->integer('id_mahasiswa')->nullable()->index('id_mahasiswa');
            $table->enum('jenis_sidang', ['sidang_reguler', 'ulang'])->nullable();
            $table->integer('id_pembimbing_utama')->nullable()->index('id_pembimbing_utama');
            $table->integer('id_pembimbing_pendamping')->nullable()->index('id_pembimbing_pendamping');
            $table->integer('id_penguji_utama')->nullable()->index('id_penguji_utama');
            $table->integer('id_penguji_pendamping')->nullable()->index('id_penguji_pendamping');
            $table->date('tanggal')->nullable();
            $table->time('waktu_mulai')->nullable();
            $table->time('waktu_selesai')->nullable();
            $table->integer('id_ruang_sidang')->nullable()->index('id_ruang_sidang');
            $table->timestamp('created_at')->nullable();
            $table->timestamp('update_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('jadwal_sidangta');
    }
};

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
        Schema::table('jadwal_sempro', function (Blueprint $table) {
            $table->foreign(['id_mahasiswa'], 'jadwal_sempro_ibfk_1')->references(['id'])->on('mahasiswa')->onUpdate('no action')->onDelete('no action');
            $table->foreign(['id_penguji_utama'], 'jadwal_sempro_ibfk_2')->references(['id'])->on('dosen')->onUpdate('no action')->onDelete('no action');
            $table->foreign(['id_penguji_pendamping'], 'jadwal_sempro_ibfk_3')->references(['id'])->on('dosen')->onUpdate('no action')->onDelete('no action');
            $table->foreign(['id_ruang_sidang'], 'jadwal_sempro_ibfk_4')->references(['id'])->on('ruangan')->onUpdate('no action')->onDelete('no action');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('jadwal_sempro', function (Blueprint $table) {
            $table->dropForeign('jadwal_sempro_ibfk_1');
            $table->dropForeign('jadwal_sempro_ibfk_2');
            $table->dropForeign('jadwal_sempro_ibfk_3');
            $table->dropForeign('jadwal_sempro_ibfk_4');
        });
    }
};

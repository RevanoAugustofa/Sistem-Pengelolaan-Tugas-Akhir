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
        Schema::table('hasil_akhirta', function (Blueprint $table) {
            $table->foreign(['id_mahasiswa'], 'hasil_akhirta_ibfk_1')->references(['id'])->on('mahasiswa')->onUpdate('no action')->onDelete('no action');
            $table->foreign(['id_jadwal_sidangTA'], 'hasil_akhirta_ibfk_2')->references(['id'])->on('jadwal_sidangta')->onUpdate('no action')->onDelete('no action');
            $table->foreign(['id_kaprodi'], 'hasil_akhirta_ibfk_3')->references(['id'])->on('dosen')->onUpdate('no action')->onDelete('no action');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('hasil_akhirta', function (Blueprint $table) {
            $table->dropForeign('hasil_akhirta_ibfk_1');
            $table->dropForeign('hasil_akhirta_ibfk_2');
            $table->dropForeign('hasil_akhirta_ibfk_3');
        });
    }
};

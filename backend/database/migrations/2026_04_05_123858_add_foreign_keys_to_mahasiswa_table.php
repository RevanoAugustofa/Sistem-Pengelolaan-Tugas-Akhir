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
        Schema::table('mahasiswa', function (Blueprint $table) {
            $table->foreign(['id_user'], 'mahasiswa_ibfk_1')->references(['id'])->on('users')->onUpdate('cascade')->onDelete('cascade');
            $table->foreign(['id_prodi'], 'mahasiswa_ibfk_2')->references(['id'])->on('prodi')->onUpdate('cascade')->onDelete('cascade');
            $table->foreign(['id_tahun_ajar'], 'mahasiswa_ibfk_3')->references(['id'])->on('tahun_ajar')->onUpdate('cascade')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('mahasiswa', function (Blueprint $table) {
            $table->dropForeign('mahasiswa_ibfk_1');
            $table->dropForeign('mahasiswa_ibfk_2');
            $table->dropForeign('mahasiswa_ibfk_3');
        });
    }
};

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
        Schema::table('pengajuan_pembimbing', function (Blueprint $table) {
            $table->foreign(['id_mahasiswa'], 'fk_mahasiswa')->references(['id'])->on('mahasiswa')->onUpdate('no action')->onDelete('no action');
            $table->foreign(['id_pembimbing_pendamping'], 'fk_pembimbing_pendamping')->references(['id'])->on('dosen')->onUpdate('no action')->onDelete('no action');
            $table->foreign(['id_pembimbing_utama'], 'fk_pembimbing_utama')->references(['id'])->on('dosen')->onUpdate('no action')->onDelete('no action');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('pengajuan_pembimbing', function (Blueprint $table) {
            $table->dropForeign('fk_mahasiswa');
            $table->dropForeign('fk_pembimbing_pendamping');
            $table->dropForeign('fk_pembimbing_utama');
        });
    }
};

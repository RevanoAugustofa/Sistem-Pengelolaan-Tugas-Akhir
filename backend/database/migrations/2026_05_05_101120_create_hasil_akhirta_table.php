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
        Schema::create('hasil_akhirta', function (Blueprint $table) {
            $table->integer('id', true);
            $table->integer('id_mahasiswa')->nullable()->index('id_mahasiswa');
            $table->integer('id_jadwal_sidangTA')->nullable()->index('id_jadwal_sidangta');
            $table->integer('id_kaprodi')->nullable()->index('id_kaprodi');
            $table->float('nilai_pembimbing_utama')->nullable();
            $table->float('nilai_pembimbing_pendamping')->nullable();
            $table->float('nilai_penguji_utama')->nullable();
            $table->float('nilai_penguji_pendamping')->nullable();
            $table->float('nilai_total')->nullable();
            $table->timestamp('created_at')->nullable();
            $table->timestamp('update_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('hasil_akhirta');
    }
};

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
        Schema::create('hasil_sempro', function (Blueprint $table) {
            $table->integer('id', true);
            $table->integer('id_jadwal_sempro')->nullable()->index('id_jadwal_sempro');
            $table->integer('id_proposal')->nullable()->index('id_proposal');
            $table->float('nilai_penguji_utama')->nullable();
            $table->float('nilai_penguji_pendamping')->nullable();
            $table->float('nilai_total')->nullable();
            $table->enum('status', ['lulus', 'revisi', 'ditolak'])->nullable();
            $table->timestamp('created_at')->nullable();
            $table->timestamp('update_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('hasil_sempro');
    }
};

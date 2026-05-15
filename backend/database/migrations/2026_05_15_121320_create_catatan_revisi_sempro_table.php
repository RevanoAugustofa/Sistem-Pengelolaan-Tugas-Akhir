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
        Schema::create('catatan_revisi_sempro', function (Blueprint $table) {
            $table->id();
            $table->integer('id_dosen')->nullable();
            $table->integer('id_jadwal_sempro')->nullable();
            $table->text('catatan_revisi')->nullable(); // Will store JSON array of points
            $table->timestamp('created_at')->nullable();
            $table->timestamp('update_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('catatan_revisi_sempro');
    }
};

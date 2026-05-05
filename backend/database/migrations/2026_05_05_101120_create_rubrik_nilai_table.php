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
        Schema::create('rubrik_nilai', function (Blueprint $table) {
            $table->integer('id', true);
            $table->integer('id_prodi')->nullable()->index('id_prodi');
            $table->enum('jenis_dosen', ['pembimbing utama','pembimbing pendamping','penguji utama','penguji pendamping'])->nullable();
            $table->string('kelompok')->nullable();
            $table->string('kategori')->nullable();
            $table->integer('presentse')->nullable();
            $table->timestamp('created_at')->nullable();
            $table->timestamp('update_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rubrik_nilai');
    }
};

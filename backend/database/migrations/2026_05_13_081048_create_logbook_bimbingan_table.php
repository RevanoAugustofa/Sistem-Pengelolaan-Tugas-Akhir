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
        Schema::create('logbook_bimbingan', function (Blueprint $table) {
            $table->integer('id', true);
            $table->integer('id_mahasiswa');
            $table->integer('id_daftar_bimbingan');
            $table->string('permasalahan')->nullable();
            $table->string('file_bimbingan')->nullable();
            $table->string('rekom_pembimbing_utama')->nullable();
            $table->string('rekom_pembimbing_pendamping')->nullable();
            $table->timestamp('created_at')->useCurrent();
            $table->timestamp('update_at')->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_mahasiswa')->references('id')->on('mahasiswa')->onDelete('cascade');
            $table->foreign('id_daftar_bimbingan')->references('id')->on('daftar_bimbingan')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('logbook_bimbingan');
    }
};

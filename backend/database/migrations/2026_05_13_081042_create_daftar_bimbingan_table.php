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
        Schema::create('daftar_bimbingan', function (Blueprint $table) {
            $table->id();
            $table->integer('id_mahasiswa');
            $table->integer('id_jadwal_bimbingan');
            $table->enum('status', ['diajukan', 'disetujui', 'selesai', 'dibatalkan'])->default('diajukan');
            $table->timestamps();

            $table->foreign('id_mahasiswa')->references('id')->on('mahasiswa')->onDelete('cascade');
            $table->foreign('id_jadwal_bimbingan')->references('id')->on('jadwal_bimbingan')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('daftar_bimbingan');
    }
};

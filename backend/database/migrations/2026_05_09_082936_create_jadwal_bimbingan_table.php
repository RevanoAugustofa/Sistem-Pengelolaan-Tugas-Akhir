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
        Schema::create('jadwal_bimbingan', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->unsignedBigInteger('id_dosen');
            $blueprint->dateTime('waktu_tanggal');
            $blueprint->integer('kuota')->default(1);
            $blueprint->enum('metode_bimbingan', ['offline', 'online']);
            $blueprint->string('tempat_link')->nullable()->comment('tempat:ruang dosen, link:gmeet/zoom');
            $blueprint->string('status')->default('tersedia');
            $blueprint->timestamp('created_at')->useCurrent();
            $blueprint->timestamp('update_at')->useCurrent()->useCurrentOnUpdate();

            $blueprint->foreign('id_dosen')->references('id')->on('dosen')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('jadwal_bimbingan');
    }
};

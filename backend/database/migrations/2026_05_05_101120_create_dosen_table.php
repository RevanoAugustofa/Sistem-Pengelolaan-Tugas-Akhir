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
        Schema::create('dosen', function (Blueprint $table) {
            $table->integer('id', true);
            $table->integer('id_user')->nullable()->index('dosen_ibfk_1');
            $table->string('nama_dosen')->nullable();
            $table->string('nip')->nullable();
            $table->string('nidn')->nullable();
            $table->string('jenis_kelamin');
            $table->string('alamat');
            $table->string('ttd_dosen')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('dosen');
    }
};

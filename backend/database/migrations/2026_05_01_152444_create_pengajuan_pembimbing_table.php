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
        Schema::create('pengajuan_pembimbing', function (Blueprint $table) {
            $table->integer('id', true);
            $table->integer('id_mahasiswa')->index('fk_mahasiswa');
            $table->integer('id_pembimbing_utama')->index('fk_pembimbing_utama');
            $table->integer('id_pembimbing_pendamping')->index('fk_pembimbing_pendamping');
            $table->enum('status', ['proses', 'diterima', 'ditolak'])->nullable()->default('proses');
            $table->timestamp('created_at')->nullable()->useCurrent();
            $table->timestamp('updated_at')->useCurrentOnUpdate()->nullable()->useCurrent();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pengajuan_pembimbing');
    }
};

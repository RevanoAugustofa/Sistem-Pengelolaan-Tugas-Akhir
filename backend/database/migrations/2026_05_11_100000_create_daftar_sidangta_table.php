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
        Schema::create('daftar_sidangta', function (Blueprint $table) {
            $table->integer('id', true);
            $table->integer('id_mahasiswa')->index('id_mahasiswa');
            $table->date('tanggal_pendaftaran');
            $table->string('file_tugas_akhir');
            $table->string('file_bebas_pinjaman_administrasi');
            $table->string('file_slip_pembayaran_semester_akhir');
            $table->string('file_transkip_sementara');
            $table->string('file_bukti_pembayaran_sidang_ta');
            $table->timestamp('created_at')->nullable();
            $table->timestamp('update_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('daftar_sidangta');
    }
};

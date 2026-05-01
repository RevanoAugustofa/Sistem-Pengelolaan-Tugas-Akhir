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
        Schema::create('proposal', function (Blueprint $table) {
            $table->integer('id', true);
            $table->integer('id_mahasiswa')->index('id_mahasiswa');
            $table->string('judul_proposal');
            $table->string('file_proposal')->nullable();
            $table->string('revisi_judul_proposal')->nullable();
            $table->string('revisi_file_proposal')->nullable();
            $table->timestamp('created_at')->nullable();
            $table->timestamp('update_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('proposal');
    }
};

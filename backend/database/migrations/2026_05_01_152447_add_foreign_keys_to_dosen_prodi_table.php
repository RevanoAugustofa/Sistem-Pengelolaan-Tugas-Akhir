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
        Schema::table('dosen_prodi', function (Blueprint $table) {
            $table->foreign(['id_dosen'], 'fk_dosen')->references(['id'])->on('dosen')->onUpdate('cascade')->onDelete('cascade');
            $table->foreign(['id_prodi'], 'fk_prodi')->references(['id'])->on('prodi')->onUpdate('cascade')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('dosen_prodi', function (Blueprint $table) {
            $table->dropForeign('fk_dosen');
            $table->dropForeign('fk_prodi');
        });
    }
};

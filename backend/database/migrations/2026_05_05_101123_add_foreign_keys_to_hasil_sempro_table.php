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
        Schema::table('hasil_sempro', function (Blueprint $table) {
            $table->foreign(['id_jadwal_sempro'], 'hasil_sempro_ibfk_1')->references(['id'])->on('jadwal_sempro')->onUpdate('no action')->onDelete('no action');
            $table->foreign(['id_proposal'], 'hasil_sempro_ibfk_2')->references(['id'])->on('proposal')->onUpdate('no action')->onDelete('no action');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('hasil_sempro', function (Blueprint $table) {
            $table->dropForeign('hasil_sempro_ibfk_1');
            $table->dropForeign('hasil_sempro_ibfk_2');
        });
    }
};

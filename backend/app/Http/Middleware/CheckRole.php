<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     * @param  string[] ...$roles
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        if (!$request->user()) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        // Ambil semua role & jabatan yang dimiliki user
        $userRoles = $request->user()->available_roles;

        // Cek apakah ada persinggungan antara role user dengan role yang dibutuhkan route
        $hasAccess = array_intersect($userRoles, $roles);

        if (empty($hasAccess)) {
            return response()->json([
                'message' => 'Forbidden: You do not have the required role or position.'
            ], 403);
        }

        return $next($request);
    }
}

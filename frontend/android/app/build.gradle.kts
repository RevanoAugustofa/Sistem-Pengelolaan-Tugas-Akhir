plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    
    // Plugin Google Services ditambahkan di sini (hapus duplikat com.android.application)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.sipta.pnc"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.sipta.pnc"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// TAMBAHKAN BLOK DEPENDENCIES INI
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // Import the Firebase BoM (Bill of Materials) untuk menyamakan versi semua produk Firebase
    implementation(platform("com.google.firebase:firebase-bom:34.13.0"))

    // Ini library dasar Firebase Analytics
    implementation("com.google.firebase:firebase-analytics")
    
    // Tambahan: Karena sebelumnya kita membahas Push Notification, 
    // kamu bisa sekalian menambahkan library Cloud Messaging (FCM) di sini
    implementation("com.google.firebase:firebase-messaging")
}

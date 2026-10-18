import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

/**
 * Firma de release (ADR-0054): upload key fuera del repositorio. En CI llega por variables de
 * entorno (ANDROID_KEYSTORE_PATH, ANDROID_KEYSTORE_PASSWORD, ANDROID_KEY_ALIAS,
 * ANDROID_KEY_PASSWORD); en una máquina, por android/key.properties (ignorado por git).
 * Google Play App Signing firma lo que se publica; esta llave solo autentica la subida.
 */
val keyProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}
fun signingValue(env: String, prop: String): String? =
    System.getenv(env)?.takeIf { it.isNotBlank() } ?: keyProperties.getProperty(prop)

val releaseStoreFile = signingValue("ANDROID_KEYSTORE_PATH", "storeFile")
val requireReleaseSigning = System.getenv("SISI_REQUIRE_RELEASE_SIGNING") == "true"

android {
    namespace = "bo.sisi.sisi_mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Identificador en Play: no se puede cambiar después de publicar. Provisional hasta tener
        // el nombre comercial (docs/pendientes.md); el release lo fija con -PAPP_ID=...
        applicationId = (project.findProperty("APP_ID") as String?) ?: "bo.sisi.sisi_mobile"
        // Nombre visible bajo el ícono (-PAPP_NAME=...; provisional "SISI").
        manifestPlaceholders["appName"] = (project.findProperty("APP_NAME") as String?) ?: "SISI"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Llave de Maps de la APP restringida a este paquete y su huella SHA-1 (ADR-0021).
        // Se pasa al compilar: -PMAPS_API_KEY=... o la variable de entorno MAPS_API_KEY.
        manifestPlaceholders["mapsApiKey"] =
            (project.findProperty("MAPS_API_KEY") as String?) ?: System.getenv("MAPS_API_KEY") ?: ""
    }

    signingConfigs {
        if (releaseStoreFile != null) {
            create("release") {
                storeFile = file(releaseStoreFile)
                storePassword = signingValue("ANDROID_KEYSTORE_PASSWORD", "storePassword")
                keyAlias = signingValue("ANDROID_KEY_ALIAS", "keyAlias")
                keyPassword = signingValue("ANDROID_KEY_PASSWORD", "keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = when {
                releaseStoreFile != null -> signingConfigs.getByName("release")
                // mobile-release exige la upload key: nunca se publica un build firmado con debug.
                requireReleaseSigning -> throw GradleException(
                    "Falta la upload key (ANDROID_KEYSTORE_PATH y demás). Ver docs/runbook.md, Android."
                )
                // En una máquina sin llave, "flutter run --release" sigue funcionando.
                else -> signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

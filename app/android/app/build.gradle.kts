plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.lollipopkit.unseen"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.lollipopkit.unseen"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // Android 10.
        minSdk = 29
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // flutter_appauth (through fl_lib) declares a redirect activity; unused here.
        manifestPlaceholders["appAuthRedirectScheme"] = applicationId!!
    }

    // The APK ships arm64-v8a alone, the ABI of the LiteRT libraries below
    // (Flutter sets its own abiFilters per build type).
    packaging { jniLibs { excludes += listOf("lib/armeabi-v7a/**", "lib/x86_64/**") } }
    // Keep bundled .tflite weights uncompressed in the APK for fast extraction.
    androidResources { noCompress += listOf("tflite", "onnx") }

    val releaseSigningVars = mapOf(
        "UNSEEN_KEYSTORE" to providers.environmentVariable("UNSEEN_KEYSTORE").orNull,
        "UNSEEN_KEYSTORE_PASSWORD" to providers.environmentVariable("UNSEEN_KEYSTORE_PASSWORD").orNull,
        "UNSEEN_KEY_ALIAS" to providers.environmentVariable("UNSEEN_KEY_ALIAS").orNull,
        "UNSEEN_KEY_PASSWORD" to providers.environmentVariable("UNSEEN_KEY_PASSWORD").orNull,
    )
    val anyReleaseSigningSet = releaseSigningVars.values.any { it != null }
    val releaseSigningConfig = if (anyReleaseSigningSet) {
        val missing = releaseSigningVars.filterValues { it.isNullOrBlank() }.keys
        if (missing.isNotEmpty()) {
            throw GradleException(
                "Incomplete Android release signing environment; missing or blank: ${missing.joinToString(", ")}",
            )
        }
        val unexpanded = releaseSigningVars.filterValues { it!!.startsWith("op://") }.keys
        if (unexpanded.isNotEmpty()) {
            throw GradleException(
                "Unexpanded 1Password references in Android signing environment (${unexpanded.joinToString(", ")}); run through app/tool/android-signing.sh",
            )
        }
        val storePath = releaseSigningVars.getValue("UNSEEN_KEYSTORE")!!.trim()
        val keystoreFile = rootProject.file(storePath)
        if (!keystoreFile.isFile || !keystoreFile.canRead()) {
            throw GradleException("Android release keystore is not a readable file: ${keystoreFile.path}")
        }
        signingConfigs.create("release") {
            storeFile = keystoreFile
            storePassword = releaseSigningVars.getValue("UNSEEN_KEYSTORE_PASSWORD")!!
            keyAlias = releaseSigningVars.getValue("UNSEEN_KEY_ALIAS")!!.trim()
            keyPassword = releaseSigningVars.getValue("UNSEEN_KEY_PASSWORD")!!
        }
    } else {
        null
    }

    buildTypes {
        release {
            // Production builds run through app/tool/android-signing.sh (1Password);
            // local `flutter run --release` with no UNSEEN_KEY* env vars falls back to debug.
            signingConfig = releaseSigningConfig ?: signingConfigs.getByName("debug")
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

// libLiteRt.so and its GPU accelerator, which unseen-infer dlopens for the
// .tflite release (crates/unseen-infer/src/litert.rs). Only these two: the
// AARs' Java API, and the Play asset delivery / WorkManager it pulls in, are
// unused (WorkManager's Room database crashed the R8 release at startup).
val litert: Configuration by configurations.creating { isTransitive = false }

dependencies {
    litert("com.google.ai.edge.litert:litert:2.3.2@aar")
    litert("com.google.ai.edge.litert:litert-gpu:2.3.2@aar")
}

val litertJni = layout.buildDirectory.dir("litert/jni")
val litertLibs by tasks.registering(Sync::class) {
    from(provider { litert.files.map { zipTree(it) } }) {
        include("jni/arm64-v8a/libLiteRt.so", "jni/arm64-v8a/libLiteRtClGlAccelerator.so")
        eachFile { path = path.removePrefix("jni/") }
    }
    includeEmptyDirs = false
    into(litertJni)
}
android.sourceSets.getByName("main").jniLibs.srcDir(litertJni.get().asFile)

// Bundle the pinned LiteRT detector (.tflite + .json sidecar) from models/manifest.toml
// into APK assets so the app works completely offline without committing weights to git.
val bundledModelAssets = layout.buildDirectory.dir("unseen-model/assets")
val bundleModel by tasks.registering(Exec::class) {
    val dest = bundledModelAssets.get().dir("models").asFile
    outputs.dir(bundledModelAssets)
    inputs.file(rootProject.file("../../models/manifest.toml"))
    inputs.file(rootProject.file("../tool/bundle-model.sh"))
    commandLine("bash", rootProject.file("../tool/bundle-model.sh").absolutePath, "litert", dest.absolutePath)
}
android.sourceSets.getByName("main").assets.srcDir(bundledModelAssets.get().asFile)
tasks.named("preBuild") { dependsOn(litertLibs, bundleModel) }

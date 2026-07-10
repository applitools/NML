plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
}

android {
    namespace = "com.applitools.accessibilitytest"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.applitools.accessibilitytest"
        minSdk = 26
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

        buildConfigField("String", "APPLITOOLS_API_KEY", "\"${System.getenv("APPLITOOLS_API_KEY") ?: ""}\"")

        // Read by applitools-android's ApplitoolsMobile.init() via AndroidManifest
        // <meta-data> (com.applitools.API_KEY) since ActivityScenarioRule launches
        // MainActivity with a plain Intent - there's no APPLITOOLS intent extra to
        // carry the key, so the manifest fallback is what actually wires NML up.
        manifestPlaceholders["applitoolsApiKey"] = System.getenv("APPLITOOLS_API_KEY") ?: ""
    }

    buildFeatures {
        buildConfig = true
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }
}

dependencies {
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.androidx.constraintlayout)
    implementation("com.applitools:applitools-android:+")

    androidTestImplementation(libs.androidx.test.junit)
    androidTestImplementation(libs.androidx.test.espresso.core)
    androidTestImplementation(libs.androidx.test.runner)
    androidTestImplementation("com.applitools:eyes-android-espresso:+")
}

buildscript {
    val kotlinVersion = "2.1.20"
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

val doordeckSdkVersion = "0.86.0"

plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

group = "com.doordeck.doordeckHeadlessSdkFlutter"
version = "0.0.0"

repositories {
    google()
    mavenCentral()
}

android {
    compileSdk = 34

    namespace = "com.doordeck.doordeckHeadlessSdkFlutter"

    defaultConfig {
        minSdk = 24
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    tasks.withType<KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = "17"
        }
    }

    sourceSets["main"].java.srcDirs("src/main/kotlin")
    sourceSets["test"].java.srcDirs("src/test/kotlin")

    testOptions {
        unitTests.all {
            it.useJUnitPlatform()
            it.testLogging.apply {
                events("passed", "skipped", "failed", "standardOut", "standardError")
                showStandardStreams = true
            }
        }
    }
}

dependencies {
    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.mockito:mockito-core:5.0.0")

    implementation("com.doordeck.headless.sdk:doordeck-sdk-android:$doordeckSdkVersion")
}
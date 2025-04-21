// Top of the file
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.3")  // Android Gradle Plugin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.20")
        classpath("com.google.gms:google-services:4.4.1")  // Kotlin plugin
    }
}
plugins {
    id("org.jetbrains.kotlin.android") version "2.1.20" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val kotlinVersion = "2.1.20"

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
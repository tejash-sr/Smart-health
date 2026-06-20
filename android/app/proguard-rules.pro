# ─── Pulse Engage — ProGuard / R8 rules ──────────────────────────────────────
#
# Conservative rules: we minify + shrink the app and keep just enough symbols
# for Flutter engine, plugins and our own reflection-based code paths to keep
# working in release.

# ─── Flutter engine ─────────────────────────────────────────────────────────
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# ─── Kotlin metadata (used by reflection at runtime) ─────────────────────────
-keep class kotlin.Metadata { *; }
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# ─── AndroidX core ──────────────────────────────────────────────────────────
-keep class androidx.lifecycle.** { *; }
-dontwarn androidx.**

# ─── Pedometer plugin (V6 step sensor) ──────────────────────────────────────
-keep class com.pravera.pedometer.** { *; }
-dontwarn com.pravera.pedometer.**

# ─── Permission handler ─────────────────────────────────────────────────────
-keep class com.baseflow.permissionhandler.** { *; }
-dontwarn com.baseflow.permissionhandler.**

# ─── HTTP client (Dart-side, but keep OkHttp for plugins) ───────────────────
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# ─── Suppress noise from optional deps ──────────────────────────────────────
-dontwarn javax.annotation.**
-dontwarn org.jetbrains.annotations.**

# ─── Keep all native methods (JNI / FFI) ────────────────────────────────────
-keepclasseswithmembernames class * {
    native <methods>;
}

# ─── Keep Parcelable CREATOR fields (needed for Activity-to-Activity passing)
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# ─── Keep enum valueOf / values (used by JSON serialisation) ────────────────
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ─── Preserve source file + line numbers for usable stack traces ────────────
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

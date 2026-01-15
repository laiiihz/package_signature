package tech.laihz.package_signature

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.Signature
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** PackageSignaturePlugin */
class PackageSignaturePlugin : FlutterPlugin, PackagePortal {
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        PackagePortal.setUp(flutterPluginBinding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        PackagePortal.setUp(binding.binaryMessenger, null)
    }

    override fun appSignature(): ByteArray? {
        val packageName = context.packageName
        val packageManager = context.packageManager

        return try {
            // 1. Get the PackageInfo using the correct flags for the OS version
            val packageInfo = when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU -> {
                    // Android 13+ (API 33+)
                    packageManager.getPackageInfo(
                        packageName, 
                        PackageManager.PackageInfoFlags.of(PackageManager.GET_SIGNING_CERTIFICATES.toLong())
                    )
                }
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.P -> {
                    // Android 9 to 12 (API 28-32)
                    @Suppress("DEPRECATION")
                    packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNING_CERTIFICATES)
                }
                else -> {
                    // Android 4.1 to 8.1 (API 16-27)
                    @Suppress("DEPRECATION")
                    packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
                }
            }

            // 2. Extract the actual bytes safely
            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.P -> {
                    // Modern signingInfo (API 28+)
                    val signingInfo = packageInfo?.signingInfo ?: return null
                    if (signingInfo.hasMultipleSigners()) {
                        signingInfo.apkContentsSigners?.firstOrNull()?.toByteArray()
                    } else {
                        signingInfo.signingCertificateHistory?.firstOrNull()?.toByteArray()
                    }
                }
                else -> {
                    // Legacy signatures (API 16-27)
                    @Suppress("DEPRECATION")
                    packageInfo?.signatures?.firstOrNull()?.toByteArray()
                }
            }
        } catch (e: Exception) {
            null // Return null instead of crashing if anything goes wrong
        }
    }
}
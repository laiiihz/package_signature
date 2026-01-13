package tech.laihz.package_signature

import PackagePortal
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
            val packageInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                // Modern Way (Android 13+) - No Warning
                packageManager.getPackageInfo(
                    packageName, 
                    PackageManager.PackageInfoFlags.of(PackageManager.GET_SIGNING_CERTIFICATES.toLong())
                )
            } else {
                // Legacy Way (Android 9 to 12)
                @Suppress("DEPRECATION")
                packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNING_CERTIFICATES)
            }

            // Get the signer bytes safely using signingInfo (the replacement for .signatures)
            val signingInfo = packageInfo?.signingInfo
            if (signingInfo == null) return null

            if (signingInfo.hasMultipleSigners()) {
                signingInfo.apkContentsSigners?.firstOrNull()?.toByteArray()
            } else {
                signingInfo.signingCertificateHistory?.firstOrNull()?.toByteArray()
            }
        } catch (e: Exception) {
            null
        }
    }
}
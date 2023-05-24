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
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


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

    @SuppressLint("PackageManagerGetSignatures")
    override fun appSignature(): ByteArray? {
        if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.P) {
            val packageInfo = context.packageManager.getPackageInfo(context.packageName, PackageManager.GET_SIGNATURES)
            return if(packageInfo.signatures.isEmpty()) {
                null
            } else {
                packageInfo.signatures.first().toByteArray()
            }
        } else {
            val packageInfo: PackageInfo = context.packageManager.getPackageInfo(context.packageName, PackageManager.GET_SIGNING_CERTIFICATES)
            val signer = packageInfo.signingInfo.apkContentsSigners
            return if(signer.isEmpty()) {
                null
            }else {
                signer.first().toByteArray()
            }
        }
    }


}

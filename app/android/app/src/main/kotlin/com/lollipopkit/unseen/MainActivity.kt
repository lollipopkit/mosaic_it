package com.lollipopkit.unseen

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    /** Chosen launcher icon, applied in [onStop]. */
    private var pendingIcon: String? = null
    private val ioExecutor = Executors.newSingleThreadExecutor()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.lollipopkit.unseen/app_icon")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "get" -> result.success(
                        pendingIcon ?: launcherIcons().firstNotNullOfOrNull { (name, on) -> name.takeIf { on } },
                    )
                    "set" -> {
                        val name = call.arguments as? String
                        if (name == null || name !in launcherIcons()) {
                            result.error("app_icon", "No launcher icon named $name", null)
                        } else {
                            pendingIcon = name
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.lollipopkit.unseen/bundled_model")
            .setMethodCallHandler { call, result ->
                if (call.method != "extract") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val dirPath = call.argument<String>("dir")
                if (dirPath.isNullOrEmpty()) {
                    result.error("bundled_model", "Missing dir", null)
                    return@setMethodCallHandler
                }
                if (ioExecutor.isShutdown) {
                    result.error("bundled_model", "Activity is shutting down", null)
                    return@setMethodCallHandler
                }
                ioExecutor.execute {
                    try {
                        val path = extractBundledModel(File(dirPath))
                        runOnUiThread { result.success(path) }
                    } catch (e: Exception) {
                        runOnUiThread { result.error("bundled_model", e.message ?: e.toString(), null) }
                    }
                }
            }
    }

    /** Copies the bundled `.tflite`, `.json` sidecar, and `bundled.stamp` from APK assets into [destDir] when missing or updated. */
    private fun extractBundledModel(destDir: File): String? {
        val assetFiles = assets.list("models")?.toSet().orEmpty()
        val modelName = assetFiles.firstOrNull { it.endsWith(".tflite") } ?: return null
        val sidecarName = "$modelName.json"
        if (sidecarName !in assetFiles) return null
        destDir.mkdirs()

        val dstModel = File(destDir, modelName)
        val dstSidecar = File(destDir, sidecarName)
        val dstStamp = File(destDir, "bundled.stamp")
        val bundledStampBytes = if ("bundled.stamp" in assetFiles) {
            assets.open("models/bundled.stamp").use { it.readBytes() }
        } else {
            assets.open("models/$sidecarName").use { it.readBytes() }
        }

        val upToDate = dstModel.isFile &&
            dstSidecar.isFile &&
            dstStamp.isFile &&
            dstStamp.readBytes().contentEquals(bundledStampBytes)
        if (!upToDate) {
            val bundledSidecarBytes = assets.open("models/$sidecarName").use { it.readBytes() }
            val tmpModel = File(destDir, "$modelName.tmp")
            val tmpSidecar = File(destDir, "$sidecarName.tmp")
            val tmpStamp = File(destDir, "bundled.stamp.tmp")
            try {
                // Remove stale models from earlier releases before extracting.
                destDir.listFiles()?.forEach { f ->
                    if (f.isFile && f.name != tmpModel.name && f.name != tmpSidecar.name && f.name != tmpStamp.name) {
                        f.delete()
                    }
                }
                assets.open("models/$modelName").use { input ->
                    tmpModel.outputStream().use { output -> input.copyTo(output, 65536) }
                }
                tmpSidecar.writeBytes(bundledSidecarBytes)
                tmpStamp.writeBytes(bundledStampBytes)

                moveAtomically(tmpModel, dstModel)
                moveAtomically(tmpSidecar, dstSidecar)
                // Write stamp last so an interrupted extraction is detected on next launch.
                moveAtomically(tmpStamp, dstStamp)
            } finally {
                tmpModel.delete()
                tmpSidecar.delete()
                tmpStamp.delete()
            }
        }
        return dstModel.absolutePath
    }

    private fun moveAtomically(src: File, dst: File) {
        if (!src.renameTo(dst)) {
            src.copyTo(dst, overwrite = true)
            src.delete()
        }
    }

    override fun onDestroy() {
        ioExecutor.shutdown()
        super.onDestroy()
    }

    // Disabling the alias a visible task was started from closes that task on
    // many launchers, so the switch waits until the app is in the background.
    override fun onStop() {
        pendingIcon?.let { name ->
            // Enable first: the launcher must never see no entry.
            for (icon in launcherIcons().keys.sortedByDescending { it == name }) {
                packageManager.setComponentEnabledSetting(
                    ComponentName(this, ICON_PREFIX + icon),
                    if (icon == name) PackageManager.COMPONENT_ENABLED_STATE_ENABLED
                    else PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                    PackageManager.DONT_KILL_APP,
                )
            }
            pendingIcon = null
        }
        super.onStop()
    }

    /** The manifest's launcher aliases by icon name, and whether each is enabled. */
    private fun launcherIcons(): Map<String, Boolean> {
        val flags = PackageManager.GET_ACTIVITIES or PackageManager.MATCH_DISABLED_COMPONENTS
        return packageManager.getPackageInfo(packageName, flags).activities.orEmpty()
            .filter { it.name.startsWith(ICON_PREFIX) }
            .associate { info ->
                val state = packageManager.getComponentEnabledSetting(ComponentName(this, info.name))
                info.name.removePrefix(ICON_PREFIX) to when (state) {
                    PackageManager.COMPONENT_ENABLED_STATE_DEFAULT -> info.enabled
                    else -> state == PackageManager.COMPONENT_ENABLED_STATE_ENABLED
                }
            }
    }

    private companion object {
        val ICON_PREFIX = MainActivity::class.java.name.substringBeforeLast('.') + ".icon."
    }
}

package com.lollipopkit.unseen

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    /** Chosen launcher icon, applied in [onStop]. */
    private var pendingIcon: String? = null

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

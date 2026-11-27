package com.lollipopkit.unseen

import android.app.Activity
import android.content.ClipData
import android.content.ClipboardManager
import android.content.ComponentName
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.ImageDecoder
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.ext.SdkExtensions
import android.provider.MediaStore
import android.provider.OpenableColumns
import android.webkit.MimeTypeMap
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.UUID
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    /** Chosen launcher icon, applied in [onStop]. */
    private var pendingIcon: String? = null
    private val ioExecutor = Executors.newSingleThreadExecutor()
    private var platformChannel: MethodChannel? = null
    @Volatile
    private var dartReady = false
    private val pendingIncoming = mutableListOf<String>()
    private var pendingPickResult: MethodChannel.Result? = null
    private val launchId = UUID.randomUUID().toString()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        cleanupStaleIncomingDirs()
        val fromHistory = (intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY) != 0
        if (savedInstanceState == null && !fromHistory) {
            handleShareIntent(intent)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleShareIntent(intent)
    }

    @Suppress("DEPRECATION")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQ_PICK_MEDIA) {
            val callback = pendingPickResult
            pendingPickResult = null
            if (callback == null) return
            if (resultCode != Activity.RESULT_OK || data == null || ioExecutor.isShutdown) {
                callback.success(emptyList<String>())
                return
            }
            val uris = buildList {
                data.clipData?.let { clip ->
                    for (i in 0 until clip.itemCount) {
                        clip.getItemAt(i).uri?.let(::add)
                    }
                }
                if (isEmpty()) {
                    data.data?.let(::add)
                }
            }
            if (uris.isEmpty()) {
                callback.success(emptyList<String>())
                return
            }
            ioExecutor.execute {
                val copied = try {
                    uris.mapNotNull(::copyUriToIncomingCache)
                } catch (_: Throwable) {
                    emptyList()
                }
                runOnUiThread { callback.success(copied) }
            }
            return
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    private fun cleanupStaleIncomingDirs() {
        if (ioExecutor.isShutdown) return
        val keep = launchId
        ioExecutor.execute {
            runCatching {
                val root = File(cacheDir, "incoming")
                root.listFiles()?.forEach { entry ->
                    if (entry.name != keep) {
                        entry.deleteRecursively()
                    }
                }
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(messenger, "com.lollipopkit.unseen/app_icon")
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
        MethodChannel(messenger, "com.lollipopkit.unseen/bundled_model")
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
                    } catch (e: Throwable) {
                        runOnUiThread { result.error("bundled_model", e.message ?: e.toString(), null) }
                    }
                }
            }
        val channel = MethodChannel(messenger, "com.lollipopkit.unseen/platform")
        platformChannel = channel
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "pickMedia" -> {
                    val multiple = call.argument<Boolean>("multiple") ?: true
                    val allowVideo = call.argument<Boolean>("allowVideo") ?: true
                    launchSystemMediaPicker(multiple, allowVideo, result)
                }
                "copyImage" -> {
                    val path = call.argument<String>("path")
                    if (path.isNullOrEmpty() || ioExecutor.isShutdown) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    ioExecutor.execute {
                        val staged = try {
                            stageClipboardFile(File(path))
                        } catch (_: Throwable) {
                            null
                        }
                        runOnUiThread {
                            val ok = staged != null && setClipboardImage(staged)
                            result.success(ok)
                        }
                    }
                }
                "saveImage" -> {
                    val path = call.argument<String>("path")
                    if (path.isNullOrEmpty() || ioExecutor.isShutdown) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    ioExecutor.execute {
                        val ok = try {
                            saveImageToMediaStore(File(path))
                        } catch (_: Throwable) {
                            false
                        }
                        runOnUiThread { result.success(ok) }
                    }
                }
                "prepareImage" -> {
                    val path = call.argument<String>("path")
                    if (path.isNullOrEmpty() || ioExecutor.isShutdown) {
                        result.success(null)
                        return@setMethodCallHandler
                    }
                    ioExecutor.execute {
                        val prepared = try {
                            prepareLocalImage(File(path))
                        } catch (_: Throwable) {
                            null
                        }
                        runOnUiThread { result.success(prepared) }
                    }
                }
                "getIncomingFiles" -> {
                    dartReady = true
                    val items = synchronized(pendingIncoming) {
                        val copy = pendingIncoming.toList()
                        pendingIncoming.clear()
                        copy
                    }
                    result.success(items)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun openDocumentIntent(multiple: Boolean, allowVideo: Boolean): Intent {
        return Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = if (allowVideo) "*/*" else "image/*"
            if (allowVideo) {
                putExtra(Intent.EXTRA_MIME_TYPES, arrayOf("image/*", "video/*"))
            }
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, multiple)
        }
    }

    @Suppress("DEPRECATION")
    private fun launchSystemMediaPicker(
        multiple: Boolean,
        allowVideo: Boolean,
        result: MethodChannel.Result,
    ) {
        if (pendingPickResult != null) {
            result.success(emptyList<String>())
            return
        }
        val hasPhotoPicker = Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ||
            (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R &&
                SdkExtensions.getExtensionVersion(Build.VERSION_CODES.R) >= 2)
        val candidates = buildList {
            if (hasPhotoPicker) {
                add(
                    Intent(MediaStore.ACTION_PICK_IMAGES).apply {
                        if (!allowVideo) type = "image/*"
                        if (multiple) {
                            putExtra(MediaStore.EXTRA_PICK_IMAGES_MAX, MediaStore.getPickImagesMaxLimit())
                        }
                    },
                )
            }
            add(openDocumentIntent(multiple, allowVideo))
        }
        pendingPickResult = result
        for (candidate in candidates) {
            try {
                startActivityForResult(candidate, REQ_PICK_MEDIA)
                return
            } catch (_: Throwable) {
                // Fall back to ACTION_OPEN_DOCUMENT if ACTION_PICK_IMAGES is unavailable.
            }
        }
        pendingPickResult = null
        result.success(emptyList<String>())
    }

    private fun handleShareIntent(intent: Intent?) {
        if (intent == null || ioExecutor.isShutdown) return
        val uris = extractShareUris(intent)
        if (uris.isEmpty()) return
        // Mark consumed so configuration changes or relaunches do not replay it.
        intent.action = Intent.ACTION_MAIN
        intent.removeExtra(Intent.EXTRA_STREAM)
        intent.clipData = null
        ioExecutor.execute {
            val copied = try {
                uris.mapNotNull(::copyUriToIncomingCache)
            } catch (_: Throwable) {
                emptyList()
            }
            if (copied.isEmpty()) return@execute
            runOnUiThread {
                val ch = platformChannel
                if (dartReady && ch != null) {
                    ch.invokeMethod("onIncomingFiles", copied)
                } else {
                    synchronized(pendingIncoming) { pendingIncoming.addAll(copied) }
                }
            }
        }
    }

    private fun extractShareUris(intent: Intent): List<Uri> {
        val fromExtra = when (intent.action) {
            Intent.ACTION_SEND -> {
                val u = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
                } else {
                    @Suppress("DEPRECATION")
                    intent.getParcelableExtra(Intent.EXTRA_STREAM)
                }
                listOfNotNull(u)
            }
            Intent.ACTION_SEND_MULTIPLE -> {
                val list = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM, Uri::class.java)
                } else {
                    @Suppress("DEPRECATION")
                    intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM)
                }
                list.orEmpty()
            }
            else -> return emptyList()
        }
        if (fromExtra.isNotEmpty()) return fromExtra
        val clip = intent.clipData ?: return emptyList()
        return buildList {
            for (i in 0 until clip.itemCount) {
                clip.getItemAt(i).uri?.let(::add)
            }
        }
    }

    private fun copyUriToIncomingCache(uri: Uri): String? {
        val dir = File(File(cacheDir, "incoming"), launchId).apply { mkdirs() }
        var dst: File? = null
        return try {
            val mime = contentResolver.getType(uri)?.lowercase().orEmpty()
            val (displayName, sizeBytes) = queryMeta(uri)
            val ext = guessExtension(displayName, mime)
            val isVideo = mime.startsWith("video/") || ext in VIDEO_EXTS
            if (!isVideo && sizeBytes != null && sizeBytes > MAX_INCOMING_BYTES) {
                return null
            }
            val stem = sanitizeStem(displayName?.substringBeforeLast('.'))
            val isNativeImage = mime in NATIVE_IMAGE_MIMES ||
                (mime.isEmpty() && ext in NATIVE_IMAGE_EXTS)
            if (isVideo || isNativeImage) {
                val safeExt = if (isVideo) {
                    ext.ifEmpty { "mp4" }
                } else {
                    ext.ifEmpty {
                        when (mime) {
                            "image/png" -> "png"
                            "image/webp" -> "webp"
                            else -> "jpg"
                        }
                    }
                }
                val target = File(dir, uniqueFileName(stem, safeExt))
                dst = target
                contentResolver.openInputStream(uri)?.use { input ->
                    target.outputStream().use { output -> input.copyTo(output, 65536) }
                } ?: return null
                return target.absolutePath
            }
            val bitmap = decodeBitmap(uri) ?: return null
            val target = File(dir, uniqueFileName(stem, "jpg"))
            dst = target
            writeUprightJpeg(bitmap, target) ?: return null
            target.absolutePath
        } catch (_: Throwable) {
            dst?.delete()
            null
        }
    }

    private fun queryMeta(uri: Uri): Pair<String?, Long?> {
        var name: String? = null
        var size: Long? = null
        runCatching {
            contentResolver.query(
                uri,
                arrayOf(OpenableColumns.DISPLAY_NAME, OpenableColumns.SIZE),
                null,
                null,
                null,
            )?.use { c ->
                if (c.moveToFirst()) {
                    if (!c.isNull(0)) name = c.getString(0)
                    if (!c.isNull(1)) size = c.getLong(1)
                }
            }
        }
        return name to size
    }

    private fun decodeBitmap(uri: Uri): Bitmap? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val source = ImageDecoder.createSource(contentResolver, uri)
            ImageDecoder.decodeBitmap(source) { decoder, _, _ ->
                decoder.allocator = ImageDecoder.ALLOCATOR_SOFTWARE
            }
        } else {
            contentResolver.openInputStream(uri)?.use { BitmapFactory.decodeStream(it) }
        }
    }

    private fun writeUprightJpeg(bitmap: Bitmap, target: File): File? {
        var toCompress = bitmap
        var flat: Bitmap? = null
        try {
            if (bitmap.hasAlpha()) {
                val opaque = Bitmap.createBitmap(bitmap.width, bitmap.height, Bitmap.Config.ARGB_8888)
                Canvas(opaque).apply {
                    drawColor(Color.WHITE)
                    drawBitmap(bitmap, 0f, 0f, null)
                }
                flat = opaque
                toCompress = opaque
            }
            target.outputStream().use { output ->
                if (!toCompress.compress(Bitmap.CompressFormat.JPEG, 95, output)) {
                    target.delete()
                    return null
                }
            }
            return target
        } finally {
            flat?.recycle()
            bitmap.recycle()
        }
    }

    private fun guessExtension(displayName: String?, mime: String): String {
        val fromMime = if (mime.isNotEmpty()) {
            MimeTypeMap.getSingleton().getExtensionFromMimeType(mime)
        } else null
        val cleanedMime = sanitizeExtension(fromMime)
        if (cleanedMime.isNotEmpty()) {
            return if (cleanedMime == "jpeg") "jpg" else cleanedMime
        }
        if (displayName != null) {
            val dot = displayName.lastIndexOf('.')
            if (dot > 0 && dot < displayName.length - 1) {
                val cleaned = sanitizeExtension(displayName.substring(dot + 1))
                if (cleaned.isNotEmpty()) return cleaned
            }
        }
        return ""
    }

    private fun sanitizeExtension(raw: String?): String {
        if (raw.isNullOrEmpty()) return ""
        return raw.lowercase().filter { it in 'a'..'z' || it in '0'..'9' }.take(8)
    }

    private fun sanitizeStem(raw: String?): String {
        val cleaned = raw.orEmpty()
            .filter { it in 'a'..'z' || it in 'A'..'Z' || it in '0'..'9' || it == '-' || it == '_' }
            .take(40)
        return cleaned.ifEmpty { "image" }
    }

    private fun uniqueFileName(stem: String, ext: String): String {
        val suffix = UUID.randomUUID().toString().take(8)
        return "$stem-$suffix.$ext"
    }

    private fun stageClipboardFile(src: File): File? {
        if (!src.isFile) return null
        return try {
            val dir = File(cacheDir, "shared").apply { mkdirs() }
            dir.listFiles()?.forEach { f ->
                if (f.isFile && f.name.startsWith("clipboard-")) f.delete()
            }
            val ext = sanitizeExtension(src.extension).ifEmpty { "png" }
            val dst = File(dir, "clipboard-${UUID.randomUUID()}.$ext")
            src.copyTo(dst, overwrite = true)
            dst
        } catch (_: Throwable) {
            null
        }
    }

    private fun setClipboardImage(file: File): Boolean {
        return try {
            val uri = FileProvider.getUriForFile(this, "$packageName.fileprovider", file)
            val cm = getSystemService(Context.CLIPBOARD_SERVICE) as? ClipboardManager ?: return false
            cm.setPrimaryClip(ClipData.newUri(contentResolver, "Redacted image", uri))
            true
        } catch (_: Throwable) {
            false
        }
    }

    private fun saveImageToMediaStore(src: File): Boolean {
        if (!src.isFile) return false
        var insertedUri: Uri? = null
        return try {
            val ext = sanitizeExtension(src.extension).ifEmpty { "png" }
            val mime = when (ext) {
                "jpg", "jpeg" -> "image/jpeg"
                "webp" -> "image/webp"
                else -> "image/png"
            }
            val values = ContentValues().apply {
                put(MediaStore.Images.Media.DISPLAY_NAME, src.name)
                put(MediaStore.Images.Media.MIME_TYPE, mime)
                put(MediaStore.Images.Media.RELATIVE_PATH, "${Environment.DIRECTORY_PICTURES}/MosaicIt")
                put(MediaStore.Images.Media.IS_PENDING, 1)
            }
            val uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
                ?: return false
            insertedUri = uri
            contentResolver.openOutputStream(uri)?.use { output ->
                src.inputStream().use { input -> input.copyTo(output, 65536) }
            } ?: throw IllegalStateException("Could not open MediaStore stream")
            val done = ContentValues().apply {
                put(MediaStore.Images.Media.IS_PENDING, 0)
            }
            contentResolver.update(uri, done, null, null)
            true
        } catch (_: Throwable) {
            insertedUri?.let { uri -> runCatching { contentResolver.delete(uri, null, null) } }
            false
        }
    }

    private fun prepareLocalImage(src: File): String? {
        if (!src.isFile || src.length() > MAX_INCOMING_BYTES) return null
        val ext = sanitizeExtension(src.extension)
        if (ext in NATIVE_IMAGE_EXTS) return src.absolutePath
        val dir = File(File(cacheDir, "incoming"), launchId).apply { mkdirs() }
        var dst: File? = null
        return try {
            val bitmap = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                val source = ImageDecoder.createSource(src)
                ImageDecoder.decodeBitmap(source) { decoder, _, _ ->
                    decoder.allocator = ImageDecoder.ALLOCATOR_SOFTWARE
                }
            } else {
                BitmapFactory.decodeFile(src.absolutePath)
            } ?: return null
            val target = File(dir, uniqueFileName(sanitizeStem(src.nameWithoutExtension), "jpg"))
            dst = target
            writeUprightJpeg(bitmap, target) ?: return null
            target.absolutePath
        } catch (_: Throwable) {
            dst?.delete()
            null
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
        pendingPickResult?.success(emptyList<String>())
        pendingPickResult = null
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
        const val REQ_PICK_MEDIA = 4107
        const val MAX_INCOMING_BYTES = 256L * 1024 * 1024
        val ICON_PREFIX = MainActivity::class.java.name.substringBeforeLast('.') + ".icon."
        val NATIVE_IMAGE_MIMES = setOf("image/png", "image/jpeg", "image/jpg", "image/webp")
        val NATIVE_IMAGE_EXTS = setOf("png", "jpg", "jpeg", "webp")
        val VIDEO_EXTS = setOf(
            "mp4", "mov", "m4v", "mkv", "webm", "avi",
            "3gp", "3g2", "mpg", "mpeg", "ts",
        )
    }
}

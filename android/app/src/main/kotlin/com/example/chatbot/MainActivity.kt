package com.example.chatbot

import android.content.ContentValues
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
  private val CHANNEL = "app/download"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
      .setMethodCallHandler { call, result ->
        if (call.method == "saveToDownloads") {
          val filePath = call.argument<String>("filePath")
          val fileName = call.argument<String>("fileName")
          if (filePath == null || fileName == null) {
            result.error("ARG_ERROR", "filePath o fileName es null", null)
            return@setMethodCallHandler
          }

          try {
            // 1) Inserta un nuevo registro vacío en MediaStore.Downloads
            val resolver = contentResolver
            val values = ContentValues().apply {
              put(MediaStore.Downloads.DISPLAY_NAME, fileName)           // Nombre en Descargas
              put(MediaStore.Downloads.MIME_TYPE, "application/pdf")
              // Si API 29+, marca IS_PENDING = 1 para edición atómica
              if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                put(MediaStore.Downloads.IS_PENDING, 1)
              }
            }
            val collection = MediaStore.Downloads.getContentUri(
              MediaStore.VOLUME_EXTERNAL_PRIMARY
            )
            val itemUri = resolver.insert(collection, values)
              ?: throw Exception("No se pudo crear URI en MediaStore")

            // 2) Copia los bytes del fichero temporal al outputStream de ese URI
            resolver.openFileDescriptor(itemUri, "w", null).use { pfd ->
              FileInputStream(File(filePath)).use { input ->
                FileOutputStream(pfd!!.fileDescriptor).use { output ->
                  input.copyTo(output)
                }
              }
            }

            // 3) Si API 29+, marca IS_PENDING = 0 para hacerlo visible
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
              values.clear()
              values.put(MediaStore.Downloads.IS_PENDING, 0)
              resolver.update(itemUri, values, null, null)
            }

            result.success(true)
          } catch (e: Exception) {
            result.error("SAVE_ERROR", e.message, null)
          }
        } else {
          result.notImplemented()
        }
      }
  }
}

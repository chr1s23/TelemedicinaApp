package com.example.chatbot

import android.app.DownloadManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.MediaStore
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
  private val CHANNEL = "app/download"
  private val NOTIF_CHANNEL_ID = "download_complete"
  private val NOTIF_CHANNEL_NAME = "Descargas finalizadas"

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
            // 1) Insertar en MediaStore Downloads
            val resolver = contentResolver
            val values = ContentValues().apply {
              put(MediaStore.Downloads.DISPLAY_NAME, fileName)
              put(MediaStore.Downloads.MIME_TYPE, "application/pdf")
              if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                put(MediaStore.Downloads.IS_PENDING, 1)
              }
            }
            val collection = MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            val itemUri = resolver.insert(collection, values)
                ?: throw Exception("No se pudo crear URI en MediaStore")

            // 2) Copiar bytes al URI abierto
            resolver.openFileDescriptor(itemUri, "w", null).use { pfd ->
              FileInputStream(File(filePath)).use { input ->
                FileOutputStream(pfd!!.fileDescriptor).use { output ->
                  input.copyTo(output)
                }
              }
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
              values.clear()
              values.put(MediaStore.Downloads.IS_PENDING, 0)
              resolver.update(itemUri, values, null, null)
            }

            // 3) Crear canal de notificación (Android O+)
            val notifMgr = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
              val chan = NotificationChannel(
                NOTIF_CHANNEL_ID,
                NOTIF_CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
              )
              notifMgr.createNotificationChannel(chan)
            }

            // 4) Intent para abrir el PDF
            val openIntent = Intent(Intent.ACTION_VIEW).apply {
              setDataAndType(itemUri, "application/pdf")
              flags = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK
            }
            val pendingIntent = PendingIntent.getActivity(
              this,
              0,
              openIntent,
              PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // 5) Disparar la notificación
            val notification = NotificationCompat.Builder(this, NOTIF_CHANNEL_ID)
              .setSmallIcon(android.R.drawable.stat_sys_download_done)
              .setContentTitle(fileName)
              .setContentText("Descarga completada")
              .setContentIntent(pendingIntent)
              .setAutoCancel(true)
              .build()
            notifMgr.notify(1001, notification)

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

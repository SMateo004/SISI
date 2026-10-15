package bo.sisi.sisi_mobile

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannel()
    }

    /**
     * Canal de los avisos push (ADR-0027). El backend envía con channelId "sisi_avisos" y
     * el manifiesto lo declara como canal por defecto de FCM.
     */
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val channel = NotificationChannel(
            "sisi_avisos",
            "Avisos de SISI",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = "Solicitudes cercanas, ofertas y cambios en tus trabajos"
        }
        getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
    }
}

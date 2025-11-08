package com.example.shake_quote_app

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import kotlin.math.sqrt

class MainActivity : FlutterActivity() {
    private val SHAKE_CHANNEL = "com.example/shake"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SHAKE_CHANNEL)
            .setStreamHandler(ShakeStreamHandler(this))
    }
}

class ShakeStreamHandler(private val context: Context) : EventChannel.StreamHandler {
    private var sensorManager: SensorManager? = null
    private var accelerometer: Sensor? = null
    private var shakeListener: SensorEventListener? = null
    private var shakeCount = 0
    
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        
        shakeListener = object : SensorEventListener {
            private var lastShakeTime = 0L
            
            override fun onSensorChanged(event: SensorEvent?) {
                if (event == null) return
                
                val x = event.values[0]
                val y = event.values[1]
                val z = event.values[2]
                
                val gForce = sqrt(x * x + y * y + z * z) / SensorManager.GRAVITY_EARTH
                
                if (gForce > 2.7) {
                    val now = System.currentTimeMillis()
                    if (now - lastShakeTime > 800) {
                        lastShakeTime = now
                        shakeCount++
                        
                        val data = mapOf(
                            "count" to shakeCount,
                            "gForce" to gForce,
                            "timestampMs" to now
                        )
                        events?.success(data)
                    }
                }
            }
            
            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
        }
        
        sensorManager?.registerListener(
            shakeListener,
            accelerometer,
            SensorManager.SENSOR_DELAY_UI
        )
    }
    
    override fun onCancel(arguments: Any?) {
        sensorManager?.unregisterListener(shakeListener)
        shakeListener = null
        sensorManager = null
    }
}


package com.example.launchpad_app

import android.media.AudioAttributes
import android.media.SoundPool
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "launchpad_app/sound_pool"
    private val maxStreams = 16

    private var soundPool: SoundPool? = null
    private val soundIds = mutableMapOf<String, Int>()
    private val loadingIds = mutableMapOf<String, Int>()
    private val soundIdToTrack = mutableMapOf<Int, String>()
    private val pendingResults = mutableMapOf<Int, MutableList<MethodChannel.Result>>()
    private val pendingPlays = mutableMapOf<String, MutableList<PlayRequest>>()
    private val streamIds = mutableMapOf<String, MutableList<Int>>()

    private data class PlayRequest(
        val volume: Float,
        val rate: Float,
    )

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        ensureSoundPool()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "load" -> loadSound(
                    call.argument<String>("trackID"),
                    call.argument<String>("filePath"),
                    result,
                )
                "play" -> {
                    playSound(
                        call.argument<String>("trackID"),
                        (call.argument<Number>("volume") ?: 1.0).toFloat(),
                        (call.argument<Number>("pitch") ?: 1.0).toFloat(),
                    )
                    result.success(null)
                }
                "stop" -> {
                    stopSound(call.argument<String>("trackID"))
                    result.success(null)
                }
                "stopAll" -> {
                    stopAllSounds()
                    result.success(null)
                }
                "dispose" -> {
                    resetSoundPool()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun ensureSoundPool(): SoundPool {
        soundPool?.let { return it }

        val attributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_GAME)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        val pool = SoundPool.Builder()
            .setMaxStreams(maxStreams)
            .setAudioAttributes(attributes)
            .build()

        pool.setOnLoadCompleteListener { loadedPool, sampleId, status ->
            val trackID = soundIdToTrack[sampleId]
            val results = pendingResults.remove(sampleId)

            if (status == 0 && trackID != null) {
                soundIds[trackID] = sampleId
                loadingIds.remove(trackID)
                results?.forEach { it.success(null) }
                pendingPlays.remove(trackID)?.forEach { request ->
                    playLoadedSound(loadedPool, trackID, sampleId, request.volume, request.rate)
                }
            } else {
                if (trackID != null) loadingIds.remove(trackID)
                results?.forEach {
                    it.error("LOAD_FAILED", "Could not load sound sample.", null)
                }
            }
        }

        soundPool = pool
        return pool
    }

    private fun loadSound(trackID: String?, filePath: String?, result: MethodChannel.Result) {
        if (trackID == null || filePath == null) {
            result.error("BAD_ARGS", "trackID and filePath are required.", null)
            return
        }

        if (soundIds.containsKey(trackID)) {
            result.success(null)
            return
        }

        val existingLoadId = loadingIds[trackID]
        if (existingLoadId != null) {
            pendingResults.getOrPut(existingLoadId) { mutableListOf() }.add(result)
            return
        }

        try {
            val pool = ensureSoundPool()
            val assetKey = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(filePath)
            val descriptor = assets.openFd(assetKey)
            val soundId = pool.load(descriptor, 1)
            descriptor.close()

            loadingIds[trackID] = soundId
            soundIdToTrack[soundId] = trackID
            pendingResults[soundId] = mutableListOf(result)
        } catch (e: Exception) {
            result.error("LOAD_FAILED", e.message, null)
        }
    }

    private fun playSound(trackID: String?, volume: Float, rate: Float) {
        if (trackID == null) return

        val loadedSoundId = soundIds[trackID]
        if (loadedSoundId != null) {
            playLoadedSound(ensureSoundPool(), trackID, loadedSoundId, volume, rate)
            return
        }

        if (loadingIds.containsKey(trackID)) {
            pendingPlays.getOrPut(trackID) { mutableListOf() }.add(
                PlayRequest(
                    volume.coerceIn(0f, 1f),
                    rate.coerceIn(0.5f, 2f),
                )
            )
        }
    }

    private fun playLoadedSound(
        pool: SoundPool,
        trackID: String,
        soundId: Int,
        volume: Float,
        rate: Float,
    ) {
        val streamId = pool.play(
            soundId,
            volume.coerceIn(0f, 1f),
            volume.coerceIn(0f, 1f),
            1,
            0,
            rate.coerceIn(0.5f, 2f),
        )

        if (streamId != 0) {
            streamIds.getOrPut(trackID) { mutableListOf() }.add(streamId)
        }
    }

    private fun stopSound(trackID: String?) {
        if (trackID == null) return

        val pool = soundPool ?: return
        streamIds.remove(trackID)?.forEach { streamId ->
            pool.stop(streamId)
        }
    }

    private fun stopAllSounds() {
        val pool = soundPool ?: return
        streamIds.values.flatten().forEach { streamId ->
            pool.stop(streamId)
        }
        streamIds.clear()
    }

    private fun resetSoundPool() {
        soundPool?.release()
        soundPool = null
        soundIds.clear()
        loadingIds.clear()
        soundIdToTrack.clear()
        pendingResults.clear()
        pendingPlays.clear()
        streamIds.clear()
        ensureSoundPool()
    }

    override fun onDestroy() {
        soundPool?.release()
        soundPool = null
        super.onDestroy()
    }
}

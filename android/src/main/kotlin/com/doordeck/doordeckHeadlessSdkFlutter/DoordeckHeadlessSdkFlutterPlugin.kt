package com.doordeck.doordeckHeadlessSdkFlutter

import com.doordeck.multiplatform.sdk.ApplicationContext
import com.doordeck.multiplatform.sdk.Doordeck
import com.doordeck.multiplatform.sdk.KDoordeckFactory
import com.doordeck.multiplatform.sdk.config.SdkConfig
import com.doordeck.multiplatform.sdk.model.data.LockOperations
import com.doordeck.multiplatform.sdk.model.responses.AssistedRegisterEphemeralKeyResponse
import com.doordeck.multiplatform.sdk.model.responses.TileLocksResponse
import com.doordeck.multiplatform.sdk.model.responses.UserDetailsResponse
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** DoordeckHeadlessSdkFlutterPlugin */
class DoordeckHeadlessSdkFlutterPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var doordeckSdk: Doordeck

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "doordeck_headless_sdk_flutter")
        channel.setMethodCallHandler(this)

        doordeckSdk = KDoordeckFactory.initialize(
            SdkConfig.Builder()
                .setApplicationContext(ApplicationContext.apply { set(flutterPluginBinding.applicationContext)})
                .build()
        )
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        return when (call.method) {
            "login" -> login(call, result)
            "setAuthToken" -> setAuthToken(call, result)
            "verify" -> verify(call, result)
            "logout" -> logout(result)
            "getUserDetails" -> getUserDetails(result)
            "getLocksBelongingToTile" -> getLocksBelongingToTile(call, result)
            "unlockDevice" -> unlockDevice(call, result)
            else -> result.notImplemented()
        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    /**
     * Auth operations
     */

    private fun login(call: MethodCall, result: Result) {
        val email = call.argument<String>("email")!!
        val password = call.argument<String>("password")!!
        setKeyPairIfNeeded()

        doordeckSdk.accountless().loginAsync(email, password)
            .thenApply {
                respondNeedsVerification(result)
            }
            .exceptionally { error ->
                result.error("LOGIN_ERROR", "", error)
            }
    }

    private fun setAuthToken(call: MethodCall, result: Result) {
        val authToken = call.argument<String>("authToken")!!
        setKeyPairIfNeeded()

        doordeckSdk.contextManager().setCloudAuthToken(authToken)
        respondNeedsVerification(result)
    }

    private fun verify(call: MethodCall, result: Result) {
        val code = call.argument<String>("code")!!
        doordeckSdk.account().verifyEphemeralKeyRegistrationAsync(code)
            .thenApply {
                result.success(null)
            }
            .exceptionally { error ->
                result.error("VERIFY_ERROR", "", error)
            }
    }

    private fun logout(result: Result) {
        doordeckSdk.account().logoutAsync()
            .thenApply {
                result.success(null)
            }
            .exceptionally { error ->
                result.error("LOGOUT_ERROR", "", error)
            }
    }

    /**
     * User operations
     */
    private fun getUserDetails(result: Result) {
        doordeckSdk.account().getUserDetailsAsync()
            .thenApply { response ->
                result.success(response.toNativeMap(
                    userId = doordeckSdk.contextManager().getUserId(),
                    certificateChainAboutToExpire = doordeckSdk.contextManager().isCertificateChainAboutToExpire(),
                    tokenAboutToExpire = doordeckSdk.contextManager().isCloudAuthTokenAboutToExpire(),
                ))
            }
            .exceptionally {  error ->
                result.error("USER_DETAILS_ERROR", "", error)
            }
    }

    /**
     * Device and tile operations
     */

    private fun getLocksBelongingToTile(call: MethodCall, result: Result) {
        val tileId = call.argument<String>("tileId")!!
        doordeckSdk.tiles().getLocksBelongingToTileAsync(tileId)
            .thenApply { response ->
                result.success(response.toNativeMap())
            }
            .exceptionally { error ->
                result.error("LOCKS_ERROR", "", error)
            }
    }

    private fun unlockDevice(call: MethodCall, result: Result) {
        val lockId = call.argument<String>("lockId")!!
        doordeckSdk.lockOperations().unlockAsync(
            LockOperations.UnlockOperation(
                LockOperations.BaseOperation(
                    lockId = lockId,
                )
            )
        )
            .thenApply {
                result.success(null)
            }
            .exceptionally { error ->
                result.error("UNLOCK_ERROR", "", error)
            }
    }

    private fun setKeyPairIfNeeded() {
        if (!doordeckSdk.contextManager().isKeyPairValid()) {
            val newKeyPair = doordeckSdk.crypto().generateKeyPair()
            doordeckSdk.contextManager().setKeyPair(
                publicKey = newKeyPair.public,
                privateKey = newKeyPair.private,
            )
        }
    }

    private fun respondNeedsVerification(result: Result) {
        doordeckSdk.helper().assistedRegisterEphemeralKeyAsync()
            .thenApply { response ->
                result.success(response.toNativeMap())
            }
            .exceptionally { error ->
                result.error("NEEDS_VERIFICATION_ERROR", "", error)
            }
    }

    private fun AssistedRegisterEphemeralKeyResponse.toNativeMap() = mapOf(
        "requiresVerification" to requiresVerification,
    )

    private fun TileLocksResponse.toNativeMap() = mapOf(
        "siteId" to siteId,
        "tileId" to tileId,
        "deviceIds" to deviceIds,
    )


    private fun UserDetailsResponse.toNativeMap(
        userId: String?,
        certificateChainAboutToExpire: Boolean,
        tokenAboutToExpire: Boolean,
    ) = mapOf(
        "userId" to userId,
        "certificateChainAboutToExpire" to certificateChainAboutToExpire,
        "tokenAboutToExpire" to tokenAboutToExpire,
        "publicKey" to publicKey,
        "email" to email,
        "displayName" to displayName,
        "emailVerified" to emailVerified,
    )

}

import Flutter
import UIKit
import DoordeckSDK

public class DoordeckHeadlessSdkFlutterPlugin: NSObject, FlutterPlugin {
  private var channel: FlutterMethodChannel!
  private let doordeckSdk: Doordeck

  override init() {
    self.doordeckSdk = KDoordeckFactory().initialize(sdkConfig: SdkConfig.Builder().build())
    super.init()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "doordeck_headless_sdk_flutter", binaryMessenger: registrar.messenger())
    let instance = DoordeckHeadlessSdkFlutterPlugin()
    instance.channel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "login":
      guard let args = call.arguments as? [String: Any],
            let email = args["email"] as? String,
            let password = args["password"] as? String else {
        result(FlutterError(code: "INVALID_ARGS", message: "Missing email or password", details: nil))
        return
      }
      login(email: email, password: password, result: result)

    case "setAuthToken":
      guard let args = call.arguments as? [String: Any],
            let token = args["authToken"] as? String else {
        result(FlutterError(code: "INVALID_ARGS", message: "Missing authToken", details: nil))
        return
      }
      setAuthToken(token: token, result: result)

    case "verify":
      guard let args = call.arguments as? [String: Any],
            let code = args["code"] as? String else {
        result(FlutterError(code: "INVALID_ARGS", message: "Missing code", details: nil))
        return
      }
      verify(code: code, result: result)

    case "logout":
      logout(result: result)

    case "getUserDetails":
      getUserDetails(result: result)

    case "getLocksBelongingToTile":
      guard let args = call.arguments as? [String: Any],
            let tileId = args["tileId"] as? String else {
        result(FlutterError(code: "INVALID_ARGS", message: "Missing tileId", details: nil))
        return
      }
      getLocksBelongingToTile(tileId: tileId, result: result)

    case "unlockDevice":
      guard let args = call.arguments as? [String: Any],
            let lockId = args["lockId"] as? String else {
        result(FlutterError(code: "INVALID_ARGS", message: "Missing lockId", details: nil))
        return
      }
      unlockDevice(lockId: lockId, result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func login(email: String, password: String, result: @escaping FlutterResult) {
    setKeyPairIfNeeded()
    doordeckSdk.accountless().login(email: email, password: password) { token, error in
      if let error = error {
        result(FlutterError(code: "LOGIN_ERROR", message: error.localizedDescription, details: error.localizedDescription))
      } else {
        self.respondNeedsVerification(result: result)
      }
    }
  }

  private func setAuthToken(token: String, result: @escaping FlutterResult) {
    setKeyPairIfNeeded()
    doordeckSdk.contextManager().setCloudAuthToken(token: token)
    respondNeedsVerification(result: result)
  }

  private func verify(code: String, result: @escaping FlutterResult) {
    doordeckSdk.account().verifyEphemeralKeyRegistration(code: code, privateKey: nil) { _, error in
      if let error = error {
        result(FlutterError(code: "VERIFY_ERROR", message: error.localizedDescription, details: error.localizedDescription))
      } else {
        result(nil)
      }
    }
  }

  private func logout(result: @escaping FlutterResult) {
    doordeckSdk.account().logout { error in
      if let error = error {
        result(FlutterError(code: "LOGOUT_ERROR", message: error.localizedDescription, details: error.localizedDescription))
      } else {
        result(nil)
      }
    }
  }

  private func getUserDetails(result: @escaping FlutterResult) {
    doordeckSdk.account().getUserDetails { response, error in
      if let error = error {
        result(FlutterError(code: "USER_DETAILS_ERROR", message: error.localizedDescription, details: error.localizedDescription))
      } else if let response = response {
        result(response.toNativeMap(
          userId: self.doordeckSdk.contextManager().getUserId(),
          certificateChainAboutToExpire: self.doordeckSdk.contextManager().isCertificateChainAboutToExpire(),
          tokenAboutToExpire: self.doordeckSdk.contextManager().isCloudAuthTokenAboutToExpire()
        ))
      } else {
        result(FlutterError(code: "USER_DETAILS_ERROR", message: "Unknown error", details: nil))
      }
    }
  }

  private func getLocksBelongingToTile(tileId: String, result: @escaping FlutterResult) {
    doordeckSdk.tiles().getLocksBelongingToTile(tileId: tileId) { response, error in
      if let error = error {
        result(FlutterError(code: "LOCKS_ERROR", message: error.localizedDescription, details: error.localizedDescription))
      } else if let response = response {
        result(response.toNativeMap())
      } else {
        result(FlutterError(code: "LOCKS_ERROR", message: "Unknown error", details: nil))
      }
    }
  }

  private func unlockDevice(lockId: String, result: @escaping FlutterResult) {
    let base = LockOperations.BaseOperation(
      userId: nil,
      userCertificateChain: nil,
      userPrivateKey: nil,
      lockId: lockId,
      notBefore: Int32(Date().timeIntervalSince1970),
      issuedAt: Int32(Date().timeIntervalSince1970),
      expiresAt: Int32(Date().addingTimeInterval(60).timeIntervalSince1970),
      jti: UUID().uuidString
    )
    let unlock = LockOperations.UnlockOperation(baseOperation: base, directAccessEndpoints: nil)

    doordeckSdk.lockOperations().unlock(unlockOperation: unlock) { error in
      if let error = error {
        result(FlutterError(code: "UNLOCK_ERROR", message: error.localizedDescription, details: nil))
      } else {
        result(nil)
      }
    }
  }

  private func setKeyPairIfNeeded() {
    if !doordeckSdk.contextManager().isKeyPairValid() {
      let kp = doordeckSdk.crypto().generateKeyPair()
      doordeckSdk.contextManager().setKeyPair(publicKey: kp.public_, privateKey: kp.private_)
    }
  }

  private func respondNeedsVerification(result: @escaping FlutterResult) {
    doordeckSdk.helper().assistedRegisterEphemeralKey(publicKey: nil) { response, error in
      if let error = error {
        result(FlutterError(code: "NEEDS_VERIFICATION_ERROR", message: error.localizedDescription, details: error.localizedDescription))
      } else if let response = response {
        result(response.toNativeMap())
      } else {
        result(FlutterError(code: "NEEDS_VERIFICATION_ERROR", message: "Unknown error", details: nil))
      }
    }
  }
}

// MARK: - Doordeck model extensions

extension AssistedRegisterEphemeralKeyResponse {
  func toNativeMap() -> NSDictionary {
    return ["requiresVerification": requiresVerification]
  }
}

extension TileLocksResponse {
  func toNativeMap() -> NSDictionary {
    return [
      "siteId": siteId,
      "tileId": tileId,
      "deviceIds": deviceIds
    ]
  }
}

extension UserDetailsResponse {
  func toNativeMap(userId: String?, certificateChainAboutToExpire: Bool, tokenAboutToExpire: Bool) -> NSDictionary {
    return [
      "userId": userId as Any,
      "certificateChainAboutToExpire": certificateChainAboutToExpire,
      "tokenAboutToExpire": tokenAboutToExpire,
      "publicKey": publicKey,
      "email": email,
      "displayName": displayName as Any,
      "emailVerified": emailVerified
    ]
  }
}



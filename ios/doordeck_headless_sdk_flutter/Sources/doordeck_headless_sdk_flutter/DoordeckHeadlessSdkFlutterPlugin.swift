import Flutter
import UIKit
import DoordeckCoreSDK_UI

public class DoordeckHeadlessSdkFlutterPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel!
    private var doordeckCore: DoordeckCore?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "doordeck_headless_sdk_flutter", binaryMessenger: registrar.messenger())
        let instance = DoordeckHeadlessSdkFlutterPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            let args = call.arguments as? [String: Any]
            let authToken = args?["authToken"] as? String
            
            Task { @MainActor in
                self.doordeckCore = DoordeckCore(cloudAuthToken: authToken)
                self.doordeckCore?.delegate = self
                result(nil)
            }
        case "unlockFlow":
            guard self.doordeckCore != nil else {
                result(FlutterError(code: "NOT_INITIALIZED", message: "DoordeckCore not initialized. Call initialize first.", details: nil))
                return
            }
            Task {
                await unlockFlow(result: result)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func unlockFlow(result: @escaping FlutterResult) async {
        let unlockResult = await doordeckCore?.presentUnlockFlow(unlockMethod: UnlockMethod.nfcId)
        
        switch unlockResult {
        case .success, .idle, .loading, .none:
            result(nil)
        case .failure(let error):
            result(FlutterError(code: "UNLOCK_ERROR", message: error.localizedDescription, details: nil))
        }
    }
}

extension DoordeckHeadlessSdkFlutterPlugin: DoordeckCoreSDKDelegate {
    public func doordeckCoreSDK(requiresNewAuthToken completion: @escaping (String) -> Void) {
        channel.invokeMethod("requiresNewAuthToken", arguments: nil) { (result: Any?) in
            if let newToken = result as? String {
                completion(newToken)
            } else {
                // Handle the case where Flutter does not return a new token.
                completion("")
            }
        }
    }
}

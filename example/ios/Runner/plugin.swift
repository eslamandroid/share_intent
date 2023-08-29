import Flutter
import UIKit

public class Plugin: NSObject,FlutterStreamHandler, FlutterPlugin {

    public static let instance = Plugin()
    private var eventSinkMedia: FlutterEventSink? = nil;
    private var url:String? = nil;

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "intent_share", binaryMessenger: registrar.messenger())
    let eventChannel  = FlutterEventChannel(name:"intent_share/IntentSender",binaryMessenger:registrar.messenger())

    eventChannel.setStreamHandler(instance)
      
    registrar.addMethodCallDelegate(instance, channel: channel)
      
  }


  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    public func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        self.url = url.absoluteString;
        return false;
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSinkMedia = events;
        if(url != nil){
            do{
                let data = try JSONEncoder().encode([
                    "url":"www.google.com"
                ])
                
            self.eventSinkMedia?(data);
            } catch {
                print(error)
            }
        }
        
        return nil;
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSinkMedia = nil;
        return nil;
    }
    
}

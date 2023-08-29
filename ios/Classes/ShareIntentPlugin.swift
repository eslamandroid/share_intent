import Flutter
import UIKit

public class ShareIntentPlugin: NSObject,FlutterStreamHandler, FlutterPlugin {

    public static let instance = ShareIntentPlugin()
    private var eventSinkMedia: FlutterEventSink? = nil;
    private var customSchemePrefix = "SharingMedia";

    private var url:String? = nil;

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "intent_share", binaryMessenger: registrar.messenger())
      
    let instance = ShareIntentPlugin()

    registrar.addMethodCallDelegate(instance, channel: channel)
      
    let eventChannel  = FlutterEventChannel(name:"intent_share/IntentSender",binaryMessenger:registrar.messenger())
      
    eventChannel.setStreamHandler(instance)

    registrar.addApplicationDelegate(instance)
      
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


    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        if let url = launchOptions[UIApplication.LaunchOptionsKey.url] as? URL {
        return handleUrl(url: url, setInitialData: true)
        }
        return true;
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return handleUrl(url: url, setInitialData: true)
    }
    
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        if let url = userActivity.webpageURL {
          return handleUrl(url: url, setInitialData: true)
             }
        return false
    }
    
    public func sendInit(){
        
        eventSinkMedia?(toJson(data: ["url":"www.google.com"]))
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSinkMedia = events
        self.eventSinkMedia?(toJson(data: ["url" : "String"]));
        print("eslam")
        debugPrint("eslam")
        
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
        self.eventSinkMedia = nil;
        return nil;
    }
    
    private func handleUrl(url:URL?,setInitialData: Bool) -> Bool {
        if let url = url {
            let appGroupId = (Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String) ?? "group.\(Bundle.main.bundleIdentifier!)"
            let userDefaults = UserDefaults(suiteName: appGroupId)

            self.eventSinkMedia?(toJson(data: ["url":"www.google.com"]))

            if url.fragment == "url" {
                if let key = url.host?.components(separatedBy: "=").last,
                   let sharedArray = userDefaults?.object(forKey: key) as? [String] {
                    self.eventSinkMedia?(toJson(data: ["url":sharedArray.joined(separator: ",")]))

            }
            }
            return true

        }
        
    return false
    }

    
    
    // By Adding bundle id to prefix, we will ensure that the correct app will be openned
      public func hasSameSchemePrefix(url: URL?) -> Bool {
          if let url = url, let appDomain = Bundle.main.bundleIdentifier {
              return url.absoluteString.hasPrefix("\(self.customSchemePrefix)-\(appDomain)")
          }
          return false
      }
        
     private func toJson(data: Dictionary<String,String>?) -> String? {
               if data == nil {
                   return nil
               }
               do {
                   let encodedData = try JSONEncoder().encode(data)
                   let json = String(data: encodedData, encoding: .utf8)!
                   return json
               } catch {
                   fatalError(error.localizedDescription)
               }
           }

}

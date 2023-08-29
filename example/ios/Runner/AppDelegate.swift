import UIKit
import Flutter
import share_intent
import Foundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
   // let sharingIntent = ShareIntentPlugin.instance
   // sharingIntent.sendInit()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
//    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let sharingIntent = ShareIntentPlugin.instance
//          print("ESLAM IOS")
//        return sharingIntent.application(app, open: url, options: options)
//        // Proceed url handling for other Flutter libraries like uni_links
//       // return super.application(app, open: url, options:options)
//      }
}





 

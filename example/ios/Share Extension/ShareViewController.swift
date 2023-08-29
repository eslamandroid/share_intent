//
//  ShareViewController.swift
//  Share Extension
//
//  Created by Eslam Gamal on 28/08/2023.
//

import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {

    private var urlString: String?
    private var textString: String?
         
     private let groupName = "group.sharingsampletwo"
     private let urlDefaultName = "incomingURL"
    
    var hostAppBundleIdentifier = "com.eaapps.shareIntentExample.Share-Extension"
    
    var appGroupId:String  = ""
    
    let sharedKey:String  = "SharingKey"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadIds()
        print("Eslam LOAD")
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        debugPrint("Eslam APPEAR")

        let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        let contentTypeURL = UTType.url.identifier
        _ = UTType.text.identifier
        
        for attachment in extensionItem.attachments! {
            attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil,completionHandler: { (results,error) in
                let url = results as! URL?
                self.urlString  = url!.absoluteString
                 debugPrint(url!.absoluteString)
                let userDefaults = UserDefaults(suiteName: self.appGroupId)
                userDefaults?.set("www.google.com", forKey: self.sharedKey)
                userDefaults?.synchronize()
                self.redirectToHostApp(type: .url)
            })
        
        }
    }
    
//    override func didSelectPost() {
//        print("Eslam didSelectPost")
//        if let content = extensionContext!.inputItems.first as? NSExtensionItem{
//            let contentTypes = [kUTTypeURL as String , kUTTypeText as String]
//            if let contents = content.attachments as? [NSItemProvider] {
//                for attachment in contents {
//                    for contentType in contentTypes {
//                        if attachment.hasItemConformingToTypeIdentifier(contentType){
//                            attachment.loadItem(forTypeIdentifier: contentType, options: nil
//                                                , completionHandler: {(results,error) in
//                                if error != nil {
//                                    print(error)
//                                    return
//                                }
//
//
//
//                                switch contentType {
//                                case kUTTypeText as? String :
//                                    if let text = results as? String {
//                                                   do {// 2.1
//                                                       let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//                                                       let matches = detector.matches(
//                                                           in: text,
//                                                           options: [],
//                                                           range: NSRange(location: 0, length: text.utf16.count)
//                                                       )
//                                                       // 2.2
//                                                       if let firstMatch = matches.first, let range = Range(firstMatch.range, in: text) {
//                                                           self.saveURLString(String(text[range]))
//                                                       }
//                                                   } catch let error {
//                                                       print("Do-Try Error: \(error.localizedDescription)")
//                                                   }
//                                               }
//                                    //self.openMainApp()
//
//                                    break
//
//
//                                case kUTTypeURL as? String :
//                                    if let url = results as? NSURL, let urlString = url.absoluteString {
//                                                self.saveURLString(urlString)
//                                            }
//
//                                          //  self.openMainApp()
//                                     break
//
//
//                                default:
//                                    return
//                                }
//
//
//                            })
//                        }
//                    }
//                }
//            }
//        }
//
//    }
    
  private func loadIds(){
        
        let shareExtBundle = Bundle.main.bundleIdentifier!;
        
        let lastIndexOfPoint = shareExtBundle.lastIndex(of: ".")
        
        hostAppBundleIdentifier = String(shareExtBundle[..<lastIndexOfPoint!])
        
        appGroupId = (Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String) ?? "group.\(hostAppBundleIdentifier)"
        
    }
    
 private func saveURLString(_ urlString: String) {
     print(urlString)
        let userDefaults = UserDefaults(suiteName: self.appGroupId)
                           userDefaults?.set(urlString, forKey: self.sharedKey)
                           userDefaults?.synchronize()
                        self.redirectToHostApp(type: .url)
        
       }

  private func redirectToHostApp(type: RedirectType) {
             // load group and app id from build info
             loadIds();
             let url = URL(string: "SharingMedia-\(hostAppBundleIdentifier)://dataUrl=\(sharedKey)#\(type)")
             var responder = self as UIResponder?
             let selectorOpenURL = sel_registerName("openURL:")

             while (responder != nil) {
                 if (responder?.responds(to: selectorOpenURL))! {
                     let _ = responder?.perform(selectorOpenURL, with: url)
                 }
                 responder = responder!.next
             }
             extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
         }
    
    
  enum RedirectType {
              case media
              case text
              case file
              case url
          }

}



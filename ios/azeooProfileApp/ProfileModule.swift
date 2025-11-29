import Foundation
import React
import Flutter

@objc(ProfileModule)
class ProfileModule: NSObject {
  
  @objc(openProfileScreen:resolve:reject:)
  func openProfileScreen(_ userId: Int, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    
    DispatchQueue.main.async {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let flutterEngine = appDelegate.flutterEngine else {
        reject("NO_ENGINE", "Flutter Engine not initialized", nil)
        return
      }
      
      let flutterViewController = ProfileViewController(engine: flutterEngine, userId: userId)
      flutterViewController.modalPresentationStyle = .fullScreen
      
      if let rootVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
        rootVC.present(flutterViewController, animated: true, completion: nil)
        resolve(nil)
      } else {
        reject("NO_ROOT_VC", "Could not find root view controller", nil)
      }
    }
  }
  
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

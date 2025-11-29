import UIKit
import Flutter

class ProfileViewController: FlutterViewController {
  private let userId: Int
  private let channelName = "azeoo/profile"
  
  init(engine: FlutterEngine, userId: Int) {
    self.userId = userId
    super.init(engine: engine, nibName: nil, bundle: nil)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Send ID when view loads
    sendUserId()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    sendUserId()
  }
    
  private func sendUserId() {
      let channel = FlutterMethodChannel(name: channelName, binaryMessenger: self.binaryMessenger)
      channel.invokeMethod("setUserId", arguments: userId)
  }
}

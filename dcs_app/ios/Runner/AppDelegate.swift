import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        
        setupChannel()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupChannel() {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.app.DCSPortfolioPlus", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "sendUserDataToIOS" {
                if let data = call.arguments as? [String: Any],
                   let token = data["token"] as? String,
                   let username = data["username"] as? String,
                   let email = data["email"] as? String,
                   let defaultSessionName = data["defaultSessionName"] as? String {
                    // Xử lý dữ liệu được gửi từ Flutter ở đây
                    print("Received data from Flutter: \(token)")
                    let sharedDefaults =  UserDefaults(suiteName: "group.com.app.DCSPortfolioPlus")
                    sharedDefaults?.set(token, forKey: "access_token")
                    sharedDefaults?.set(username, forKey: "username")
                    sharedDefaults?.set(email, forKey: "email")
                    sharedDefaults?.set(defaultSessionName, forKey: "defaultSessionName")
                    // Trả kết quả (nếu cần)
                    let token: String = sharedDefaults?.string(forKey: "access_token") ?? "null"
                    print("Received data from UserDefault: \(token)")
                    result("Data received on iOS: \(token)")
                }
            }
        }
    }
}

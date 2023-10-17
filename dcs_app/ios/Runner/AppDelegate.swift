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
        let sharedDefaults =  UserDefaults(suiteName: "group.com.app.DCSPortfolioPlus")
        
        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "sendUserDataToIOS" {
                if let data = call.arguments as? [String: Any],
                   let token = data["token"] as? String,
                   let username = data["username"] as? String,
                   let email = data["email"] as? String,
                   let browsers = data["browsers"] as? String,
                   let defaultSessionName = data["defaultSessionName"] as? String {
                    // Xử lý dữ liệu được gửi từ Flutter ở đây
                    print("Received data from Flutter: \(token)")
                    sharedDefaults?.set(token, forKey: "token")
                    sharedDefaults?.set(username, forKey: "username")
                    sharedDefaults?.set(email, forKey: "email")
                    sharedDefaults?.set(defaultSessionName, forKey: "defaultSessionName")
                    sharedDefaults?.set(browsers, forKey: "browsers")
                    // Trả kết quả (nếu cần)
                    let token: String = sharedDefaults?.string(forKey: "token") ?? "null"
                    print("Received data from UserDefault: \(browsers)")
                    result("Data received on iOS: \(token)")
                }
            }
            if call.method == "logout" {
                sharedDefaults?.removeObject(forKey: "token")
                sharedDefaults?.removeObject(forKey: "username")
                sharedDefaults?.removeObject(forKey: "email")
                sharedDefaults?.removeObject(forKey: "defaultSessionName")
                sharedDefaults?.removeObject(forKey: "browsers")
            }
        }
    }
}

//
//  SafariWebExtensionHandler.swift
//  Extension
//
//  Created by Klabs Mobile on 27/09/2023.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    
    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        let sharedDefaults =  UserDefaults(suiteName: "group.com.app.DCSPortfolioPlus")
        let token = sharedDefaults?.string(forKey: "access_token") ?? ""
        let email = sharedDefaults?.string(forKey: "email") ?? ""
        let username = sharedDefaults?.string(forKey: "username") ?? ""
        let defaultSessionName = sharedDefaults?.string(forKey: "defaultSessionName") ?? ""
        let body: Dictionary<String, String> = ["token": token, "email" : email, "username": username, "defaultSessionName": defaultSessionName]
        do {
            
            os_log(.default, "Token ne %@", token)
            let data = try JSONEncoder().encode(body)
            let json = String(data: data, encoding: .utf8) ?? ""
            let extensionItem = NSExtensionItem()
            extensionItem.userInfo = [ SFExtensionMessageKey: json ]
            context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
            print("thanh cong")
            os_log(.default, "Received token: %@", token as! CVarArg)
        } catch {
            print("error")
            os_log(.default, "Error roi ne %@", message as! CVarArg)
        }
    }
    
}

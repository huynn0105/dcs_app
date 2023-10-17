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
        let message = item.userInfo?[SFExtensionMessageKey] as AnyObject?
        let sharedDefaults =  UserDefaults(suiteName: "group.com.app.DCSPortfolioPlus")
        
        guard let key = message?["message"] as? String else {
            return
        }
        do {
            switch(key) {
            case "authoried1":
                let extensionItem = NSExtensionItem()
                let token = sharedDefaults?.string(forKey: "token")
                if token == nil {
                    extensionItem.userInfo = [ SFExtensionMessageKey: "false" ]
                } else {
                    extensionItem.userInfo = [ SFExtensionMessageKey: "true" ]
                }
                context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
                break
            case "authoried":
                let token = sharedDefaults?.string(forKey: "token") ?? ""
                let extensionItem = NSExtensionItem()
                if token.isEmpty {
                    extensionItem.userInfo = [ SFExtensionMessageKey: "" ]
                } else {
                    let email = sharedDefaults?.string(forKey: "email") ?? ""
                    let username = sharedDefaults?.string(forKey: "username") ?? ""
                    let defaultSessionName = sharedDefaults?.string(forKey: "defaultSessionName") ?? ""
                    let browsers = sharedDefaults?.string(forKey: "browsers") ?? ""
                    let body: Dictionary<String, String> = ["token": token, "email" : email, "username": username, "defaultSessionName": defaultSessionName, "browsers": browsers]
                    os_log(.default, "Token ne %@", token)
                    let data = try JSONEncoder().encode(body)
                    let json = String(data: data, encoding: .utf8) ?? ""
                    extensionItem.userInfo = [ SFExtensionMessageKey: json ]
                }
                context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
                os_log(.default, "Received token: %@", token as! CVarArg)
                break
            default:
                break
            }
        } catch {
            print("error")
            os_log(.default, "Error roi ne %@", message as! CVarArg)
        }
    }
    
}

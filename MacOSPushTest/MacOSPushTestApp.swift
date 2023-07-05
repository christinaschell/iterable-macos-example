//
//  MacOSPushTestApp.swift
//  MacOSPushTest
//
//  Created by Christina Schell on 5/25/23.
//

import SwiftUI
import Foundation
import UserNotifications

let currentUserEmail = Tokens.email

@main
struct MacOSPushTestApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    }
                ShopView()
                    .tabItem {
                        VStack {
                            Image(systemName: "cart.fill")
                            Text("Shop")
                        }
                    }
            }
            .accentColor(.darkPurple)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var mainMenu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupNotifications()
    }
    
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.hexString
        print("Device Token: \(token)")
        
        // Save the token to the user
        AppState.shared.user.deviceToken = token
        
        // Register user and device with Iterable
        let devicePaylod = createDevicePayload(with: token)
        Networker.task(with: devicePaylod, url: IterableUrls.register)
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        // Save the push payload if push is sent from Iterable
        createAndSaveNotificationPayload(from: userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        // Track push open event if app opened from push
        Networker.task(with: pushPayload, url: IterableUrls.trackPushOpen)
    }
    
    public func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    private func createDevicePayload(with token: String) -> IterableRegisterDevicePayload {
        IterableRegisterDevicePayload(email: AppState.shared.user.email, device: IterableDevice(token: token))
    }
    
    private var pushPayload: IterablePushOpenPayload? {
        guard let mostRecentPushPayload = AppState.shared.user.mostRecentPushPayload else {
            return nil
        }
        return IterablePushOpenPayload(email: AppState.shared.user.email, campaignId: mostRecentPushPayload.campaignId, templateId: mostRecentPushPayload.templateId, messageId: mostRecentPushPayload.messageId)
    }
    
    private func createAndSaveNotificationPayload(from userInfo: [String: Any]) {
        guard let iterablePayload = userInfo[IterableKey.itbl] as? [String: Any],
              let campaignId = iterablePayload[IterableKey.campaignId] as? Int,
              let templateId = iterablePayload[IterableKey.templateId] as? Int,
              let messageId = iterablePayload[IterableKey.messageId] as? String else {
            return
        }
        let iterablePushNotification = IterableNotification(campaignId: campaignId, templateId: templateId, messageId: messageId)
        // Save most recent push payload
        AppState.shared.user.mostRecentPushPayload = iterablePushNotification
    }
    
    private func setupNotifications() {
       UNUserNotificationCenter.current().delegate = self
       UNUserNotificationCenter.current()
         .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
           print("Permission granted: \(granted)")
             guard granted else { return }
             DispatchQueue.main.async {
                 NSApplication.shared.registerForRemoteNotifications()
             }
           
       }
    }
    
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}




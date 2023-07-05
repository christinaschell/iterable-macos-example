//
//  ContentView.swift
//  MacOSPushTest
//
//  Created by Christina Schell on 5/25/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "house.fill")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Home")
                .padding()
            ButtonView(title: "Login") {
                // Set email/id on the user object (e.g. AppState.shared.user.email = newEmail
                // This will trigger the `didRegisterForRemoteNotifications` callback which will then trigger the Iterable registerDeviceToken API call
                NSApplication.shared.registerForRemoteNotifications()
            }
            ButtonView(title: "Logout") {
                // Disable the device within Iterable and set email/id to "" (e.g. AppState.shared.user.email = "")
                let disableDevicePayload = IterableDisableDevicePayload(email: AppState.shared.user.email, token: AppState.shared.user.deviceToken)
                Networker.task(with: disableDevicePayload, url: IterableUrls.disableDevice)
            }
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


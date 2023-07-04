//
//  IterableModels.swift
//  MacOSPushTest
//
//  Created by Christina Schell on 7/4/23.
//

import Foundation

struct IterableUrls {
    private static let baseUrl = "https://api.iterable.com"
    static let register = "\(baseUrl)/api/users/registerDeviceToken"
    static let updateUser = "\(baseUrl)/api/users/update"
    static let trackPushOpen = "\(baseUrl)/api/events/trackPushOpen"
}

struct IterableRegisterDevicePayload: Encodable {
    let email: String
    let device: IterableDevice
}

struct IterableDevice: Encodable {
    let token: String
    let applicationName: String = "com.schelly.MacOSPushTest"
    let platform: String = "APNS_SANDBOX"
}

struct IterableResponse: Codable, Hashable {
    let msg: String
    let code: String
}

struct IterableUser: Encodable {
    let email: String
}

struct IterablePushOpenPayload: Encodable {
    let email: String
    let campaignId: Int
    let templateId: Int
    let messageId: String
}

struct IterableNotification: Codable {
    var campaignId: Int
    var templateId: Int
    var messageId: String
}

struct IterableKey {
    static let itbl = "itbl"
    static let campaignId = "campaignId"
    static let templateId = "templateId"
    static let messageId = "messageId"
    static let pushPayload = "iterableMostRecentPushPayload"
}



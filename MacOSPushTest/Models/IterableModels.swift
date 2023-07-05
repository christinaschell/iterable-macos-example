//
//  IterableModels.swift
//  MacOSPushTest
//
//  Created by Christina Schell on 7/4/23.
//

import Foundation

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var user = IterableUser()
}

class IterableUser: Codable {
    var email: String = Tokens.email
    var deviceToken: String = ""
    var mostRecentPushPayload: IterableNotification? = nil
    
    init() {}
    
    enum CodingKeys: CodingKey {
        case email, deviceToken, mostRecentPushPayload
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        deviceToken = try container.decode(String.self, forKey: .deviceToken)
        mostRecentPushPayload = try container.decode(IterableNotification.self, forKey: .mostRecentPushPayload)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(deviceToken, forKey: .deviceToken)
        try container.encode(mostRecentPushPayload, forKey: .mostRecentPushPayload)
    }
}

struct IterableUrls {
    private static let baseUrl = "https://api.iterable.com"
    static let register = "\(baseUrl)/api/users/registerDeviceToken"
    static let updateUser = "\(baseUrl)/api/users/update"
    static let trackPushOpen = "\(baseUrl)/api/events/trackPushOpen"
    static let disableDevice = "\(baseUrl)/api/users/disableDevice"
}

struct IterableRegisterDevicePayload: Encodable {
    let email: String
    let device: IterableDevice
}

struct IterableDisableDevicePayload: Encodable {
    let email: String
    let token: String
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
}



//
//  URLSessionProtocol.swift
//  MacOSPushTest
//
//  Created by Christina Schell on 5/25/23.
//

import Foundation

struct Networker {
    
    enum NetworkError: Error {
        case invalidURL
        case unknown(String)
    }
    
    static func task(with data: Encodable, url: String) {
        Task {
            do {
                let payload = try JSONEncoder().encode(data)
                try await Networker.post(to: url, with: payload)
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
    
    private static func post(to urlString: String, with payload: Data?) async throws {

        guard let url = URL(string: urlString), let payload = payload else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(Tokens.apiKey, forHTTPHeaderField: "Api-Key")
        urlRequest.httpMethod = "POST"

        let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: payload)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.unknown("Error while fetching data. Response: \(response)")
        }

        let result = try JSONDecoder().decode(IterableResponse.self, from: data)
        
        guard result.code == "Success" else {
            throw NetworkError.unknown(result.msg)
        }
    }
}

//
//  APIResponse.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/2/22.
//

import Foundation

struct APIResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension APIResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}

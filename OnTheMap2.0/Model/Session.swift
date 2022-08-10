//
//  Session.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/8/22.
//

import Foundation

struct TheSession: Codable {
    let sessionId: String
    let expiration: String

    enum CodingKeys: String, CodingKey {
        case sessionId = "id"
        case expiration
    }
}

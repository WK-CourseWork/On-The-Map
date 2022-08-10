//
//  LoginRequest.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/4/22.
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case password = "password"
    }
}

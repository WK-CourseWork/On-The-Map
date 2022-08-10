//
//  UserProfile.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/8/22.
//

import Foundation

struct TheUserProfile: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

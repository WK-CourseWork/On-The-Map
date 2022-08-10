//
//  LoginResponse.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/8/22.
//

import Foundation

struct TheLoginResponse: Codable {
    let account: TheAccount
    let session: TheSession
}

//
//  Client.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/2/22.
//

import UIKit

class APIClient {

    struct Auth {
        static var sessionId: String?
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }

    enum APIEndpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case logout
        case studentLocation
        case addLocation
        case updateLocation
        case getLoggedInUserProfile
        case signUp
        
        var stringValue: String {
            switch self {
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            case .login: return APIEndpoints.base + "/session"
            case .logout: return APIEndpoints.base + "/logout"
            case .studentLocation: return APIEndpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .addLocation: return APIEndpoints.base + "/StudentLocation"
            case .updateLocation:
                return APIEndpoints.base + "/StudentLocation/" + Auth.objectId
            case .getLoggedInUserProfile:
                return APIEndpoints.base + "/users/" + Auth.key
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        TheRequestHelpers.taskForPOSTRequest(url: APIEndpoints.login.url, apiType: "Udacity", responseType: TheLoginResponse.self, body: body, httpMethod: "POST") { (data, error) in
            if let data = data {
                Auth.sessionId = data.session.theId
                Auth.key = data.account.key
                getLoggedInUserProfile(completion: { (success, _) in
                    if success {
                        print("Logged in user's profile fetched.")
                    }
                })
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getLoggedInUserProfile(completion: @escaping (Bool, Error?) -> Void) {
        TheRequestHelpers.taskForGETRequest(url: APIEndpoints.getLoggedInUserProfile.url, apiType: "Udacity", responseType: TheUserProfile.self) { (data, error) in
            if let data = data {
                print("First Name : \(data.firstName) && Last Name : \(data.lastName)")
                Auth.firstName = data.firstName
                Auth.lastName = data.lastName
                completion(true, nil)
            } else {
                print("Failed to get user's profile.")
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie?
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies!
            where cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }

        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
            if error != nil { // Handle error…
                print("Error logout")
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }

    class func getStudentLocation(completion: @escaping ([TheStudentInformation]?, Error?) -> Void) {
        TheRequestHelpers.taskForGETRequest(url: APIEndpoints.studentLocation.url, apiType: "Parse", responseType: TheStudentLocation.self) { (data, error) in
            if let data = data {
                completion(data.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func addStudentLocation(information: TheStudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"
        print(body)
        TheRequestHelpers.taskForPOSTRequest(url: APIEndpoints.addLocation.url, apiType: "Parse", responseType: PostTheLocationResponse.self, body: body, httpMethod: "POST") { (response, error) in
            if let response = response, response.createdAt != nil {
                Auth.objectId = response.objectId ?? ""
                completion(true, nil)
            }
            completion(false, error)
        }
    }
    
    class func updateStudentLocation(information: TheStudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"
        TheRequestHelpers.taskForPOSTRequest(url: APIEndpoints.updateLocation.url, apiType: "Parse", responseType: UpdateTheLocationResponse.self, body: body, httpMethod: "PUT") { (response, error) in
            if let response = response, response.updatedAt != nil {
                completion(true, nil)
            }
            completion(false, error)
        }
    }
}

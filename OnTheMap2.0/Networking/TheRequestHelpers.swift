//
//  TheRequestHelpers.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/4/22.
//

import Foundation

class TheRequestHelpers {

    class func taskForGETRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        taskForRequest(url: url, apiType: apiType, responseType: responseType, httpMethod: "GET") { response, error in
            completion(response, error)
        }
    }

    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, body: String, httpMethod: String, completion: @escaping (ResponseType?, Error?) -> Void) {
        taskForRequest(url: url, apiType: apiType, responseType: responseType, body: body, httpMethod: httpMethod) { response, error in
            completion(response, error)
        }
    }
    
    class func taskForRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, body: String? = nil, httpMethod: String, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if apiType == "Udacity" || httpMethod != "GET" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if let body = body {
            request.httpBody = body.data(using: .utf8)
        }
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if error != nil {
                completion(nil, error)
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            do {
                if apiType == "Udacity" {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } else {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }

        }
        task.resume()
    }
}

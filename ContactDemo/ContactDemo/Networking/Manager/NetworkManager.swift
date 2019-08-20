//
//  NetworkManager.swift
//  ContactDemo
//
//  Created by apple on 8/16/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    static let environment : NetworkEnvironment = .production
    static let MovieAPIKey = ""
    let router = Router<ContactAPI>()
    
    func getContactListWith(type: ContactAPI, completion: @escaping (_ contact: [Contact]?, _ error: String?) -> ()) {
        router.request(type) {[type] data, response, error in
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        DispatchQueue.main.async {
                            completion(nil, NetworkResponse.noData.rawValue)
                        }
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        if type == .contactListing  {
                            let contactList = try JSONDecoder().decode([Contact].self, from: responseData)
                            DispatchQueue.main.async {
                                completion(contactList, nil)
                            }
                        } else {
                            let contact = try JSONDecoder().decode(Contact.self, from: responseData)
                            DispatchQueue.main.async {
                                completion([contact], nil)
                            }
                        }
                    }catch {
                        print(error)
                        DispatchQueue.main.async {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    }
                case .failure(let networkFailureError):
                    DispatchQueue.main.async {
                        completion(nil, networkFailureError)
                    }
                    print(networkFailureError)
                }
            }

        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

//
//  NetworkManager.swift
//  ContactDemo
//
//  Created by apple on 8/16/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation

//MARK:- Enums for Network response
enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case validationError = "We are not able to validate data. Please enter different detail and try again"
}

//MARK:- Result enums
enum Result<String>{
    case success
    case failure(String)
}

//MARK:-  Network Manager for managing network request
struct NetworkManager {
    static let environment : NetworkEnvironment = .production
    static let MovieAPIKey = ""
    private let router = Router<ContactAPI>()
    
    /// Method for adding or updating contact
    ///
    /// - Parameters:
    ///   - type: Contact API (.newContact(contact: Contact), updateContact(id: Int, contact: Contact))
    ///   - completion: completion Handler
    func addOrUpdateContactWith(type: ContactAPI, completion: @escaping (_ responseString: String?) -> ()) {
        router.request(type) { (data, response, error) in
            //If error check for internet connection
            if error != nil {
                completion("Please check your network connection.")
            }
            //Checking for HTTPURLResponse from the server
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                    //if success
                case .success:
                    //Send error if data is not there
                    guard let _ = data else {
                        DispatchQueue.main.async {
                            completion(NetworkResponse.noData.rawValue)
                        }
                        return
                    }
                    // Send successfull message
                    DispatchQueue.main.async {
                        completion(AppConstants.contactSuccessfullyPostedMessage)
                    }
                    
                case .failure(let networkFailureError):
                    //Send failure message
                    DispatchQueue.main.async {
                        completion(networkFailureError)
                    }
                }
            }

        }
    }
    
    
    /// Method for getting contact list which would be used for fetching both contact list and contact
    /// detail content
    /// - Parameters:
    ///   - type: type of service to be provided
    ///   - completion: completion handler
    func getContactListWith(type: ContactAPI, completion: @escaping (_ contact: [Contact]?, _ error: String?) -> ()) {
        router.request(type) {[type] data, response, error in
            //If error check for internet connection
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            //Checking for HTTPURLResponse from the server
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                    //If success
                case .success:
                    guard let responseData = data else {
                        //Send error if data is not there
                        DispatchQueue.main.async {
                            completion(nil, NetworkResponse.noData.rawValue)
                        }
                        return
                    }
                    do {
                        //If type if of contactListing then decode dara in the form of array of contact list
                        if type == .contactListing  {
                            let contactList = try JSONDecoder().decode([Contact].self, from: responseData)
                            DispatchQueue.main.async {
                                completion(contactList, nil)
                            }
                        } else {  //Else decode data for single contact object
                            let contact = try JSONDecoder().decode(Contact.self, from: responseData)
                            DispatchQueue.main.async {
                                completion([contact], nil)
                            }
                        }
                    }catch {
                        //Catch and throw error if not able to decode data from the responseData
                        DispatchQueue.main.async {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    }
                case .failure(let networkFailureError):
                    // For failure case send response
                    DispatchQueue.main.async {
                        completion(nil, networkFailureError)
                    }
                }
            }

        }
    }
    
    
    /// Method for handling HTTPURLResponse from the server and determining the success and failure
    ///
    /// - Parameter response: HTTPURLResponse response
    /// - Returns: Result enum
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...421: return .failure(NetworkResponse.authenticationError.rawValue)
        case 422: return .failure(NetworkResponse.validationError.rawValue)
        case 423...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

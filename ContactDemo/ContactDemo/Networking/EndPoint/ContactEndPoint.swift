//
//  ContactEndPoint.swift
//  ContactDemo
//
//  Created by apple on 8/16/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation


enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum ContactAPI {
    case contactListing
    case contactDetail(id: Int)
    case newContact(contact: Contact)
    case updateContact(id: Int, contact: Contact)
}

extension ContactAPI: Equatable {
    
    public static func ==(lhs: ContactAPI, rhs: ContactAPI) -> Bool {
        switch (lhs, rhs) {
        case (let .contactDetail(a1), let .contactDetail(a2)):
            return a1 == a2
        case (.contactListing,.contactListing):
            return true
        default:
            return false
        }
    }
}

extension ContactAPI: EndPointType {
    var httpMethod: HTTPMethod {
        switch self {
        case .contactDetail:
            fallthrough
        case .contactListing:
            return .get
        case .newContact:
            return .post
        case .updateContact:
            return .put
        }
        
    }
    
    var task: HTTPTask {
        switch self {
        case .contactDetail:
            fallthrough
        case .contactListing:
            return .request
        case .newContact(let contact):
            let contactParameters = ["first_name": (contact.firstName ?? ""), "last_name": (contact.lastName ?? ""), "email": (contact.emailAddress ?? ""), "phone_number": (contact.mobileNumber ?? ""), "favorite": (contact.favorite ?? false)] as [String : Any]
            return .requestParameters(bodyParameters: contactParameters, bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .updateContact( _, let contact):
            let contactParameters = ["first_name": (contact.firstName ?? ""), "last_name": (contact.lastName ?? ""), "email": (contact.emailAddress ?? ""), "phone_number": (contact.mobileNumber ?? ""), "favorite": (contact.favorite ?? false)] as [String : Any]
            return .requestParameters(bodyParameters: contactParameters, bodyEncoding: .jsonEncoding, urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return ["key": "Content-Type", "value": "application/json", "description": ""]
    }
    

    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "http://gojek-contacts-app.herokuapp.com/"
        default: return "http://gojek-contacts-app.herokuapp.com/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .contactDetail(let id):
            return "contacts/\(id).json"
        case .newContact:
            fallthrough
        case .contactListing:
            return "contacts.json"
        case .updateContact(let id, _):
            return "contacts/\(id).json"
        }

    }
}

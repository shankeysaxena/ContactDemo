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
//    case recommended(id:Int)
//    case popular(page:Int)
//    case newMovies(page:Int)
//    case video(id:Int)
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
        }
        
    }
    
    var task: HTTPTask {
        return .request
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
        case .contactListing:
            return "contacts.json"
//        case .recommended(let id):
//            return "\(id)/recommendations"
//        case .video(let id):
//            return "\(id)/videos"
        }

    }
}

//
//  EndpointType.swift
//  ContactDemo
//
//  Created by apple on 8/16/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation

//Protocol for Endpoint to be confirmed
protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

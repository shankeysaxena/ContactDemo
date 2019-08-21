//
//  Router.swift
//  ContactDemo
//
//  Created by apple on 8/16/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

//Protocol for network router for routing the requests
protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

//Router class for routing the requests
class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    /// Method for requesting/posting the data on a server
    /// - Parameters:
    ///   - route: Endpoints enums
    ///   - completion: completion handler to handle response
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            //Build request
            let request = try self.buildRequest(from: route)
            //Uncomment below network logger for logging request data
//            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        //Building requests
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            //Configuring request paramters and url parameters according the type of router task
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    
    /// Method for configuring request according to mentioned body and url paramters
    ///
    /// - Parameters:
    ///   - bodyParameters: Parameters
    ///   - bodyEncoding: ParameterEncoding
    ///   - urlParameters: Parameters
    ///   - request: URLRequest
    /// - Throws: throws exception
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    //Helper method for adding additional header to the request
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}

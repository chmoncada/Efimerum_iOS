//
//  ApiClient.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 14/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import Alamofire
import enum Result.Result

class ApiClient {
    
    public static let baseURL: String = "https://efimerum-48618.appspot.com/api/v1"
    
    static let manager: SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["efimerum-48618.appspot.com": .disableEvaluation]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        configuration.timeoutIntervalForRequest = 70
        
        //        configuration.URLCache = NSURLCache.sharedURLCache()
        //        configuration.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        
        return Alamofire.SessionManager(configuration: configuration,
                                        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()
    
    static let headers = ["Content-type": "application/x-www-form-urlencoded"]
    
    public enum Endpoints {
        
        case photos
        case likes(String)
        case photo(String)
//        case report(String)
        
        public var method: Alamofire.HTTPMethod {
            switch self {
            case .photos,
                 .likes:
                return .get
            case .photo://,
//                 .report:
                return .post
            }
        }
        
        public var path: String {
            switch self {
            case .photos:
                return baseURL + "/photos"
            case .likes:
                return baseURL + "/likes"
            case .photo:
                return baseURL + "/photo"
//            case .report:
//                return baseURL + "/report"
            }
        }
        
        public var parameters: [String : AnyObject] {
            var parameters = [String : AnyObject]()
            switch self {
            case .photos:
                break
            case .likes:
                break
            case .photo:
                break
//            case .report(let keywords):
//                parameters["keywords"] = keywords
//                break
            }
            return parameters as [String : AnyObject]
        }
    }
    
    public static func request(endpoint: ApiClient.Endpoints, completionHandler: @escaping (Result<EfimerumResponse, ApiError>) -> Void) -> Request {
            
        let request = ApiClient.manager.request(endpoint.path,
                                                method: endpoint.method,
                                                parameters: endpoint.parameters,
                                                encoding: URLEncoding.default,
                                                headers: headers).responseJSON { response in
                                                    
                                                    if let json = response.result.value as? [String: AnyObject] {
                                                        
                                                        guard let apiResponse = EfimerumResponse(json: json) else {
                                                            completionHandler(.failure(.parserError))
                                                            return
                                                        }
                                                        
                                                        if apiResponse.success {
                                                            completionHandler(Result.success(apiResponse))
                                                        } else {
                                                            completionHandler(Result.failure(ApiError.serverError(message: apiResponse.error!)))
                                                        }
         
                                                    } else {
                                                        completionHandler(Result.failure(ApiError.unknownError))
                                                    }
            
        }
        return request
    }
}




    

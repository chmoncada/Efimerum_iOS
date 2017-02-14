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
    
    public static let baseURL: String = "http://colourlovers.com/api"
    
    static let manager: SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["81.93.214.105": .disableEvaluation]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        configuration.timeoutIntervalForRequest = 70
        
        //        configuration.URLCache = NSURLCache.sharedURLCache()
        //        configuration.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        
        return Alamofire.SessionManager(configuration: configuration,
                                        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()
    
    public enum Endpoints {
        
        case photos(String)
        case likes(String)
        case photo(String)
        case report(String)
        
        public var method: Alamofire.HTTPMethod {
            switch self {
            case .photos,
                 .likes:
                return .get
            case .photo,
                 .report:
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
            case .report:
                return baseURL + "/report"
            }
        }
        
        public var parameters: [String : AnyObject] {
            var parameters = ["format":"json"]
            switch self {
            case .photos(let keywords):
                parameters["keywords"] = keywords
                break
            case .likes(let keywords):
                parameters["keywords"] = keywords
                break
            case .photo(let keywords):
                parameters["keywords"] = keywords
                break
            case .report(let keywords):
                parameters["keywords"] = keywords
                break
            }
            return parameters as [String : AnyObject]
        }
    }
    
    public static func request(endpoint: ApiClient.Endpoints, completionHandler: @escaping (Result<AnyObject, NSError>) -> Void) -> Request {
            
        let request = ApiClient.manager.request(endpoint.path,
                                                method: endpoint.method,
                                                parameters: endpoint.parameters,
                                                encoding: URLEncoding.default,
                                                headers: nil).responseJSON { response in
                                                    
                                                    if (response.result.error) != nil {
                                                
                                                    } else {
                    
                                                    }
            
        }
        return request
    }
}
    

//
//  ApiClient.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 14/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

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
    
    fileprivate func getToken() -> String {
        return FIRInstanceID.instanceID().token()!
    }
    
    public enum Endpoints {
        
        case photos
        case likes(photoKey: String, latitude: Double, longitude: Double)
        case photo
//        case report(String)
        
        public var method: Alamofire.HTTPMethod {
            switch self {
            case .photos:
                return .get
            case .photo,
                 .likes:
//                 .report:
                return .post
            }
        }
        
        public var path: String {
            switch self {
            case .photos:
                return baseURL + "/photos?uid=PRUEBA"
            case .likes:
                return baseURL + "/likes"
            case .photo:
                return baseURL + "/photo"
//            case .report:
//                return baseURL + "/report"
            }
        }
        
        public var parameters: [String : String] {
            switch self {
            case .photos:
                return [String : String]()
            case let .likes(photoKey: p, latitude: lat, longitude: lon):
                return [
                    "photoKey": p,
                    "latitude": "\(lat)",
                    "longitude": "\(lon)"
                    ]
            case .photo:
                return [String : String]()
//            case .report(let keywords):
//                parameters["keywords"] = keywords
//                break
            }
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




    

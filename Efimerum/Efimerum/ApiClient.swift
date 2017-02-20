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
        
        case likes
        case photos(token: String, latitude: Double, longitude: Double)
        case photo
//        case report(String)
        
        public var method: Alamofire.HTTPMethod {
            switch self {
            case .photo:
                return .get
            case .photos,
                 .likes:
//                 .report:
                return .post
            }
        }
        
        public var path: String {
            switch self {
            case .photos(token: let t, latitude: let lat, longitude: let lon):
                return baseURL + "/photos?idToken=\(t)&latitude=\(lat)&longitude=\(lon)"
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
            case .likes:
                return [String : String]()
            case .photos:
                return [String : String]()
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
    
    
    public static func upload(data: Data, endpoint: ApiClient.Endpoints, completionHandler: @escaping (Result<EfimerumResponse, ApiError>) -> Void) {
        
        ApiClient.manager.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(data, withName: "photoImg", fileName: "photo.jpeg", mimeType: "image/jpeg")
    
        }, to: endpoint.path) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
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
                    }
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                completionHandler(Result.failure(ApiError.unknownError))
            }
            
        }
    }
}






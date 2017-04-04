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
    
    fileprivate static let baseURL: String = "https://efimerum-48618.appspot.com/api/v1"
    
    static let manager: SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["efimerum-48618.appspot.com": .disableEvaluation]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        configuration.timeoutIntervalForRequest = 45
        
        //        configuration.URLCache = NSURLCache.sharedURLCache()
        //        configuration.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        
        return Alamofire.SessionManager(configuration: configuration,
                                        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()
    
    static let headers = ["Content-type": "application/x-www-form-urlencoded"]
    
    fileprivate func getToken() -> String {
        return FIRInstanceID.instanceID().token()!
    }
    
    fileprivate enum Endpoints {
        
        case likes(token: String, photoKey: String, latitude: Double?, longitude: Double?)
        case photos(token: String, latitude: Double?, longitude: Double?)
        case favoriteTags(token: String, language: String)
        case saveFavorite(tag: String, token: String, language: String)
        case deleteFavorite(tag: String, token: String, language: String)
        case reportPhoto(token: String, photoKey: String, reportCode: String)
        
        fileprivate var method: Alamofire.HTTPMethod {
            switch self {
            case .favoriteTags:
                return .get
            case .photos, .likes, .saveFavorite, .reportPhoto:
                return .post
            case .deleteFavorite:
                return .delete
            }
        }
        
        fileprivate var path: String {
            switch self {
            case .photos:
                return baseURL + "/photos"
            case .likes:
                return baseURL + "/likes"
            case .favoriteTags:
                return baseURL + "/labels"
            case .saveFavorite:
                return baseURL + "/favoriteLabels"
            case .deleteFavorite:
                return baseURL + "/favoriteLabels"
            case .reportPhoto:
                return baseURL + "/reportPhoto"

            }
        }
        
        fileprivate var parameters: [String : String] {
            
            switch self {
                
            case let .likes(token: t, photoKey: p, latitude: lat, longitude: lon):
                
                if let lat = lat,
                    let lon = lon {
                    return [
                        "idToken": t,
                        "photoKey": p,
                        "latitude": "\(lat)",
                        "longitude": "\(lon)"
                        ]
                } else {
                    return [
                        "idToken": t,
                        "photoKey": p
                        ]
                }
            case let .photos(token: t, latitude: lat, longitude: lon):
                if let lat = lat,
                    let lon = lon {
                    return [
                        "idToken": t,
                        "latitude": "\(lat)",
                        "longitude": "\(lon)"
                        ]
                } else {
                    return [
                        "idToken": t
                        ]
                }
            case let .favoriteTags(token: t, language: lang):
                return [
                    "idToken": t,
                    "lang": "\(lang)"
                ]
            case let .saveFavorite(tag: tag, token: t, language: lang):
                return [
                    "label": tag,
                    "idToken": t,
                    "lang": "\(lang)"
                    ]
            case let .deleteFavorite(tag: tag, token: t, language: lang):
                return [
                    "label": tag,
                    "idToken": t,
                    "lang": "\(lang)"
                    ]
            case let .reportPhoto(token: t, photoKey: k, reportCode: c):
                return [
                    "idToken": t,
                    "photoKey": k,
                    "reportCode": c
                    ]
            }
        }
    }
    
    fileprivate static func request(endpoint: ApiClient.Endpoints, completionHandler: @escaping (Result<EfimerumResponse, ApiError>) -> Void) -> Request {
            
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
    
    
    fileprivate static func upload(data: Data, endpoint: ApiClient.Endpoints, completionHandler: @escaping (Result<EfimerumResponse, ApiError>) -> Void) {
        
        ApiClient.manager.upload(multipartFormData: { (multipartFormData) in
            
            let parameters = endpoint.parameters
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
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


//MARK: Public methods

extension ApiClient {
    
    public static func postPhoto(photoData: Data, token t: String, latitude lat: Double?, longitude lon: Double?, completion: @escaping (Result<EfimerumResponse, ApiError>) -> Void) {
        
        self.upload(data: photoData, endpoint: .photos(token: t, latitude: lat, longitude: lon)) { (result) in
            completion(result)
        }
    }
    
    
    public static func likePhoto(token t: String, photoKey k: String, latitude lat: Double?, longitude lon: Double?, completion: @escaping (Result<EfimerumResponse, ApiError>) -> Void) {
        
        let _ = self.request(endpoint: .likes(token: t, photoKey: k, latitude: lat, longitude: lon)) { (result) in
            
            completion(result)
        }
    }
    
    public static func getFavoriteTags(token t: String, language lang: String, completion: @escaping ([String]?, ApiError?) -> Void) {
        
        let _ = self.request(endpoint: .favoriteTags(token: t, language: lang)) { (result) in
            
            if let error = result.error {
                completion(nil, error)
            } else {
                if let response = result.value {
                    print(response)
                }
            }
            
        }
    }
    
    public static func saveFavoriteTag(tag: String, token t: String, language lang: String, completion: @escaping (Bool, ApiError?) -> Void) {
        
        let _ = self.request(endpoint: .saveFavorite(tag: tag, token: t, language: lang)) { (result) in
            
            if let error = result.error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    public static func deleteFavoriteTag(tag: String, token t: String, language lang: String, completion: @escaping (Bool, ApiError?) -> Void) {
        
        let _ = self.request(endpoint: .deleteFavorite(tag: tag, token: t, language: lang)) { (result) in
            if let error = result.error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    public static func reportPhoto(token t: String, photoKey k: String, reportCode c: String, completion: @escaping (Bool, ApiError?) -> Void) {
        
        let _ = self.request(endpoint: .reportPhoto(token: t, photoKey: k, reportCode: c)) { (result) in
            if let error = result.error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
}























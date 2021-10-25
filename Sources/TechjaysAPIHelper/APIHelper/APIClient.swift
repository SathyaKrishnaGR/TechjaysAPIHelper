//
//  APIClient.swift
//  TechjaysAPIHelper
//
//  Created by Sathya on 10/24/21.
//  Copyright © 2021 Techjays. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

public typealias  APICompletion<T: Codable> =  (_ status: APIClient.Status, _ response: APIResponse<T>) -> Void

public class APIClient {
    var token: String?
    static let shared = APIClient()
    let urlFactory = URLFactory()
    
    public init() {}
    
    /// Sends a GET request to the server
    /// - Parameters:
    ///   - url: Request URL
    ///   - completion: Completion callback which will be called asyncronously when response is received
    public func GET<T: Codable>(url: String,
                         headers: [String: String]? = nil,
                         completion:@escaping APICompletion<T>) {
        executeRequest(to: url, headers: headers, requestType: .get, completion: completion)
    }

    /// Sends a POST request to the server
    /// - Parameters:
    ///   - url: Request URL
    ///   - payload: Request Payload
    ///   - completion: Completion callback which will be called asyncronously when response is received
    public func POST<P, T: Codable> (url: String,
                              headers: [String: String]? = nil,
                              payload: P,
                              completion:@escaping APICompletion<T>) {
        executeRequest(to: url, headers: headers, requestType: .post, payload: parsePayload(payload), completion: completion)
    }

    /// Sends a PUT request to the server
    /// - Parameters:
    ///   - url: Request URL
    ///   - payload: Request Payload
    ///   - completion: Completion callback which will be called asyncronously when response is received
    public func PUT<P, T: Codable> (url: String,
                             headers: [String: String]? = nil,
                             payload: P,
                             completion: @escaping APICompletion<T>) {
        executeRequest(to: url, headers: headers, requestType: .put, payload: parsePayload(payload), completion: completion)
    }

    /// Sends a DELETE request to the server
    /// - Parameters:
    ///   - url: Request URL
    ///   - completion: Completion callback which will be called asyncronously when response is received
    public func DELETE<P, T: Codable>(url: String,
                               headers: [String: String]? = nil,
                               payload: P,
                               completion: @escaping APICompletion<T>) {
        executeRequest(to: url, headers: headers, requestType: .delete, payload: parsePayload(payload), completion: completion)
    }

    /// Sends a MultipartFormData request as POST or PUT with one Image to the server
    /// - Parameters:
    ///   - url: Request URL
    ///   - method: Request type - POST, PUT, DELETE, etc./
    ///   - payload: Request payload. Note: The values should always be string for MultipartFormData request
    ///   - image: Key - Image field name, Value - Image to be sent
    ///   - completion: Completion callback which will be called asyncronously when response is received
    public func MULTIPART<T: Codable> (url: String,
                                headers: [String: String]? = nil,
                                uploadType method: HTTPMethod,
                                image: (key: String, value: UIImage)? = nil,
                                completion: @escaping APICompletion<T>) {
        executeRequest(to: url,
                       headers: headers,
                       requestType: method,
                       payload: [String: Any](),
                       image: image,
                       completion: completion)
    }

    /// Sends a MultipartFormData request as POST or PUT with one Image to the server
    /// - Parameters:
    ///   - url: Request URL
    ///   - method: Request type - POST, PUT, DELETE, etc./
    ///   - payload: Request payload. Note: The values should always be string for MultipartFormData request
    ///   - image: Key - Image field name, Value - Image to be sent
    ///   - completion: Completion callback which will be called asyncronously when response is received
    public func MULTIPART<P, T: Codable> (url: String,
                                   headers: [String: String]? = nil,
                                   uploadType method: HTTPMethod,
                                   payload: P,
                                   image: (key: String, value: UIImage)? = nil,
                                   completion: @escaping APICompletion<T>) {
        executeRequest(to: url,
                       headers: headers,
                       requestType: method,
                       payload: parsePayload(payload) ?? [String: Any](),
                       image: image,
                       completion: completion)
    }
}

extension APIClient {
    /// Handles GET, POST, PUT, DELETE requests
    /// - Parameters:
    ///   - url: Request URL
    ///   - method: HTTP Request type - GET, POST, PUT, DELETE
    ///   - payload: Request payload. Note: The values should always be string for MultipartFormData request
    ///   - completion: Completion callback which will be called asyncronously when response is received
    public func executeRequest<T: Codable>(to url: String,
                                            headers: [String: String]? = nil,
                                            requestType method: HTTPMethod,
                                            payload: [String: Any]? = nil,
                                            completion: @escaping APICompletion<T>) {
        guard isNetworkReachable(completion) else {
            return
        }
        let headers: HTTPHeaders = buildHeaders(contentType: APIStrings.APIClient.applicationJson, overrideHeaders: headers)
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.FAILURE, APIResponse<T>(result: false, msg: "Url can't be encoded"))
            return
        }
        AF.sessionConfiguration.urlCache = nil
        AF.request(URL.init(string: encodedUrl)!,
                   method: method,
                   parameters: payload,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .responseJSON { (response) in
                self.parseResponse(response: response, completion: completion)
        }
    }

    /// Handles MultipartFormData Request for PUT and POST with one Image
    /// - Parameters:
    ///   - url: Request URL
    ///   - method: HTTP Request type - PUT, POST
    ///   - image: Key - Image field name, Value - Image to be sent
    ///   - param: Request payload. Note: The values should always be string for MultipartFormData request
    ///   - completion: Completion callback which will be called asyncronously when response is received
    public func executeRequest<T: Codable>(to url: String,
                                            headers: [String: String]? = nil,
                                            requestType method: HTTPMethod,
                                            payload param: [String: Any],
                                            image: (key: String, value: UIImage)?,
                                            completion: @escaping APICompletion<T>) {
        guard isNetworkReachable(completion) else {
            return
        }
        let headers: HTTPHeaders = buildHeaders(contentType: APIStrings.APIClient.multipartFormData, overrideHeaders: headers)

        let multipartFormData = { (data: MultipartFormData) in
            if let img = image, let jpegImage = img.value.jpegData(compressionQuality: 1) {
                data.append(jpegImage,
                            withName: img.key,
                            fileName: "\(img.key).\(APIStrings.APIClient.JPG)",
                    mimeType: APIStrings.APIClient.imageJpg)
            }
            for (key, value) in param {
                if let value = value as? String, let utf8Value = value.data(using: String.Encoding.utf8) {
                    data.append(utf8Value, withName: key)
                } else {
                    debugPrint(String(format: APIStrings.APIClient.multiPartPayloadMustBeString, key))
                }
            }
        }

        debugPrint(param)
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.FAILURE, APIResponse<T>(result: false, msg: "Url can't be encoded"))
            return
        }
        AF.sessionConfiguration.urlCache = nil
        AF.upload(multipartFormData: multipartFormData,
                  to: URL.init(string: encodedUrl)!,
                  method: method,
                  headers: headers)
            .responseJSON { (response) in
                self.parseResponse(response: response, completion: completion)
        }
    }
}

extension APIClient {
    /// Parses the API Response
    /// - Parameters:
    ///   - response: Alamofire response which was received from the server
    ///   - completion: Completion callback through which the Success or Failure response will be sent
    public func parseResponse<T: Codable>(
        response: AFDataResponse<Any>,
        completion :@escaping APICompletion<T>) {
        do {
            debugPrint(response)
            var apiResponse: APIResponse<T>
            
            if let data = response.data, let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200, 201:
                    apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                    if apiResponse.result {
                        completion(.SUCCESS, apiResponse)
                    } else {
                        completion(.FAILURE, apiResponse)
                    }
                case 500, 504:
                    apiResponse = APIResponse<T>(result: false, msg: APIStrings.APIClient.cantConnectToServer)
                    completion(.FAILURE, apiResponse)
                case 401:
                    apiResponse = APIResponse<T>(result: false, msg: APIStrings.APIClient.unAuthorized)
                    completion(.FAILURE, apiResponse)
                    // 401, Logout here
                default:
                    apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: response.data!)
                    completion(.FAILURE, apiResponse)
                }
            } else {
                apiResponse = APIResponse<T>(result: false, msg: APIStrings.APIClient.noResponseFromServer)
                completion(.FAILURE, apiResponse)
            }
        } catch {
            print(error)
            completion(.FAILURE, APIResponse<T>(result: false, msg: APIStrings.APIClient.cantConnectToServer))
        }
    }
}

extension APIClient {
    public func parsePayload<P>(_ payload: P) -> [String: Any]? {
        if let codable = payload as? Codable {
            return codable.asDictionary()
        }
        if let dictionary = payload as? [String: Any] {
            return dictionary
        }
        return nil
    }

    public func buildHeaders(contentType: String, overrideHeaders: [String: String]? = nil) -> HTTPHeaders {
        var headers: HTTPHeaders = [
            APIStrings.APIClient.contentType: contentType,
            APIStrings.APIClient.device: AppKeys.DeviceUUID,
            APIStrings.APIClient.platform: APIStrings.APIClient.iOS.lowercased()
        ]
        addAuthToken(&headers)
        if let additionalHeaders = overrideHeaders {
            additionalHeaders.forEach { (key, value) in
                headers[key] = value
            }
        }
        return headers
    }

    public func addAuthToken(_ headers: inout HTTPHeaders) {
        headers[APIStrings.APIClient.authorization] = APIStrings.APIClient.token
    }

    public func isNetworkReachable<T>(_ completion: @escaping APICompletion<T>)
        -> Bool {
        if NetworkReachabilityManager()?.isReachable ?? false {
            return true
        }
        let status: Status = .FAILURE
        let response = APIResponse<T>(result: false,
                                      msg: APIStrings.APIClient.pleaseCheckYourInternetConnection)
        completion(status, response)
        return false
    }

    public enum Status {
        case SUCCESS, FAILURE
    }

    public enum UploadType {
        case POST, PUT
    }
}

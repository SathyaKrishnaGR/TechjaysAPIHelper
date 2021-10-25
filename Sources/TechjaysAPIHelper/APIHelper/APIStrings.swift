//
//  File.swift
//  
//
//  Created by SathyaKrishna on 20/09/21.
//

import Foundation
public struct APIStrings {
    public struct APIClient {
        static let contentType = "content-type"
        static let applicationJson = "application/json"
        static let multipartFormData = "multipart/form-data"
        static let device = "device"
        static let platform = "platform"
        static let iOS = "iOS"
        static let JPG = "jpg"
        static let facebook = "facebook"
        static let authorization = "Authorization"
        static let token = "Token "
        static let imageJpg = "image/jpg"
        static let image = "image"
        static let profilePic = "profile_pic"
        static let pleaseCheckYourInternetConnection = "Please check your internet connection!"
        static let cantConnectToServer = "Oops! Can't connect to server"
        static let unAuthorized = "Authorization Failed!"
        static let noResponseFromServer = "No Response from server"
        static let multiPartPayloadMustBeString = """
    MultipartFormData Payload should be of type 'String'.payload[%@] can't be cast to String
    """
        static let offset = "offset"
        static let limit = "limit"
    }
}

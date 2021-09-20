//
//  File.swift
//  
//
//  Created by SathyaKrishna on 20/09/21.
//

import Foundation
import UIKit



public struct AppKeys {
    static let DeviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? ""
    
    struct UserDefault {
        static let authTokenKey = "Auth-Token"
        static let userKey = "user"
    }
}

//
//  File.swift
//  
//
//  Created by SathyaKrishna on 20/09/21.
//

import Foundation
import UIKit



public struct AppKeys {
    
    public init(userDefaults: UserDefault) {
        
    }
    static let DeviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? ""
    
    public struct UserDefault {
        public init(authTokenKey: String, userKey: String) {
            
        }
        static let authTokenKey = "Auth-Token"
        static let userKey = "user"
    }
}

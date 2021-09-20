//
//  File.swift
//  
//
//  Created by SathyaKrishna on 20/09/21.
//

import Foundation
class LocalStorage {
    
    static let standard = LocalStorage()

    private init() {}

    private let userDefaults = UserDefaults.standard

//    var user: User? {
//        get {
//            return userDefaults.getObject(forKey: AppKeys.UserDefault.userKey)
//        }
//        set(newUser) {
//            if let user = newUser {
//                userDefaults.setObject(AppKeys.UserDefault.userKey, forKey: user)
//            } else {
//                userDefaults.removeObject(forKey: AppKeys.UserDefault.userKey)
//            }
//        }
//    }
}

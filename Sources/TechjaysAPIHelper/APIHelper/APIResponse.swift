//
//  APIResponse.swift
//  TechjaysAPIHelper
//
//  Created by Sathya on 10/24/21.
//  Copyright © 2021 Techjays. All rights reserved.
//

import Foundation

public struct APIResponse<T: Codable>: Codable {
    var result: Bool
    var msg: String
    var data: T?
    var nextLink: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case result
        case msg
        case nextLink = "next_link"
        case data
    }
}

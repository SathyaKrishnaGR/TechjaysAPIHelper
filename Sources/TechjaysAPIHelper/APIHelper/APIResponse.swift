//
//  APIResponse.swift
//  TechjaysAPIHelper
//
//  Created by Sathya on 10/24/21.
//  Copyright © 2021 Techjays. All rights reserved.
//

import Foundation

public struct APIResponse<T: Codable>: Codable {
    public var result: Bool
    public var msg: String
    public var data: T?
    public var nextLink: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case result
        case msg
        case nextLink = "next_link"
        case data
    }
}

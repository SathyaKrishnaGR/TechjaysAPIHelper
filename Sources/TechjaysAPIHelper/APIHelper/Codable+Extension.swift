//
//  File.swift
//  
//
//  Created by SathyaKrishna on 20/09/21.
//

import Foundation

extension Encodable {
  func asDictionary() -> [String: Any] {
   return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
  }
}

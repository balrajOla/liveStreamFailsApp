//
//  DictionaryEncodable.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 23/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

protocol DictionaryCodable: Codable {}

extension DictionaryCodable {
  func dictionary() -> [String: Any]? {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .millisecondsSince1970
    guard let json = try? encoder.encode(self),
      let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
        return nil
    }
    return dict
  }
}

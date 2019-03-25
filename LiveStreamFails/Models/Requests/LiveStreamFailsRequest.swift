//
//  LiveStreamFailsRequest.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 23/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
private enum PostMode: String, Codable {
  case standard = "standard"
}

public struct LiveStreamFailsRequestModel: DictionaryCodable {
  let order: String = "hot"
  let pageNumber: Int
  let timeFrame: String = "all"
  private let postMode: PostMode
  
  private init(pageNumber: Int,
               postMode: PostMode) {
    
    self.pageNumber = pageNumber
    self.postMode = postMode
  }
  
  enum CodingKeys: String, CodingKey {
    case order = "loadPostOrder"
    case pageNumber = "loadPostPage"
    case postMode = "loadPostMode"
    case timeFrame = "loadPostTimeFrame"
  }
  
  static func instantiate(pageNumber: Int) -> LiveStreamFailsRequestModel {
    return LiveStreamFailsRequestModel(pageNumber: pageNumber, postMode: .standard)
  }
}

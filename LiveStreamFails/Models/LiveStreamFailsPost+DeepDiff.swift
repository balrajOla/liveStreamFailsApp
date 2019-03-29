//
//  LiveStreamFailsPostsResponse+DeepDiff.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 28/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import DeepDiff

extension LiveStreamFailsPost: DiffAware {
  public var diffId: Int {
    return self.id
  }
  
  public static func compareContent(_ a: LiveStreamFailsPost, _ b: LiveStreamFailsPost) -> Bool {
    return a.id == b.id
  }
}

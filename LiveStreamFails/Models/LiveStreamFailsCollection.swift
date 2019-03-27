//
//  LiveStreamFailsCollection.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 27/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import SwiftSoup

public class LiveStreamFailsCollection: Aggregatable {
  public var posts: [LiveStreamFailsPostsResponse]
  fileprivate var hasNextPage: Bool = true
  
  public init(elements: Elements) {
    self.posts = elements.compactMap{ LiveStreamFailsPostsResponse(element: $0) }
  }
  
  public init() {
    self.posts = [LiveStreamFailsPostsResponse]()
  }
  
  public func aggregate(result: Aggregatable) -> Aggregatable {
    self.posts = (result as? LiveStreamFailsCollection).flatMap { self.posts + $0.posts } ?? self.posts
    return self
  }
}

extension LiveStreamFailsCollection: Pagination {
  public func isNextPageAvailable() -> Bool {
    return true
  }
  
  public func updatePaginationStatus(next: Bool) {
    self.hasNextPage = next
  }
}

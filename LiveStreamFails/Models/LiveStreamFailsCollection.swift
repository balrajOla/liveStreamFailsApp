//
//  LiveStreamFailsCollection.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 27/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import SwiftSoup

public struct LiveStreamFailsCollection: Aggregatable {
  public var posts: [LiveStreamFailsPost]
  
  public init(posts: [LiveStreamFailsPost]) {
    self.posts = posts
  }
  
  public func aggregate(result: Aggregatable) -> Aggregatable {
    return LiveStreamFailsCollection(posts: (result as? LiveStreamFailsCollection).flatMap { self.posts + $0.posts } ?? self.posts)
  }
}

extension LiveStreamFailsCollection: Pagination {
  public func isNextPageAvailable() -> Bool {
    return true
  }
  
  public func updatePaginationStatus(next: Bool) {}
}

public struct LiveStreamFailsPost {
  let id: Int
  let title: String
  
  let game: String?
  let imageUrl: URL?
  let streamer: String?
  var videoUrl: URL?
  
  public init(response: (res: LiveStreamFailsPostsResponse, videoUrl: URL?)) {
    self.id = response.res.id
    self.title = response.res.title
    self.game = response.res.game
    self.imageUrl = response.res.imageUrl
    self.streamer = response.res.streamer
    self.videoUrl = response.videoUrl
  }
}

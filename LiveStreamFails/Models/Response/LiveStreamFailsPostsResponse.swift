//
//  LiveStreamFailsPostsResponse.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 24/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import SwiftSoup
import PromiseKit

public struct LiveStreamFailsPostsResponse {
  
  private let titlePath = HTMLParser.selectElem(path: "p.title")
  private let postIdPath = HTMLParser.selectElem(path: "a[href]")
  private let imgUrlPath = HTMLParser.selectElem(path: "img.card-img-top")
  private let streamerPath = HTMLParser.selectElem(path: "div.stream-info > small.text-muted")
  private let gamePath = HTMLParser.selectElem(path: "div.stream-info > small.text-muted")
  
  private let getText = { (_ path: Result<Elements>) -> String? in
    switch path {
    case .fulfilled(let elements):
      return try? elements.text()
    case .rejected( _):
      return nil
    }
  }
  
  private let getPostId = { (_ path: Result<Elements>) -> Int? in
    switch path {
    case .fulfilled(let elements):
      return (try? elements.attr("href").components(separatedBy: "/"))?.last.flatMap { Int($0) }
    case .rejected( _):
      return nil
    }
  }
  
  private let getGameUrl = { (_ path: Result<Elements>) -> String? in
    switch path {
    case .fulfilled(let elements):
      return (try? elements.select("a[href]")).flatMap { $0.last().flatMap { try? $0.text() } }
    case .rejected( _):
      return nil
    }
  }
  
  private let getStreamUrl = { (_ path: Result<Elements>) -> String? in
    switch path {
    case .fulfilled(let elements):
      return (try? elements.select("a[href]")).flatMap { $0.first().flatMap { try? $0.text() } }
    case .rejected( _):
      return nil
    }
  }
  
  private let getImageUrl = { (_ path: Result<Elements>) -> URL? in
    switch path {
    case .fulfilled(let elements):
      return (try? elements.attr("src")).flatMap { URL(string: $0) }
    case .rejected( _):
      return nil
    }
  }
  
  let id: Int
  let title: String
  
  let game: String?
  let imageUrl: URL?
  let streamer: String?
  
  init?(element: Element) {
    guard let title = getText(titlePath(element)),
          let postId = getPostId(postIdPath(element)) else {
      return nil
    }
    
    self.title = title
    self.id = postId
    self.game = getGameUrl(gamePath(element))
    self.streamer = getStreamUrl(streamerPath(element))
    self.imageUrl = getImageUrl(imgUrlPath(element))
  }
}

//
//  Service.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 24/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftSoup

public struct Service: ServiceType {
  public let serverConfig: ServerConfigType
  
  public init(serverConfig: ServerConfigType = ServerConfig.production) {
    self.serverConfig = serverConfig
  }
  
  public func fetchLiveStreamFailPost(forRequest request: LiveStreamFailsRequestModel) -> Promise<[LiveStreamFailsPostsResponse]> {
    return request
      |> Route.createLoadPosts(request:)
      |> request(route:)
      |> parse(response:)
  }
  
  public func fetchVideoStreamDetail(forPostId postId: String) -> Promise<(id: String, video: URL)> {
      let parseResponse = parse(postId: postId)
      return postId
        |> Route.fetchPostDetail(postId:)
        |> request(route:)
        |> parseResponse
  }
  
  private func parse(response: Promise<String>) -> Promise<[LiveStreamFailsPostsResponse]> {
    let selectPostCard = HTMLParser.selectDoc(path: "div.post-card")
    
    return response
      .then(on: DispatchQueue.global(qos: .background)) { (stringResponse: String) -> Promise<[LiveStreamFailsPostsResponse]> in
        return stringResponse
          |> HTMLParser.createDocument(fromHTMLString:)
          |> selectPostCard
          |> resultMap(f: { $0.compactMap { return LiveStreamFailsPostsResponse(element: $0) } })
          |> mapToPromise(result:)
    }
  }
  
  private func parse(postId: String)
    -> (_ details: Promise<String>)
    -> Promise<(id: String, video: URL)> {
      return { (_ details: Promise<String>) -> Promise<(id: String, video: URL)> in
        let parseVideoWithID = self.parseVideo(postId: postId)
        return details
          .then(on: DispatchQueue.global(qos: .background)) {
            $0
              |> HTMLParser.createDocument(fromHTMLString:)
              |> parseVideoWithID
        }
      }
  }
  
  private func parseVideo(postId: String)
    -> (_ result: Result<Document>)
    -> Promise<(id: String, video: URL)> {
      return { (_ result: Result<Document>) -> Promise<(id: String, video: URL)> in
        switch result {
        case .fulfilled(let value):
          return value
            .body()
            .flatMap(self.retrieveVideoUrl(fromBody:))
            .flatMap { Promise.value((id: postId, video: $0)) }
            ?? Promise(error: ServiceError.parsingIssue)
        case .rejected(let error):
          return Promise(error: error)
        }
      }
  }
  
  private func retrieveVideoUrl(fromBody body: Element) -> URL? {
    guard let urlString = try? body.select("video > source").attr("src") else {
      return nil
    }
    return URL(string: urlString)
  }
}

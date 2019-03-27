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
  
  public func fetchLiveStreamFailPost(forRequest request: LiveStreamFailsRequestModel) -> Promise<LiveStreamFailsCollection> {
    return request
      |> Route.createLoadPosts(request:)
      |> request(route:)
      |> parse(response:)
      |> requestDetail(forPosts:)
  }
  
  private func parse(response: Promise<String>) -> Promise<LiveStreamFailsCollection> {
    let selectPostCard = HTMLParser.selectDoc(path: "div.post-card")
    
    return response
      .then { (stringResponse: String) -> Promise<LiveStreamFailsCollection> in
        return stringResponse
          |> HTMLParser.createDocument(fromHTMLString:)
          |> selectPostCard
          |> resultMap(f: { LiveStreamFailsCollection(elements: $0) })
          |> mapToPromise(result:)
    }
  }
  
  private func requestDetail(forPosts posts: Promise<LiveStreamFailsCollection>) -> Promise<LiveStreamFailsCollection> {
    return posts
      .then { (liveStreamFailsCollection: LiveStreamFailsCollection) -> Promise<LiveStreamFailsCollection> in
        let mergePosts = self.merge(posts: liveStreamFailsCollection)
        
        return when(resolved: liveStreamFailsCollection.posts.map { self.fetchVideoStreamDetail(forPostId: String($0.id)) })
          .map{ (response: [Result<(id: String, video: URL)>]) -> LiveStreamFailsCollection in
            return response
              |> mergePosts
        }
    }
  }
  
  private func merge(posts: LiveStreamFailsCollection)
    -> (_ result: [Result<(id: String, video: URL)>])
    -> LiveStreamFailsCollection {
      return { (result: [Result<(id: String, video: URL)>]) -> LiveStreamFailsCollection in
        posts.posts = posts.posts.compactMap { (postsData: LiveStreamFailsPostsResponse) -> LiveStreamFailsPostsResponse? in
          result.first(where: { (resultData: Result<(id: String, video: URL)>) -> Bool in
            switch resultData {
            case .fulfilled(let tuppleValue):
              return tuppleValue.id == String(postsData.id) ? true : false
            case .rejected:
              return false
            }
          }).flatMap {
            switch $0 {
            case .fulfilled(let tuppleValue):
              var postsValue = postsData
              postsValue.videoUrl = tuppleValue.video
              return postsValue
            case .rejected:
              return nil
            }
          }
        }
        
        return posts
      }
  }
  
  private func fetchVideoStreamDetail(forPostId postId: String) -> Promise<(id: String, video: URL)> {
      let parseResponse = parse(postId: postId)
      return postId
        |> Route.fetchPostDetail(postId:)
        |> request(route:)
        |> parseResponse
  }
  
  private func parse(postId: String)
    -> (_ details: Promise<String>)
    -> Promise<(id: String, video: URL)> {
      return { (_ details: Promise<String>) -> Promise<(id: String, video: URL)> in
        let parseVideoWithID = self.parseVideo(postId: postId)
        return details
          .then {
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

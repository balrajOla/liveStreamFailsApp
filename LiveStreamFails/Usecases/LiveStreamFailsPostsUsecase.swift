//
//  LiveStreamFailsPostsUsecase.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 26/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit

public struct LiveStreamFailsPostsUsecase {
  private var paginator: Paginator<LiveStreamFailsCollection>!
  private let pagesize = 10
  
  public init() {
    paginator = Paginator<LiveStreamFailsCollection>(pageSize: pagesize,
                                                     asyncTask: fetchLiveFeedPosts)
  }
  
  public func getLiveFeedPosts() -> Promise<LiveStreamFailsCollection> {
    if Network.isConnected() {
      return self.paginator.fetchNextPage()
    } else {
      return Promise(error: ServiceError.noInternet)
    }
  }
  
  private func fetchLiveFeedPosts(page: Int, pageSize: Int) -> Promise<LiveStreamFailsCollection> {
    return fetchLiveStreamFailPost(request: LiveStreamFailsRequestModel.instantiate(pageNumber: page))
  }
  
  private func fetchLiveStreamFailPost(request: LiveStreamFailsRequestModel) -> Promise<LiveStreamFailsCollection> {
    return AppEnvironment.current.apiService.fetchLiveStreamFailPost(forRequest: request)
      |> requestDetail
  }
  
  private func merge(posts: [LiveStreamFailsPostsResponse])
    -> (_ result: [Result<(id: String, video: URL)>])
    -> LiveStreamFailsCollection {
      return { (result: [Result<(id: String, video: URL)>]) -> LiveStreamFailsCollection in
        return LiveStreamFailsCollection(posts: posts.compactMap { (postsData: LiveStreamFailsPostsResponse) -> LiveStreamFailsPost? in
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
              return LiveStreamFailsPost(response: (res: postsData, videoUrl: tuppleValue.video))
            case .rejected:
              return nil
            }
          }
        })
      }
  }
  
  private func requestDetail(posts: Promise<[LiveStreamFailsPostsResponse]>) -> Promise<LiveStreamFailsCollection> {
    return posts
      .then(on: DispatchQueue.global(qos: .background)) { (liveStreamFailsResponseCollection: [LiveStreamFailsPostsResponse]) -> Promise<LiveStreamFailsCollection> in
        let mergePosts = self.merge(posts: liveStreamFailsResponseCollection)
        
        return when(resolved: liveStreamFailsResponseCollection.map {
          AppEnvironment.current.apiService.fetchVideoStreamDetail(forPostId: String($0.id)) })
          .map{ (response: [Result<(id: String, video: URL)>]) -> LiveStreamFailsCollection in
            return response
              |> mergePosts
        }
    }
  }
}

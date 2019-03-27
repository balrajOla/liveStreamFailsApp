//
//  LiveStreamFailsPostsUsecase.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 26/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit

// Need to fetch data from post service
// paginate
// handle errors
// retry if required
// internet network handling

public struct LiveStreamFailsPostsUsecase {
  private let paginator: Paginator<LiveStreamFailsCollection>
  
  private let pagesize = 10
  private let fetchLiveFeedPosts = { (page: Int, pageSize: Int) -> Promise<LiveStreamFailsCollection> in
    return AppEnvironment.current.apiService.fetchLiveStreamFailPost(forRequest: LiveStreamFailsRequestModel.instantiate(pageNumber: page))
  }
  
  public init() {
    paginator = Paginator<LiveStreamFailsCollection>(pageSize: pagesize,
                                                     asyncTask: fetchLiveFeedPosts)
  }
  
  public func getLiveFeedPosts() -> Promise<LiveStreamFailsCollection> {
    return self.paginator.fetchNextPage()
  }
}

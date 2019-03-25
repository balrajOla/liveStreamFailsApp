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
  public func fetchLiveStreamFailPost(forRequest request: LiveStreamFailsRequestModel) -> Promise<[LiveStreamFailsPostsResponse]> {
    return request
      |> Route.createLoadPosts(request:)
      |> request(route:)
      |> parse(response:)
  }
  
  private func parse(response: Promise<String>) -> Promise<[LiveStreamFailsPostsResponse]> {
    let selectPostCard = HTMLParser.select(path: "div.post-card")
    
    return response
      .then { (stringResponse: String) -> Promise<[LiveStreamFailsPostsResponse]> in
        return stringResponse
          |> HTMLParser.createDocument(fromHTMLString:)
          |> selectPostCard
          |> resultMap(f: { $0.map{ LiveStreamFailsPostsResponse(element: $0) } })
          |> mapToPromise(result:)
    }
  }
}

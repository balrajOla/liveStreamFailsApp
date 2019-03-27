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
}

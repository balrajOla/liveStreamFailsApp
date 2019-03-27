//
//  Route.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 23/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import Alamofire

/**
 A list of possible requests that can be made for LiveStreamFails data.
 */
internal enum Route {
  case createLoadPosts(request: LiveStreamFailsRequestModel)
  case fetchPostDetail(postId: String)
  
  internal var requestProperties:
    (method: HTTPMethod, path: String, query: [String: Any]) {
    switch self {
    case let .createLoadPosts(request):
      return (HTTPMethod.get, "/load/loadPosts.php", request.dictionary() ?? [String: Any]())
    case let .fetchPostDetail(postId):
      return (HTTPMethod.get, "/post/\(postId)", [String: Any]())
    }
  }
}

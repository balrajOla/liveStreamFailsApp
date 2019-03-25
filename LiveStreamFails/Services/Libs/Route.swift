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
  
  internal var requestProperties:
    (method: HTTPMethod, path: String, query: [String: Any]) {
    switch self {
    case let .createLoadPosts(request):
      return (HTTPMethod.get, "/load/loadPosts.php", request.dictionary() ?? [String: Any]())
    }
  }
}

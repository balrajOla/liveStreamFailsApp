//
//  Service+RequestHelper.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 24/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

enum ServiceError: Error {
  case urlInvalid
}

extension Service {
  func request(route: Route) -> Promise<String> {
    let url = serverConfig.apiBaseUrl.appendingPathComponent(route.requestProperties.path)
      
    return Promise<String> { seal in
      Alamofire.request(url,
                        method: route.requestProperties.method,
                        parameters: route.requestProperties.query,
                        encoding: URLEncoding.default,
                        headers: nil)
        .validate(statusCode: 200..<300)
        .responseString(completionHandler: { response in
          switch response.result {
          case .success(let value):
            seal.fulfill(value)
          case .failure(let error):
            seal.reject(error)
          }
        })
    }
  }
}

//
//  ServiceType.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 24/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit

public protocol ServiceType {
  func fetchLiveStreamFailPost(forRequest request: LiveStreamFailsRequestModel
  ) -> Promise<[LiveStreamFailsPostsResponse]>
}

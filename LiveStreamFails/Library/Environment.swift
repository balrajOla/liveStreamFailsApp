//
//  Environment.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 26/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

/**
 A collection of **all** global variables and singletons that the app wants access to.
 */
public struct Environment {
  /// A type that exposes endpoints for fetching LiveStreamFails data.
  public let apiService: ServiceType
  
  public init(apiService: ServiceType = Service()) {
     self.apiService = apiService
  }
}

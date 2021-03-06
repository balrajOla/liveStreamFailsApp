//
//  AppEnvironment.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 26/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

/**
 A global stack that captures the current state of global objects that the app wants access to.
 */
public struct AppEnvironment {
  /**
   A global stack of environments.
   */
  fileprivate static var stack: [Environment] = [Environment()]
  
  // The most recent environment on the stack.
  public static var current: Environment! {
    return stack.last
  }
}

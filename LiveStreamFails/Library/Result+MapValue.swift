//
//  Result+MapValue.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 25/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit

extension Result {
  public func map<B>(f: (T) -> B) -> Result<B> {
    switch self {
    case .fulfilled(let value):
      return Result<B>.fulfilled(f(value))
    case .rejected(let error):
      return Result<B>.rejected(error)
    }
  }
  
  public func flatMap<B>(f: (T) -> Result<B>) -> Result<B> {
    switch self {
    case .fulfilled(let value):
      return f(value)
    case .rejected(let error):
      return Result<B>.rejected(error)
    }
  }
}

public func resultMap<A, B>(f: @escaping (A) -> B)
  -> (Result<A>)
  -> Result<B> {
    return { (result: Result<A>) -> Result<B> in
      return result.map(f: f)
    }
}

public func mapToPromise<T>(result: Result<T>)
  -> Promise<T> {
    switch result {
    case .fulfilled(let value):
      return Promise<T>.value(value)
    case .rejected(let error):
      return Promise<T>(error: error)
    }
}



//
//  Paginator.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 26/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import PromiseKit


/// RequestStatus for Paginator
///
/// - none:       No pages have been fetched.
/// - inProgress: The paginator fetchHandler is in progress.
/// - done:       All fetch calls have finished and data exists.
public enum RequestStatus {
  case none, inProgress, done
}

/// Make the result adhere to Pagination protocol to check if there is another page
public protocol Pagination {
  func isNextPageAvailable() -> Bool
  func updatePaginationStatus(next: Bool) -> Void
}

/// Make the result aggregatable
public protocol Aggregatable {
  func aggregate(result: Aggregatable) -> Aggregatable
}

public enum PaginationErrors: Error {
  case executionInProgress
  case dataNotAvailable
  case pagesCompleted
}

public class Paginator<T: Aggregatable> where T: Pagination {
  
  /// Size of pages.
  private var pageSize = 0
  
  /// Last page fetched.  Start at 1, fetch calls use page+1 and increment after.  Read-Only
  private var page = 1
  
  /// The requestStatus defines the current state of the paginator.  If .None, no pages have fetched.
  /// If .InProgress, incoming `fetchNextPage()` calls are ignored.
  private var requestStatus: RequestStatus = .none
  
  /// All results in the order they were received.
  private var results: T?
  
  /// Fetch Handler Signature
  public typealias AsyncTaskType   = (_ page: Int, _ pageSize: Int) -> Promise<T>
  
  /// Reset Handler Signature
  public typealias ResetHandlerType   = () -> ()
  
  /// The asyncTask is defined by the user, it defines the behaviour for how to fetch a given page.
  /// NOTE: completionHandler will be called with result value
  public private(set) var asyncTask: AsyncTaskType
  
  /// The resetHandler is called by `reset()`.  Here you can define a callback to be called after
  /// the paginator has been reset.
  public private(set) var resetHandler: ResetHandlerType?
  
  /// Creates a Paginator
  ///
  /// - parameter asyncTask    :      Block to define fetch behaviour, required.
  /// - parameter resetHandler:      Callback for `reset()`, will be called after data has been reset, optional.
  public init(pageSize: Int,
              asyncTask: @escaping AsyncTaskType,
              resetHandler: ResetHandlerType? = nil) {
    self.pageSize = pageSize
    self.asyncTask = asyncTask
    self.resetHandler = resetHandler
    self.setDefaultValues()
  }
  
  /// Reset the Paginator, clears all results
  public func reset() {
    setDefaultValues()
    resetHandler?()
  }
  
  /// Fetch the first page.  If requestStatus is not .None, the paginator will be reset.
  public func fetchFirstPage() -> Promise<T> {
    setDefaultValues()
    return fetchNextPage()
  }
  
  /// Fetch the next page.  If no pages are present it will fetch the first page
  public func fetchNextPage() -> Promise<T> {
    if requestStatus == .inProgress {
      return Promise(error: PaginationErrors.executionInProgress)
    }
    
    let pageNo = self.page
    
    if isNextPageAvailable {
      requestStatus = .inProgress
      
      return asyncTask(self.page, self.pageSize)
        .then { result -> Promise<T> in
          return self.aggregatingResult(pageNo: pageNo, result: result)
        }.tap { result in
          self.incrementPageNo(pageNo: pageNo, result: result)
        }.ensure(updateRequestStatusToDone)
    } else {
      return Promise(error: PaginationErrors.pagesCompleted)
    }
  }
  
  /// Boolean indicating all pages have been fetched
  public var isNextPageAvailable: Bool {
    if requestStatus == .none {
      // This means the result is not loaded for the first time also
      return true
    }
    
    // If the data is available the take that else no next page is available
    print("is next page available: \((self.results?.isNextPageAvailable() ?? false))")
    return (self.results?.isNextPageAvailable() ?? false)
  }
  
  ///Sets default values for total, page, and results.  Called by `reset()` and `init`
  private func setDefaultValues() {
    page = 1
    requestStatus = .none
    results = nil
  }
  
  /// Increment the page number by 1
  private func incrementPageNo(pageNo: Int, result: Result<T>) -> Void {
    switch result {
    case .fulfilled(_):
      self.page = pageNo + 1
    default: break
    }
  }
  
  /// Combine the previous result with the new one
  private func aggregatingResult(pageNo: Int, result: T) -> Promise<T> {
    return Promise<T> { seal in
      if pageNo == 1 {
        self.results = result
      } else {
        self.results = (self.results?.aggregate(result: result) as? T) ?? result
      }
      self.results?.updatePaginationStatus(next: result.isNextPageAvailable())
      
      // check if there is results or not
      if let res = self.results {
        seal.fulfill(res)
      } else {
        seal.reject(PaginationErrors.dataNotAvailable)
      }
    }
  }
  
  /// Mark the status of request as done to let the next set of instruction pass through
  private func updateRequestStatusToDone() -> Void {
    self.requestStatus = (self.results != nil) ? .done : .none
  }
}

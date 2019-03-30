//
//  HomeScreenViewController+CollectionViewDatasource.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 28/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit
import DeepDiff

extension HomeScreenViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.dataSource?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let data = self.dataSource?[indexPath.row],
      let cell = tableView.dequeueReusableCell(withIdentifier: FailStreamDetailVTableViewCell.identifier,
                                                    for: indexPath) as? FailStreamDetailVTableViewCell else {
                                                      fatalError("Failed to dequeue cell")
    }
    
    cell.set(data: data)
    return cell
  }
  
  private func checkAndPrefetchFails(forIndexPath indexPath: IndexPath) {
    if indexPath.row > ((self.dataSource?.count ?? 0) - 5) {
      showLoader()
      _ = self.usecase.getLiveFeedPosts()
        .done { response in
          self.dataSource.map {
            let changes = diff(old: $0, new: response.posts)
            self.failStreamTableView.reload(changes: changes, updateData: {
              self.dataSource = response.posts
            })
          }
        }.tap { _ in self.hideLoader() }
    }
  }
}

extension HomeScreenViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.failStreamTableView.bounds.height
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    checkAndPrefetchFails(forIndexPath: indexPath)
  }
}

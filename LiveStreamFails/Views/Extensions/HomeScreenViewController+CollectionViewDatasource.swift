//
//  HomeScreenViewController+CollectionViewDatasource.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 28/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit
import DeepDiff

extension HomeScreenViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.dataSource?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    
    guard let data = self.dataSource?[indexPath.row],
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FailStreamDetailViewCell.identifier,
                                                        for: indexPath) as? FailStreamDetailViewCell else {
                                                          fatalError("Failed to dequeue cell")
    }
    
    cell.set(data: data)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let cell = cell as? FailStreamDetailViewCell else {
      return
    }
    
    checkAndPrefetchFails(forIndexPath: indexPath)
  }
  
  private func checkAndPrefetchFails(forIndexPath indexPath: IndexPath) {
    if indexPath.row > ((self.dataSource?.count ?? 0) - 5) {
      self.usecase.getLiveFeedPosts()
        .done { response in
          self.dataSource.map {
            let changes = diff(old: $0, new: response.posts)
            self.failStreamCollectionView.reload(changes: changes, updateData: {
              self.dataSource = response.posts
            })
          }
      }
    }
  }
}

//
//  HomeScreenViewController+CollectionViewDatasource.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 28/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit

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
}

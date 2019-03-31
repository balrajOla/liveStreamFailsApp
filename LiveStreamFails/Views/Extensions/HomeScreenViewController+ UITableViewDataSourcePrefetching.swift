//
//  HomeScreenViewController+ UITableViewDataSourcePrefetching.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 31/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit

extension HomeScreenViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    // get data
    indexPaths.forEach { (indexPath: IndexPath) in
      (self.dataSource?[indexPath.row]).map {
        $0.videoUrl.map {
          VideoPlayerController.sharedVideoPlayer.setupVideoFor(url: $0.absoluteString)
        }
      }
    }
  }
}

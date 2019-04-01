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
    // TODO: Need to handle prefetching in videos with much care.
    // This consumes lot of bandwidth hence need to rethink about it.
//    indexPaths.forEach { (indexPath: IndexPath) in
//      (self.dataSource?[indexPath.row]).map {
//        $0.videoUrl.map {
//          VideoPlayerController.sharedVideoPlayer.setupVideoFor(url: $0.absoluteString)
//        }
//      }
//    }
  }
}

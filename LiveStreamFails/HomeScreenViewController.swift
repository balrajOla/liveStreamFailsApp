//
//  HomeScreenViewController.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 23/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit
import DeepDiff

class HomeScreenViewController: UIViewController {
  @IBOutlet weak var failStreamCollectionView: UICollectionView!
  @IBOutlet weak var splashScreenView: UIView!
  
  var dataSource: [LiveStreamFailsPost]?
  
  var usecase = LiveStreamFailsPostsUsecase()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      self.failStreamCollectionView.dataSource = self
      self.failStreamCollectionView.delegate = self
      self.failStreamCollectionView.isPagingEnabled = true
      
      self.failStreamCollectionView.registerCells([FailStreamDetailViewCell.self], bundle: Bundle.main)
      
      showLoader()
      _ = usecase.getLiveFeedPosts()
        .done { response in
          self.dataSource = response.posts
          self.failStreamCollectionView.reloadData()
        }.tap { _ in
          self.hideLoader()
          self.splashScreenView.isHidden = true
      }
    }
}

extension HomeScreenViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.failStreamCollectionView.frame.width, height: self.failStreamCollectionView.frame.height)
  }
}

extension HomeScreenViewController {
  func showLoader() {
    DispatchQueue.main.async {
      Loader.show()
    }
  }
  
  func hideLoader() {
    DispatchQueue.main.async {
      Loader.hide()
    }
  }
}

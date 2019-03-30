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
  @IBOutlet weak var failStreamTableView: UITableView!
  @IBOutlet weak var splashScreenView: UIView!
  
  var dataSource: [LiveStreamFailsPost]?
  
  var usecase = LiveStreamFailsPostsUsecase()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // set up navigation bar
      let nav = self.navigationController?.navigationBar
      nav?.barStyle = UIBarStyle.black
      nav?.tintColor = UIColor.white
      nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
      self.title = "LivestreamFails"

        // Do any additional setup after loading the view.
      self.failStreamTableView.dataSource = self
      self.failStreamTableView.delegate = self
      self.failStreamTableView.isPagingEnabled = true
      
      self.failStreamTableView.registerCells([FailStreamDetailVTableViewCell.self], bundle: Bundle.main)
      
      showLoader()
      _ = usecase.getLiveFeedPosts()
        .done { response in
          self.dataSource = response.posts
          self.failStreamTableView.reloadData()
        }.tap { _ in
          self.hideLoader()
          self.splashScreenView.isHidden = true
      }
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

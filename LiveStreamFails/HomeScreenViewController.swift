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
    self.failStreamTableView.prefetchDataSource = self
    self.failStreamTableView.isPagingEnabled = true
    
    self.failStreamTableView.registerCells([FailStreamDetailVTableViewCell.self], bundle: Bundle.main)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.appEnteredFromBackground),
                                           name: UIApplication.willEnterForegroundNotification, object: nil)
    
    showLoader()
    _ = usecase.getLiveFeedPosts()
      .done { response in
        self.dataSource = response.posts
        self.failStreamTableView.reloadData()
      }.tap { _ in
        self.hideLoader()
        self.pausePlayeVideos()
        self.splashScreenView.isHidden = true
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    pausePlayeVideos()
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

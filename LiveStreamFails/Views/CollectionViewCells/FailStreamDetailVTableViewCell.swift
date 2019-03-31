//
//  FailStreamDetailVTableViewCell.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 30/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit
import AlamofireImage
import AVFoundation

class FailStreamDetailVTableViewCell: UITableViewCell, AutoPlayVideoLayerContainer {
  @IBOutlet weak var liveStreamImg: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var subTitle: UILabel!
  
  // Video Player Properties
  var playerController: VideoPlayerController?
  var videoLayer: AVPlayerLayer = AVPlayerLayer()
  var videoURL: String? {
    didSet {
      if let videoURL = videoURL {
        VideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
      }
      videoLayer.isHidden = videoURL == nil
    }
  }
  
  class var identifier: String{
    return String(describing: self)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    videoLayer.backgroundColor = UIColor.clear.cgColor
    videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect
    liveStreamImg.layer.addSublayer(videoLayer)
    selectionStyle = .none
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.liveStreamImg.image = nil
    self.title.text = nil
    self.subTitle.text = nil
  }
  
  public func set(data: LiveStreamFailsPost) {
    data.imageUrl.map { self.liveStreamImg.af_setImage(withURL: $0) }
    self.title.text = data.title
    self.subTitle.text = [data.streamer, data.game].compactMap { $0 }.joined(separator: " playing ")
    self.videoURL = data.videoUrl?.absoluteString
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
   videoLayer.frame = self.liveStreamImg.bounds
  }
  
  func visibleVideoHeight() -> CGFloat {
    let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(liveStreamImg.frame, from: liveStreamImg)
    guard let videoFrame = videoFrameInParentSuperView,
      let superViewFrame = superview?.frame else {
        return 0
    }
    let visibleVideoFrame = videoFrame.intersection(superViewFrame)
    return visibleVideoFrame.size.height
  }
}

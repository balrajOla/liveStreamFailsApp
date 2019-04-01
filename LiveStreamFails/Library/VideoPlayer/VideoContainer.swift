//
//  VideoContainer.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 31/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import AVFoundation

class VideoContainer {
  var url: String
  var playOn: Bool {
    didSet {
      player.isMuted = VideoPlayerController.sharedVideoPlayer.mute
      playerItem.preferredPeakBitRate = VideoPlayerController.sharedVideoPlayer.preferredPeakBitRate
      if playOn && playerItem.status == .readyToPlay {
        player.play()
      }
      else{
        player.pause()
      }
    }
  }
  
  let player: AVPlayer
  let playerItem: AVPlayerItem
  
  init(player: AVPlayer, item: AVPlayerItem, url: String) {
    self.player = player
    self.playerItem = item
    self.url = url
    playOn = false
  }
}

//
//  FailStreamDetailViewCell.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 28/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit
import AlamofireImage

class FailStreamDetailViewCell: UICollectionViewCell {
  @IBOutlet weak var liveStreamImg: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var subTitle: UILabel!
  
  class var identifier: String{
    return String(describing: self)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
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
  }
}

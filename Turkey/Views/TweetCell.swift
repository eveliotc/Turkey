//
//  TweetCell.swift
//  Turkey
//
//  Created by Evelio Tarazona on 10/30/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
  
  func tweetCell(tweetCell: TweetCell, didTapProfile user: User)
}

class TweetCell: BaseTableViewCell {
  
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var handleTimeLabel: UILabel!
  
  var tweet : Tweet! {
    didSet {
      
      if let url = tweet.user.profileImage {
        photoImageView.setImageWith(url, placeholderImage: Placeholders.image)
      } else {
        photoImageView.image = Placeholders.image
      }
      
      nameLabel.text = tweet.user.name
      tweetTextLabel.text = tweet.text
      handleTimeLabel.text = "@\(tweet.user.username) · \(tweet.timeAgo)"
    }
  }
  
  var delegate: TweetCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    photoImageView.layer.cornerRadius = 5
    photoImageView.clipsToBounds = true
    
    photoImageView.addGestureRecognizer(createProfileTap())
    nameLabel.addGestureRecognizer(createProfileTap())
    handleTimeLabel.addGestureRecognizer(createProfileTap())
  }
  
  private func createProfileTap() -> UITapGestureRecognizer {
    let tap = UITapGestureRecognizer()
    tap.addTarget(self, action: #selector(onProfileTap))
    return tap
  }
  
  @objc private func onProfileTap() {
    delegate?.tweetCell(tweetCell: self, didTapProfile: tweet.user)
  }

  override func prepareForReuse() {
    photoImageView.cancelImageRequestOperation()
    
  }
  
}

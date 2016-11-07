//
//  TweetController.swift
//  Turkey
//
//  Created by Evelio Tarazona on 10/31/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import UIKit

class TweetController: UIViewController {
  
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var handleTimeLabel: UILabel!
  
  var tweet : Tweet!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let url = tweet.user.profileImage {
      photoImageView.setImageWith(url, placeholderImage: Placeholders.image)
    } else {
      photoImageView.image = Placeholders.image
    }
    
    nameLabel.text = tweet.user.name
    tweetTextLabel.text = tweet.text
    handleTimeLabel.text = "@\(tweet.user.username) · \(tweet.timeAgo)"
    
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
    NavigationManager.shared.displayProfile(tweet.user, from: self)
  }

}

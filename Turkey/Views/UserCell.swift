//
//  UserCell.swift
//  Turkey
//
//  Created by Evelio Tarazona on 11/6/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import Foundation
import UIKit

class UserCell: UITableViewCell {
  
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var bioLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  @IBOutlet weak var tweetsLabel: UILabel!
  @IBOutlet weak var followingLabel: UILabel!
  @IBOutlet weak var followersLabel: UILabel!
  
  var user: User! {
    didSet {
      
      if let url = user.profileImage {
        photoImageView.setImageWith(url, placeholderImage: Placeholders.image)
      } else {
        photoImageView.image = Placeholders.image
      }
      
      if let url = user.profileBackgroundImage {
        backgroundImageView.setImageWith(url, placeholderImage: Placeholders.image)
      } else {
        backgroundImageView.image = Placeholders.image
      }

      nameLabel.text = user.name
      bioLabel.text = user.bio
      handleLabel.text = "@\(user.username)"
      tweetsLabel.text = "\(user.counts.tweets)"
      followingLabel.text = "\(user.counts.following)"
      followersLabel.text = "\(user.counts.followers)"
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    photoImageView.layer.cornerRadius = 5
    photoImageView.clipsToBounds = true
    
  }
  
  override func prepareForReuse() {
    photoImageView.cancelImageRequestOperation()
    backgroundImageView.cancelImageRequestOperation()
    
  }
  
}

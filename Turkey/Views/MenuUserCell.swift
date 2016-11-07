//
//  MenuUserCell.swift
//  Turkey
//
//  Created by Evelio Tarazona on 11/6/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class MenuUserCell: UITableViewCell {
  
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  
  var user: User! {
    didSet {
      
      if let url = user.profileImage {
        photoImageView.setImageWith(url, placeholderImage: Placeholders.image)
      } else {
        photoImageView.image = Placeholders.image
      }
      nameLabel.text = user.name
      handleLabel.text = "@\(user.username)"
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    photoImageView.layer.cornerRadius = 5
    photoImageView.clipsToBounds = true
    
  }
  
  override func prepareForReuse() {
    photoImageView.cancelImageRequestOperation()
    
  }
  
}

//
//  ComposeController.swift
//  Turkey
//
//  Created by Evelio Tarazona on 10/31/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import UIKit

protocol ComposeControllerDelegate: class {
  
  func composeController(composeController: ComposeController, didTweet tweet: Tweet)
}

class ComposeController: UIViewController {
  
  @IBOutlet weak var tweetTextView: UITextView!
  @IBOutlet weak var characterCountLabel: UILabel!
  weak var delegate: ComposeControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tweetTextView.delegate = self
    tweetTextView.becomeFirstResponder()
  }
  
  @IBAction func onNevermindTap(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func onTweetTap(_ sender: UIButton) {
    guard let text = tweetTextView.text, !text.isEmpty && text.characters.count <= kCharacterLimit  else {
      return
    }
    
    TwitterClient.shared.tweet(text) {
      self.delegate?.composeController(composeController: self, didTweet: Tweet.from(text))
      self.dismiss(animated: true, completion: nil)
    }
  }
  
}

private let kCharacterLimit = 140
extension ComposeController: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    characterCountLabel.text = "\(kCharacterLimit - textView.text.characters.count)"
  }
  
}

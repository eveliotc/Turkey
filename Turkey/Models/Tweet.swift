//
//  Tweet.swift
//  Turkey
//
//  Created by Evelio Tarazona on 10/30/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import Foundation


struct Tweet {
  
  let id: Int64
  let text: String
  let createdAt: Date
  let user: User
  var timeAgo: String = "now"
  
  public init(_ map: NSDictionary) {
    id = map["id"] as! Int64
    text = map["text"] as! String
    user = User(map["user"] as! NSDictionary)
    createdAt = Date()
    timeAgo = "1m"
  }
  
  private init(text: String) {
    id = -1
    self.text = text
    user = AccountManager.shared.currentUser!
    createdAt = Date()
    timeAgo = "now"
  }
  
  
  static func from(_ array: [NSDictionary]) -> [Tweet] {
    var tweets = [Tweet]()
    for json in array {
      tweets.append(Tweet(json))
    }
    return tweets
  }
  
  static func from(_ text: String) -> Tweet {
    return Tweet(text: text)
  }
  
}

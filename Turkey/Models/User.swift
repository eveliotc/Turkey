//
//  User.swift
//  twitter
//
//  Created by Evelio Tarazona on 10/30/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import Foundation

public struct User: Persistable {
  public typealias Source = NSDictionary
  let sourceValue: NSDictionary
  let id: String
  let username: String
  let name: String
  let bio: String
  let profileImage: URL?
  let profileBackgroundImage: URL?
  let website: URL?
  let location: String
  let protected: Bool
  let verified: Bool
  let following: Bool
  let counts: UserCounts
  
  public init(_ map: Source) {
    sourceValue = map
    id = map["id_str"] as? String ?? ""
    username = map["screen_name"] as? String ?? ""
    name = map["name"] as? String ?? ""
    bio = map["description"] as? String ?? ""
    profileImage = URL.from(map["profile_image_url_https"])
    profileBackgroundImage = URL.from(map["profile_background_image_url_https"])
    website = URL.from(map["url"])
    location = map["location"] as? String ?? ""
    protected = map["protected"] as? Bool ?? false
    verified = map["verified"] as? Bool ?? false
    following = map["following"] as? Bool ?? false
    counts = UserCounts(map)
  }
  
  public func source() -> NSDictionary {
    return sourceValue
  }
  
}

extension URL {
  static func from(_ value: Any?) -> URL? {
    if let string = value as? String {
      return URL(string: string)
    }
    return nil
  }
}

struct UserCounts {
  let tweets: UInt
  let followers: UInt
  let following: UInt
  let favourites: UInt
  
  init(_ map: NSDictionary) {
    tweets = map["statuses_count"] as? UInt ?? 0
    followers = map["followers_count"] as? UInt ?? 0
    following = map["friends_count"] as? UInt ?? 0
    favourites = map["favourites_count"] as? UInt ?? 0
  }
}

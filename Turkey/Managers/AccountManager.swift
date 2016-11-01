//
//  AccountManager.swift
//  twitter
//
//  Created by Evelio Tarazona on 10/30/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import Foundation

fileprivate let kUserDataKey = "userData"

public class AccountManager {
  static let shared = AccountManager()
  
  private let persistence = Persistence<User>(key: kUserDataKey, defaults: UserDefaults.standard)
  var currentUser: User?
  
  func login(_ success: @escaping (() -> Void) ) {
    logout()
    TwitterClient.shared.login { user in
      self.currentUser = user
      self.persistence.save(user)
      success()
    }
  }
  
  func logout() {
    TwitterClient.shared.deauthorize()
    currentUser = nil
    persistence.clear()
  }
  
  func restore() {
    currentUser = persistence.load()
  }
  
  func hasCredentials() -> Bool {
    return TwitterClient.shared.isAuthorized
  }
  
}

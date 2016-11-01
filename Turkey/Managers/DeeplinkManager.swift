//
//  DeeplinkManager.swift
//  twitter
//
//  Created by Evelio Tarazona on 10/30/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import Foundation

public class DeeplinkManager {
  static let shared = DeeplinkManager()
  
  func handle(_ url: URL) -> Bool {
    // Currently only oauth uses deeplink
    TwitterClient.shared.handleOAuthURL(url)
    return true
  }
}

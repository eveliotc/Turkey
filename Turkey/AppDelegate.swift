//
//  AppDelegate.swift
//  twitter
//
//  Created by Evelio Tarazona on 10/29/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    let accountManager = AccountManager.shared
    accountManager.restore()
    
    window?.rootViewController = NavigationManager.shared.rootViewController
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return DeeplinkManager.shared.handle(url)
  }
}


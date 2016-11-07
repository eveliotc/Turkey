//
//  NavigationManager.swift
//  Turkey
//
//  Created by Evelio Tarazona on 11/6/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import Foundation
import UIKit

class NavigationManager {
  static let shared = NavigationManager()
  
  private var mainStoryboard: UIStoryboard {
    get {
      return UIStoryboard(name: "Main", bundle: nil)
    }
  }
  
  var rootViewController: UIViewController {
    get {
      let controller = AccountManager.shared.hasCredentials()
        ? mainStoryboard.instantiateViewController(withIdentifier: "ContainerController")
        : mainStoryboard.instantiateInitialViewController()
      return controller!
    }
  }
  
  private func instantiateTimelineController() -> TimelineController {
    return mainStoryboard.instantiateViewController(withIdentifier: "TimelineController") as! TimelineController
  }
  
  private func instantiateTimelineNavigationController() -> UINavigationController {
    return mainStoryboard.instantiateViewController(withIdentifier: "TimelineNavigationController") as! UINavigationController
  }
  
  private func embed(_ cacheIdentifier: String, factory: () -> UIViewController, into: MenuController) {
    let vc: UIViewController
    if let cached = into.sideMenuController?.viewController(forCacheIdentifier: cacheIdentifier) {
      vc = cached
    } else {
      vc = factory()
    }
    into.sideMenuController?.embed(centerViewController: vc, cacheIdentifier: cacheIdentifier)
  }
  
  func toInitial(from: UIViewController) {
    from.performSegue(withIdentifier: "PostLogInSegue", sender: self)
  }
  
  func displayProfile(_ user: User!, from: UIViewController) {
    if let fromProfile = from as? TimelineController, let profileUser = fromProfile.user {
      guard profileUser.id != user.id else {
        return
      }
    }
    let profile = instantiateTimelineController()
    profile.timeline = .user
    profile.user = user
    from.navigationController?.pushViewController(profile, animated: true)
  }
  
  func displayMyProfile(from: MenuController) {
    embed("MyProfile", factory: {
      let navController = instantiateTimelineNavigationController()
      let profile = navController.viewControllers[0] as! TimelineController
      profile.timeline = .user
      profile.user = AccountManager.shared.currentUser
      return navController
    }, into: from)
  }
  
  func displayHome(from: MenuController) {
    embed("Home", factory: {
      let navController = instantiateTimelineNavigationController()
      let controller = navController.viewControllers[0] as! TimelineController
      controller.timeline = .home
      return navController
    }, into: from)
  }
  
  func displayReplies(from: MenuController) {
    embed("Replies", factory: {
      let navController = instantiateTimelineNavigationController()
      let controller = navController.viewControllers[0] as! TimelineController
      controller.timeline = .replies
      controller.title = "Replies"
      return navController
    }, into: from)
  }
}

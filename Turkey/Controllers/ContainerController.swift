//
//  MenuController.swift
//  Turkey
//
//  Created by Evelio Tarazona on 11/6/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import UIKit
import SideMenuController

class ContainerController: SideMenuController {
  
  required init?(coder aDecoder: NSCoder) {
    SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "ic_menu")
    SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelLeft
    SideMenuController.preferences.drawing.sidePanelWidth = 242
    SideMenuController.preferences.drawing.centerPanelShadow = true
    SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
    SideMenuController.preferences.interaction.panningEnabled = true
    SideMenuController.preferences.interaction.swipingEnabled = true
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    performSegue(withIdentifier: "embedInitialCenterController", sender: nil)
    performSegue(withIdentifier: "embedSideController", sender: nil)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}

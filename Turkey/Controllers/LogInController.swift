//
//  LogInController.swift
//  twitter
//
//  Created by Evelio Tarazona on 10/30/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import UIKit

class LogInController: UIViewController {
  
  @IBAction func onLoginWithTwitterTapped(_ sender: Any) {
    AccountManager.shared.login {
      self.performSegue(withIdentifier: "PostLogInSegue", sender: self)
    }
  }
}

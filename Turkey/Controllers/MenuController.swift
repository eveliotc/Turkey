//
//  MenuController.swift
//  Turkey
//
//  Created by Evelio Tarazona on 11/6/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import UIKit

struct MenuItem {
  let title: String
  let action: (MenuController) -> ()
  
  init(title: String, action: @escaping (MenuController) -> ()) {
    self.title = title
    self.action = action
  }
}

class MenuController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  let menuItems = [
    MenuItem(title: "Profile", action: { menuController in
      NavigationManager.shared.displayMyProfile(from: menuController)
    }),
    MenuItem(title: "Home", action: { menuController in
      NavigationManager.shared.displayHome(from: menuController)
    }),
    MenuItem(title: "Replies", action: { menuController in
      NavigationManager.shared.displayReplies(from: menuController)
    }),
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    tableView.selectRow(at: IndexPath(row: 1, section: 0), animated: false, scrollPosition: .none)
  }
  
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let userCell = tableView.dequeueReusableCell(withIdentifier: "MenuUserCell", for: indexPath) as! MenuUserCell
      userCell.user = AccountManager.shared.currentUser
      return userCell;
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
    cell.menuLabel.text = menuItems[indexPath.row].title
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    menuItems[indexPath.row].action(self)
  }
}

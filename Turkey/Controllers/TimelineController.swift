//
//  TimelineController.swift
//  twitter
//
//  Created by Evelio Tarazona on 10/30/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import UIKit
import JGProgressHUD
import SVPullToRefresh

class TimelineController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var timeline: Timeline = .home
  var tweets = [Tweet]()
  var user: User? {
    didSet {
      self.title = "@\(user!.username)"
      self.navigationItem.rightBarButtonItem = nil
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    tableView.addPullToRefresh(actionHandler: { [weak self] in
      self?.loadTimeline()
    })
    tableView.addInfiniteScrolling(actionHandler: { [weak self] in
      self?.loadTimeline(more: true)
    })
    
    loadTimeline()
    addUserHeaderIfPresent()
  }
  
  func loadTimeline(more: Bool = false) {
    let maxId = more ? tweets.last?.id : nil
    TwitterClient.shared.timeline(timeline, userId: user?.id, maxId: maxId) { tweets in
      if more {
        self.tweets.append(contentsOf: tweets)
      } else {
        self.tweets = tweets
      }
      self.tableView.reloadData()
      
      self.tableView.pullToRefreshView.stopAnimating()
      self.tableView.infiniteScrollingView.stopAnimating()
    }
  }
  
  func addUserHeaderIfPresent() {
    guard user != nil else {
      return
    }
    
    let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
    userCell.user = user
    tableView.tableHeaderView = userCell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowTweet" {
      let tweetController = segue.destination as! TweetController
      let cell = sender as! TweetCell
      tweetController.tweet = cell.tweet
      return
    }
    
    if segue.identifier == "ComposeTweet" {
      let composeController = segue.destination as! ComposeController
      composeController.delegate = self
      return
    }
  }
}

extension TimelineController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
    cell.delegate = self
    cell.tweet = tweets[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension TimelineController: ComposeControllerDelegate {
  func composeController(composeController: ComposeController, didTweet tweet: Tweet) {
    tweets.insert(tweet, at: 0)
    tableView.reloadData()
  }
}

extension TimelineController: TweetCellDelegate {
  func tweetCell(tweetCell: TweetCell, didTapProfile user: User) {
    NavigationManager.shared.displayProfile(user, from: self)
  }
}

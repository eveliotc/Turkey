//
//  HomeController.swift
//  twitter
//
//  Created by Evelio Tarazona on 10/30/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import UIKit
import JGProgressHUD
import SVPullToRefresh

class HomeController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var tweets = [Tweet]()
  
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
  }
  
  func loadTimeline(more: Bool = false) {
    let maxId = more ? tweets.last?.id : nil
    TwitterClient.shared.homeTimeline(maxId: maxId) { tweets in
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

extension HomeController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
    
    cell.tweet = tweets[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension HomeController: ComposeControllerDelegate {
  func composeController(composeController: ComposeController, didTweet tweet: Tweet) {
    tweets.insert(tweet, at: 0)
    tableView.reloadData()
  }
}

//
//  Twitter.swift
//  twitter
//
//  Created by Evelio Tarazona on 10/30/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

private let kBase = "https://api.twitter.com"

class TwitterClient: BDBOAuth1SessionManager {
  static let shared = TwitterClient(baseURL: URL(string: kBase)!, consumerKey: kKey, consumerSecret: kSecret)!
  
  private var loginSuccess: ((User) -> ())?
  private var loginFailure: ((Error?) -> ())?
  
  func login(failure: ((Error?) -> ())? = nil, success: @escaping ((User) -> ())) {
    deauthorize()
    loginSuccess = success
    fetchRequestToken(
      withPath: "oauth/request_token",
      method: "GET",
      callbackURL: URL(string: "turkeyevelio://oauth")!,
      scope: nil,
      success: { requestToken in
        let authStr = "\(kBase)/oauth/authorize?oauth_token=\(requestToken!.token!)"
        let authURL = URL(string: authStr)!
        UIApplication.shared.open(authURL)
    },
      failure: { error in
        self.log(error)
        self.loginFailure?(error)
    })
  }
  
  func handleOAuthURL(_ url: URL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    fetchAccessToken(
      withPath: "oauth/access_token", method: "POST", requestToken: requestToken,
      success: { accessToken in
        self.loadUser(failure: self.loginFailure, success: self.loginSuccess!)
    }, failure: { error in
      self.log(error)
      self.loginFailure?(error)
    })
  }
  
  func loadUser(failure: ((Error?) -> ())? = nil, success: @escaping ((User) -> ())) {
    get("1.1/account/verify_credentials.json", parameters: nil,
        success: { ( _, response ) in
          self.log(response)
          success(User(response as! NSDictionary))
    },
        failure: { (_, error) in
          self.log(error)
          failure?(error)
    })
  }
  
  func homeTimeline(sinceId: Int64? = nil, maxId: Int64? = nil, failure: ((Error?) -> ())? = nil, success: @escaping (([Tweet]) -> ())) {
    
    var params: [String : Any] = ["count": 20]
    if let maxId = maxId {
      params["max_id"] = maxId - 1
    }
    if let sinceId = sinceId {
      params["since_id"] = sinceId
    }
    get("1.1/statuses/home_timeline.json", parameters: params,
        success: { ( _, response ) in
          self.log("Got response \(response)")
          let array = response as! [NSDictionary]
          let tweets = Tweet.from(array)
          success(tweets)
          
    },
        failure: { (_, error) in
          self.log(error)
          failure?(error)
    })
  }
  
  func tweet(_ text: String, failure: ((Error?) -> ())? = nil, success: @escaping (() -> ())) {
    let params: [String : Any] = ["status": text]
    post("1.1/statuses/update.json", parameters: params,
         success: { ( _, response ) in
          self.log(response)
          success()
    },
         failure: { (_, error) in
          self.log(error)
          failure?(error)
    })
    
  }
  
  private func log(_ any: Any?) {
    if let error = any as? Error {
      print(error.localizedDescription )
    }
    print("\(any)")
  }
  
}

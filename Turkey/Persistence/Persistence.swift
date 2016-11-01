//
//  Persistence.swift
//  Turkey
//
//  Created by Evelio Tarazona on 10/30/16.
//  Copyright © 2016 Evelio Tarazona. All rights reserved.
//

import Foundation

public protocol Persistable {
  associatedtype Source
  
  init(_ source: Source) throws
  
  func source() -> Source
}

class Persistence<T: Persistable> {
  
  let key: String
  let defaults: UserDefaults
  
  init(key: String, defaults: UserDefaults) {
    self.key = key
    self.defaults = defaults
  }
  
  func save(_ value: T) {
    
    let data = try! JSONSerialization.data(withJSONObject: value.source(), options: [])
    defaults.setValue(data, forKey: key)
    defaults.synchronize()
  }
  
  func load() -> T? {
    if let data = UserDefaults.standard.object(forKey: key) as? Data {
      let source = try! JSONSerialization.jsonObject(with: data as Data, options: [])
      let instance = try? T(source as! T.Source)
      return instance
    }
    return nil
  }
  
  func clear() {
    defaults.removeObject(forKey: key)
  }
  
}

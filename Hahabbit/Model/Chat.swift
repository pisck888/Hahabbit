//
//  Chat.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/30.
//

import Foundation

struct Chat {
  var users: [String]
  var dictionary: [String: Any] {
    return ["users": users]
  }
}

extension Chat {
  init?(dictionary: [String:Any]) {
    guard let chatUsers = dictionary["users"] as? [String] else {return nil}
    self.init(users: chatUsers)
  }
}

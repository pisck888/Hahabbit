//
//  User.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/23.
//

import Foundation

struct User: Decodable, Equatable {
  var id: String
  var title: String
  var name: String
  var image: String
  var coin: Int
  var email: String
  var titleArray: [String]
  var blacklist: [String]

  static func == (lhs: User, rhs:User) -> Bool {
    lhs.id == rhs.id
  }
}

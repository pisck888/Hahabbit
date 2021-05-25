//
//  User.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/23.
//

import Foundation

struct User: Decodable {
  var id: String
  var title: String
  var name: String
  var location: String
  var image: String
  var coin: Int
}

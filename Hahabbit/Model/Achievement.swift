//
//  Achievement.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/25.
//

import Foundation

struct Achievement: Decodable {
  var id: Int
  var type: Int
  var reward: Int
  var title: String
  var discription: String
  var requirement: Int
  var isDone: [String]
}

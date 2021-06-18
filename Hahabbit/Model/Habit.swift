//
//  Habits.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/19.
//

import Foundation

struct Habit: Codable {
  var id: String
  var title: String
  var weekday: [String: Bool]
  var slogan: String
  var members: [String]
  var detail: String
  var location: String
  var owner: String
  var type: [String: Bool]
  var icon: String
  var photo: String
}

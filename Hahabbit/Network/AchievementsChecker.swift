//
//  AchievementsChecker.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/25.
//

import Foundation

class AchievementsChecker {

  static let checker = AchievementsChecker()

  func checkAllAchievements() {

  }

  func checkAchievements0() {

  }
  // 半夜睡不著覺
  func checkAchievements1() {

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH"

    let timeString = dateFormatter.string(from: Date())

    if timeString == "17" {
      print("獲得成就")
    }
  }
  
}

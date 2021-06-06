//
//  Constants.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//
// swiftlint:disable type_name

import Foundation

enum K {
  static let addNewGoalCell = "AddNewGoalCell"

  static let mainPageTableViewCell = "MainPageTableViewCell"

  static let publicGoalsTableViewCell = "PublicGoalsTableViewCell"
}

enum MySegue {
  static let toAddNewGoalDetailPage = "SegueToAddNewGoalDetailPage"

  static let toChatRoomPage = "SegeuToChatRoomPage"

  static let toBlacklistPage = "SegueToBlacklistPage"

  static let toMainPage = "SegueToMainPage"

  static let toLoginPage = "SegueToLoginPage"
}

enum MyArray {
  static let locationArray = [
    "台北市", "新北市", "基隆市", "桃園市", "新竹市", "新竹縣", "苗栗縣",
    "台中市", "彰化縣", "南投縣", "雲林縣", "嘉義市", "嘉義縣", "台南市",
    "高雄市", "屏東縣", "宜蘭縣", "花蓮縣", "台東縣", "澎湖縣", "金門縣",
    "連江縣", "不限制"
  ]
  static let weekdayArray = [ "周日", "周一", "周二", "周三", "周四", "周五", "周六"]
  static let typeArray = ["健身運動", "學習技能", "自我管理", "其他自訂"]

  static let weekday = ["Sun.", "Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat."]

  static let habitIconArray = [
    "abstract", "accordion", "balet", "banjo", "basket", "beach", "beer",
    "beer2", "book", "boomerang", "boots", "candles", "cheeseMeat", "coat",
    "coconut-drink", "coffee", "coin", "dancer", "dog", "donations", "drum",
    "envelope", "excalibur", "fireworks", "food", "gifts", "guitar", "harp",
    "heart", "icecream", "lion", "love", "mask2", "monalisa", "no-alchool",
    "no-cookie", "no-music", "no-shopping", "no-tech", "people-love", "perfume",
    "peru", "pray-down", "pray", "rain", "roses", "scroll", "slippers", "smoke",
    "stopwatch", "sunrise", "sword", "symbol", "tea"
  ]
}

//
//  Constants.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//
// swiftlint:disable type_name

import Foundation
import UIKit
import SwiftTheme
import SwiftHEXColors

enum K {

  static let addNewGoalCell = "AddNewGoalCell"

  static let mainPageTableViewCell = "MainPageTableViewCell"

  static let publicHabitsTableViewCell = "PublicHabitsTableViewCell"
}

enum MySegue {
  static let toAddNewGoalDetailPage = "SegueToAddNewGoalDetailPage"

  static let toChatRoomPage = "SegeuToChatRoomPage"

  static let toBlocklistPage = "SegueToBlocklistPage"

  static let toMainPage = "SegueToMainPage"

  static let toLoginPage = "SegueToLoginPage"

  static let toThemePage = "SegueToThemePage"
}

enum MyArray {
  static let locationArray = [
    "台北市", "新北市", "基隆市", "桃園市", "新竹市", "新竹縣", "苗栗縣",
    "台中市", "彰化縣", "南投縣", "雲林縣", "嘉義市", "嘉義縣", "台南市",
    "高雄市", "屏東縣", "宜蘭縣", "花蓮縣", "台東縣", "澎湖縣", "金門縣",
    "連江縣", "不限制"
  ]

  static let mainPageTag = [
    "全部習慣", "公開習慣", "私人習慣", "運動健身", "技能學習", "自我管理", "其他自訂"
  ]

  static let addGoalTitle = [
    "運動健身", "技能學習", "自我管理", "其他自訂"
  ]

  static let publicHabitsPageTag = [
    "總覽", "跑步", "重訓", "英文", "日文", "減肥", "喝水", "冥想"
  ]

  static let weekdayArray = [
    "周日", "周一", "周二", "周三", "周四", "周五", "周六"
  ]

  static let typeArray = [
    "運動健身", "技能學習", "自我管理", "其他自訂"
  ]

  static let settingsTitle = ["語言設置", "封鎖名單", "主題顏色", "震動反饋", "暗黑模式", "Touch ID"]

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

enum ThemeColor {

  static let color = ThemeColorPicker(
    colors: UIColor.darkGray,
    UIColor(hexString: "#63ace5") ?? .black,
    UIColor(hexString: "#3da4ab") ?? .black,
    UIColor(hexString: "#f6cd61") ?? .black,
    UIColor(hexString: "#fe8a71") ?? .black,
    UIColor(hexString: "#FCB6D8") ?? .black,
    UIColor(hexString: "#CF133D") ?? .black,
    UIColor(hexString: "#AEADEB") ?? .black,
    UIColor(hexString: "#A436FC") ?? .black,
    UIColor(hexString: "#CEB1AB") ?? .black
  )
  
  static let colorArray: [UIColor] = [
    UIColor.darkGray,
    UIColor(hexString: "#63ace5") ?? .black,
    UIColor(hexString: "#3da4ab") ?? .black,
    UIColor(hexString: "#f6cd61") ?? .black,
    UIColor(hexString: "#fe8a71") ?? .black,
    UIColor(hexString: "#FCB6D8") ?? .black,
    UIColor(hexString: "#CF133D") ?? .black,
    UIColor(hexString: "#AEADEB") ?? .black,
    UIColor(hexString: "#A436FC") ?? .black,
    UIColor(hexString: "#CEB1AB") ?? .black
  ]
}

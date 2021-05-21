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
//  var type: Int
  var isPublic: Bool
//  var detail: String
//  var icon: String
//  var isCompleted: Bool
  var weekday: [String: Bool]
  var isDone: Bool
  var slogan: String
  var members: [String]
//  var userID: String
 


  //  enum CodingKeys: String, CodingKey {
  //  }

//  var toDict: [String: Any] {
//    return [
//      "id": id as Any,
//      "title": title as Any,
//      "type": type as Any,
//      "detail": detail as Any,
//      "icon": icon as Any,
//      "isCompleted": isCompleted as Any,
//      "isDone": isDone as Any,
//      "slogan": slogan as Any,
//      "userID": userID as Any
//    ]
//  }
}

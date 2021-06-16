//
//  NotificationsViewModel.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/3.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class NotificationsViewModel {

  var notification: Box<String?> = Box(nil)

  var hour: Box<Int?> = Box(nil)

  var minute: Box<Int?> = Box(nil)

  lazy var db = Firestore.firestore()

  func fetchNotifications(id: String) {
    db.collection("habits")
      .document(id)
      .collection("notification")
      .document(UserManager.shared.currentUser)
      .getDocument { documentSnapshot, error in
        guard let hours = documentSnapshot?.data()?["hours"] as? [Int],
              let minutes = documentSnapshot?.data()?["minutes"] as? [Int],
              !hours.isEmpty,
              !minutes.isEmpty else {
          return
        }
        for i in 0...(hours.count - 1) {
          self.hour.value = hours[i]
          self.minute.value = minutes[i]
          var stringHour = ""
          var stringMinute = ""
          switch hours[i] {
          case 0...9:
            stringHour = "0\(hours[i])"
          default:
            stringHour = String(hours[i])
          }
          switch minutes[i] {
          case 0...9:
            stringMinute = "0\(minutes[i])"
          default:
            stringMinute = String(minutes[i])
          }
          self.notification.value = "\(stringHour):\(stringMinute)"
        }
      }
  }
}
